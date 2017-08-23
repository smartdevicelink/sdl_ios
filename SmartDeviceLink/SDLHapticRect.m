//
//  SDLHapticRect.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLHapticRect.h"

#import "SDLNames.h"
#import "SDLRectangle.h"

@implementation SDLHapticRect

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

- (instancetype)initWithId:(NSNumber *)id rect:(SDLRectangle *)rect {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.id = id;
    self.rect = rect;

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

- (void)setRect:(SDLRectangle *)rect {
    if (rect != nil) {
        [store setObject:rect forKey:NAMES_rect];
    } else {
        [store removeObjectForKey:NAMES_rect];
    }
}

- (SDLRectangle *)rect {
    NSObject *obj = store[NAMES_rect];
    if (obj == nil || [obj isKindOfClass:SDLRectangle.class]) {
        return (SDLRectangle *)obj;
    } else {
        return [[SDLRectangle alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
