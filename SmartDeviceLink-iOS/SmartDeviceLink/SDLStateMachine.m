//
//  SDLStateMachine.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/30/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLStateMachine.h"

#import "SDLState.h"

@interface SDLStateMachine ()

@property (strong, nonatomic, readwrite) SDLState *currentState;

@end


@implementation SDLStateMachine

- (instancetype)initWithTarget:(id)target states:(NSDictionary<SDLState *,SDLAllowableStateTransitions *> *)states startState:(SDLState *)startState {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    if (states[startState] == nil) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempted to start with an SDLState that is not in the states dictionary" userInfo:nil];
    }
    
    _target = target;
    _states = states;
    _currentState = startState;
    
    return self;
}

- (void)transitionToState:(SDLState *)state {
    if (![self sdl_canState:self.currentState transitionToState:state]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Attempted to transition to a state that is not allowed from the current state"
                                     userInfo:@{@"fromState": self.currentState,
                                                @"toState": state}];
    }
    
    SEL willLeave = NSSelectorFromString([NSString stringWithFormat:@"willLeaveState%@", self.currentState.name]);
    SEL willTransition = NSSelectorFromString([NSString stringWithFormat:@"willTransitionFromState%@ToState%@", self.currentState.name, state.name]);
    SEL didTransition = NSSelectorFromString([NSString stringWithFormat:@"didTransitionFromState%@ToState%@", self.currentState.name, state.name]);
    SEL didEnter = NSSelectorFromString([NSString stringWithFormat:@"enteringState%@", state.name]);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if ([self.target respondsToSelector:willLeave]) {
        [self.target performSelector:willLeave];
    }
    
    if ([self.target respondsToSelector:willTransition]) {
        [self.target performSelector:willTransition];
    }
    
    self.currentState = state;
    
    if ([self.target respondsToSelector:didTransition]) {
        [self.target performSelector:didTransition];
    }
    
    if ([self.target respondsToSelector:didEnter]) {
        [self.target performSelector:didEnter];
    }
    
#pragma clang diagnostic pop
}

- (BOOL)sdl_canState:(SDLState *)fromState transitionToState:(SDLState *)toState {
    if ([self.states[fromState] containsObject:toState]) {
        return YES;
    }
    
    return NO;
}

@end
