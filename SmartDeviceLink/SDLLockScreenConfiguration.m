//
//  SDLLockScreenConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/13/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenConfiguration.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenConfiguration ()

@end


@implementation SDLLockScreenConfiguration

#pragma mark - Lifecycle

- (instancetype)initWithAutoLockScreen:(BOOL)enableAutomatic enableInOptional:(BOOL)enableOptional backgroundColor:(UIColor *)backgroundColor appIcon:(nullable UIImage *)appIcon viewController:(nullable UIViewController *)customViewController {
    self = [super init];
    if (!self) {
        return nil;
    }

    _enableAutomaticLockScreen = enableAutomatic;
    _showInOptionalState = enableOptional;
    _backgroundColor = backgroundColor;
    _appIcon = appIcon;
    _customViewController = customViewController;

    return self;
}

+ (instancetype)disabledConfiguration {
    return [[self alloc] initWithAutoLockScreen:NO enableInOptional:NO backgroundColor:[self sdl_defaultBackgroundColor] appIcon:nil viewController:nil];
}

+ (instancetype)enabledConfiguration {
    return [[self alloc] initWithAutoLockScreen:YES enableInOptional:NO backgroundColor:[self sdl_defaultBackgroundColor] appIcon:nil viewController:nil];
}

+ (instancetype)enabledConfigurationWithAppIcon:(UIImage *)lockScreenAppIcon backgroundColor:(nullable UIColor *)lockScreenBackgroundColor {
    if (lockScreenBackgroundColor == nil) {
        lockScreenBackgroundColor = [self.class sdl_defaultBackgroundColor];
    }

    return [[self alloc] initWithAutoLockScreen:YES enableInOptional:NO backgroundColor:lockScreenBackgroundColor appIcon:lockScreenAppIcon viewController:nil];
}

+ (instancetype)enabledConfigurationWithViewController:(UIViewController *)viewController {
    return [[self alloc] initWithAutoLockScreen:YES enableInOptional:NO backgroundColor:[self.class sdl_defaultBackgroundColor] appIcon:nil viewController:viewController];
}


#pragma mark - Defaults

+ (UIColor *)sdl_defaultBackgroundColor {
    return [UIColor colorWithRed:(57.0 / 255.0) green:(78.0 / 255.0) blue:(96.0 / 255.0) alpha:1.0];
}


#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLLockScreenConfiguration *new = [[SDLLockScreenConfiguration allocWithZone:zone] initWithAutoLockScreen : _enableAutomaticLockScreen
                                           enableInOptional : _showInOptionalState
                                               backgroundColor : _backgroundColor
                                                   appIcon : _appIcon
                                                       viewController : _customViewController];

    return new;
}

@end

NS_ASSUME_NONNULL_END
