//
//  SDLGetInteriorVehicleDataResponse.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLGetInteriorVehicleDataResponse.h"

#import "SDLModuleData.h"
#import "SDLNames.h"


@implementation SDLGetInteriorVehicleDataResponse

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

- (void)setModuleData:(SDLModuleData *)moduleData {
    if (moduleData != nil) {
        [store setObject:moduleData forKey:NAMES_moduleData];
    } else {
        [store removeObjectForKey:NAMES_moduleData];
    }
}

- (SDLModuleData *)moduleData {
    NSObject *obj = [store objectForKey:NAMES_moduleData];
    if ([obj isKindOfClass:[SDLModuleData class]]) {
        return (SDLModuleData *)obj;
    } else {
        return [[SDLModuleData alloc] initWithDictionary:[obj mutableCopy]];
    }
}

@end
