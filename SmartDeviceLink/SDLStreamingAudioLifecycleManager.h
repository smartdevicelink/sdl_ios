//
//  SDLStreamingAudioLifecycleManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/19/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLHMILevel.h"
#import "SDLProtocolListener.h"
#import "SDLStreamingAudioManagerType.h"
#import "SDLStreamingMediaManagerConstants.h"

@class SDLAudioStreamManager;
@class SDLProtocol;
@class SDLStateMachine;
@class SDLStreamingMediaConfiguration;

@protocol SDLConnectionManagerType;


NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingAudioLifecycleManager : NSObject <SDLProtocolListener, SDLStreamingAudioManagerType>

@property (nonatomic, strong, readonly) SDLAudioStreamManager *audioManager;

@property (strong, nonatomic, readonly) SDLStateMachine *audioStreamStateMachine;
@property (strong, nonatomic, readonly) SDLAudioStreamManagerState *currentAudioStreamState;

@property (strong, nonatomic, readonly) SDLStateMachine *appStateMachine;
@property (strong, nonatomic, readonly) SDLAppState *currentAppState;

@property (copy, nonatomic, nullable) SDLHMILevel hmiLevel;

/**
 *  Whether or not the audio session is connected.
 */
@property (assign, nonatomic, readonly, getter=isAudioConnected) BOOL audioConnected;

/**
 *  Whether or not the audio session is encrypted. This may be different than the requestedEncryptionType.
 */
@property (assign, nonatomic, readonly, getter=isAudioEncrypted) BOOL audioEncrypted;

/**
 *  Whether or not video streaming is supported
 *
 *  @see SDLRegisterAppInterface SDLDisplayCapabilities
 */
@property (assign, nonatomic, readonly, getter=isStreamingSupported) BOOL streamingSupported;

/**
 *  The requested encryption type when a session attempts to connect. This setting applies to both video and audio sessions.
 *
 *  DEFAULT: SDLStreamingEncryptionFlagAuthenticateAndEncrypt
 */
@property (assign, nonatomic) SDLStreamingEncryptionFlag requestedEncryptionType;

- (instancetype)init NS_UNAVAILABLE;

/**
 Create a new streaming media manager for navigation and VPM apps with a specified configuration

 @param connectionManager The pass-through for RPCs
 @param configuration The configuration of this streaming media session
 @return A new streaming manager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLStreamingMediaConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/**
 *  Start the manager with a completion block that will be called when startup completes. This is used internally. To use an SDLStreamingMediaManager, you should use the manager found on `SDLManager`.
 */
- (void)startWithProtocol:(SDLProtocol *)protocol;

/**
 *  Stop the manager. This method is used internally.
 */
- (void)stop;

/**
 *  This method receives PCM audio data and will attempt to send that data across to the head unit for immediate playback
 *
 *  @param audioData    The data in PCM audio format, to be played
 *
 *  @return Whether or not the data was successfully sent.
 */
- (BOOL)sendAudioData:(NSData *)audioData;

@end

NS_ASSUME_NONNULL_END
