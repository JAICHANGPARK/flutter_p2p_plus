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

import android.content.ContentValues.TAG
import android.os.AsyncTask
import android.util.Log
import com.dreamwalker.flutter_p2p_plus.StreamHandler
import com.dreamwalker.flutter_p2p_plus.utility.CoroutinesAsyncTask
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers.IO
import kotlinx.coroutines.launch
import java.net.Socket

abstract class SocketTask(private val inputStreamHandler: StreamHandler) :
    CoroutinesAsyncTask<Void, ByteArray, Boolean>("socket_task") {

    lateinit var socket: Socket

    override fun onProgressUpdate(vararg values: ByteArray?) {
        Log.e(TAG, "[SocketTask] onProgressUpdate() ${values.size} | ${values[0]} ")
        values.forEach {
          print(it.toString())
        }
        Log.e(TAG, "[SocketTask] values[0] ${values[0]} | ${values[0].toString()}")
        inputStreamHandler.sink?.success(values[0])
    }

    fun writeToOutput(bytes: ByteArray): Boolean {
        try {
            val task = WriteDataToStreamTask(socket.getOutputStream(), bytes)
            task.doInBackground()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return true
    }
}