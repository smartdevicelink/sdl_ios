//
//  SDLGetInteriorVehicleDataCapabilities.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLGetInteriorVehicleDataCapabilities.h"

#import "SDLInteriorZone.h"
#import "SDLModuleType.h"
#import "SDLNames.h"


@implementation SDLGetInteriorVehicleDataCapabilities

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

- (void)setInteriorZone:(SDLInteriorZone *)interiorZone {
    if (interiorZone != nil) {
        [store setObject:interiorZone forKey:NAMES_zone];
    } else {
        [store removeObjectForKey:NAMES_zone];
    }
}

- (SDLInteriorZone *)interiorZone {
    NSObject *obj = [store objectForKey:NAMES_zone];
    if ([obj isKindOfClass:[SDLInteriorZone class]]) {
        return (SDLInteriorZone *)obj;
    } else {
        return [[SDLInteriorZone alloc] initWithDictionary:[obj mutableCopy]];
    }
}

- (void)setModuleTypes:(NSArray<SDLModuleType *> *)moduleTypes {
    if (moduleTypes != nil) {
        [store setObject:moduleTypes forKey:NAMES_moduleTypes];
    } else {
        [store removeObjectForKey:NAMES_moduleTypes];
    }
}

- (NSArray<SDLModuleType *> *)moduleTypes {
    return [store objectForKey:NAMES_moduleTypes];
}

@end
