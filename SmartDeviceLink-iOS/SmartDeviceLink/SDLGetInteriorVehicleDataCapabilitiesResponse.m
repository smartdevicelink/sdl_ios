//
//  SDLGetInteriorVehicleDataCapabilitiesResponse.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLGetInteriorVehicleDataCapabilitiesResponse.h"

#import "SDLModuleDescription.h"
#import "SDLNames.h"


@implementation SDLGetInteriorVehicleDataCapabilitiesResponse

- (instancetype)init {
    if (self = [super initWithName:NAMES_GetInteriorVehicleDataCapabilities]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:[dict mutableCopy]]) {
    }
    return self;
}

- (void)setInteriorVehicleDataCapabilities:(NSArray<SDLModuleDescription *> *)interiorVehicleDataCapabilities {
    [parameters setObject:interiorVehicleDataCapabilities forKey:NAMES_interiorVehicleDataCapabilities];
}

- (NSArray<SDLModuleDescription *> *)interiorVehicleDataCapabilities {
    NSArray *array = [parameters objectForKey:NAMES_interiorVehicleDataCapabilities];
    if ([array count] < 1 || [array[0] isKindOfClass:[SDLModuleDescription class]]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLModuleDescription alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        
        return [newList copy];
    }
}

@end
