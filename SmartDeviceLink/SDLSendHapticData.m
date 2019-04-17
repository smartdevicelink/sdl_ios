//
//  SDLSendHapticData.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSendHapticData.h"
#import "SDLHapticRect.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSendHapticData

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSendHapticData]) {
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
    [parameters sdl_setObject:hapticRectData forName:SDLRPCParameterNameHapticRectData];
}

- (nullable NSArray<SDLHapticRect *> *)hapticRectData {
    return [parameters sdl_objectsForName:SDLRPCParameterNameHapticRectData ofClass:SDLHapticRect.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
