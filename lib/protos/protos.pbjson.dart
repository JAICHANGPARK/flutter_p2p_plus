///
//  Generated code. Do not modify.
//  source: protos.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use stateChangeDescriptor instead')
const StateChange$json = const {
  '1': 'StateChange',
  '2': const [
    const {'1': 'isEnabled', '3': 1, '4': 1, '5': 8, '10': 'isEnabled'},
  ],
};

/// Descriptor for `StateChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stateChangeDescriptor = $convert.base64Decode('CgtTdGF0ZUNoYW5nZRIcCglpc0VuYWJsZWQYASABKAhSCWlzRW5hYmxlZA==');
@$core.Deprecated('Use wifiP2pDeviceDescriptor instead')
const WifiP2pDevice$json = const {
  '1': 'WifiP2pDevice',
  '2': const [
    const {'1': 'wpsPbcSupported', '3': 1, '4': 1, '5': 8, '10': 'wpsPbcSupported'},
    const {'1': 'wpsKeypadSupported', '3': 2, '4': 1, '5': 8, '10': 'wpsKeypadSupported'},
    const {'1': 'wpsDisplaySupported', '3': 3, '4': 1, '5': 8, '10': 'wpsDisplaySupported'},
    const {'1': 'isServiceDiscoveryCapable', '3': 4, '4': 1, '5': 8, '10': 'isServiceDiscoveryCapable'},
    const {'1': 'isGroupOwner', '3': 5, '4': 1, '5': 8, '10': 'isGroupOwner'},
    const {'1': 'deviceName', '3': 6, '4': 1, '5': 9, '10': 'deviceName'},
    const {'1': 'deviceAddress', '3': 7, '4': 1, '5': 9, '10': 'deviceAddress'},
    const {'1': 'primaryDeviceType', '3': 8, '4': 1, '5': 9, '10': 'primaryDeviceType'},
    const {'1': 'secondaryDeviceType', '3': 9, '4': 1, '5': 9, '10': 'secondaryDeviceType'},
    const {'1': 'status', '3': 10, '4': 1, '5': 14, '6': '.WifiP2pDevice.Status', '10': 'status'},
  ],
  '4': const [WifiP2pDevice_Status$json],
};

@$core.Deprecated('Use wifiP2pDeviceDescriptor instead')
const WifiP2pDevice_Status$json = const {
  '1': 'Status',
  '2': const [
    const {'1': 'CONNECTED', '2': 0},
    const {'1': 'INVITED', '2': 1},
    const {'1': 'FAILED', '2': 2},
    const {'1': 'AVAILABLE', '2': 3},
    const {'1': 'UNAVAILABLE', '2': 4},
  ],
};

/// Descriptor for `WifiP2pDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wifiP2pDeviceDescriptor = $convert.base64Decode('Cg1XaWZpUDJwRGV2aWNlEigKD3dwc1BiY1N1cHBvcnRlZBgBIAEoCFIPd3BzUGJjU3VwcG9ydGVkEi4KEndwc0tleXBhZFN1cHBvcnRlZBgCIAEoCFISd3BzS2V5cGFkU3VwcG9ydGVkEjAKE3dwc0Rpc3BsYXlTdXBwb3J0ZWQYAyABKAhSE3dwc0Rpc3BsYXlTdXBwb3J0ZWQSPAoZaXNTZXJ2aWNlRGlzY292ZXJ5Q2FwYWJsZRgEIAEoCFIZaXNTZXJ2aWNlRGlzY292ZXJ5Q2FwYWJsZRIiCgxpc0dyb3VwT3duZXIYBSABKAhSDGlzR3JvdXBPd25lchIeCgpkZXZpY2VOYW1lGAYgASgJUgpkZXZpY2VOYW1lEiQKDWRldmljZUFkZHJlc3MYByABKAlSDWRldmljZUFkZHJlc3MSLAoRcHJpbWFyeURldmljZVR5cGUYCCABKAlSEXByaW1hcnlEZXZpY2VUeXBlEjAKE3NlY29uZGFyeURldmljZVR5cGUYCSABKAlSE3NlY29uZGFyeURldmljZVR5cGUSLQoGc3RhdHVzGAogASgOMhUuV2lmaVAycERldmljZS5TdGF0dXNSBnN0YXR1cyJQCgZTdGF0dXMSDQoJQ09OTkVDVEVEEAASCwoHSU5WSVRFRBABEgoKBkZBSUxFRBACEg0KCUFWQUlMQUJMRRADEg8KC1VOQVZBSUxBQkxFEAQ=');
@$core.Deprecated('Use wifiP2pDeviceListDescriptor instead')
const WifiP2pDeviceList$json = const {
  '1': 'WifiP2pDeviceList',
  '2': const [
    const {'1': 'devices', '3': 1, '4': 3, '5': 11, '6': '.WifiP2pDevice', '10': 'devices'},
  ],
};

