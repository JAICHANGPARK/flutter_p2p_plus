/*
 * This file is part of the flutter_p2p package.
 *
 * Copyright 2019 by Julian Finkler <julian@mintware.de>
 *
 * For the full copyright and license information, please read the LICENSE
 * file that was distributed with this source code.
 *
 */

package com.dreamwalker.flutter_p2p_plus

import android.Manifest
import android.content.ContentValues.TAG
import android.content.Context
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.wifi.p2p.WifiP2pConfig
import android.net.wifi.p2p.WifiP2pManager
import android.os.Build
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import com.dreamwalker.flutter_p2p_plus.utility.EventChannelPool
import com.dreamwalker.flutter_p2p_plus.wifi_direct.ResultActionListener
import com.dreamwalker.flutter_p2p_plus.wifi_direct.SocketPool
import com.dreamwalker.flutter_p2p_plus.wifi_direct.WiFiDirectBroadcastReceiver
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception


class FlutterP2pPlusPlugin : MethodCallHandler, FlutterPlugin, ActivityAware {

    private val intentFilter = IntentFilter()
    private var receiver: WiFiDirectBroadcastReceiver? = null
    private var eventPool: EventChannelPool? = null
    private lateinit var socketPool: SocketPool

    private lateinit var channel: WifiP2pManager.Channel
    private lateinit var manager: WifiP2pManager

    private lateinit var mChannel: MethodChannel
    var context: Context? = null
    private var pluginBinding: FlutterPluginBinding? = null
    private var activityBinding: ActivityPluginBinding? = null

    companion object {
        private const val REQUEST_ENABLE_LOCATION = 600
        private const val CH_STATE_CHANGE = "bc/state-change"
        private const val CH_PEERS_CHANGE = "bc/peers-change"
        private const val CH_CON_CHANGE = "bc/connection-change"
        private const val CH_DEVICE_CHANGE = "bc/this-device-change"
        private const val CH_DISCOVERY_CHANGE = "bc/discovery-change"
        private const val CH_SOCKET_READ = "socket/read"
        val config: Config = Config()

    }

    init {
        setupIntentFilters()
    }

    fun setupEventPool() {
        eventPool?.register(CH_STATE_CHANGE)
        eventPool?.register(CH_PEERS_CHANGE)
        eventPool?.register(CH_CON_CHANGE)
        eventPool?.register(CH_DEVICE_CHANGE)
        eventPool?.register(CH_SOCKET_READ)
        eventPool?.register(CH_DISCOVERY_CHANGE)

        socketPool = SocketPool(eventPool?.getHandler(CH_SOCKET_READ)!!)
    }

