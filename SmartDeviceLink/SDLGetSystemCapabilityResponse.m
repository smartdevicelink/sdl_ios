//
//  SDLGetSystemCapabilityResponse.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLGetSystemCapabilityResponse.h"

#import "SDLNames.h"
#import "SDLSystemCapability.h"


@implementation SDLGetSystemCapabilityResponse

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

- (void)setSystemCapability:(SDLSystemCapability *)systemCapability {
    if (systemCapability != nil) {
        parameters[NAMES_systemCapability] = systemCapability;
    } else {
        [parameters removeObjectForKey:NAMES_systemCapability];
    }
}

- (SDLSystemCapability *)systemCapability {
    NSObject *obj = [parameters objectForKey:NAMES_systemCapability];
    if (obj == nil || [obj isKindOfClass:SDLSystemCapability.class]) {
        return (SDLSystemCapability *)obj;
    } else {
        return [[SDLSystemCapability alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