/// Descriptor for `WifiP2pDeviceList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wifiP2pDeviceListDescriptor = $convert.base64Decode('ChFXaWZpUDJwRGV2aWNlTGlzdBIoCgdkZXZpY2VzGAEgAygLMg4uV2lmaVAycERldmljZVIHZGV2aWNlcw==');
@$core.Deprecated('Use connectionChangeDescriptor instead')
const ConnectionChange$json = const {
  '1': 'ConnectionChange',
  '2': const [
    const {'1': 'wifiP2pInfo', '3': 1, '4': 1, '5': 11, '6': '.WifiP2pInfo', '10': 'wifiP2pInfo'},
    const {'1': 'networkInfo', '3': 2, '4': 1, '5': 11, '6': '.NetworkInfo', '10': 'networkInfo'},
  ],
};

/// Descriptor for `ConnectionChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionChangeDescriptor = $convert.base64Decode('ChBDb25uZWN0aW9uQ2hhbmdlEi4KC3dpZmlQMnBJbmZvGAEgASgLMgwuV2lmaVAycEluZm9SC3dpZmlQMnBJbmZvEi4KC25ldHdvcmtJbmZvGAIgASgLMgwuTmV0d29ya0luZm9SC25ldHdvcmtJbmZv');
@$core.Deprecated('Use wifiP2pInfoDescriptor instead')
const WifiP2pInfo$json = const {
  '1': 'WifiP2pInfo',
  '2': const [
    const {'1': 'groupFormed', '3': 1, '4': 1, '5': 8, '10': 'groupFormed'},
    const {'1': 'isGroupOwner', '3': 2, '4': 1, '5': 8, '10': 'isGroupOwner'},
    const {'1': 'groupOwnerAddress', '3': 3, '4': 1, '5': 9, '10': 'groupOwnerAddress'},
  ],
};

/// Descriptor for `WifiP2pInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wifiP2pInfoDescriptor = $convert.base64Decode('CgtXaWZpUDJwSW5mbxIgCgtncm91cEZvcm1lZBgBIAEoCFILZ3JvdXBGb3JtZWQSIgoMaXNHcm91cE93bmVyGAIgASgIUgxpc0dyb3VwT3duZXISLAoRZ3JvdXBPd25lckFkZHJlc3MYAyABKAlSEWdyb3VwT3duZXJBZGRyZXNz');
@$core.Deprecated('Use networkInfoDescriptor instead')
const NetworkInfo$json = const {
  '1': 'NetworkInfo',
  '2': const [
    const {'1': 'subType', '3': 1, '4': 1, '5': 5, '10': 'subType'},
    const {'1': 'isConnected', '3': 2, '4': 1, '5': 8, '10': 'isConnected'},
    const {'1': 'detailedState', '3': 3, '4': 1, '5': 14, '6': '.NetworkInfo.DetailedState', '10': 'detailedState'},
    const {'1': 'extraInfo', '3': 4, '4': 1, '5': 9, '10': 'extraInfo'},
  ],
  '4': const [NetworkInfo_DetailedState$json],
};

@$core.Deprecated('Use networkInfoDescriptor instead')
const NetworkInfo_DetailedState$json = const {
  '1': 'DetailedState',
  '2': const [
    const {'1': 'IDLE', '2': 0},
    const {'1': 'SCANNING', '2': 1},
    const {'1': 'CONNECTING', '2': 2},
    const {'1': 'AUTHENTICATING', '2': 3},
    const {'1': 'OBTAINING_IPADDR', '2': 4},
    const {'1': 'CONNECTED', '2': 5},
    const {'1': 'SUSPENDED', '2': 6},
    const {'1': 'DISCONNECTING', '2': 7},
    const {'1': 'DISCONNECTED', '2': 8},
    const {'1': 'FAILED', '2': 9},
    const {'1': 'BLOCKED', '2': 10},
    const {'1': 'VERIFYING_POOR_LINK', '2': 11},
    const {'1': 'CAPTIVE_PORTAL_CHECK', '2': 12},
  ],
};

