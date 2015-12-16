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
        [parameters setObject:interiorZone forKey:NAMES_zone];
    } else {
        [parameters removeObjectForKey:NAMES_zone];
    }
}

- (SDLInteriorZone *)interiorZone {
    NSObject *obj = [parameters objectForKey:NAMES_zone];
    if ([obj isKindOfClass:[SDLInteriorZone class]]) {
        return (SDLInteriorZone *)obj;
    } else {
        return [[SDLInteriorZone alloc] initWithDictionary:[obj mutableCopy]];
    }
}

- (void)setModuleTypes:(NSArray<SDLModuleType *> *)moduleTypes {
    if (moduleTypes != nil) {
        [parameters setObject:moduleTypes forKey:NAMES_moduleTypes];
    } else {
        [parameters removeObjectForKey:NAMES_moduleTypes];
    }
}

- (NSArray<SDLModuleType *> *)moduleTypes {
    NSArray *array = [parameters objectForKey:NAMES_moduleTypes];
    if ([array count] < 1 || [array[0] isKindOfClass:[SDLModuleType class]]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLModuleType valueOf:enumString]];
        }
        
        return [newList copy];
    }
}

@end
