//
//  SDLRectangle.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/23/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRectangle.h"

#import "SDLNames.h"

@implementation SDLRectangle

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

- (instancetype)initWithX:(NSNumber *)x y:(NSNumber *)y width:(NSNumber *)width height:(NSNumber *)height {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height;

    return self;
}

- (instancetype)initWithCGRect:(CGRect)rect {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.x = @((float)rect.origin.x);
    self.y = @((float)rect.origin.y);
    self.width = @((float)rect.size.width);
    self.height = @((float)rect.size.height);

    return self;
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