/// Descriptor for `NetworkInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List networkInfoDescriptor = $convert.base64Decode('CgtOZXR3b3JrSW5mbxIYCgdzdWJUeXBlGAEgASgFUgdzdWJUeXBlEiAKC2lzQ29ubmVjdGVkGAIgASgIUgtpc0Nvbm5lY3RlZBJACg1kZXRhaWxlZFN0YXRlGAMgASgOMhouTmV0d29ya0luZm8uRGV0YWlsZWRTdGF0ZVINZGV0YWlsZWRTdGF0ZRIcCglleHRyYUluZm8YBCABKAlSCWV4dHJhSW5mbyLwAQoNRGV0YWlsZWRTdGF0ZRIICgRJRExFEAASDAoIU0NBTk5JTkcQARIOCgpDT05ORUNUSU5HEAISEgoOQVVUSEVOVElDQVRJTkcQAxIUChBPQlRBSU5JTkdfSVBBRERSEAQSDQoJQ09OTkVDVEVEEAUSDQoJU1VTUEVOREVEEAYSEQoNRElTQ09OTkVDVElORxAHEhAKDERJU0NPTk5FQ1RFRBAIEgoKBkZBSUxFRBAJEgsKB0JMT0NLRUQQChIXChNWRVJJRllJTkdfUE9PUl9MSU5LEAsSGAoUQ0FQVElWRV9QT1JUQUxfQ0hFQ0sQDA==');
@$core.Deprecated('Use requestPermissionResultDescriptor instead')
const RequestPermissionResult$json = const {
  '1': 'RequestPermissionResult',
  '2': const [
    const {'1': 'requestCode', '3': 1, '4': 1, '5': 5, '10': 'requestCode'},
    const {'1': 'grantedPermissions', '3': 2, '4': 3, '5': 9, '10': 'grantedPermissions'},
  ],
};

/// Descriptor for `RequestPermissionResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestPermissionResultDescriptor = $convert.base64Decode('ChdSZXF1ZXN0UGVybWlzc2lvblJlc3VsdBIgCgtyZXF1ZXN0Q29kZRgBIAEoBVILcmVxdWVzdENvZGUSLgoSZ3JhbnRlZFBlcm1pc3Npb25zGAIgAygJUhJncmFudGVkUGVybWlzc2lvbnM=');
@$core.Deprecated('Use socketMessageDescriptor instead')
const SocketMessage$json = const {
  '1': 'SocketMessage',
  '2': const [
    const {'1': 'port', '3': 1, '4': 1, '5': 5, '10': 'port'},
    const {'1': 'dataAvailable', '3': 2, '4': 1, '5': 5, '10': 'dataAvailable'},
    const {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `SocketMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List socketMessageDescriptor = $convert.base64Decode('Cg1Tb2NrZXRNZXNzYWdlEhIKBHBvcnQYASABKAVSBHBvcnQSJAoNZGF0YUF2YWlsYWJsZRgCIAEoBVINZGF0YUF2YWlsYWJsZRISCgRkYXRhGAMgASgMUgRkYXRh');
@$core.Deprecated('Use discoveryStateChangeDescriptor instead')
const DiscoveryStateChange$json = const {
  '1': 'DiscoveryStateChange',
  '2': const [
    const {'1': 'isDiscovering', '3': 1, '4': 1, '5': 8, '10': 'isDiscovering'},
  ],
};

/// Descriptor for `DiscoveryStateChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoveryStateChangeDescriptor = $convert.base64Decode('ChREaXNjb3ZlcnlTdGF0ZUNoYW5nZRIkCg1pc0Rpc2NvdmVyaW5nGAEgASgIUg1pc0Rpc2NvdmVyaW5n');
@$core.Deprecated('Use socketStateDescriptor instead')
const SocketState$json = const {
  '1': 'SocketState',
  '2': const [
    const {'1': 'isDisconnect', '3': 1, '4': 1, '5': 8, '10': 'isDisconnect'},
  ],
};

/// Descriptor for `SocketState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List socketStateDescriptor = $convert.base64Decode('CgtTb2NrZXRTdGF0ZRIiCgxpc0Rpc2Nvbm5lY3QYASABKAhSDGlzRGlzY29ubmVjdA==');
