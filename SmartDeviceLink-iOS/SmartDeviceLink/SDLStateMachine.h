//
//  SDLStateMachine.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/30/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLState;


typedef NSArray <SDLState *> SDLAllowableStateTransitions;


NS_ASSUME_NONNULL_BEGIN

@interface SDLStateMachine : NSObject

@property (copy, nonatomic, readonly) NSDictionary<SDLState *, SDLAllowableStateTransitions *> *states;
@property (strong, nonatomic, readonly) SDLState *currentState;
@property (weak, nonatomic, readonly) id target;


- (instancetype)initWithTarget:(id)target states:(NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)states startState:(SDLState *)startState;

- (void)transitionToState:(SDLState *)state;

@end

NS_ASSUME_NONNULL_END
