//
//  SDLConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/13/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLConfiguration.h"

#import "SDLLifecycleConfiguration.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLogConfiguration.h"
#import "SDLStreamingMediaConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLConfiguration

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    return [self initWithLifecycle:lifecycleConfiguration lockScreen:nil logging:nil];
}

+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    return [[self alloc] initWithLifecycle:lifecycleConfiguration lockScreen:nil logging:nil];
}

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig {
    return [self initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:nil];
}

+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig {
    return [[self alloc] initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig];
}

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig {
    self = [super init];
    if (!self) {
        return nil;
    }

    _lifecycleConfig = lifecycleConfig;
    _lockScreenConfig = lockScreenConfig ?: [SDLLockScreenConfiguration enabledConfiguration];
    _loggingConfig = logConfig ?: [SDLLogConfiguration defaultConfiguration];

    return self;
}

+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig {
    return [[self alloc] initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:logConfig];
}

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig {
    self = [super init];
    if (!self) {
        return nil;
    }

    _lifecycleConfig = lifecycleConfig;
    _lockScreenConfig = lockScreenConfig ?: [SDLLockScreenConfiguration enabledConfiguration];
    _loggingConfig = logConfig ?: [SDLLogConfiguration defaultConfiguration];
    _streamingMediaConfig = streamingMediaConfig;

    if (_streamingMediaConfig != nil) {
        // If we have a streaming config, the apptype MUST be navigation or projection
        NSAssert(([_lifecycleConfig.appType isEqualToEnum:SDLAppHMITypeNavigation] || [_lifecycleConfig.appType isEqualToEnum:SDLAppHMITypeProjection] || [_lifecycleConfig.additionalAppTypes containsObject:SDLAppHMITypeNavigation] || [_lifecycleConfig.additionalAppTypes containsObject:SDLAppHMITypeProjection]), @"You should only set a streaming media configuration if your app is a NAVIGATION or PROJECTION HMI type");
        _streamingMediaConfig = streamingMediaConfig;
    } else {
        // If we don't have a streaming config, we MUST NOT be navigation or projection
        NSAssert(!([_lifecycleConfig.appType isEqualToEnum:SDLAppHMITypeNavigation] || [_lifecycleConfig.appType isEqualToEnum:SDLAppHMITypeProjection] || [_lifecycleConfig.additionalAppTypes containsObject:SDLAppHMITypeNavigation] || [_lifecycleConfig.additionalAppTypes containsObject:SDLAppHMITypeProjection]), @"If your app is a NAVIGATION or PROJECTION HMI type, you must set a streaming media configuration on SDLConfiguration");
    }

    return self;
}

+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig {
    return [[self alloc] initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:logConfig streamingMedia:streamingMediaConfig];
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLConfiguration *new = [[SDLConfiguration allocWithZone:zone] initWithLifecycle: _lifecycleConfig lockScreen: _lockScreenConfig logging:_loggingConfig streamingMedia:_streamingMediaConfig];

    return new;
}

@end

NS_ASSUME_NONNULL_END
