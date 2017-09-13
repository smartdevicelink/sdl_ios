//
//  SDLVideoStreamingCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLImageResolution.h"
#import "SDLNames.h"
#import "SDLVideoStreamingFormat.h"
#import "SDLVideoStreamingCapability.h"

@implementation SDLVideoStreamingCapability

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithVideoStreaming:(SDLImageResolution *)preferredResolution maxBitrate:(NSNumber *)maxBitrate supportedFormats:(NSArray<SDLVideoStreamingFormat *> *)supportedFormats hapticDataSupported:(NSNumber *)hapticDataSupported {
    self = [self init];
    if (!self) {
        return self;
    }

    self.maxBitrate = maxBitrate;
    self.preferredResolution = preferredResolution;
    self.supportedFormats = [supportedFormats mutableCopy];
    self.hapticSpatialDataSupported = hapticDataSupported;

    return self;
}

- (void)setPreferredResolution:(SDLImageResolution *)preferredResolution {
    if (preferredResolution != nil) {
        [store setObject:preferredResolution forKey:NAMES_preferredResolution];
    } else {
        [store removeObjectForKey:NAMES_preferredResolution];
    }
}

- (SDLImageResolution *)preferredResolution {
    NSObject *obj = [store objectForKey:NAMES_preferredResolution];
    if (obj == nil || [obj isKindOfClass:SDLImageResolution.class]) {
        return (SDLImageResolution *)obj;
    } else {
        return [[SDLImageResolution alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setMaxBitrate:(NSNumber *)maxBitrate {
    if (maxBitrate != nil) {
        [store setObject:maxBitrate forKey:NAMES_maxBitrate];
    } else {
        [store removeObjectForKey:NAMES_maxBitrate];
    }
}

- (NSNumber *)maxBitrate {
    return [store objectForKey:NAMES_maxBitrate];
}

- (void)setSupportedFormats:(NSMutableArray *)supportedFormats {
    if (supportedFormats != nil) {
        [store setObject:supportedFormats forKey:NAMES_supportedFormats];
    } else {
        [store removeObjectForKey:NAMES_supportedFormats];
    }
}

- (NSMutableArray *)supportedFormats {
    NSMutableArray *array = [store objectForKey:NAMES_supportedFormats];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLVideoStreamingFormat.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLVideoStreamingFormat alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setHapticSpatialDataSupported:(NSNumber *)hapticSpatialDataSupported {
    if (hapticSpatialDataSupported != nil) {
        [store setObject:hapticSpatialDataSupported forKey:NAMES_hapticSpatialDataSupported];
    } else {
        [store removeObjectForKey:NAMES_hapticSpatialDataSupported];
    }
}

- (NSNumber *)hapticSpatialDataSupported {
    return [store objectForKey:NAMES_hapticSpatialDataSupported];
}

@end
