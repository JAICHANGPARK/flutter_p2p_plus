/*
 * This file is part of the flutter_p2p package.
 *
 * Copyright 2019 by Julian Finkler <julian@mintware.de>
 * Copyright 2022 by JAICHANGPARK <Maintaince>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 *
 */

part of 'flutter_p2p_plus.dart';

class FlutterP2pPlus {
  static FlutterP2pPlus _instance = FlutterP2pPlus._();

  static FlutterP2pPlus get instance => _instance;

  FlutterP2pPlus._() {
    // _channel.setMethodCallHandler((MethodCall call) async {
    //   _methodStreamController.add(call);
    // });
    //
    // _setLogLevelIfAvailable();
  }

  static const channelBase = "com.dreamwalker.flutter_p2p_plus";

  static const _channel = MethodChannel('$channelBase/flutter_p2p');

  static WiFiDirectBroadcastReceiver wifiEvents = WiFiDirectBroadcastReceiver();
  static final SocketMaster _socketMaster = SocketMaster();

  Future<bool?> isLocationPermissionGranted() async {
    return await _channel.invokeMethod("isLocationPermissionGranted", {});
  }

  Future<bool?> requestLocationPermission() async {
    return await _channel.invokeMethod("requestLocationPermission", {});
  }

  Future<bool?> register() async {
    return await _channel.invokeMethod("register", {});
  }

  Future<bool?> unregister() async {
    return await _channel.invokeMethod("unregister", {});
  }

  Future<bool?> discoverDevices() async {
    return await _channel.invokeMethod("discover", {});
  }

  Future<bool?> stopDiscoverDevices() async {
    return await _channel.invokeMethod("stopDiscover", {});
  }

  Future<bool?> connect(WifiP2pDevice device) async {
    return await _channel.invokeMethod("connect", {"payload": device.writeToBuffer()});
  }

  Future<bool?> cancelConnect(WifiP2pDevice device) async {
    return await _channel.invokeMethod("cancelConnect", {});
  }

  Future<bool?> removeGroup() async {
    return await _channel.invokeMethod("removeGroup", {});
  }

  Future<P2pSocket?> openHostPort(int port) async {
    await _channel.invokeMethod("openHostPort", {"port": port});
    return _socketMaster.registerSocket(port, true);
  }

  Future<P2pSocket> closeHostPort(int port) async {
    await _channel.invokeMethod("closeHostPort", {"port": port});
    return _socketMaster.unregisterServerPort(port);
  }

  Future<bool?> acceptPort(int port) async {
    return await _channel.invokeMethod("acceptPort", {"port": port});
  }

  Future<P2pSocket?> connectToHost(
    String address,
    int port, {
    int timeout = 500,
  }) async {
    bool? result = await _channel.invokeMethod("connectToHost", {
      "address": address,
      "port": port,
      "timeout": timeout,
    });
    if (result ?? false) {
      return _socketMaster.registerSocket(port, false);
    }

    return null;
  }

  Future<bool?> disconnectFromHost(int port) async {
    return await _channel.invokeMethod("disconnectFromHost", {
      "port": port,
    });
  }

  Future<bool?> sendData(int port, bool isHost, Uint8List data) async {
    var req = SocketMessage.create();
    req.port = port;
    req.data = data;
    req.dataAvailable = 0;

    var action = isHost ? "sendDataToClient" : "sendDataToHost";
    return await _channel.invokeMethod(action, {
      "payload": req.writeToBuffer(),
    });
  }
}
