//
//  SDLSpatialStruct.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLSpatialStruct.h"
#import "SDLNames.h"

@implementation SDLSpatialStruct

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithId:(NSNumber *)id xCoord:(NSNumber *)x yCoord:(NSNumber *)y width:(NSNumber *)width height:(NSNumber *)height {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.id = id;
    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height;

    return self;
}

- (instancetype)initWithId:(NSNumber *)id CGRect:(CGRect)rect {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.id = id;
    self.x = @((uint64_t)rect.origin.x);
    self.y = @((uint64_t)rect.origin.y);
    self.width = @((uint64_t)rect.size.width);
    self.height = @((uint64_t)rect.size.height);

    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setId:(NSNumber *)id {
    if (id != nil) {
        [store setObject:id forKey:NAMES_id];
    } else {
        [store removeObjectForKey:NAMES_id];
    }
}

- (NSNumber *)id {
    return [store objectForKey:NAMES_id];
}

- (void)setX:(NSNumber *)x {
    if (x != nil) {
        [store setObject:x forKey:NAMES_x];
    } else {
        [store removeObjectForKey:NAMES_x];
    }
}

- (NSNumber *)x {
    return [store objectForKey:NAMES_x];
}

- (void)setY:(NSNumber *)y {
    if (y != nil) {
        [store setObject:y forKey:NAMES_y];
    } else {
        [store removeObjectForKey:NAMES_y];
    }
}

- (NSNumber *)y {
    return [store objectForKey:NAMES_y];
}

- (void)setWidth:(NSNumber *)width {
    if (width != nil) {
        [store setObject:width forKey:NAMES_width];
    } else {
        [store removeObjectForKey:NAMES_width];
    }
}

- (NSNumber *)width {
    return [store objectForKey:NAMES_width];
}

- (void)setHeight:(NSNumber *)height {
    if (height != nil) {
        [store setObject:height forKey:NAMES_height];
    } else {
        [store removeObjectForKey:NAMES_height];
    }
}

- (NSNumber *)height {
    return [store objectForKey:NAMES_height];
}

@end
