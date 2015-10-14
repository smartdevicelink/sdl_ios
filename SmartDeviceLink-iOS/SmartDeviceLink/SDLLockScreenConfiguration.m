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

@property (assign, nonatomic) BOOL enableAutomaticLockScreen;

@end



@implementation SDLLockScreenConfiguration

#pragma mark - Lifecycle

- (instancetype)initWithAutoLockScreen:(BOOL)enableAutomatic enableInOptional:(BOOL)enableOptional backgroundColor:(UIColor *)backgroundColor appIcon:(nullable UIImage *)appIcon {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _enableAutomaticLockScreen = enableAutomatic;
    _showInOptional = enableOptional;
    _backgroundColor = backgroundColor;
    _appIcon = appIcon;
    
    return self;
}

+ (instancetype)disabledConfiguration {
    return [[self alloc] initWithAutoLockScreen:NO enableInOptional:NO backgroundColor:[self defaultBackgroundColor] appIcon:nil];
}

+ (instancetype)enabledConfiguration {
    return [[self alloc] initWithAutoLockScreen:YES enableInOptional:NO backgroundColor:[self defaultBackgroundColor] appIcon:nil];
}

+ (instancetype)enabledConfigurationWithBackgroundColor:(UIColor *)lockScreenBackgroundColor appIcon:(UIImage *)lockScreenAppIcon {
    return [[self alloc] initWithAutoLockScreen:YES enableInOptional:NO backgroundColor:lockScreenBackgroundColor appIcon:lockScreenAppIcon];
}


#pragma mark - Custom Setters

- (void)setBackgroundColor:(nullable UIColor *)backgroundColor {
    if (backgroundColor == nil) {
        _backgroundColor = [self.class defaultBackgroundColor];
    } else {
        _backgroundColor = backgroundColor;
    }
}


#pragma mark - Defaults

+ (UIColor *)defaultBackgroundColor {
    return [UIColor blackColor];
}


#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLLockScreenConfiguration *new = [[SDLLockScreenConfiguration allocWithZone:zone] init];
    new->_enableAutomaticLockScreen = _enableAutomaticLockScreen;
    new->_showInOptional = _showInOptional;
    new->_backgroundColor = _backgroundColor;
    new->_appIcon = _appIcon;
    
    return new;
}

@end

NS_ASSUME_NONNULL_END
