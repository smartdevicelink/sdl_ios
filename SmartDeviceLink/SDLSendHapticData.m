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

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSendHapticData

- (instancetype)init {
    if (self = [super initWithName:SDLNameSendHapticData]) {
    }
    return self;
}

- (instancetype)initWithHapticSpatialData:(NSArray<SDLSpatialStruct *> *)hapticSpatialData {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.hapticSpatialData = [hapticSpatialData mutableCopy];

    return self;
}

- (void)setHapticSpatialData:(nullable NSArray<SDLSpatialStruct *> *)hapticSpatialData {
    [parameters sdl_setObject:hapticSpatialData forName:SDLNameHapticSpatialData];
}

- (nullable NSArray<SDLSpatialStruct *> *)hapticSpatialData {
    return [parameters sdl_objectForName:SDLNameHapticSpatialData];
}

@end

NS_ASSUME_NONNULL_END
