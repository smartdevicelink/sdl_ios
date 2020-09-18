//
//  SDLManagerConfiguration.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAppHMIType.h"
#import "SDLLanguage.h"

@class SDLFile;
@class SDLTemplateColorScheme;
@class SDLTTSChunk;
@class SDLVersion;


NS_ASSUME_NONNULL_BEGIN

/// List of secondary transports
typedef NS_OPTIONS(NSUInteger, SDLSecondaryTransports) {
    /// No secondary transport
    SDLSecondaryTransportsNone = 0,

    /// TCP as secondary transport
    SDLSecondaryTransportsTCP = 1 << 0
};

/**
 *  Configuration options for SDLManager
 */
@interface SDLLifecycleConfiguration : NSObject <NSCopying>

/// Initializer unavailable
- (instancetype)init NS_UNAVAILABLE;

/**
 *  A production configuration that runs using IAP. Additional functionality should be customized on the properties.
 *
 *  @param appName      The name of the app.
 *  @param fullAppId    The full app id to be used. This should be registered with the head unit's manufacturer. When set, the `appId` parameter will be set automatically to the first 10 non-dash characters of the `fullAppId`.
 *
 *  @return The lifecycle configuration
 */
+ (SDLLifecycleConfiguration *)defaultConfigurationWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppId NS_SWIFT_NAME(init(appName:fullAppId:));

/**
 *  A debug configuration that runs using TCP. Additional functionality should be customized on the properties.
 *
 *  @param appName      The name of the app.
 *  @param fullAppId    The full app id to be used. This should be registered with the head unit's manufacturer. When set, the `appId` parameter will be set automatically to the first 10 non-dash characters of the `fullAppId` if the `fullAppId` is a valid UUID string. Otherwise, the `appId` parameter will be set to the same string as the `fullAppId` parameter. If you want to set the `appId` parameter separately, set the `fullAppId` here, then set the `appId` parameter separately.
 *  @param ipAddress    The ip address of the server to connect to
 *  @param port         The port of the server to connect to
 *
 *  @return The lifecycle configuration
 */
+ (SDLLifecycleConfiguration *)debugConfigurationWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppId ipAddress:(NSString *)ipAddress port:(UInt16)port NS_SWIFT_NAME(init(appName:fullAppId:ipAddress:port:));

/**
 *  Whether or not debug mode is enabled
 */
@property (assign, nonatomic, readonly) BOOL tcpDebugMode;

/**
 *  The ip address at which the library will look for a server
 */
@property (copy, nonatomic, readonly, null_resettable) NSString *tcpDebugIPAddress;

/**
 *  The port at which the library will look for a server
 */
@property (assign, nonatomic, readonly) UInt16 tcpDebugPort;

/**
 *  The full name of the app
 */
@property (copy, nonatomic) NSString *appName;

/**
 *  The app id. This must be the same as the app id received from the SDL developer portal.
 *
 *  @see `fullAppId`
 *
 *  Required
 */
@property (copy, nonatomic) NSString *appId;

/**
 *  The full app id. This must be the same as the full app id received from the SDL developer portal.
 *
 *  Optional
 *
 *  @discussion  The `fullAppId` is used to authenticate apps that connect with modules that support RPC spec v.5.0 and newer. If connecting with older modules, the `fullAppId` may be truncated to create the required `appId` needed to register the app on older modules. The `appId` is the first 10 non-dash ("-") characters of the `fullAppId` (e.g. if you have a `fullAppId` of 123e4567-e89b-12d3-a456-426655440000, the `appId` will be 123e4567e8).
 */
@property (copy, nonatomic, nullable, readonly) NSString *fullAppId;

/**
 *  A hash id which should be passed to the remote system in the RegisterAppInterface
 */
@property (copy, nonatomic, nullable) NSString *resumeHash;

/**
 *  This is an automatically set based on the app type
 */
@property (assign, nonatomic, readonly) BOOL isMedia;

/**
 *  The application type
 */
@property (strong, nonatomic, null_resettable) SDLAppHMIType appType;

/**
 *  Additional application types beyond `appType`
 */
@property (copy, nonatomic, nullable) NSArray<SDLAppHMIType> *additionalAppTypes;

/**
 *  The default language to use
 */
@property (strong, nonatomic) SDLLanguage language;

/**
 *  An array of all the supported languages
 */
@property (strong, nonatomic) NSArray<SDLLanguage> *languagesSupported;

/**
 *  The application icon to be used on an app launching screen
 */
@property (strong, nonatomic, nullable) SDLFile *appIcon;

/**
 *  An abbrevited application name that will be used on the app launching screen if the full one would be truncated
 */
@property (copy, nonatomic, nullable) NSString *shortAppName;

/**
 *  A Text to Speech String for voice recognition of the mobile application name.
 */
@property (copy, nonatomic, nullable) NSArray<SDLTTSChunk *> *ttsName;

/**
 *  Additional voice recognition commands. May not interfere with any other app name or global commands.
 */
@property (copy, nonatomic, nullable) NSArray<NSString *> *voiceRecognitionCommandNames;

/**
 *  The color scheme to use when the head unit is in a light / day situation.
 */
@property (copy, nonatomic, nullable) SDLTemplateColorScheme *dayColorScheme;

/**
 *  The color scheme to use when the head unit is in a dark / night situation.
 */
@property (copy, nonatomic, nullable) SDLTemplateColorScheme *nightColorScheme;

/**
 The minimum protocol version that will be permitted to connect. This defaults to 1.0.0. If the protocol version of the head unit connected is below this version, the app will disconnect with an EndService protocol message and will not register.
 */
@property (strong, nonatomic) SDLVersion *minimumProtocolVersion;

/**
 The minimum RPC version that will be permitted to connect. This defaults to 1.0.0. If the RPC version of the head unit connected is below this version, an UnregisterAppInterface will be sent.
 */
@property (strong, nonatomic) SDLVersion *minimumRPCVersion;

/**
 Which transports are permitted to be used as secondary transports. A secondary transport is a transport that is connected as an alternate, higher bandwidth transport for situations when a low-bandwidth primary transport (such as Bluetooth) will restrict certain features (such as video streaming navigation).

 The only currently available secondary transport is TCP over WiFi. This is set to permit TCP by default, but it can be disabled by using SDLSecondaryTransportsNone instead.

 This will only affect apps that have high-bandwidth requirements; currently that is only video streaming navigation apps.
 */
@property (assign, nonatomic) SDLSecondaryTransports allowedSecondaryTransports;

@end

NS_ASSUME_NONNULL_END
