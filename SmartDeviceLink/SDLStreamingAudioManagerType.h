//
//  SDLStreamingAudioManagerType.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 12/5/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Streaming audio manager
@protocol SDLStreamingAudioManagerType <NSObject>

/**
 Whether or not the audio byte stream is currently connected
 */
@property (assign, nonatomic, readonly, getter=isAudioConnected) BOOL audioConnected;

/**
 Send audio data bytes over the audio byte stream

 @param audioData The PCM data bytes
 @return Whether or not it sent successfully
 */
- (BOOL)sendAudioData:(NSData *)audioData;

@end
