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

NS_ASSUME_NONNULL_BEGIN

@implementation SDLConfiguration

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


#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLConfiguration *new = [[SDLConfiguration allocWithZone:zone] initWithLifecycle: _lifecycleConfig lockScreen: _lockScreenConfig logging:_loggingConfig];

    return new;
}

@end

NS_ASSUME_NONNULL_END
