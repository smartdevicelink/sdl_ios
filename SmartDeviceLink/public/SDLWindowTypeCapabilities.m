//
//  SDLWindowTypeCapabilities.m
//  SmartDeviceLink
//
//  Created by cssoeutest1 on 16.07.19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLWindowTypeCapabilities.h"


#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLWindowTypeCapabilities

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

- (instancetype)initWithType:(SDLWindowType)type maximumNumberOfWindows:(UInt32)maximumNumberOfWindows {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.type = type;
    self.maximumNumberOfWindows = @(maximumNumberOfWindows);
    return self;
}

- (void)setType:(SDLWindowType)type {
    [self.store sdl_setObject:type forName:SDLRPCParameterNameType];
}

- (SDLWindowType)type {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameType error:&error];
}

- (void)setMaximumNumberOfWindows:(NSNumber<SDLInt> *)maximumNumberOfWindows {
    [self.store sdl_setObject:maximumNumberOfWindows forName:SDLRPCParameterNameMaximumNumberOfWindows];
}

- (NSNumber<SDLInt> *)maximumNumberOfWindows {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameMaximumNumberOfWindows ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END

