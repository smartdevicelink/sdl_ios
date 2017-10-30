//
//  SDLManagerDelegate.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 6/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAudioStreamingState.h"
#import "SDLHMILevel.h"
#import "SDLSystemContext.h"


NS_ASSUME_NONNULL_BEGIN

@protocol SDLManagerDelegate <NSObject>

/**
 *  Called upon a disconnection from the remote system.
 */
- (void)managerDidDisconnect;

/**
 *  Called when the HMI level state of this application changes on the remote system. This is equivalent to the application's state changes in iOS such as foreground, background, or closed.
 *
 *  @param oldLevel The previous level which has now been left.
 *  @param newLevel The current level.
 */
- (void)hmiLevel:(SDLHMILevel)oldLevel didChangeToLevel:(SDLHMILevel)newLevel;

@optional
/**
 *  Called when the audio streaming state of this application changes on the remote system. This refers to when streaming audio is audible to the user.
 *
 *  @param oldState The previous state which has now been left.
 *  @param newState The current state.
 */
- (void)audioStreamingState:(nullable SDLAudioStreamingState)oldState didChangeToState:(SDLAudioStreamingState)newState;

/**
 *  Called when the system context of this application changes on the remote system. This refers to whether or not a user-initiated interaction is in progress, and if so, what it is.
 *
 *  @param oldContext The previous context which has now been left.
 *  @param newContext The current context.
 */
- (void)systemContext:(nullable SDLSystemContext)oldContext didChangeToContext:(SDLSystemContext)newContext;


@end

NS_ASSUME_NONNULL_END
