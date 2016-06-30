//
//  SDLLockScreenConfiguration.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/13/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

@import UIKit;

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenConfiguration : NSObject <NSCopying>

@property (assign, nonatomic) BOOL showInOptional;

/**
 *  If YES, the lock screen should be managed by SDL and automatically engage when necessary. If NO, then the lock screen will never be engaged.
 */
@property (assign, nonatomic, readonly) BOOL enableAutomaticLockScreen;

@property (copy, nonatomic, readonly) UIColor *backgroundColor;
@property (copy, nonatomic, readonly, nullable) UIImage *appIcon;
@property (strong, nonatomic, readonly, nullable) UIViewController *customViewController;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)disabledConfiguration;
+ (instancetype)enabledConfiguration;
+ (instancetype)enabledConfigurationWithBackgroundColor:(nullable UIColor *)lockScreenBackgroundColor appIcon:(UIImage *)lockScreenAppIcon;
+ (instancetype)enabledConfigurationWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
