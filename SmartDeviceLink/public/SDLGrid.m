//
//  SDLGrid.m
//  SmartDeviceLink
//
//  Created by standa1 on 7/10/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLGrid.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

@implementation SDLGrid

- (void)setCol:(NSNumber<SDLInt> *)col {
    [self.store sdl_setObject:col forName:SDLRPCParameterNameCol];
}

- (NSNumber<SDLInt> *)col {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameCol ofClass:NSNumber.class error:&error];
}

- (void)setRow:(NSNumber<SDLInt> *)row {
    [self.store sdl_setObject:row forName:SDLRPCParameterNameRow];
}

- (NSNumber<SDLInt> *)row {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameRow ofClass:NSNumber.class error:&error];
}

- (void)setLevel:(nullable NSNumber<SDLInt> *)level {
    [self.store sdl_setObject:level forName:SDLRPCParameterNameLevel];
}

- (nullable NSNumber<SDLInt> *)level {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLevel ofClass:NSNumber.class error:&error];
}

- (void)setColspan:(nullable NSNumber<SDLInt> *)colspan {
    [self.store sdl_setObject:colspan forName:SDLRPCParameterNameColSpan];
}

- (nullable NSNumber<SDLInt> *)colspan {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameColSpan ofClass:NSNumber.class error:&error];
}

- (void)setRowspan:(nullable NSNumber<SDLInt> *)rowspan {
    [self.store sdl_setObject:rowspan forName:SDLRPCParameterNameRowSpan];
}

- (nullable NSNumber<SDLInt> *)rowspan {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameRowSpan ofClass:NSNumber.class error:&error];
}

- (void)setLevelspan:(nullable NSNumber<SDLInt> *)levelspan {
    [self.store sdl_setObject:levelspan forName:SDLRPCParameterNameLevelSpan];
}

- (nullable NSNumber<SDLInt> *)levelspan {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLevelSpan ofClass:NSNumber.class error:&error];
}

@end
