//
//  SDLLockScreenConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/13/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenConfiguration.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLLockScreenConfiguration

#pragma mark - Lifecycle

- (instancetype)initWithDisplayMode:(SDLLockScreenConfigurationDisplayMode)mode enableDismissGesture:(BOOL)enableDismissGesture showDeviceLogo:(BOOL)showDeviceLogo backgroundColor:(UIColor *)backgroundColor appIcon:(nullable UIImage *)appIcon viewController:(nullable UIViewController *)customViewController {
    self = [super init];
    if (!self) {
        return nil;
    }

    _displayMode = mode;
    _enableDismissGesture = enableDismissGesture;
    _backgroundColor = backgroundColor;
    _appIcon = appIcon;
    _customViewController = customViewController;
    _showDeviceLogo = showDeviceLogo;

    return self;
}

+ (instancetype)disabledConfiguration {
    return [[self alloc] initWithDisplayMode:SDLLockScreenConfigurationDisplayModeNever enableDismissGesture:NO showDeviceLogo:NO backgroundColor:[self sdl_defaultBackgroundColor] appIcon:nil viewController:nil];
}

+ (instancetype)enabledConfiguration {
    return [[self alloc] initWithDisplayMode:SDLLockScreenConfigurationDisplayModeRequiredOnly enableDismissGesture:YES showDeviceLogo:YES backgroundColor:[self sdl_defaultBackgroundColor] appIcon:nil viewController:nil];
}

+ (instancetype)enabledConfigurationWithAppIcon:(UIImage *)lockScreenAppIcon backgroundColor:(nullable UIColor *)lockScreenBackgroundColor {
    if (lockScreenBackgroundColor == nil) {
        lockScreenBackgroundColor = [self.class sdl_defaultBackgroundColor];
    }

    return [[self alloc] initWithDisplayMode:SDLLockScreenConfigurationDisplayModeRequiredOnly enableDismissGesture:YES showDeviceLogo:YES backgroundColor:lockScreenBackgroundColor appIcon:lockScreenAppIcon viewController:nil];
}

+ (instancetype)enabledConfigurationWithViewController:(UIViewController *)viewController {
    return [[self alloc] initWithDisplayMode:SDLLockScreenConfigurationDisplayModeRequiredOnly enableDismissGesture:YES showDeviceLogo:YES backgroundColor:[self.class sdl_defaultBackgroundColor] appIcon:nil viewController:viewController];
}


#pragma mark - Defaults

+ (UIColor *)sdl_defaultBackgroundColor {
    return [UIColor colorWithRed:(57.0 / 255.0) green:(78.0 / 255.0) blue:(96.0 / 255.0) alpha:1.0];
}


#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLLockScreenConfiguration *new = [[SDLLockScreenConfiguration allocWithZone:zone] initWithDisplayMode:_displayMode enableDismissGesture:_enableDismissGesture showDeviceLogo:_showDeviceLogo backgroundColor:_backgroundColor appIcon:_appIcon viewController:_customViewController];

    return new;
}

@end

NS_ASSUME_NONNULL_END
