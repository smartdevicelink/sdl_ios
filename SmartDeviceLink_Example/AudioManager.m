//
//  AudioManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 4/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "AudioManager.h"
#import "SmartDeviceLink.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, AudioRecordingState) {
    AudioRecordingStateListening,
    AudioRecordingStateNotListening
};


NS_ASSUME_NONNULL_BEGIN

@interface AudioManager ()

@property (strong, nonatomic) SDLManager *sdlManager;
@property (strong, nonatomic, nullable) NSMutableData *audioData;
@property (assign, nonatomic) AudioRecordingState audioRecordingState;

@property (nonatomic, copy, nullable) SDLResponseHandler audioPassThruEndedHandler;
@property (nonatomic, copy, nullable) void (^audioDataReceivedHandler)(NSData *__nullable audioData);

@end


@implementation AudioManager

#pragma mark - Lifecycle

- (instancetype)initWithManager:(SDLManager *)manager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _sdlManager = manager;
    _audioData = [NSMutableData data];
    _audioRecordingState = AudioRecordingStateNotListening;

    return self;
}

- (void)startRecording {
    if (self.audioRecordingState == AudioRecordingStateListening) { return; }

    UInt32 recordingDurationInMilliseconds = 5000;
    SDLPerformAudioPassThru *performAudioPassThru = [[SDLPerformAudioPassThru alloc] initWithInitialPrompt:@"Starting sound recording" audioPassThruDisplayText1:@"Say Something" audioPassThruDisplayText2:[NSString stringWithFormat:@"Recording for %d seconds", (recordingDurationInMilliseconds / 1000)] samplingRate:SDLSamplingRate16KHZ bitsPerSample:SDLBitsPerSample16Bit audioType:SDLAudioTypePCM maxDuration:recordingDurationInMilliseconds muteAudio:true audioDataHandler:self.audioDataReceivedHandler];

    [self.sdlManager sendRequest:performAudioPassThru withResponseHandler:self.audioPassThruEndedHandler];
}

- (void)stopRecording {
    self.audioRecordingState = AudioRecordingStateNotListening;
    self.audioData = [NSMutableData data];
}


#pragma mark - Audio Pass Thru Notifications

- (nullable void (^)(NSData * _Nullable))audioDataReceivedHandler {
    if (!_audioDataReceivedHandler) {
        __weak typeof(self) weakSelf = self;
        self.audioDataReceivedHandler = ^(NSData * _Nullable audioData) {
            if (audioData.length == 0) { return; }
            if (weakSelf.audioRecordingState == AudioRecordingStateNotListening) {
                weakSelf.audioData = [NSMutableData data];
                weakSelf.audioRecordingState = AudioRecordingStateListening;
            }
            [weakSelf.audioData appendData:audioData];
        };
    }

    return _audioDataReceivedHandler;
}

- (nullable SDLResponseHandler)audioPassThruEndedHandler {
    if (!_audioPassThruEndedHandler) {
        __weak typeof(self) weakSelf = self;
        self.audioPassThruEndedHandler = ^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (response == nil) { return; }
            weakSelf.audioRecordingState = AudioRecordingStateNotListening;

            SDLResult resultCode = response.resultCode;
            if ([resultCode isEqualToEnum:SDLResultSuccess]) {
                // The `PerformAudioPassThru` timed out or the "Done" button was pressed in the pop-up.
                if (weakSelf.audioData.length == 0) {
                    [weakSelf.sdlManager sendRequest: [[SDLAlert alloc] initWithAlertText1:@"No audio recorded" alertText2:nil duration:5000]];
                } else {
                    AVAudioPCMBuffer *pcmBuffer = [weakSelf sdlex_convertDataToPCMFormattedAudio:weakSelf.audioData];
                    [weakSelf.sdlManager sendRequest: [[SDLAlert alloc] initWithAlertText1:@"Audio recorded!" alertText2:[NSString stringWithFormat:@"%@", pcmBuffer] duration:5000]];
                }
            } else if ([resultCode isEqualToEnum:SDLResultAborted]) {
                // The "Cancel" button was pressed in the pop-up. Ignore this audio pass thru.
                weakSelf.audioData = [NSMutableData data];
                [weakSelf.sdlManager sendRequest: [[SDLAlert alloc] initWithAlertText1:@"Recording canceled" alertText2:nil duration:5000]];
            } else {
                weakSelf.audioData = [NSMutableData data];
                [weakSelf.sdlManager sendRequest: [[SDLAlert alloc] initWithAlertText1:@"Recording unsuccessful" alertText2:nil duration:5000]];
            }
        };
    }

    return _audioPassThruEndedHandler;
}

#pragma mark - Audio Data Conversion

- (AVAudioPCMBuffer *)sdlex_convertDataToPCMFormattedAudio:(NSMutableData *)data {
    AVAudioFormat *audioFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatInt16 sampleRate:16000 channels:1 interleaved:NO];
    UInt32 numberOfFrames = (UInt32)data.length / audioFormat.streamDescription->mBytesPerFrame;
    AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:audioFormat frameCapacity:numberOfFrames];
    buffer.frameLength = numberOfFrames;

    memcpy(buffer.int16ChannelData[0], data.bytes, data.length);

    return buffer;
}

@end

NS_ASSUME_NONNULL_END
