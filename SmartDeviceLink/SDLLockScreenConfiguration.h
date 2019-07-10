//
//  SDLLockScreenConfiguration.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/13/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenConfiguration : NSObject <NSCopying>

/**
 *  Whether or not the lock screen should be shown in the "lock screen optional" state. Defaults to false.
 *
 *  @discussion In order for the "lock screen optional" state to occur, the following must be true:
 *  1. The app should have received at least 1 driver distraction notification (i.e. a `OnDriverDistraction` notification) from SDL Core. Older versions of Core did not send a notification immediately on connection.
 *  2. The driver is not distracted (i.e. the last `OnDriverDistraction` notification received was for a driver distraction state off).
 *  3. The `hmiLevel` can not be `NONE`.
 *  4. If the `hmiLevel` is currently `BACKGROUND` then the previous `hmiLevel` should have been `FULL` or `LIMITED` (i.e. the user should have interacted with app before it was backgrounded).
 */
@property (assign, nonatomic) BOOL showInOptionalState;

/**
 *  If YES, the lock screen should be managed by SDL and automatically engage when necessary. If NO, then the lock screen will never be engaged.
 */
@property (assign, nonatomic, readonly) BOOL enableAutomaticLockScreen;

/**
 *  The background color of the lock screen. This could be a branding color, or leave at the default for a dark blue-gray.
 */
@property (copy, nonatomic, readonly) UIColor *backgroundColor;

/**
 *  Your app icon as it will appear on the lock screen.
 */
@property (copy, nonatomic, readonly, nullable) UIImage *appIcon;

/**
 *  A custom view controller that the lock screen will manage the presentation of.
 */
@property (strong, nonatomic, readonly, nullable) UIViewController *customViewController;

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Use this configuration if you wish to manage a lock screen yourself. This may be useful if the automatic presentation feature of SDLLockScreenManager is failing for some reason.
 *
 *  @return The configuration
 */
+ (instancetype)disabledConfiguration;

/**
 *  Use this configuration for the basic default lock screen. A custom app icon will not be used.
 *
 *  @return The configuration
 */
+ (instancetype)enabledConfiguration;

/**
 *  Use this configuration to provide a custom lock screen icon and a custom background color, or nil if you wish to use the default background color. This will use the default lock screen layout.
 *
 *  @param lockScreenAppIcon         The app icon to be shown on the lock screen
 *  @param lockScreenBackgroundColor The color of the lock screen background
 *
 *  @return The configuration
 */
+ (instancetype)enabledConfigurationWithAppIcon:(UIImage *)lockScreenAppIcon backgroundColor:(nullable UIColor *)lockScreenBackgroundColor;

/**
 *  Use this configuration if you wish to provide your own view controller for the lock screen. This view controller's presentation and dismissal will still be managed by the lock screen manager. Note that you may subclass SDLLockScreenViewController and pass it here to continue to have the vehicle icon set to your view controller by the manager.
 *
 *  @param viewController The view controller to be managed
 *
 *  @return The configuration
 */
+ (instancetype)enabledConfigurationWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
