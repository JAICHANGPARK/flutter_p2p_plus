/*
 * This file is part of the flutter_p2p package.
 *
 * Copyright 2019 by Julian Finkler <julian@mintware.de>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 *
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_p2p_plus/flutter_p2p_plus.dart';
import 'package:flutter_p2p_plus/protos/protos.pb.dart';
import 'package:permission_handler/permission_handler.dart';

class Packet {
  String? data;
  int? timestamp;

  Packet({this.data, this.timestamp});

  Packet.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['timestamp'] = timestamp;
    return data;
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyExample(),
    );
  }
}

class MyExample extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyExample> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _deviceAddress = "";
  var _isConnected = false;
  var _isHost = false;
  var _isOpen = false;
  var _socketClientConnected = false;
  String _sendText = "";
  String _rcvText = "";

  P2pSocket? _socket;
  WifiP2pDevice? _wifiP2pDevice;
  List<WifiP2pDevice> devices = [];
  final List<StreamSubscription> _subscriptions = [];
  final TextEditingController _textEditingController = TextEditingController();
  final FlutterP2pPlus _flutterP2pPlus = FlutterP2pPlus.instance;
  StreamSubscription? _socketInputStreamSubscription;
  StreamSubscription? _socketStateStreamSubscription;

  @override
  void initState() {
    super.initState();
    print("initState()");
    _register();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _socketInputStreamSubscription?.cancel();
    _socketStateStreamSubscription?.cancel();
    _flutterP2pPlus.removeGroup();
    for (var element in _subscriptions) {
      element.cancel();
    }
    if (_isConnected) {
      if (_wifiP2pDevice != null) {
        FlutterP2pPlus.instance.cancelConnect(_wifiP2pDevice!);
      }
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _register();
    } else if (state == AppLifecycleState.paused) {
      _unregister();
    }
  }

  void _register() async {
    await Permission.location.request();

    if (!await _checkPermission()) {
      return;
    }

    _subscriptions.add(FlutterP2pPlus.wifiEvents.stateChange!.listen((change) {
      debugPrint("[Listen] stateChange: ${change.isEnabled}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.connectionChange!.listen((change) {
      debugPrint("[Listen] connectionChange() ${change.wifiP2pInfo.groupOwnerAddress}");
      setState(() {
        _isConnected = change.networkInfo.isConnected;
        _isHost = change.wifiP2pInfo.isGroupOwner;
        _deviceAddress = change.wifiP2pInfo.groupOwnerAddress;
      });
      debugPrint(
          "[Listen] connectionChange: ${change.wifiP2pInfo.isGroupOwner}, Connected: ${change.networkInfo.isConnected} | _deviceAddress: ${_deviceAddress}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.thisDeviceChange!.listen((change) {
      debugPrint(
          "[Listen] deviceChange: ${change.deviceName} / ${change.deviceAddress} / ${change.primaryDeviceType} / ${change.secondaryDeviceType} ${change.isGroupOwner ? 'GO' : '-GO'}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.discoveryChange!.listen((change) {
      debugPrint("[Listen] discoveryStateChange: ${change.isDiscovering}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.peersChange!.listen((change) {
      debugPrint("[Listen] peersChange: ${change.devices.length}");
      // for (var device in change.devices) {
      //   debugPrint("device: ${device.deviceName} / ${device.deviceAddress}");
      // }
      setState(() {
        devices = change.devices;
      });
    }));

    await _flutterP2pPlus.register();
  }

  void _unregister() {
    _socketInputStreamSubscription?.cancel();
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _flutterP2pPlus.unregister();
  }

  void _openPortAndAccept(int port) async {
    if (!_isOpen) {
      var socket = await _flutterP2pPlus.openHostPort(port);
      setState(() {
        _socket = socket;
      });

      var buffer = "";
      socket?.inputStream.listen((data) {
        var msg = String.fromCharCodes(data.data);
        buffer += msg;
        if (data.dataAvailable == 0) {
          snackBar("Data Received from ${_isHost ? "Client" : "Host"}: $buffer");
          socket.writeString("Successfully received: $buffer");
          buffer = "";
        }
      });

      debugPrint("_openPort done");
      _isOpen = await _flutterP2pPlus.acceptPort(port) ?? false;
      debugPrint("_accept done: $_isOpen");
    }
  }

  _connectToPort(int port) async {
    var socket = await _flutterP2pPlus.connectToHost(
      _deviceAddress,
      // "192.168.15.240",
      port,
      timeout: 10000,
    );

    setState(() {
      _socketClientConnected = true;
      _socket = socket;
    });
    await _socketInputStreamSubscription?.cancel();
    _socketInputStreamSubscription = null;
    await _socketStateStreamSubscription?.cancel();
    _socketStateStreamSubscription = null;

    _socketInputStreamSubscription ??= _socket?.inputStream.listen((data) {
      var msg = utf8.decode(data.data);
      setState(() {
        _rcvText += "$msg \n";
      });
      // snackBar("Received from ${_isHost ? "Host" : "Client"} $msg");
    });

    _socketStateStreamSubscription ??= _socket?.stateStream.listen((event) {
      debugPrint("[Listen] Socket State: $event");
      setState(() {
        _socketClientConnected = false;
      });
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text("Socket Host Disconnected"),
              ));
    });

    debugPrint("_connectToPort done");
  }

  Future<bool?> _socketDisconnect() async {
    bool result = false;
    if (_isHost) {
      await _flutterP2pPlus.closeHostPort(8000);
    } else {
      await _flutterP2pPlus.disconnectFromHost(8000);
    }
    _socketInputStreamSubscription?.cancel();
    _socketInputStreamSubscription = null;
    setState(() {
      _socketClientConnected = false;
    });
    // if (_wifiP2pDevice != null) {
    //   result = await FlutterP2pPlus.cancelConnect(_wifiP2pDevice!) ?? false;
    // }

    return result;
  }

  Future<bool?> _teardown() async {
    bool? result = await _flutterP2pPlus.removeGroup();
    _unregister();
    _socket = null;
    if ((result ?? false)) _isOpen = false;
    return result;
  }

  Future<bool> _checkPermission() async {
    // if (!await FlutterP2pPlus?.isLocationPermissionGranted()) {
    //   await FlutterP2pPlus.requestLocationPermission();
    //   return false;
    // }
    if (await Permission.location.status.isDenied) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Flutter P2P Plus - Example App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: const Text("Registration"),
              subtitle: const Text("P2P Registration"),
              onTap: () async {
                await _flutterP2pPlus.register();
              },
            ),
            const Divider(
              color: Colors.black,
            ),
            ListTile(
              title: const Text("Connection State"),
              trailing: Text(_isConnected ? "Connected: ${_isHost ? "Host" : "Client"}" : "Disconnected"),
            ),
            _isConnected
                ? MaterialButton(
                    child: const Text("Disconnect P2P"),
                    onPressed: () async {
                      if (_wifiP2pDevice != null) {
                        bool? result = await _flutterP2pPlus.cancelConnect(_wifiP2pDevice!);
                        print("[cancelConnect] result: $result");
                        setState(() {
                          _isConnected = false;
                        });
                      }
                    })
                : Container(),
            const Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Discover Controller",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            IntrinsicHeight(
              child: SizedBox(
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text("Discover Devices"),
                        onTap: () async {
                          if (!_isConnected) {
                            await _flutterP2pPlus.discoverDevices();
                          } else {
                            return;
                          }
                        },
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text("Stop Discover Devices"),
                        onTap: () async {
                          await _flutterP2pPlus.stopDiscoverDevices();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Device List",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(
              height: 240,
              child: ListView(
                children: devices.map((d) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(d.deviceName),
                        subtitle: Text(d.deviceAddress),
                        onTap: () async {
                          // debugPrint("${_isConnected ? "Disconnect" : "Connect"} to device: $_deviceAddress");

                          if (_isConnected) {
                            // if (_wifiP2pDevice != null) {
                            //   await FlutterP2pPlus.cancelConnect(_wifiP2pDevice!);
                            // }
                            return;
                          } else {
                            _wifiP2pDevice = d;
                            // bool? stopResult = await FlutterP2pPlus.stopDiscoverDevices();
                            // if(stopResult ?? false){
                            //   print("[stopDiscoverDevices] stop discovery devices");
                            // }

                            print("[_wifiP2pDevice] deviceAddress: ${_wifiP2pDevice?.deviceAddress}");
                            bool? result = await _flutterP2pPlus.connect(_wifiP2pDevice ?? d);
                            print("[connect] reault: $result");
                            if (result ?? false) {
                              _isConnected = true;
                            }
                            await Future.delayed(const Duration(seconds: 1));
                            await _flutterP2pPlus.stopDiscoverDevices();
                            setState(() {});
                          }
                        },
                      ),
                      const Divider(
                        color: Colors.brown,
                        endIndent: 16,
                        indent: 16,
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Connect & Open Socket",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const Divider(
              color: Colors.brown,
              indent: 24,
              endIndent: 24,
            ),
            ListTile(
              title: const Text("Open and accept data from port 8000"),
              subtitle: _isConnected ? const Text("Active") : const Text("Disable"),
              onTap: _isConnected && _isHost ? () => _openPortAndAccept(8000) : null,
            ),
            const Divider(
              color: Colors.brown,
              indent: 24,
              endIndent: 24,
            ),
            ListTile(
                title: const Text("Connect to port 8000"),
                subtitle: const Text("This is able to only Client"),
                onTap: () async {
                  if (_socketClientConnected) {
                    showDialog(
                        context: _scaffoldKey.currentContext!,
                        builder: (context) => const AlertDialog(
                              content: Text("Already Connected with Host"),
                            ));
                    return;
                  }
                  if (_isConnected && !_isHost) {
                    _connectToPort(8000);
                  }
                }),
            const Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Data Transfer",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            ListTile(
                title: const Text("Send hello world"),
                onTap: () async {
                  if (_isConnected) {
                    var pkt = Packet(data: "Hello World", timestamp: DateTime.now().millisecondsSinceEpoch);
                    bool? result = await _socket?.writeString(jsonEncode(pkt).toString());
                    setState(() {
                      _sendText += "Hello World\n";
                    });
                  }
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 64,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextField(
                        controller: _textEditingController,
                      ),
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_textEditingController.text.isNotEmpty) {
                          await _socket?.writeString(_textEditingController.text.trim());
                          setState(() {
                            _sendText += _textEditingController.text.trim() + "\n";
                          });
                        }
                      },
                      child: const Text("Send"),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _sendText = "";
                          _rcvText = "";
                        });
                      },
                      child: const Text("Clear"),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 240,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Sender"),
                          const Divider(
                            color: Colors.brown,
                          ),
                          Expanded(
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                child: Text(_sendText),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.brown,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Receiver"),
                          const Divider(
                            color: Colors.brown,
                          ),
                          Expanded(
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                child: Text(_rcvText),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Disconnect & Teardown",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            ListTile(
              title: const Text("Socket Disconnect"),
              onTap: _isConnected ? () async => await _socketDisconnect() : null,
            ),
            const Divider(
              color: Colors.brown,
              indent: 24,
              endIndent: 24,
            ),
            ListTile(
              title: const Text("Teardown"),
              onTap: _isConnected ? () async => await _teardown() : null,
            ),
          ],
        ),
      ),
    );
  }

  snackBar(String text) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
