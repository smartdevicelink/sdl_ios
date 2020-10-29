//
//  SDLSeatLocation.m
//  SmartDeviceLink
//
//  Created by standa1 on 7/11/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLSeatLocation.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

@implementation SDLSeatLocation

- (instancetype)initWithGrid:(nullable SDLGrid *)grid {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.grid = grid;
    return self;
}

- (void)setGrid:(nullable SDLGrid *)grid {
    [self.store sdl_setObject:grid forName:SDLRPCParameterNameGrid];
}

- (nullable SDLGrid *)grid {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameGrid ofClass:SDLGrid.class error:&error];
}

@end
