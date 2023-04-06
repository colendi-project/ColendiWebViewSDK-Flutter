#import "ColendiWebViewSdkFlutterPlugin.h"
#if __has_include(<colendi_web_view_sdk_flutter/colendi_web_view_sdk_flutter-Swift.h>)
#import <colendi_web_view_sdk_flutter/colendi_web_view_sdk_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "colendi_web_view_sdk_flutter-Swift.h"
#endif

@implementation ColendiWebViewSdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftColendiWebViewSdkFlutterPlugin registerWithRegistrar:registrar];
}
@end
