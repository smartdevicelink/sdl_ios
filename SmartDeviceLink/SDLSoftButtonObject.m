//
//  SDLSoftButtonObject.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonObject.h"

#import "SDLSoftButtonState.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSoftButtonObject

- (instancetype)initWithName:(NSString *)name states:(NSArray<SDLSoftButtonState *> *)states initialStateName:(NSString *)initialStateName handler:(SDLRPCButtonNotificationHandler)eventHandler {
    self = [super init];
    if (!self) { return nil; }

    _name = name;
    _states = states;
    _currentStateName = initialStateName;
    _eventHandler = eventHandler;

    // Make sure there aren't two states with the same name

    return self;
}

- (instancetype)initWithName:(NSString *)name state:(SDLSoftButtonState *)state handler:(SDLRPCButtonNotificationHandler)eventHandler {
    return [self initWithName:name states:@[state] initialStateName:state.name handler:eventHandler];
}

- (BOOL)transitionToState:(NSString *)stateName {
    // TODO

    return YES;
}

@end

NS_ASSUME_NONNULL_END
