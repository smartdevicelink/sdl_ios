//  SDLAppInfo.h
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A struct used in register app interface. Contains detailed information about the registered application.
 */
@interface SDLAppInfo : SDLRPCStruct

/// Convenience init with no parameters
///
/// @return An SDLAppInfo object
+ (instancetype)currentAppInfo;

/**
 The name displayed for the mobile application on the mobile device (can differ from the app name set in the initial RAI request).

 Required
 */
@property (strong, nonatomic) NSString *appDisplayName;

/**
 The AppBundleID of an iOS application or package name of the Android application. This supports App Launch strategies for each platform.

 Required
 */
@property (strong, nonatomic) NSString *appBundleID;

/**
 Represents the build version number of this particular mobile app.

 Required
 */
@property (strong, nonatomic) NSString *appVersion;

@end

NS_ASSUME_NONNULL_END
