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
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers.IO
import kotlinx.coroutines.launch
import java.io.OutputStream

class WriteDataToStreamTask(
    private val stream: OutputStream,
    private val bytes: ByteArray
) {

    val mCoroutineScope: CoroutineScope = CoroutineScope(IO)


    fun doInBackground(vararg params: Void?): Boolean {
        mCoroutineScope.launch {
            stream.write(bytes)
            stream.flush()

        }
        return true
    }

}