//
//  SDLConfiguration.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/13/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLLifecycleConfiguration;
@class SDLLockScreenConfiguration;
@class SDLLogConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface SDLConfiguration : NSObject <NSCopying>

/**
 *  The lifecycle configuration.
 */
@property (copy, nonatomic, readonly) SDLLifecycleConfiguration *lifecycleConfig;

/**
 *  The lock screen configuration.
 */
@property (copy, nonatomic, readonly) SDLLockScreenConfiguration *lockScreenConfig;


/**
 The log configuration.
 */
@property (copy, nonatomic, readonly) SDLLogConfiguration *loggingConfig;

/**
 Create a new configuration to be passed into SDLManager with a custom lifecycle, lock screen, and a default logging configuration.

 @param lifecycleConfiguration The lifecycle configuration to be used.
 @return The configuration
 */
- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfiguration;

/**
 *  Create a new configuration to be passed into SDLManager with a custom lifecycle, lock screen, and a default logging configuration.
 *
 *  @param lifecycleConfig  The lifecycle configuration to be used.
 *  @param lockScreenConfig The lockscreen configuration to be used, or `enabledConfiguration` if nil.
 *
 *  @return The configuration
 */
- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig;

/**
 Create a new configuration to be passed into SDLManager with a custom lifecycle, lock screen, and logging configuration.

 @param lifecycleConfig The lifecycle configuration to be used.
 @param lockScreenConfig The lockscreen configuration to be used, or `enabledConfiguration` if nil.
 @param logConfig The logging configuration to be used, or `defaultConfiguration` if nil.
 @return The configuration
 */
- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig;

/**
 Create a new configuration to be passed into SDLManager with a custom lifecycle, lock screen, and a default logging configuration.

 @param lifecycleConfiguration The lifecycle configuration to be used.
 @return The configuration
 */
+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfiguration;

/**
 *  Create a new configuration to be passed into SDLManager with a custom lifecycle, lock screen, and a default logging configuration.
 *
 *  @param lifecycleConfig  The lifecycle configuration to be used.
 *  @param lockScreenConfig The lockscreen configuration to be used, or `enabledConfiguration` if nil.
 *
 *  @return The configuration
 */
+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig;

/**
 Create a new configuration to be passed into SDLManager with a custom lifecycle, lock screen, and logging configuration.

 @param lifecycleConfig The lifecycle configuration to be used.
 @param lockScreenConfig The lockscreen configuration to be used, or `enabledConfiguration` if nil.
 @param logConfig The logging configuration to be used, or `defaultConfiguration` if nil.
 @return The configuration
 */
+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig;

@end

NS_ASSUME_NONNULL_END
