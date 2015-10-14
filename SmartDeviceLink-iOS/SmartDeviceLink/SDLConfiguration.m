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

NS_ASSUME_NONNULL_BEGIN

@implementation SDLConfiguration

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _lifecycleConfig = lifecycleConfig;
    
    if (lockScreenConfig != nil) {
        _lockScreenConfig = lockScreenConfig;
    } else {
        _lockScreenConfig = [SDLLockScreenConfiguration enabledConfiguration];
    }
    
    return self;
}

+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig {
    return [[self alloc] initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLConfiguration *new = [[SDLConfiguration allocWithZone:zone] initWithLifecycle:_lifecycleConfig lockScreen:_lockScreenConfig];
    
    return new;
}

@end

NS_ASSUME_NONNULL_END
