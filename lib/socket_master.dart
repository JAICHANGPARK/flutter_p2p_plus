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

class SocketMaster {
  static const _channelBase = FlutterP2pPlus.channelBase;

  final _socketReadChannel = const EventChannel("$_channelBase/socket/read");

  Map<int, P2pSocket> sockets = {};

  late Stream<SocketMessage> _readStream;

  SocketMaster() {
    _readStream = _socketReadChannel.receiveBroadcastStream().map((a) {
      try {
        debugPrint("[Info][SocketMaster] ${SocketMessage.fromBuffer(a)}");
        return SocketMessage.fromBuffer(a);
      } catch (e) {
        debugPrint(e.toString());
        rethrow;
      }
    });
  }

  P2pSocket? registerSocket(int port, bool isHost) {
    if (sockets[port] == null) {
      sockets[port] = P2pSocket(
        port,
        isHost,
        _readStream.where((s) {
          return s.port == port;
        }),
      );
    }

    return sockets[port];
  }

  unregisterServerPort(int port) {
    if (sockets[port] == null) {
      throw Exception("The port $port is not registered.");
    }

    sockets.remove(port);
  }
}
