#import "FlutterP2pPlusPlugin.h"
#if __has_include(<flutter_p2p_plus/flutter_p2p_plus-Swift.h>)
#import <flutter_p2p_plus/flutter_p2p_plus-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_p2p_plus-Swift.h"
#endif

@implementation FlutterP2pPlusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterP2pPlusPlugin registerWithRegistrar:registrar];
}
@end
