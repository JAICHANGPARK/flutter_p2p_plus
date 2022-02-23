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
import java.io.OutputStream

class WriteDataToStreamTask(private val stream: OutputStream,
                            private val bytes: ByteArray
) : AsyncTask<Void, Void, Boolean>() {

    override fun doInBackground(vararg params: Void?): Boolean {
        stream.write(bytes)
        stream.flush()
        return true
    }

}