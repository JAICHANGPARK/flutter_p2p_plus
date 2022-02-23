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
import android.net.wifi.p2p.WifiP2pManager
import android.util.Log
import io.flutter.plugin.common.MethodChannel

class ResultActionListener(private val result: MethodChannel.Result) : WifiP2pManager.ActionListener {
    override fun onSuccess() {
        Log.e(TAG, "[ResultActionListener] onSuccess()")
        result.success(true)
    }

    override fun onFailure(reasonCode: Int) {
        Log.e(TAG, "[ResultActionListener] onFailure() | code = $reasonCode")
        result.error(reasonCode.toString(), null, null)
    }
}