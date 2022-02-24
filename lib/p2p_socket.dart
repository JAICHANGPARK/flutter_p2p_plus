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

class P2pSocket {
  final bool isHost;
  final int port;
  final Stream<SocketMessage> _inputStream;

  Stream<SocketMessage> get inputStream => _inputStream;

  P2pSocket(this.port, this.isHost, this._inputStream);

  Future<bool?> write(Uint8List data) async {
    return FlutterP2pPlus.instance.sendData(port, isHost, data);
  }

  Future<bool?> writeString(String text) {
    return write(utf8.encode(text) as Uint8List);
  }
}
