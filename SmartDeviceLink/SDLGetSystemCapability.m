//
//  SDLGetSystemCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLGetSystemCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLSystemCapabilityType.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetSystemCapability

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetSystemCapability]) {
    }
    return self;
}

- (instancetype)initWithType:(SDLSystemCapabilityType)type {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = type;

    return self;
}

- (void)setSystemCapabilityType:(SDLSystemCapabilityType)type {
    [parameters sdl_setObject:type forName:SDLNameSystemCapabilityType];
}

- (SDLSystemCapabilityType)systemCapabilityType {
    return [parameters sdl_objectForName:SDLNameSystemCapabilityType];
}

@end

NS_ASSUME_NONNULL_END
