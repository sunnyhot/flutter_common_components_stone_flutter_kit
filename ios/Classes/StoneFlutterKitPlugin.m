#import "StoneFlutterKitPlugin.h"
#if __has_include(<stone_flutter_kit/stone_flutter_kit-Swift.h>)
#import <stone_flutter_kit/stone_flutter_kit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "stone_flutter_kit-Swift.h"
#endif

@implementation StoneFlutterKitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftStoneFlutterKitPlugin registerWithRegistrar:registrar];
}
@end
