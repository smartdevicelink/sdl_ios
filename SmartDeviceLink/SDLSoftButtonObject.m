//
//  SDLSoftButtonObject.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonObject.h"

#import "SDLSoftButtonState.h"

@implementation SDLSoftButtonObject

- (instancetype)initWithName:(NSString *)name states:(NSArray<SDLSoftButtonState *> *)states initialStateName:(NSString *)initialStateName handler:(SDLRPCButtonNotificationHandler)eventHandler {
    self = [super init];
    if (!self) { return nil; }

    _name = name;
    _states = states;
    _currentStateName = initialStateName;
    _eventHandler = eventHandler;

    return self;
}

- (instancetype)initWithName:(NSString *)name state:(SDLSoftButtonState *)state handler:(SDLRPCButtonNotificationHandler)eventHandler {
    return [self initWithName:name states:@[state] initialStateName:state.name handler:eventHandler];
}

- (void)transitionToState:(NSString *)stateName {
    
}

@end
