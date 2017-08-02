//
//  SDLSendHapticData.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLNames.h"
#import "SDLSendHapticData.h"
#import "SDLSpatialStruct.h"

@implementation SDLSendHapticData

- (instancetype)init {
    if (self = [super initWithName:NAMES_SendHapticData]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithHapticSpatialData:(NSMutableArray *)hapticSpatialData {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.hapticSpatialData = [hapticSpatialData mutableCopy];

    return self;
}

- (void)setHapticSpatialData:(NSMutableArray *)hapticSpatialData {
    if (hapticSpatialData != nil) {
        [parameters setObject:hapticSpatialData forKey:NAMES_hapticSpatialData];
    } else {
        [parameters removeObjectForKey:NAMES_hapticSpatialData];
    }
}

- (NSMutableArray *)hapticSpatialData {
    NSMutableArray *array = [parameters objectForKey:NAMES_hapticSpatialData];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLSpatialStruct.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSpatialStruct alloc] initWithDictionary:(NSMutableDictionary *) dict]];
        }
        return newList;
    }
}

@end