    private fun setupIntentFilters() {
        intentFilter.apply {
            // Indicates a change in the Wi-Fi P2P status.
            addAction(WifiP2pManager.WIFI_P2P_STATE_CHANGED_ACTION)
            // Indicates a change in the list of available peers.
            addAction(WifiP2pManager.WIFI_P2P_PEERS_CHANGED_ACTION)
            // Indicates the state of Wi-Fi P2P connectivity has changed.
            addAction(WifiP2pManager.WIFI_P2P_CONNECTION_CHANGED_ACTION)
            // Indicates this device'base details have changed.
            addAction(WifiP2pManager.WIFI_P2P_THIS_DEVICE_CHANGED_ACTION)
            // Indicates the state of peer discovery has changed
            addAction(WifiP2pManager.WIFI_P2P_DISCOVERY_CHANGED_ACTION)
        }
    }


    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
//        activityBinding?.addRequestPermissionsResultListener(this);
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        Log.d(TAG, "onDetachedFromActivity")
//        activityBinding?.removeRequestPermissionsResultListener(this)
        activityBinding = null
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPluginBinding) {
        Log.e(TAG, "[Call] onAttachedToEngine()")

        pluginBinding = flutterPluginBinding
        context = flutterPluginBinding.applicationContext

        mChannel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "com.dreamwalker.flutter_p2p_plus/flutter_p2p"
        )
        mChannel.setMethodCallHandler(this)

        manager =
            flutterPluginBinding.applicationContext.getSystemService(Context.WIFI_P2P_SERVICE) as WifiP2pManager
        channel = manager.initialize(
            flutterPluginBinding.applicationContext,
            Looper.getMainLooper(),
            null
        )
        eventPool = EventChannelPool(flutterPluginBinding.binaryMessenger)
        setupEventPool()

    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        mChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.e(TAG, "[Call] onMethodCall()")
        Log.e(TAG, "Method: " + call.method + call.arguments)

        when (call.method) {
            "register" -> {
                Log.e(TAG, "[Info] register 메소드 처리 실행")
                if (receiver != null) {
                    result.success(false)
                    return
                }

                receiver = WiFiDirectBroadcastReceiver(
                    manager,
                    channel,
                    eventPool?.getHandler(CH_STATE_CHANGE)?.sink,
                    eventPool?.getHandler(CH_PEERS_CHANGE)?.sink,
                    eventPool?.getHandler(CH_CON_CHANGE)?.sink,
                    eventPool?.getHandler(CH_DEVICE_CHANGE)?.sink,
                    eventPool?.getHandler(CH_DISCOVERY_CHANGE)?.sink,
                    pluginBinding?.applicationContext,
                )
                context?.registerReceiver(receiver, intentFilter)
                result.success(true)
            }
            "unregister" -> {
                if (receiver == null) {
                    result.success(false)
                    return
                }

                context?.unregisterReceiver(receiver)
                result.success(true)
            }
            "discover" -> {
                manager.discoverPeers(channel, ResultActionListener(result))
            }
            "stopDiscover" -> {
                manager.stopPeerDiscovery(channel, ResultActionListener(result))
            }
            "connect" -> {
                Log.e(TAG, "[Call] onMethodCall connect()")
                val device = Protos.WifiP2pDevice.parseFrom(call.argument<ByteArray>("payload"))
                Log.e(TAG, "[Device] $device | ${device.deviceName} | ${device.deviceAddress} | ")
//                val config = WifiP2pConfig().apply {
//                    deviceAddress = device.deviceAddress
//                }
                val config = WifiP2pConfig()
                config.deviceAddress = device.deviceAddress


                try {
                    manager.connect(channel, config, ResultActionListener(result))
                } catch (e: Exception) {
                    Log.e(TAG, "[Error] ${e.toString()}")
                }

            }
            "cancelConnect" -> {
                Log.e(TAG, "[Call] onMethodCall cancelConnect()")
                manager.cancelConnect(channel, ResultActionListener(result))
            }
            "removeGroup" -> {
                manager.requestGroupInfo(channel) { group ->
                    if (group != null) {
                        manager.removeGroup(channel, ResultActionListener(result))
                    } else {
                        //signal success as the device is not currently a member of a group
                        result.success(true)
                    }
                }
            }
            "openHostPort" -> {
                Log.e(TAG, "[Call] onMethodCall openHostPort()")
                val port = call.argument<Int>("port")
                if (port == null) {
                    result.error("Invalid port given", null, null)
                    return
                }

                socketPool.openSocket(port)
                result.success(true)
            }

            "closeHostPort" -> {
                Log.e(TAG, "[Call] onMethodCall closeHostPort()")
                val port = call.argument<Int>("port")
                if (port == null) {
                    result.error("Invalid port given", null, null)
                    return
                }

                socketPool.closeSocket(port)
                result.success(true)
            }
            "acceptPort" -> {
                val port = call.argument<Int>("port")
                if (port == null) {
                    result.error("Invalid port given", null, null)
                    return
                }

                socketPool.acceptClientConnection(port)
                result.success(true)
            }
            "connectToHost" -> {
                Log.e(TAG, "[Call] onMethodCall connectToHost()")
                val address = call.argument<String>("address")
                val port = call.argument<Int>("port")
                val timeout = call.argument<Int>("timeout") ?: config.timeout

                if (port == null || address == null) {
                    result.error("Invalid address or port given", null, null)
                    return
                }
                Log.e(TAG, "[Call] connectToHost $address | $port | $timeout")

                socketPool.connectToHost(address, port, timeout)
                result.success(true)
            }
            "disconnectFromHost" -> {
                Log.e(TAG, "[Call] onMethodCall disconnectFromHost()")
                val port = call.argument<Int>("port")
                if (port == null) {
                    result.error("Invalid port given", null, null)
                    return
                }
                this.socketPool.disconnectFromHost(port)
                result.success(true)
            }
            "sendDataToHost" -> {
                val socketMessage =
                    Protos.SocketMessage.parseFrom(call.argument<ByteArray>("payload"))

                this.socketPool.sendDataToHost(socketMessage.port, socketMessage.data.toByteArray())
                result.success(true)
            }
            "sendDataToClient" -> {
                val socketMessage =
                    Protos.SocketMessage.parseFrom(call.argument<ByteArray>("payload"))

                this.socketPool.sendDataToClient(
                    socketMessage.port,
                    socketMessage.data.toByteArray()
                )
                result.success(true)
            }
            "requestLocationPermission" -> {
                val perm = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
                activityBinding?.let {
                    ActivityCompat.requestPermissions(
                        it.activity, perm, REQUEST_ENABLE_LOCATION
                    )
                }
                result?.success(true)
            }
            "isLocationPermissionGranted" -> {
                val permission = Manifest.permission.ACCESS_FINE_LOCATION
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    result.success(
                        PackageManager.PERMISSION_GRANTED == context
                            ?.checkSelfPermission(permission)
                    )
                }
            }
        }
    }
}
