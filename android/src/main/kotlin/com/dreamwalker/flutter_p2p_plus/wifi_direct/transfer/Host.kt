/*
 * This file is part of the flutter_p2p package.
 *
 * Copyright 2019 by Julian Finkler <julian@mintware.de>
 * Copyright 2022 by JAICHANG PARK <Maintaince>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 *
 */

package com.dreamwalker.flutter_p2p_plus.wifi_direct.transfer

import com.dreamwalker.flutter_p2p_plus.StreamHandler
import java.net.ServerSocket

class Host(val serverSocket: ServerSocket,
           inputStreamHandler: StreamHandler
) : SocketTask(inputStreamHandler) {

    private lateinit var handler: SocketHandler

    override fun doInBackground(vararg params: Void?): Boolean {

        try {
            socket = serverSocket.accept()
            handler = SocketHandler(socket, true)
            handler.handleInput { data -> publishProgress(data) }
        } catch (e: Exception) {
            e.printStackTrace()
            return false
        }

        return true
    }

}