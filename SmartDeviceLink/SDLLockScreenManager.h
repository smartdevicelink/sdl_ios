//
//  SDLLockScreenManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/8/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLLockScreenConfiguration;
@class SDLLockScreenViewController;
@protocol SDLViewControllerPresentable;


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenManager : NSObject

@property (assign, nonatomic, readonly) BOOL lockScreenPresented;
@property (copy, nonatomic, readonly) SDLLockScreenConfiguration *config;
@property (strong, nonatomic, readonly, nullable) UIViewController *lockScreenViewController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(SDLLockScreenConfiguration *)config notificationDispatcher:(nullable id)dispatcher presenter:(id<SDLViewControllerPresentable>)presenter;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
