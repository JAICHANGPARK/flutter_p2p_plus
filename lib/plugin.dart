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
  static const channelBase = "com.dreamwalker.flutter_p2p_plus";

  static const _channel = MethodChannel('$channelBase/flutter_p2p');

  static WiFiDirectBroadcastReceiver wifiEvents = WiFiDirectBroadcastReceiver();
  static final SocketMaster _socketMaster = SocketMaster();


  static Future<bool?> isLocationPermissionGranted() async {
    return await _channel.invokeMethod("isLocationPermissionGranted", {});
  }

  static Future<bool?> requestLocationPermission() async {
    return await _channel.invokeMethod("requestLocationPermission", {});
  }


  static Future<bool?> register() async {
    return await _channel.invokeMethod("register", {});
  }

  static Future<bool?> unregister() async {
    return await _channel.invokeMethod("unregister", {});
  }


  static Future<bool?> discoverDevices() async {
    return await _channel.invokeMethod("discover", {});
  }

  static Future<bool?> stopDiscoverDevices() async {
    return await _channel.invokeMethod("stopDiscover", {});
  }


  static Future<bool?> connect(WifiP2pDevice device) async {
    return await _channel
        .invokeMethod("connect", {"payload": device.writeToBuffer()});
  }

  static Future<bool?> cancelConnect(WifiP2pDevice device) async {
    return await _channel.invokeMethod("cancelConnect", {});
  }

  static Future<bool?> removeGroup() async {
    return await _channel.invokeMethod("removeGroup", {});
  }

  static Future<P2pSocket?> openHostPort(int port) async {
    await _channel.invokeMethod("openHostPort", {"port": port});
    return _socketMaster.registerSocket(port, true);
  }

  static Future<P2pSocket> closeHostPort(int port) async {
    await _channel.invokeMethod("closeHostPort", {"port": port});
    return _socketMaster.unregisterServerPort(port);
  }

  static Future<bool?> acceptPort(int port) async {
    return await _channel.invokeMethod("acceptPort", {"port": port});
  }

  static Future<P2pSocket?> connectToHost(
    String address,
    int port, {
    int timeout = 500,
  }) async {
    if (await (_channel.invokeMethod("connectToHost", {
      "address": address,
      "port": port,
      "timeout": timeout,
    }) as FutureOr<bool>)) {
      return _socketMaster.registerSocket(port, false);
    }
    return null;
  }

  static Future<bool?> disconnectFromHost(int port) async {
    return await _channel.invokeMethod("disconnectFromHost", {
      "port": port,
    });
  }

  static Future<bool?> sendData(int port, bool isHost, Uint8List data) async {
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
