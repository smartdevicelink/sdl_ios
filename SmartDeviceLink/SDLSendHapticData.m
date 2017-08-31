//
//  SDLSendHapticData.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLNames.h"
#import "SDLSendHapticData.h"
#import "SDLHapticRect.h"

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

- (instancetype)initWithHapticRectData:(NSMutableArray *)hapticRectData {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.hapticRectData = [hapticRectData mutableCopy];

    return self;
}

- (void)setHapticRectData:(NSMutableArray *)hapticRectData {
    if (hapticRectData != nil) {
        [parameters setObject:hapticRectData forKey:NAMES_hapticRectData];
    } else {
        [parameters removeObjectForKey:NAMES_hapticRectData];
    }
}

- (NSMutableArray *)hapticRectData {
    NSMutableArray *array = [parameters objectForKey:NAMES_hapticRectData];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLHapticRect.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLHapticRect alloc] initWithDictionary:(NSMutableDictionary *) dict]];
        }
        return newList;
    }
}

@end
