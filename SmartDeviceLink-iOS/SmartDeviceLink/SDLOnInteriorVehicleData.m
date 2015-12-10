//
//  SDLOnInteriorVehicleData.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLOnInteriorVehicleData.h"

#import "SDLModuleData.h"
#import "SDLNames.h"


@implementation SDLOnInteriorVehicleData

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnInteriorVehicleData]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:[dict mutableCopy]]) {
    }
    return self;
}

- (void)setModuleData:(SDLModuleData *)moduleData {
    if (moduleData != nil) {
        [parameters setObject:moduleData forKey:NAMES_moduleData];
    } else {
        [parameters removeObjectForKey:NAMES_moduleData];
    }
}

- (SDLModuleData *)moduleData {
    NSObject *obj = [parameters objectForKey:NAMES_moduleData];
    if ([obj isKindOfClass:[SDLModuleData class]]) {
        return (SDLModuleData *)obj;
    } else {
        return [[SDLModuleData alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
