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
import com.dreamwalker.flutter_p2p_plus.utility.CoroutinesAsyncTask
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers.IO
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import java.io.OutputStream
import java.lang.Exception

class WriteDataToStreamTask(
    private val stream: OutputStream,
    private val bytes: ByteArray
) : CoroutinesAsyncTask<Void, Void, Boolean>("write_data_to_stream_task") {

    private val mCoroutineScope: CoroutineScope = CoroutineScope(IO)

    override fun doInBackground(vararg params: Void?): Boolean {
        Log.e(TAG, "[WriteDataToStreamTask] doInBackground() | $bytes ")

        mCoroutineScope.launch {
            try {
                stream.write(bytes)
                stream.flush()
            } catch (e: Exception) {
                Log.e(TAG, "[Error]: ${e.printStackTrace()}")
            }

        }

        return true
    }

}