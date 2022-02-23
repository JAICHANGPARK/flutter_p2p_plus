/*
 * This file is part of the flutter_p2p package.
 *
 * Copyright 2019 by Julian Finkler <julian@mintware.de>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 *
 */

package com.dreamwalker.flutter_p2p_plus.wifi_direct.transfer

import com.dreamwalker.flutter_p2p_plus.FlutterP2pPlusPlugin
import com.dreamwalker.flutter_p2p_plus.utility.ProtoHelper
import java.io.InputStream
import java.net.Socket

class SocketHandler(private val socket: Socket,
                    private val isHost: Boolean
) {
    private val inputStream: InputStream = socket.getInputStream()

    fun handleInput(cb: (data: ByteArray) -> Unit) {
        val buf = ByteArray(1024)

        var readCount = 0

        val port = if (isHost) socket.localPort else (socket.port)
        while (run {
                readCount = inputStream.read(buf)
                readCount
            } != -1) {
            val result = ProtoHelper.create(port, buf.take(readCount).toByteArray(), inputStream.available())
            cb(result.toByteArray())
        }
    }
}