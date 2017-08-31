//
//  SDLGetSystemCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLGetSystemCapability.h"

#import "SDLNames.h"
#import "SDLSystemCapabilityType.h"

@implementation SDLGetSystemCapability

- (instancetype)init {
    if (self = [super initWithName:NAMES_GetSystemCapability]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithType:(SDLSystemCapabilityType *)type {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = type;

    return self;
}

- (void)setSystemCapabilityType:(SDLSystemCapabilityType *)type {
    if (type != nil) {
        [parameters setObject:type forKey:NAMES_systemCapabilityType];
    } else {
        [parameters removeObjectForKey:NAMES_systemCapabilityType];
    }
}

- (SDLSystemCapabilityType *)systemCapabilityType {
    id obj = parameters[NAMES_systemCapabilityType];
    if (obj == nil || [obj isKindOfClass:SDLSystemCapabilityType.class]) {
        return (SDLSystemCapabilityType *)obj;
    } else {
        return [SDLSystemCapabilityType valueOf:(NSString *)obj];
    }
}

@end
