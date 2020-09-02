//
//  SDLLifecycleConfigurationUpdate.h
//  SmartDeviceLink-iOS
//
//  Created by Kujtim Shala on 06.09.17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLTTSChunk;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Configuration update options for SDLManager. This class can be used to update the lifecycle configuration in
 *  cases the language of the head unit changes or does not match the app language.
 */
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

/**
 *  Initializes and returns a newly allocated lifecycle configuration update object with the specified app data.
 *  This is a convenience initializer for -init.
 *  @param appName The full name of the app to that the configuration should be updated to.
 *  @param shortAppName An abbrevited application name that will be used on the app launching screen if the full one would be truncated.
 *  @param ttsName A Text to Speech String for voice recognition of the mobile application name.
 *  @param voiceRecognitionCommandNames Additional voice recognition commands. May not interfere with any other app name or global commands.
 */
- (instancetype)initWithAppName:(nullable NSString *)appName shortAppName:(nullable NSString *)shortAppName ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName voiceRecognitionCommandNames:(nullable NSArray<NSString *> *)voiceRecognitionCommandNames;

@end

NS_ASSUME_NONNULL_END
