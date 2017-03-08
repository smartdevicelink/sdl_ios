//
//  NSBundle+SDLBundle.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/31/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "NSBundle+SDLBundle.h"

#import "SDLManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSBundle (SDLBundle)

+ (nullable NSBundle *)sdlBundle {
    NSURL *sdlBundleURL = [[NSBundle mainBundle] URLForResource:@"SmartDeviceLink" withExtension:@"bundle"];
    NSBundle *sdlBundle = nil;

    if (sdlBundleURL != nil) {
        sdlBundle = [NSBundle bundleWithURL:sdlBundleURL];
    }
    if (sdlBundle == nil) {
        sdlBundle = [NSBundle bundleForClass:[SDLManager class]];
    }
    if (sdlBundle == nil) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"SDL WARNING: The 'SmartDeviceLink.bundle' resources bundle was not found. If you are using cocoapods, try dragging the bundle from the SmartDeviceLink-iOS pod 'products' directory into your resources build phase. If this does not work, please go to the SDL slack at slack.smartdevicelink.com and explain your issue. You may disable the lockscreen in configuration to prevent this failure, for now." userInfo:nil];
    }

    return sdlBundle;
}

@end

NS_ASSUME_NONNULL_END
