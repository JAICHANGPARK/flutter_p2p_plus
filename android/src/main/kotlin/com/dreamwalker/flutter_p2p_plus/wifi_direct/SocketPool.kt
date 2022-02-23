/*
 * This file is part of the flutter_p2p package.
 *
 * Copyright 2019 by Julian Finkler <julian@mintware.de>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 *
 */

package com.dreamwalker.flutter_p2p_plus.wifi_direct

import android.content.ContentValues.TAG
import android.util.Log
import com.dreamwalker.flutter_p2p_plus.StreamHandler
import com.dreamwalker.flutter_p2p_plus.wifi_direct.transfer.Client
import com.dreamwalker.flutter_p2p_plus.wifi_direct.transfer.Host
import java.net.ServerSocket

class SocketPool(private val inputStreamHandler: StreamHandler) {

    private val clientPool = mutableListOf<Client>()
    private val hosts = mutableListOf<Host>()

    fun openSocket(port: Int): Host {
        val h = getHostByPort(port)
        if ((h != null) && !(h.serverSocket.isClosed)) {
            throw Exception("A socket with this port already exist")
        }

        val socket = ServerSocket(port)

        val host = Host(socket, inputStreamHandler)
        hosts.add(host)

        return host
    }

    fun acceptClientConnection(port: Int) {
        val host: Host = getHostByPort(port)
            ?: throw Exception("A socket with this port is not registered.")
        host.execute()
    }

    fun closeSocket(port: Int) {
        val socket: Host = getHostByPort(port)
            ?: throw Exception("A socket with this port is not registered.")
        socket.serverSocket.close()
        hosts.remove(socket)
    }

    fun connectToHost(address: String, port: Int, timeout: Int): Client {
        val client = Client(address, port, inputStreamHandler, timeout)
        clientPool.add(client)
        client.execute()

        return client
    }

    fun sendDataToHost(port: Int, data: ByteArray) {
        Log.e(TAG, "[Call] sendDataToHost() | $port")
        val client: Client = getClientByPort(port)
            ?: throw Exception("A socket with this port is not connected.")

        try {
            client.writeToOutput(data)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun sendDataToClient(port: Int, data: ByteArray) {
        val host: Host = getHostByPort(port)
            ?: throw Exception("A socket with this port is not connected.")

        host.writeToOutput(data)
    }

    fun disconnectFromHost(port: Int) {
        Log.e(TAG, "[Call] disconnectFromHost() | $port")
        val client: Client = getClientByPort(port)
            ?: throw Exception("A socket with this port is not connected.")
        Log.e(TAG, "[Info] filtered client | ${client.port}")
        client.socket.takeIf { it.isConnected }?.apply {
            close()
        }
    }

    fun disconnectFromClient(port: Int) {
        val host: Host = getHostByPort(port)
            ?: throw Exception("A socket with this port is not connected.")

        host.serverSocket.takeIf { !it.isClosed }?.apply {
            close()
        }
    }

    private fun getHostByPort(port: Int): Host? {
        Log.e(TAG, "[Call] getHostByPort() | $port")
        return hosts.firstOrNull { s -> s.serverSocket.localPort == port }
    }


    private fun getClientByPort(port: Int): Client? {
        Log.e(TAG, "[Call] getClientByPort() | $port")
        return clientPool.firstOrNull { s -> s.port == port }
    }
}