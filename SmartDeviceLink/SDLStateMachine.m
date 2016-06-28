//
//  SDLStateMachine.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/30/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLStateMachine.h"

#import "SDLError.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLStateMachine ()

@property (copy, nonatomic, readwrite) SDLState *currentState;

@end


@implementation SDLStateMachine

- (instancetype)initWithTarget:(id)target initialState:(SDLState *)initialState states:(NSDictionary<SDLState *,SDLAllowableStateTransitions *> *)states {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    if (states[initialState] == nil) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempted to start with an SDLState that is not in the states dictionary" userInfo:nil];
    }
    
    _target = target;
    _states = states;
    _currentState = initialState;
    
    return self;
}

- (void)transitionToState:(SDLState *)state {
    NSString *oldState = [self.currentState copy];
    if ([self isCurrentState:state]) {
        return;
    }
    
    if (![self sdl_canState:self.currentState transitionToState:state]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Invalid state machine transition occurred" userInfo:@{ @"targetClass": NSStringFromClass([self.target class]), @"fromState": self.currentState, @"toState": state}];
    }
    
    SEL willLeave = NSSelectorFromString([NSString stringWithFormat:@"willLeaveState%@", self.currentState]);
    SEL willTransition = NSSelectorFromString([NSString stringWithFormat:@"willTransitionFromState%@ToState%@", self.currentState, state]);
    SEL didTransition = NSSelectorFromString([NSString stringWithFormat:@"didTransitionFromState%@ToState%@", self.currentState, state]);
    SEL didEnter = NSSelectorFromString([NSString stringWithFormat:@"didEnterState%@", state]);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    // Don't call this method if we aren't actually leaving the state
    if ([self.target respondsToSelector:willLeave]) {
        [self.target performSelector:willLeave];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"com.sdl.notification.statemachine.%@", [self.target class]] object:self userInfo:@{ @"type": @"willLeave", @"oldState": oldState }];
    }
    
    if ([self.target respondsToSelector:willTransition]) {
        [self.target performSelector:willTransition];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"com.sdl.notification.statemachine.%@", [self.target class]] object:self userInfo:@{ @"type": @"willTransition", @"oldState": oldState, @"newState": state }];
    }
    
    self.currentState = state;
    
    if ([self.target respondsToSelector:didTransition]) {
        [self.target performSelector:didTransition];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"com.sdl.notification.statemachine.%@", [self.target class]] object:self userInfo:@{ @"type": @"didTransition", @"oldState": oldState, @"newState": state }];
    }
    
    if ([self.target respondsToSelector:didEnter]) {
        [self.target performSelector:didEnter];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"com.sdl.notification.statemachine.%@", [self.target class]] object:self userInfo:@{ @"type": @"didEnter", @"newState": state }];
    }
    
#pragma clang diagnostic pop
}

- (BOOL)isCurrentState:(SDLState *)state {
    return [self.currentState isEqualToString:state];
}

/**
 *  Determine if a state transition is valid. Returns YES if the state transition dictionary's fromState key contains toState in its value array, or if fromState and toState are the same state.
 *
 *  @param fromState The former state
 *  @param toState   The new state
 *
 *  @return Whether or not the state transition is valid
 */
- (BOOL)sdl_canState:(SDLState *)fromState transitionToState:(SDLState *)toState {
    if ([self.states[fromState] containsObject:toState] || [fromState isEqualToString:toState]) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)sdl_notificationNameForTargetClass:(Class)targetClass selector:(SEL)selector {
    return [NSString stringWithFormat:@"com.sdl.notification.statemachine.%@.%@", [targetClass class], NSStringFromSelector(selector)];
}

@end

NS_ASSUME_NONNULL_END