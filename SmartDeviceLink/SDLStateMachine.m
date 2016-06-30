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

SDLStateMachineTransitionType *const SDLStateMachineTransitionTypeWillLeave = @"willLeave";
SDLStateMachineTransitionType *const SDLStateMachineTransitionTypeWillTransition = @"willTransition";
SDLStateMachineTransitionType *const SDLStateMachineTransitionTypeDidTransition = @"didTransition";
SDLStateMachineTransitionType *const SDLStateMachineTransitionTypeDidEnter = @"didEnter";

SDLStateMachineNotificationInfoKey *const SDLStateMachineNotificationInfoKeyType = @"type";
SDLStateMachineNotificationInfoKey *const SDLStateMachineNotificationInfoKeyOldState = @"oldState";
SDLStateMachineNotificationInfoKey *const SDLStateMachineNotificationInfoKeyNewState = @"newState";


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
    
    SEL willLeave = NSSelectorFromString([NSString stringWithFormat:@"willLeaveState%@", oldState]);
    SEL willTransition = NSSelectorFromString([NSString stringWithFormat:@"willTransitionFromState%@ToState%@", oldState, state]);
    SEL didTransition = NSSelectorFromString([NSString stringWithFormat:@"didTransitionFromState%@ToState%@", oldState, state]);
    SEL didEnter = NSSelectorFromString([NSString stringWithFormat:@"didEnterState%@", state]);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    // Pre state transition calls
    [[NSNotificationCenter defaultCenter] postNotificationName:self.transitionNotificationName object:self userInfo:@{ SDLStateMachineNotificationInfoKeyType: SDLStateMachineTransitionTypeWillLeave, SDLStateMachineNotificationInfoKeyOldState: oldState, SDLStateMachineNotificationInfoKeyNewState: state  }];
    if ([self.target respondsToSelector:willLeave]) {
        [self.target performSelector:willLeave];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.transitionNotificationName object:self userInfo:@{ SDLStateMachineNotificationInfoKeyType: SDLStateMachineTransitionTypeWillTransition, SDLStateMachineNotificationInfoKeyOldState: oldState, SDLStateMachineNotificationInfoKeyNewState: state }];
    if ([self.target respondsToSelector:willTransition]) {
        [self.target performSelector:willTransition];
    }
    
    // Transition the state
    self.currentState = state;
    
    // Post state transition calls
    [[NSNotificationCenter defaultCenter] postNotificationName:self.transitionNotificationName object:self userInfo:@{ SDLStateMachineNotificationInfoKeyType: SDLStateMachineTransitionTypeDidTransition, SDLStateMachineNotificationInfoKeyOldState: oldState,SDLStateMachineNotificationInfoKeyNewState: state }];
    if ([self.target respondsToSelector:didTransition]) {
        [self.target performSelector:didTransition];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.transitionNotificationName object:self userInfo:@{ SDLStateMachineNotificationInfoKeyType: SDLStateMachineTransitionTypeDidEnter, SDLStateMachineNotificationInfoKeyOldState: oldState, SDLStateMachineNotificationInfoKeyNewState: state }];
    if ([self.target respondsToSelector:didEnter]) {
        [self.target performSelector:didEnter];
    }
    
#pragma clang diagnostic pop
}

- (BOOL)isCurrentState:(SDLState *)state {
    return [self.currentState isEqualToString:state];
}


#pragma mark - Helpers

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

- (NSString *)transitionNotificationName {
    return [NSString stringWithFormat:@"com.sdl.notification.statemachine.%@", [self.target class]];
}

@end

NS_ASSUME_NONNULL_END