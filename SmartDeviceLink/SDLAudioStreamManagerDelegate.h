//
//  SDLBinaryAudioQueueDelegate.h
//  SmartDeviceLink-Example
//
//  Created by Joel Fischer on 10/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLAudioFile;
@class SDLAudioStreamManager;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLAudioStreamManagerDelegate <NSObject>

@required

/**
 Called when a file from the SDLAudioStreamManager finishes playing

 @param audioManager A reference to the audio stream manager
 @param fileURL The URL that finished playing
 @param successfully Whether or not it was played successfully
 */
- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager fileDidFinishPlaying:(NSURL *)fileURL successfully:(BOOL)successfully;

/**
 Called when a file from the SDLAudioStreamManager could not play

 @param audioManager  A reference to the audio stream manager
 @param fileURL The URL that failed
 @param error The error that occurred
 */
- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager errorDidOccurForFile:(NSURL *)fileURL error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
