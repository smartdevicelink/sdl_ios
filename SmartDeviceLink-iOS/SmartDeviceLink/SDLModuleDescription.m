//
//  SDLModuleDescription.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLModuleDescription.h"

#import "SDLInteriorZone.h"
#import "SDLModuleType.h"
#import "SDLNames.h"


@implementation SDLModuleDescription

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

- (void)setModuleZone:(SDLInteriorZone *)moduleZone {
    if (moduleZone != nil) {
        [store setObject:moduleZone forKey:NAMES_moduleZone];
    } else {
        [store removeObjectForKey:NAMES_moduleZone];
    }
}

- (SDLInteriorZone *)moduleZone {
    NSObject *obj = [store objectForKey:NAMES_moduleZone];
    if ([obj isKindOfClass:[SDLInteriorZone class]]) {
        return (SDLInteriorZone *)obj;
    } else {
        return [[SDLInteriorZone alloc] initWithDictionary:[obj mutableCopy]];
    }
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

@end
