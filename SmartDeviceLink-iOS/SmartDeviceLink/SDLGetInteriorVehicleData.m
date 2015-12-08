//
//  SDLGetInteriorVehicleData.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLGetInteriorVehicleData.h"

#import "SDLModuleDescription.h"
#import "SDLNames.h"


@implementation SDLGetInteriorVehicleData

- (instancetype)init {
    if (self = [super initWithName:NAMES_GetInteriorVehicleData]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:[dict mutableCopy]]) {
    }
    return self;
}

- (void)setModuleDescription:(SDLModuleDescription *)moduleDescription {
    [store setObject:moduleDescription forKey:NAMES_moduleDescription];
}

- (SDLModuleDescription *)moduleDescription {
    NSObject *obj = [store objectForKey:NAMES_moduleDescription];
    if ([obj isKindOfClass:[SDLModuleDescription class]]) {
        return (SDLModuleDescription *)obj;
    } else {
        return [[SDLModuleDescription alloc] initWithDictionary:[obj mutableCopy]];
    }
}

- (void)setSubscribe:(NSNumber *)subscribe {
    if (subscribe != nil) {
        [store setObject:subscribe forKey:NAMES_subscribe];
    } else {
        [store removeObjectForKey:NAMES_subscribe];
    }
}

- (NSNumber *)subscribe {
    return [store objectForKey:NAMES_subscribe];
}

@end
