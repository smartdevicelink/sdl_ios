//
//  SDLLockScreenManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/8/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLLockScreenConfiguration;
@class SDLLockScreenViewController;


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenManager : NSObject

@property (assign, nonatomic, readonly) BOOL lockScreenPresented;

- (instancetype)initWithConfiguration:(SDLLockScreenConfiguration *)config notificationDispatcher:(nullable id)dispatcher;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
