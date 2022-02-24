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

import android.util.Log
import com.dreamwalker.flutter_p2p_plus.StreamHandler
import io.flutter.plugin.common.EventChannel
import java.net.ConnectException
import java.net.InetSocketAddress
import java.net.Socket
import java.net.SocketException

class Client(
    val address: String,
    val port: Int,
    private val timeout: Int,
    inputStreamHandler: StreamHandler,
    stateStreamHandler: StreamHandler,
//    private val stateChangedSink: EventChannel.EventSink?,
) : SocketTask(inputStreamHandler, stateStreamHandler) {

    private lateinit var socketHandler: SocketHandler

    init {
        socket = Socket()
        socket.bind(null)
    }

    override fun doInBackground(vararg params: Void?): Boolean {
        try {
            val socketAddress = InetSocketAddress(address, port)
            Log.e(TAG, "[INFO] socketAddress: ${socketAddress}")
            socket.connect(socketAddress, timeout)
            socketHandler = SocketHandler(socket, false)
            socketHandler.handleInput { data -> publishProgress(data) }
        } catch (e: IllegalArgumentException) {
            Log.e(
                TAG,
                "[Error] Client: doInBackground() IllegalArgumentException ${e.stackTraceToString()}"
            )
            return false
        } catch (e: SocketException) {
            Log.e(TAG, "[Error] Client: doInBackground() SocketException ${e.stackTraceToString()}")
            return false
        } catch (e: Exception) {
            e.printStackTrace()
            Log.e(TAG, "[Error] Client: doInBackground() Exception: ${e.stackTraceToString()}")
            return false
        }
        return true
    }

}