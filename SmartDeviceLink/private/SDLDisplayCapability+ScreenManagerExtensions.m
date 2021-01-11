//
//  SDLDisplayCapability+ScreenManagerExtensions.m
//  SmartDeviceLink
//
//  Created by Nicole on 1/8/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLDisplayCapability+ScreenManagerExtensions.h"

#import "SDLPredefinedWindows.h"
#import "SDLWindowCapability.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDisplayCapability (ScreenManagerExtensions)

- (nullable SDLWindowCapability *)currentWindowCapability {
    if (self.windowCapabilities == nil || self.windowCapabilities.count == 0) {
        return nil;
    }

    for (SDLWindowCapability *windowCapability in self.windowCapabilities) {
        NSUInteger currentWindowID = windowCapability.windowID != nil ? windowCapability.windowID.unsignedIntegerValue : SDLPredefinedWindowsDefaultWindow;
        if (currentWindowID != SDLPredefinedWindowsDefaultWindow) { continue; }

        return windowCapability;
    }

    return nil;
}

@end

NS_ASSUME_NONNULL_END
