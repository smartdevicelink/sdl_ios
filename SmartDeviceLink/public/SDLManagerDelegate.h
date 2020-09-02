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
#import "SDLLifecycleConfigurationUpdate.h"
#import "SDLLanguage.h"
#import "SDLVideoStreamingState.h"

NS_ASSUME_NONNULL_BEGIN

/// The manager's delegate
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

/// Called when the video streaming state of this application changes. This refers to streaming video for navigation purposes. If you are "autostreaming" via CarWindow, you should not do anything with this method. Everything should be handled for you automatically.
///
/// Only supported on RPC v5.0+ connections.
///
/// @param oldState The previous state
/// @param newState The current state
- (void)videoStreamingState:(nullable SDLVideoStreamingState)oldState didChangetoState:(SDLVideoStreamingState)newState;

/**
 *  Called when the system context of this application changes on the remote system. This refers to whether or not a user-initiated interaction is in progress, and if so, what it is.
 *
 *  @param oldContext The previous context which has now been left.
 *  @param newContext The current context.
 */
- (void)systemContext:(nullable SDLSystemContext)oldContext didChangeToContext:(SDLSystemContext)newContext;

/**
 * Called when the lifecycle manager detected a language mismatch. In case of a language mismatch the manager should change the apps registration by updating the lifecycle configuration to the specified language. If the app can support the specified language it should return an Object of SDLLifecycleConfigurationUpdate, otherwise it should return nil to indicate that the language is not supported.
 *
 * @param language The language of the connected head unit the manager is trying to update the configuration.
 * @return An object of SDLLifecycleConfigurationUpdate if the head unit language is supported, otherwise nil to indicate that the language is not supported.
 */
- (nullable SDLLifecycleConfigurationUpdate *)managerShouldUpdateLifecycleToLanguage:(SDLLanguage)language __deprecated_msg("Use managerShouldUpdateLifecycleToLanguage:hmiLanguage");

/**
 * Called when the lifecycle manager detected a language mismatch. In case of a language mismatch the manager should change the apps registration by updating the lifecycle configuration to the specified language. If the app can support the specified language it should return an Object of SDLLifecycleConfigurationUpdate, otherwise it should return nil to indicate that the language is not supported.
 *
 * @param language The VR+TTS language of the connected head unit the manager is trying to update the configuration.
 * @param hmiLanguage The HMI display language of the connected head unit the manager is trying to update the configuration.
 * @return An object of SDLLifecycleConfigurationUpdate if the head unit language is supported, otherwise nil to indicate that the language is not supported.
 */
- (nullable SDLLifecycleConfigurationUpdate *)managerShouldUpdateLifecycleToLanguage:(SDLLanguage)language hmiLanguage:(SDLLanguage)hmiLanguage;

@end

NS_ASSUME_NONNULL_END
