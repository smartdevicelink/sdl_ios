//
//  TestStateMachineTarget.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 6/29/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "TestStateMachineTarget.h"

#import "SDLStateMachine.h"


NS_ASSUME_NONNULL_BEGIN

@implementation TestStateMachineTarget

- (void)willLeaveStateInitial {
    self.callback(SDLStateMachineTransitionTypeWillLeave, @"Initial", nil);
}

- (void)willTransitionFromStateInitialToStateSecond {
    self.callback(SDLStateMachineTransitionTypeWillTransition, @"Initial", @"Second");
}

- (void)didTransitionFromStateInitialToStateSecond {
    self.callback(SDLStateMachineTransitionTypeDidTransition, @"Initial", @"Second");
}

- (void)didEnterStateSecond {
    self.callback(SDLStateMachineTransitionTypeDidEnter, nil, @"Second");
}

@end

NS_ASSUME_NONNULL_END