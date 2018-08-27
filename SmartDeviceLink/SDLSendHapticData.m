//
//  SDLSendHapticData.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLSendHapticData.h"
#import "SDLHapticRect.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSendHapticData

- (instancetype)init {
    if (self = [super initWithName:SDLNameSendHapticData]) {
    }
    return self;
}

- (instancetype)initWithHapticRectData:(NSArray<SDLHapticRect *> *)hapticRectData {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.hapticRectData = [hapticRectData mutableCopy];

    return self;
}

- (void)setHapticRectData:(nullable NSArray<SDLHapticRect *> *)hapticRectData {
    [parameters sdl_setObject:hapticRectData forName:SDLNameHapticRectData];
}

- (nullable NSArray<SDLHapticRect *> *)hapticRectData {
    return [parameters sdl_objectsForName:SDLNameHapticRectData ofClass:SDLHapticRect.class];
}

@end

NS_ASSUME_NONNULL_END
