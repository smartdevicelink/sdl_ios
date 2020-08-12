//
//  SDLFuelRange.m
//  SmartDeviceLink
//
//  Created by Nicole on 6/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLFuelRange.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLFuelRange

- (instancetype)initWithType:(nullable SDLFuelType)type range:(float)range level:(float)level levelState:(nullable SDLComponentVolumeStatus)levelState capacity:(float)capacity capacityUnit:(nullable SDLCapacityUnit)capacityUnit {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.type = type;
    self.range = @(range);
    self.level = @(level);
    self.levelState = levelState;
    self.capacity = @(capacity);
    self.capacityUnit = capacityUnit;
    return self;
}

- (void)setType:(nullable SDLFuelType)type {
    [self.store sdl_setObject:type forName:SDLRPCParameterNameType];
}

- (nullable SDLFuelType)type {
    return [self.store sdl_enumForName:SDLRPCParameterNameType error:nil];
}

- (void)setRange:(nullable NSNumber<SDLFloat> *)range {
    [self.store sdl_setObject:range forName:SDLRPCParameterNameRange];
}

- (nullable NSNumber<SDLFloat> *)range {
    return [self.store sdl_objectForName:SDLRPCParameterNameRange ofClass:NSNumber.class error:nil];
}

- (void)setLevel:(nullable NSNumber<SDLFloat> *)level {
    [self.store sdl_setObject:level forName:SDLRPCParameterNameLevel];
}

- (nullable NSNumber<SDLFloat> *)level {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLevel ofClass:NSNumber.class error:&error];
}

- (void)setLevelState:(nullable SDLComponentVolumeStatus)levelState {
    [self.store sdl_setObject:levelState forName:SDLRPCParameterNameLevelState];
}

- (nullable SDLComponentVolumeStatus)levelState {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameLevelState error:&error];
}

- (void)setCapacity:(nullable NSNumber<SDLFloat> *)capacity {
    [self.store sdl_setObject:capacity forName:SDLRPCParameterNameCapacity];
}

- (nullable NSNumber<SDLFloat> *)capacity {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameCapacity ofClass:NSNumber.class error:&error];
}

- (void)setCapacityUnit:(nullable SDLCapacityUnit)capacityUnit {
    [self.store sdl_setObject:capacityUnit forName:SDLRPCParameterNameCapacityUnit];
}

- (nullable SDLCapacityUnit)capacityUnit {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameCapacityUnit error:&error];
}

@end

NS_ASSUME_NONNULL_END
