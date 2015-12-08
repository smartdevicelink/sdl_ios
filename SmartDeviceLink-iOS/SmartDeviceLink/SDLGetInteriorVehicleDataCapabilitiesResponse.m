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
    return [store objectForKey:NAMES_interiorVehicleDataCapabilities];
}

@end
