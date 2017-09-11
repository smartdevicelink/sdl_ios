//
//  SDLLifecycleConfigurationUpdate.h
//  SmartDeviceLink-iOS
//
//  Created by Kujtim Shala on 06.09.17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLTTSChunk;

@interface SDLLifecycleConfigurationUpdate : NSObject

/**
 *  The full name of the app to that the configuration should be updated to.
 */
@property (copy, nonatomic, nullable) NSString *appName;

/**
 *  An abbrevited application name that will be used on the app launching screen if the full one would be truncated.
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
