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
 *  Create a new configuration to be passed into SDLManager.
 *
 *  @param lifecycleConfig  The lifecycle configuration to be used.
 *  @param lockScreenConfig The lockscreen configuration to be used. If nil, this will be `enabledConfiguration`.
 *
 *  @return The configuration
 */
- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(SDLLockScreenConfiguration *)lockScreenConfig;

/**
 *  Create a new configuration to be passed into SDLManager.
 *
 *  @param lifecycleConfig  The lifecycle configuration to be used.
 *  @param lockScreenConfig The lockscreen configuration to be used. If nil, this will be `enabledConfiguration`.
 *
 *  @return The configuration
 */
+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(SDLLockScreenConfiguration *)lockScreenConfig;

@end

NS_ASSUME_NONNULL_END
