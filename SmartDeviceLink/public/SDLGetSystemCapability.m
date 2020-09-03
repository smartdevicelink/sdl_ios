//
//  SDLGetSystemCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLGetSystemCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSystemCapabilityType.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetSystemCapability

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetSystemCapability]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithType:(SDLSystemCapabilityType)type {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = type;

    return self;
}

- (instancetype)initWithType:(SDLSystemCapabilityType)type subscribe:(BOOL)subscribe {
    self = [self initWithType:type];
    if (!self) {
        return nil;
    }

    self.subscribe = @(subscribe);

    return self;
}

- (void)setSystemCapabilityType:(SDLSystemCapabilityType)type {
    [self.parameters sdl_setObject:type forName:SDLRPCParameterNameSystemCapabilityType];
}

- (SDLSystemCapabilityType)systemCapabilityType {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameSystemCapabilityType error:&error];
}

- (void)setSubscribe:(nullable NSNumber<SDLBool> *)subscribe {
    [self.parameters sdl_setObject:subscribe forName:SDLRPCParameterNameSubscribe];
}

- (nullable NSNumber<SDLBool> *)subscribe {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSubscribe ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
