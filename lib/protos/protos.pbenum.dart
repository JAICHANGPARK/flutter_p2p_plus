///
//  Generated code. Do not modify.
//  source: protos.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class WifiP2pDevice_Status extends $pb.ProtobufEnum {
  static const WifiP2pDevice_Status CONNECTED = WifiP2pDevice_Status._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONNECTED');
  static const WifiP2pDevice_Status INVITED = WifiP2pDevice_Status._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'INVITED');
  static const WifiP2pDevice_Status FAILED = WifiP2pDevice_Status._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FAILED');
  static const WifiP2pDevice_Status AVAILABLE = WifiP2pDevice_Status._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AVAILABLE');
  static const WifiP2pDevice_Status UNAVAILABLE = WifiP2pDevice_Status._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNAVAILABLE');

  static const $core.List<WifiP2pDevice_Status> values = <WifiP2pDevice_Status> [
    CONNECTED,
    INVITED,
    FAILED,
    AVAILABLE,
    UNAVAILABLE,
  ];

  static final $core.Map<$core.int, WifiP2pDevice_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WifiP2pDevice_Status? valueOf($core.int value) => _byValue[value];

  const WifiP2pDevice_Status._($core.int v, $core.String n) : super(v, n);
}

class NetworkInfo_DetailedState extends $pb.ProtobufEnum {
  static const NetworkInfo_DetailedState IDLE = NetworkInfo_DetailedState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'IDLE');
  static const NetworkInfo_DetailedState SCANNING = NetworkInfo_DetailedState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SCANNING');
  static const NetworkInfo_DetailedState CONNECTING = NetworkInfo_DetailedState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONNECTING');
  static const NetworkInfo_DetailedState AUTHENTICATING = NetworkInfo_DetailedState._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUTHENTICATING');
  static const NetworkInfo_DetailedState OBTAINING_IPADDR = NetworkInfo_DetailedState._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OBTAINING_IPADDR');
  static const NetworkInfo_DetailedState CONNECTED = NetworkInfo_DetailedState._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONNECTED');
  static const NetworkInfo_DetailedState SUSPENDED = NetworkInfo_DetailedState._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUSPENDED');
  static const NetworkInfo_DetailedState DISCONNECTING = NetworkInfo_DetailedState._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DISCONNECTING');
  static const NetworkInfo_DetailedState DISCONNECTED = NetworkInfo_DetailedState._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DISCONNECTED');
  static const NetworkInfo_DetailedState FAILED = NetworkInfo_DetailedState._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FAILED');
  static const NetworkInfo_DetailedState BLOCKED = NetworkInfo_DetailedState._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BLOCKED');
  static const NetworkInfo_DetailedState VERIFYING_POOR_LINK = NetworkInfo_DetailedState._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VERIFYING_POOR_LINK');
  static const NetworkInfo_DetailedState CAPTIVE_PORTAL_CHECK = NetworkInfo_DetailedState._(12, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CAPTIVE_PORTAL_CHECK');

  static const $core.List<NetworkInfo_DetailedState> values = <NetworkInfo_DetailedState> [
    IDLE,
    SCANNING,
    CONNECTING,
    AUTHENTICATING,
    OBTAINING_IPADDR,
    CONNECTED,
    SUSPENDED,
    DISCONNECTING,
    DISCONNECTED,
    FAILED,
    BLOCKED,
    VERIFYING_POOR_LINK,
    CAPTIVE_PORTAL_CHECK,
  ];

  static final $core.Map<$core.int, NetworkInfo_DetailedState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static NetworkInfo_DetailedState? valueOf($core.int value) => _byValue[value];

  const NetworkInfo_DetailedState._($core.int v, $core.String n) : super(v, n);
}

