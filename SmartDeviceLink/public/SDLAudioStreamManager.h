//
//  SDLBinaryAudioManager.h
//  SmartDeviceLink-Example
//
//  Created by Joel Fischer on 10/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLAudioFile;
@class SDLManager;
@class SDLStreamingMediaLifecycleManager;
@protocol SDLStreamingAudioManagerType;
@protocol SDLAudioStreamManagerDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 The manager to control the audio stream
 */
@interface SDLAudioStreamManager : NSObject

/**
 The delegate describing when files are done playing or any errors that occur
 */
@property (weak, nonatomic) id<SDLAudioStreamManagerDelegate> delegate;

/**
 Whether or not we are currently playing audio
 */
@property (assign, nonatomic, readonly, getter=isPlaying) BOOL playing;

/**
 The queue of audio files that will be played in sequence
 */
@property (copy, nonatomic, readonly) NSArray<SDLAudioFile *> *queue;

/**
 Init should only occur with dependencies. use `initWithManager:`

 @return A failure
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Create an audio stream manager with a reference to the parent stream manager.

 @warning For internal use

 @param streamManager The parent stream manager
 @return The audio stream manager
 */
- (instancetype)initWithManager:(id<SDLStreamingAudioManagerType>)streamManager NS_DESIGNATED_INITIALIZER;

/**
 Push a new file URL onto the queue after converting it into the correct PCM format for streaming binary data. Call `playNextWhenReady` to start playing the next completed pushed file.

 @note This happens on a serial background thread and will provide an error callback using the delegate if the conversion fails.

 @param fileURL File URL to convert
 */
- (void)pushWithFileURL:(NSURL *)fileURL;

/**
 Push a new audio buffer onto the queue. Call `playNextWhenReady` to start playing the pushed audio buffer.

 This data must be of the required PCM format. See SDLSystemCapabilityManager.pcmStreamCapability and SDLAudioPassThruCapability.h.

 This is *an example* of a PCM format used by some head units:
 - audioType: PCM
 - samplingRate: 16kHZ
 - bitsPerSample: 16 bits

 There is generally only one channel to the data.

 @param data The audio buffer to be pushed onto the queue
 */
- (void)pushWithData:(NSData *)data;

/**
 Play the next item in the queue. If an item is currently playing, it will continue playing and this item will begin playing after it is completed.

 When complete, this will callback on the delegate.
 */
- (void)playNextWhenReady;

/**
 Stop playing the queue after the current item completes and clear the queue. If nothing is playing, the queue will be cleared.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
