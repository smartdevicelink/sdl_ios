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
@class SDLTTSChunk;


NS_ASSUME_NONNULL_BEGIN

/**
 *  Configuration options for SDLManager
 */
@interface SDLLifecycleConfiguration : NSObject <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 *  A production configuration that runs using IAP. Additional functionality should be customized on the properties.
 *
 *  @param appName The name of the app.
 *  @param appId   The appId to be used. This should be registered with the radio's manufacturer.
 *
 *  @return The lifecycle configuration
 */
+ (SDLLifecycleConfiguration *)defaultConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId NS_SWIFT_NAME(init(appName:appId:));

/**
 *  A debug configuration that runs using TCP. Additional functionality should be customized on the properties.
 *
 *  @param appName   The name of the app.
 *  @param appId     The appId to be used. This should be registered with the radio's manufacturer.
 *  @param ipAddress The ip address of the server to connect to
 *  @param port      The port of the server to connect to
 *
 *  @return The lifecycle configuration
 */
+ (SDLLifecycleConfiguration *)debugConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId ipAddress:(NSString *)ipAddress port:(UInt16)port NS_SWIFT_NAME(init(appName:appId:ipAddress:port:));

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
 *  The app id. This must be the same as the app id received from the SDL developer portal or OEM.
 */
@property (copy, nonatomic, readonly) NSString *appId;

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
 Additional application types beyond `appType`
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

@end

NS_ASSUME_NONNULL_END
