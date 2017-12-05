//
//  SDLStreamingAudioManagerMock.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 12/5/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLStreamingAudioManagerMock.h"

@interface SDLStreamingAudioManagerMock()

@property (assign, nonatomic, readwrite, getter=isAudioConnected) BOOL audioConnected;

@property (strong, nonatomic) NSMutableData *mutableDataSinceClear;

@property (assign, nonatomic, readwrite) BOOL fileFinishedPlaying;
@property (strong, nonatomic, readwrite) NSError *fileError;

@end

@implementation SDLStreamingAudioManagerMock

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _lastSentData = nil;
    _mutableDataSinceClear = nil;

    return self;
}

- (void)clearData {
    _lastSentData = nil;
    _mutableDataSinceClear = nil;
    
    _fileFinishedPlaying = NO;
    _fileError = nil;
}

#pragma mark SDLStreamingAudioManagerType
- (NSData *)dataSinceClear {
    return [_mutableDataSinceClear copy];
}

- (BOOL)sendAudioData:(NSData *)audioData {
    _lastSentData = audioData;

    if (_mutableDataSinceClear == nil) {
        _mutableDataSinceClear = [audioData mutableCopy];
    } else {
        [_mutableDataSinceClear appendData:audioData];
    }

    return YES;
}

- (void)setAudioConnected:(BOOL)audioConnected {
    _audioConnected = audioConnected;
}

#pragma mark SDLAudioStreamManagerDelegate
- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager fileDidFinishPlaying:(SDLAudioFile *)file successfully:(BOOL)successfully {
    _fileFinishedPlaying = successfully;
}

- (void)audioStreamManager:(SDLAudioStreamManager *)audioManager errorDidOccurForFile:(SDLAudioFile *)file error:(NSError *)error {
    _fileError = error;
}

@end
