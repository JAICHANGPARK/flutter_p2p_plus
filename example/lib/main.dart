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

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _deviceAddress = "";
  var _isConnected = false;
  var _isHost = false;
  var _isOpen = false;

  P2pSocket? _socket;
  WifiP2pDevice? _wifiP2pDevice;
  List<WifiP2pDevice> devices = [];
  final List<StreamSubscription> _subscriptions = [];
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _register();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FlutterP2pPlus.removeGroup();
    for (var element in _subscriptions) {
      element.cancel();
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
      debugPrint("stateChange: ${change.isEnabled}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.connectionChange!.listen((change) {
      debugPrint(
          "[Listen] connectionChange() ${change.wifiP2pInfo.groupOwnerAddress}");
      setState(() {
        _isConnected = change.networkInfo.isConnected;
        _isHost = change.wifiP2pInfo.isGroupOwner;
        _deviceAddress = change.wifiP2pInfo.groupOwnerAddress;
      });
      debugPrint(
          "connectionChange: ${change.wifiP2pInfo.isGroupOwner}, Connected: ${change.networkInfo.isConnected} | _deviceAddress: ${_deviceAddress}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.thisDeviceChange!.listen((change) {
      debugPrint(
          "deviceChange: ${change.deviceName} / ${change.deviceAddress} / ${change.primaryDeviceType} / ${change.secondaryDeviceType} ${change.isGroupOwner ? 'GO' : '-GO'}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.discoveryChange!.listen((change) {
      debugPrint("discoveryStateChange: ${change.isDiscovering}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.peersChange!.listen((change) {
      debugPrint("peersChange: ${change.devices.length}");
      // for (var device in change.devices) {
      //   debugPrint("device: ${device.deviceName} / ${device.deviceAddress}");
      // }

      setState(() {
        devices = change.devices;
      });
    }));

    FlutterP2pPlus.register();
  }

  void _unregister() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    FlutterP2pPlus.unregister();
  }

  void _openPortAndAccept(int port) async {
    if (!_isOpen) {
      var socket = await FlutterP2pPlus.openHostPort(port);
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
      _isOpen = await FlutterP2pPlus.acceptPort(port) ?? false;
      debugPrint("_accept done: $_isOpen");
    }
  }

  _connectToPort(int port) async {
    var socket = await FlutterP2pPlus.connectToHost(
      _deviceAddress,
      // "192.168.15.240",
      port,
      timeout: 100000,
    );

    setState(() {
      _socket = socket;
    });

    _socket?.inputStream.listen((data) {
      var msg = utf8.decode(data.data);
      snackBar("Received from ${_isHost ? "Host" : "Client"} $msg");
    });

    debugPrint("_connectToPort done");
  }

  Future<bool?> _socketDisconnect() async {
    bool result = false;
    if (_isHost) {
      await FlutterP2pPlus.closeHostPort(8000);
    } else {
      await FlutterP2pPlus.disconnectFromHost(8000);
    }
    // if (_wifiP2pDevice != null) {
    //   result = await FlutterP2pPlus.cancelConnect(_wifiP2pDevice!) ?? false;
    // }

    return result;
  }

  Future<bool?> _teardown() async {
    bool? result = await FlutterP2pPlus.removeGroup();
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
    return MaterialApp(
      home: Scaffold(
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
                  await FlutterP2pPlus.register();
                },
              ),
              ListTile(
                title: const Text("Connection State"),
                subtitle: Text(_isConnected ? "Connected: ${_isHost ? "Host" : "Client"}" : "Disconnected"),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Controller",
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
                              await FlutterP2pPlus.discoverDevices();
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
                            FlutterP2pPlus.stopDiscoverDevices();
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
                            debugPrint("${_isConnected ? "Disconnect" : "Connect"} to device: $_deviceAddress");

                            if (_isConnected) {
                              if(_wifiP2pDevice != null){
                                await FlutterP2pPlus.cancelConnect(_wifiP2pDevice!);
                              }
                            } else {
                              _wifiP2pDevice = d;
                              print("[_wifiP2pDevice] deviceAddress: ${_wifiP2pDevice?.deviceAddress}");
                              var result = (await FlutterP2pPlus.connect(_wifiP2pDevice!) ?? false);
                              print("[connect] reault: $result");
                              if (result) {
                                _isConnected = true;
                              }
                              setState(() {});
                            }
                          },
                        ),
                        Divider(
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
                onTap: _isConnected && !_isHost ? () => _connectToPort(8000) : null,
              ),
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
                onTap: _isConnected ? () async => await _socket?.writeString("Hello World") : null,
              ),
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
                      SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (_textEditingController.text.isNotEmpty) {
                              await _socket?.writeString(_textEditingController.text.trim());
                            }
                          },
                          child: Text("Send"))
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
