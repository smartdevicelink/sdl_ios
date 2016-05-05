//
//  SDLStateMachine.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/30/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLState;
typedef NSArray<SDLState *> SDLAllowableStateTransitions;


/**
 *  This class allows for a state machine to be created with a set of states and allowable transitions. When a transition occurs, the state machine will attempt to call a series of methods on the `target` class.
 *
 *  The sequence of events and methods are:
 *  * `[target willLeaveState<old state name>]`
 *  * `[target willTransitionFromState<old state name>ToState<new state name>]`
 *  * The state transitions here
 *  * `[target didTransitionFromState<old state name>ToState<new state name>]`
 *  * `[target didEnterState<new state name>]`
 */
@interface SDLStateMachine : NSObject

@property (copy, nonatomic, readonly) NSDictionary<SDLState *, SDLAllowableStateTransitions *> *states;
@property (copy, nonatomic, readonly) SDLState *currentState;
@property (weak, nonatomic, readonly) id target;


/**
 *  Create a new state machine with these parameters
 *
 *  @param target     The target class state transition messages will be sent to
 *  @param states     A dictionary of states and their allowed transitions
 *  @param startState The initial state of the state machine
 *
 *  @return An instance of the state machine class
 */
- (instancetype)initWithTarget:(id)target states:(NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)states startState:(SDLState *)startState;

/**
 *  Transition to another state when called. If the current state is not allowed to transition to the new state, an error will be returned to the error parameter.
 *
 *  @param state The state to transition to.
 *  @param error An error passthrough an error will be placed within if an error occurs.
 */
- (BOOL)transitionToState:(SDLState *)state error:(NSError **)error;

/**
 *  Return whether or not the current state is the passed state
 *
 *  @param state The state to check
 */
- (BOOL)isCurrentState:(SDLState *)state;

@end

NS_ASSUME_NONNULL_END
