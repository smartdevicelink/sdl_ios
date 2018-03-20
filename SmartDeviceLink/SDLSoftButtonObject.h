//
//  SDLSoftButtonObject.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLNotificationConstants.h"

@class SDLSoftButton;
@class SDLSoftButtonObject;
@class SDLSoftButtonState;


NS_ASSUME_NONNULL_BEGIN

@interface SDLSoftButtonObject : NSObject

/**
 The name of this button
 */
@property (copy, nonatomic, readonly) NSString *name;

/**
 All states available to this button
 */
@property (strong, nonatomic, readonly) NSArray<SDLSoftButtonState *> *states;

/**
 The name of the current state of this soft button
 */
@property (copy, nonatomic, readonly) SDLSoftButtonState *currentState;

@property (strong, nonatomic, readonly) SDLSoftButton *currentStateSoftButton;

/**
 The handler to be called when the button is in the current state and is pressed
 */
@property (strong, nonatomic, readonly) SDLRPCButtonNotificationHandler eventHandler;

/**
 Create a multi-state (or single-state, but you should use initWithName:state: instead for that case) soft button. For example, a button that changes its image or text, such as a repeat or shuffle button.

 @param name The name of the button
 @param states The states available to the button
 @param eventHandler The handler to be called when the button is in the current state and is pressed
 @param initialStateName The first state to use
 */
- (instancetype)initWithName:(NSString *)name states:(NSArray<SDLSoftButtonState *> *)states initialStateName:(NSString *)initialStateName handler:(nullable SDLRPCButtonNotificationHandler)eventHandler;

/**
 Create a single-state soft button. For example, a button that brings up a Perform Interaction menu.

 @param name The name of the button
 @param eventHandler The handler to be called when the button is in the current state and is pressed
 @param state The single state of the button
 */
- (instancetype)initWithName:(NSString *)name state:(SDLSoftButtonState *)state handler:(nullable SDLRPCButtonNotificationHandler)eventHandler;

/**
 Transition the soft button to another state in the `states` property. The wrapper considers all transitions valid (assuming a state with that name exists).

 @warning This method will throw an exception and crash your app (on purpose) if you attempt an invalid transition. So...don't do that.

 @param stateName The next state.
 @return YES if a state was found with that name, NO otherwise.
 */
- (BOOL)transitionToStateNamed:(NSString *)stateName NS_SWIFT_NAME(transition(toState:));

- (void)transitionToNextState;

/**
 Return a state from the state array with a specific name.

 @param stateName The name of the state to return
 @return The state, or nil if no state with that name exists
 */
- (nullable SDLSoftButtonState *)stateWithName:(NSString *)stateName;

@end

NS_ASSUME_NONNULL_END
