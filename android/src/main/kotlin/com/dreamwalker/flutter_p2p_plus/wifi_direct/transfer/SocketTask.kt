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

import android.os.AsyncTask
import com.dreamwalker.flutter_p2p_plus.StreamHandler
import java.net.Socket

abstract class SocketTask(private val inputStreamHandler: StreamHandler) : AsyncTask<Void, ByteArray, Boolean>() {

    lateinit var socket: Socket

    override fun onProgressUpdate(vararg values: ByteArray?) {
        inputStreamHandler.sink?.success(values[0])
    }

    fun writeToOutput(bytes: ByteArray): Boolean {
        try {
            val task = WriteDataToStreamTask(socket.getOutputStream(), bytes)
            task.executeOnExecutor(THREAD_POOL_EXECUTOR)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return true
    }
}