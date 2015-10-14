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

@property (copy, nonatomic, readonly) SDLLifecycleConfiguration *lifecycleConfig;
@property (copy, nonatomic, readonly) SDLLockScreenConfiguration *lockScreenConfig;


- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig;
+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig;

@end

NS_ASSUME_NONNULL_END
