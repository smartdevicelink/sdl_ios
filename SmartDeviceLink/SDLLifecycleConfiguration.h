//
//  SDLManagerConfiguration.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

@import UIKit;

#import <Foundation/Foundation.h>

@class SDLAppHMIType;
@class SDLFile;
@class SDLLanguage;


NS_ASSUME_NONNULL_BEGIN

/**
 *  Configuration options for SDLManager
 */
@interface SDLLifecycleConfiguration : NSObject <NSCopying>

// TODO: Need documentation
+ (SDLLifecycleConfiguration *)defaultConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId;
+ (SDLLifecycleConfiguration *)debugConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId ipAddress:(NSString *)ipAddress port:(NSString *)port;

@property (assign, nonatomic) BOOL tcpDebugMode;
@property (copy, nonatomic, null_resettable) NSString *tcpDebugIPAddress;
@property (copy, nonatomic, null_resettable) NSString *tcpDebugPort;

@property (copy, nonatomic, readonly) NSString *appName;
@property (copy, nonatomic, readonly) NSString *appId;

/**
 *  This is an automatically set based on the app type
 */
@property (assign, nonatomic, readonly) BOOL isMedia;

@property (strong, nonatomic, null_resettable) SDLAppHMIType *appType;
@property (strong, nonatomic) SDLLanguage *language;
@property (strong, nonatomic) NSArray<SDLLanguage *> *languagesSupported;
@property (copy, nonatomic, nullable) NSString *shortAppName;
@property (copy, nonatomic, nullable) NSString *ttsName;
@property (copy, nonatomic) NSArray<NSString *> *voiceRecognitionSynonyms; // TODO: Better name?

@end

NS_ASSUME_NONNULL_END
