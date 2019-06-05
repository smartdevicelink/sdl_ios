//
//  SDLStreamingAudioManagerMock.h
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 12/5/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAudioStreamManagerDelegate.h"
#import "SDLStreamingAudioManagerType.h"

@interface SDLStreamingAudioManagerMock : NSObject <SDLStreamingAudioManagerType, SDLAudioStreamManagerDelegate>

@property (copy, nonatomic, readonly) NSData *dataSinceClear;
@property (strong, nonatomic) NSData *lastSentData;

- (void)clearData;

#pragma mark SDLStreamingAudioManagerType
@property (assign, nonatomic, readonly, getter=isAudioConnected) BOOL audioConnected;
- (BOOL)sendAudioData:(NSData *)audioData;
- (void)setAudioConnected:(BOOL)audioConnected;

#pragma mark SDLAudioStreamManagerDelegate
- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager fileDidFinishPlaying:(SDLAudioFile *)file successfully:(BOOL)successfully;
- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager dataBufferDidFinishPlayingSuccessfully:(BOOL)successfully;
- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager errorDidOccurForFile:(SDLAudioFile *)file error:(NSError *)error;
- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager errorDidOccurForDataBuffer:(NSError *)error;
@property (assign, nonatomic, readonly) BOOL finishedPlaying;
@property (strong, nonatomic, readonly) NSError *error;

@end
