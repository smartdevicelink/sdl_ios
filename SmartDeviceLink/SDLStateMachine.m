//
//  SDLStateMachine.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/30/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLStateMachine.h"

#import "SDLError.h"
#import "SDLLogMacros.h"


NS_ASSUME_NONNULL_BEGIN

NSString *const SDLStateMachineNotificationFormat = @"com.sdl.statemachine.%@";

SDLStateMachineNotificationInfoKey const SDLStateMachineNotificationInfoKeyOldState = @"oldState";
SDLStateMachineNotificationInfoKey const SDLStateMachineNotificationInfoKeyNewState = @"newState";

SDLStateMachineExceptionInfoKey const SDLStateMachineExceptionInfoKeyTargetClass = @"targetClass";
SDLStateMachineExceptionInfoKey const SDLStateMachineExceptionInfoKeyFromState = @"fromState";
SDLStateMachineExceptionInfoKey const SDLStateMachineExceptionInfoKeyToClass = @"toState";

SDLStateMachineTransitionFormat const SDLStateMachineTransitionFormatWillLeave = @"willLeaveState%@";
SDLStateMachineTransitionFormat const SDLStateMachineTransitionFormatWillTransition = @"willTransitionFromState%@ToState%@";
SDLStateMachineTransitionFormat const SDLStateMachineTransitionFormatDidTransition = @"didTransitionFromState%@ToState%@";
SDLStateMachineTransitionFormat const SDLStateMachineTransitionFormatDidEnter = @"didEnterState%@";


@interface SDLStateMachine ()

@property (copy, nonatomic, readwrite) SDLState *currentState;

@end


@implementation SDLStateMachine

- (instancetype)initWithTarget:(id)target initialState:(SDLState *)initialState states:(NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)states {
    self = [super init];

    if (!self) {
        return nil;
    }

    if (states[initialState] == nil) {
        NSString *reasonMessage = [NSString stringWithFormat:@"Attempted to start with an SDLState (%@) that is not in the states dictionary", initialState];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reasonMessage userInfo:nil];
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
        NSString *targetClassString = NSStringFromClass([self.target class]);
        NSString *reasonMessage = [NSString stringWithFormat:@"Invalid state machine %@ transition of target %@ occurred from %@ to %@", NSStringFromClass(self.class), targetClassString, self.currentState, state];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:reasonMessage
                                     userInfo:@{SDLStateMachineExceptionInfoKeyTargetClass: targetClassString,
                                                SDLStateMachineExceptionInfoKeyFromState: self.currentState,
                                                SDLStateMachineExceptionInfoKeyToClass: state}];
    }

    SEL willLeave = NSSelectorFromString([NSString stringWithFormat:SDLStateMachineTransitionFormatWillLeave, oldState]);
    SEL willTransition = NSSelectorFromString([NSString stringWithFormat:SDLStateMachineTransitionFormatWillTransition, oldState, state]);
    SEL didTransition = NSSelectorFromString([NSString stringWithFormat:SDLStateMachineTransitionFormatDidTransition, oldState, state]);
    SEL didEnter = NSSelectorFromString([NSString stringWithFormat:SDLStateMachineTransitionFormatDidEnter, state]);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    SDLLogV(@"State machine for class %@ will transition from state %@ to state %@", NSStringFromClass([_target class]), oldState, state);

    // Pre state transition calls
    if ([self.target respondsToSelector:willLeave]) {
        [self.target performSelector:willLeave];
    }

    if ([self.target respondsToSelector:willTransition]) {
        [self.target performSelector:willTransition];
    }

    // Transition the state
    self.currentState = state;

    // Post state transition calls
    [[NSNotificationCenter defaultCenter] postNotificationName:self.transitionNotificationName object:self userInfo:@{SDLStateMachineNotificationInfoKeyOldState: oldState, SDLStateMachineNotificationInfoKeyNewState: state}];
    if ([self.target respondsToSelector:didTransition]) {
        [self.target performSelector:didTransition];
    }

    if ([self.target respondsToSelector:didEnter]) {
        [self.target performSelector:didEnter];
    }

#pragma clang diagnostic pop
}

- (BOOL)isCurrentState:(SDLState *)state {
    return [self.currentState isEqualToString:state];
}


#pragma mark - Helpers

- (void)setToState:(SDLState *)state fromOldState:(nullable SDLState *)oldState callEnterTransition:(BOOL)shouldCall {
    if (![self.states.allKeys containsObject:state]) {
        return;
    }

    if (oldState != nil) {
        self.currentState = oldState;
    }

    self.currentState = state;

    if (shouldCall) {
        SEL didEnter = NSSelectorFromString([NSString stringWithFormat:SDLStateMachineTransitionFormatDidEnter, state]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([self.target respondsToSelector:didEnter]) {
            [self.target performSelector:didEnter];
#pragma clang diagnostic pop
        }
    }
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

- (NSString *)transitionNotificationName {
    return [NSString stringWithFormat:SDLStateMachineNotificationFormat, [self.target class]];
}

@end

NS_ASSUME_NONNULL_END
