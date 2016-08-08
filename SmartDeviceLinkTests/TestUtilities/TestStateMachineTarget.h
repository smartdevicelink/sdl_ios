//
//  TestStateMachineTarget.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 6/29/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString TestStateMachineTransitionType;
extern TestStateMachineTransitionType *const SDLStateMachineTransitionTypeWillLeave;
extern TestStateMachineTransitionType *const SDLStateMachineTransitionTypeWillTransition;
extern TestStateMachineTransitionType *const SDLStateMachineTransitionTypeDidTransition;
extern TestStateMachineTransitionType *const SDLStateMachineTransitionTypeDidEnter;

/**
 *  Callback block that fires whenever one of the TestStateMachineTarget class' state transition methods is called.
 *
 *  @param type     The type of the transition. One of 'willLeave', 'willTransition', 'didTransition', or 'didEnter'
 *  @param oldState The old state, if available
 *  @param newState The new state, if available
 */
typedef void (^TestStateMachineCallback)(NSString *type, NSString *__nullable oldState, NSString *__nullable newState);

@interface TestStateMachineTarget : NSObject

@property (copy, nonatomic) TestStateMachineCallback callback;

@end

NS_ASSUME_NONNULL_END