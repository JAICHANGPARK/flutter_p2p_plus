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

import android.content.BroadcastReceiver
import android.content.ContentValues.TAG
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.NetworkInfo
import android.net.wifi.p2p.WifiP2pDevice
import android.net.wifi.p2p.WifiP2pInfo
import android.net.wifi.p2p.WifiP2pManager
import android.os.Build
import android.util.Log
import androidx.core.content.ContextCompat.getSystemService
import com.dreamwalker.flutter_p2p_plus.Protos
import com.dreamwalker.flutter_p2p_plus.utility.ProtoHelper
import io.flutter.plugin.common.EventChannel


class WiFiDirectBroadcastReceiver(
    private val manager: WifiP2pManager,
    private val channel: WifiP2pManager.Channel,
    private val stateChangedSink: EventChannel.EventSink?,
    peersChangedSink: EventChannel.EventSink?,
    private val connectionChangedSink: EventChannel.EventSink?,
    private val thisDeviceChangedSink: EventChannel.EventSink?,
    private val discoveryChangedSink: EventChannel.EventSink?,
    private val appContext: Context?
) : BroadcastReceiver() {

    private val peerListListener = WiFiDirectPeerListListener(peersChangedSink)

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent == null) {
            return
        }

        when (intent.action) {
            WifiP2pManager.WIFI_P2P_STATE_CHANGED_ACTION -> onStateChanged(intent)
            WifiP2pManager.WIFI_P2P_PEERS_CHANGED_ACTION -> onPeersChanged()
            WifiP2pManager.WIFI_P2P_CONNECTION_CHANGED_ACTION -> onConnectionChanged(intent)
            WifiP2pManager.WIFI_P2P_THIS_DEVICE_CHANGED_ACTION -> onThisDeviceChanged(intent)
            WifiP2pManager.WIFI_P2P_DISCOVERY_CHANGED_ACTION -> onDiscoveryChanged(intent)
        }
    }

    private fun onConnectionChanged(intent: Intent) {
        val p2pInfo =
            intent.getParcelableExtra<WifiP2pInfo>(WifiP2pManager.EXTRA_WIFI_P2P_INFO) as WifiP2pInfo
        val networkInfo =
            intent.getParcelableExtra<NetworkInfo>(WifiP2pManager.EXTRA_NETWORK_INFO) as NetworkInfo

        manager.let { manager ->

            if (isNetworkAvailable(appContext)) {
                manager.requestConnectionInfo(channel) { info ->
                    // InetAddress from WifiP2pInfo struct.
//                    val groupOwnerAddress: String = info.groupOwnerAddress.hostAddress

                    // After the group negotiation, we can determine the group owner
                    // (server).
                    if (info.groupFormed && info.isGroupOwner) {
                        // Do whatever tasks are specific to the group owner.
                        // One common case is creating a group owner thread and accepting
                        // incoming connections.
                    } else if (info.groupFormed) {
                        // The other device acts as the peer (client). In this case,
                        // you'll want to create a peer thread that connects
                        // to the group owner.
                    }

                }
            }
        }

        connectionChangedSink?.success(ProtoHelper.create(p2pInfo, networkInfo).toByteArray())
    }

    private fun onStateChanged(intent: Intent) {
        Log.e(TAG, "[onStateChanged] Called")
        val state = intent.getIntExtra(WifiP2pManager.EXTRA_WIFI_STATE, -1)

        val isConnected = state == WifiP2pManager.WIFI_P2P_STATE_ENABLED
        val stateChange: Protos.StateChange = ProtoHelper.create(isConnected)
        when (state) {
            WifiP2pManager.WIFI_P2P_STATE_ENABLED -> {
                Log.e(TAG, "[onStateChanged] WIFI_P2P_STATE_ENABLED")
            }
            else -> {
                Log.e(TAG, "[onStateChanged] WIFI_P2P_STATE_DISABLE")
            }
        }
        Log.e(TAG, "[onStateChanged] $state | $isConnected | $stateChange")
        stateChangedSink?.success(stateChange.toByteArray())
    }

    private fun onPeersChanged() {
        Log.e(TAG, "[onPeersChanged] $channel, ")
        manager.requestPeers(channel, peerListListener)
    }

    private fun onThisDeviceChanged(intent: Intent) {

        val device =
            intent.getParcelableExtra<WifiP2pDevice>(WifiP2pManager.EXTRA_WIFI_P2P_DEVICE) as WifiP2pDevice
        val dev: Protos.WifiP2pDevice = ProtoHelper.create(device)
        Log.e(TAG, "[onThisDeviceChanged] ${device} | ${device.isGroupOwner} | ${dev}")
        thisDeviceChangedSink?.success(dev.toByteArray())
    }

    private fun onDiscoveryChanged(intent: Intent) {
        val discoveryState = intent.getIntExtra(
            WifiP2pManager.EXTRA_DISCOVERY_STATE,
            WifiP2pManager.WIFI_P2P_DISCOVERY_STOPPED
        )
        val stateChange: Protos.DiscoveryStateChange = ProtoHelper.create(discoveryState)
        Log.e(TAG, "[onDiscoveryChanged] $discoveryState | $stateChange")
        discoveryChangedSink?.success(stateChange.toByteArray())
    }

    private fun isNetworkAvailable(context: Context?): Boolean {
        val connectivityManager =
            context?.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val nw = connectivityManager.activeNetwork ?: return false
            val actNw = connectivityManager.getNetworkCapabilities(nw) ?: return false
            return when {
                actNw.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> true
                actNw.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> true
                //for other device how are able to connect with Ethernet
                actNw.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> true
                //for check internet over Bluetooth
                actNw.hasTransport(NetworkCapabilities.TRANSPORT_BLUETOOTH) -> true
                else -> false
            }
        } else {
            return connectivityManager.activeNetworkInfo?.isConnected ?: false
        }
    }

}