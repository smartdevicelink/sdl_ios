//
//  SDLOnSeekMediaClockTimer.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 7/3/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLOnSeekMediaClockTimer.h"

#import "NSMutableDictionary+Store.h"
#import "SDLStartTime.h"
#import "SDLNames.h"

@implementation SDLOnSeekMediaClockTimer

- (instancetype)init {
    self = [super initWithName:SDLNameOnSeekMediaClockTimer];

    if (!self) { return nil; }

    return self;
}

- (void)setSeekTime:(SDLStartTime *)seekTime {
    [parameters sdl_setObject:seekTime forName:SDLNameSeekTime];
}

- (SDLStartTime *)seekTime {
    return [parameters sdl_objectForName:SDLNameSeekTime ofClass:[SDLStartTime class]];
}

@end
