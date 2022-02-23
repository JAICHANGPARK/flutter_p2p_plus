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

import com.dreamwalker.flutter_p2p_plus.StreamHandler
import java.net.InetSocketAddress
import java.net.Socket

class Client(private val address: String,
             val port: Int,
             inputStreamHandler: StreamHandler,
             private val timeout: Int
) : SocketTask(inputStreamHandler) {

    private lateinit var socketHandler: SocketHandler

    init {
        socket = Socket()
        socket.bind(null)
    }

    override fun doInBackground(vararg params: Void?): Boolean {
        try {
            val socketAddress = InetSocketAddress(address, port)
            socket.connect(socketAddress, timeout)
            socketHandler = SocketHandler(socket, false)
            socketHandler.handleInput { data -> publishProgress(data) }
        } catch (e: Exception) {
            e.printStackTrace()
            return false
        }
        return true
    }

}