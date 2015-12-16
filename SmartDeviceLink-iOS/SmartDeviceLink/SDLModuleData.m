//
//  SDLModuleData.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLModuleData.h"

#import "SDLClimateControlData.h"
#import "SDLInteriorZone.h"
#import "SDLModuleType.h"
#import "SDLNames.h"
#import "SDLRadioControlData.h"


@implementation SDLModuleData

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:[dict mutableCopy]]) {
    }
    return self;
}

- (void)setModuleType:(SDLModuleType *)moduleType {
    if (moduleType != nil) {
        [store setObject:moduleType forKey:NAMES_moduleType];
    } else {
        [store removeObjectForKey:NAMES_moduleType];
    }
}

- (SDLModuleType *)moduleType {
    NSObject *obj = [store objectForKey:NAMES_moduleType];
    if ([obj isKindOfClass:[SDLModuleType class]]) {
        return (SDLModuleType *)obj;
    } else {
        return [SDLModuleType valueOf:(NSString *)obj];
    }
}

- (void)setModuleZone:(SDLInteriorZone *)moduleZone {
    if (moduleZone != nil) {
        [store setObject:moduleZone forKey:NAMES_moduleZone];
    } else {
        [store removeObjectForKey:NAMES_moduleZone];
    }
}

- (SDLInteriorZone *)moduleZone {
    NSObject *obj = [store objectForKey:NAMES_moduleZone];
    if ([obj isKindOfClass:[SDLModuleType class]]) {
        return (SDLInteriorZone *)obj;
    } else {
        return [[SDLInteriorZone alloc] initWithDictionary:[obj mutableCopy]];
    }
}

- (void)setClimateControlData:(SDLClimateControlData *)climateControlData {
    if (climateControlData != nil) {
        [store setObject:climateControlData forKey:NAMES_climateControlData];
    } else {
        [store removeObjectForKey:NAMES_climateControlData];
    }
}

- (SDLClimateControlData *)climateControlData {
    NSObject *obj = [store objectForKey:NAMES_climateControlData];
    if ([obj isKindOfClass:[SDLClimateControlData class]]) {
        return (SDLClimateControlData *)obj;
    } else {
        return [[SDLClimateControlData alloc] initWithDictionary:[obj mutableCopy]];
    }
}

- (void)setRadioControlData:(SDLRadioControlData *)radioControlData {
    if (radioControlData != nil) {
        [store setObject:radioControlData forKey:NAMES_radioControlData];
    } else {
        [store removeObjectForKey:NAMES_radioControlData];
    }
}

- (SDLRadioControlData *)radioControlData {
    NSObject *obj = [store objectForKey:NAMES_radioControlData];
    if ([obj isKindOfClass:[SDLRadioControlData class]]) {
        return (SDLRadioControlData *)obj;
    } else {
        return [[SDLRadioControlData alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
