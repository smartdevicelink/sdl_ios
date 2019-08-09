//
//  AudioManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 4/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "AlertManager.h"
#import "AudioManager.h"
#import <AVFoundation/AVFoundation.h>
#import "SDLLogMacros.h"
#import "SmartDeviceLink.h"
#import <Speech/Speech.h>


typedef NS_ENUM(NSUInteger, AudioRecordingState) {
    AudioRecordingStateListening,
    AudioRecordingStateNotListening
};

typedef NS_ENUM(NSUInteger, SpeechRecognitionAuthState) {
    SpeechRecognitionAuthStateAuthorized,
    SpeechRecognitionAuthStateNotAuthorized,
    SpeechRecognitionAuthStateBadRegion
};

NS_ASSUME_NONNULL_BEGIN

@interface AudioManager () <SFSpeechRecognizerDelegate>

@property (strong, nonatomic) SDLManager *sdlManager;
@property (strong, nonatomic, nullable) NSMutableData *audioData;
@property (assign, nonatomic) AudioRecordingState audioRecordingState;

@property (assign, nonatomic) SpeechRecognitionAuthState speechRecognitionAuthState;
@property (strong, nonatomic, nullable) SFSpeechAudioBufferRecognitionRequest *speechRecognitionRequest;
@property (strong, nonatomic) SFSpeechRecognizer *speechRecognizer;
@property (strong, nonatomic, nullable) SFSpeechRecognitionTask *speechRecognitionTask;
@property (strong, nonatomic) NSString *speechTranscription;

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
    _speechRecognitionAuthState = SpeechRecognitionAuthStateNotAuthorized;
    NSLocale *speechDefaultLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    _speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:speechDefaultLocale];
    _speechRecognizer.delegate = self;
    _speechRecognitionAuthState = [AudioManager sdlex_checkSpeechRecognizerAuth:self.speechRecognizer];

    if (self.speechRecognitionAuthState != SpeechRecognitionAuthStateAuthorized) {
        [self sdlex_requestSFSpeechRecognizerAuthorization];
    }

    return self;
}

/**
 *  Resets the manager
 */
- (void)stopManager {
    self.audioRecordingState = AudioRecordingStateNotListening;
    self.audioData = [NSMutableData data];
    self.speechTranscription = @"";
}

/**
 *  Starts an audio recording using the in-car microphone. During the recording, a pop-up will let the user know that they are being recorded. The pop-up is only dismissed when the recording stops.
 */
- (void)startRecording {
    if (self.speechRecognitionAuthState != SpeechRecognitionAuthStateAuthorized) {
        SDLLogW(@"This app does not have permission to access the Speech Recognition API");
        [self.sdlManager sendRequest:[AlertManager alertWithMessageAndCloseButton:@"You must give this app permission to access Speech Recognition" textField2:nil iconName:nil]];
        return;
    }

    if (self.audioRecordingState != AudioRecordingStateNotListening) {
        SDLLogW(@"Audio recording already in progress");
        return;
    }

    [self sdlex_startSpeechRecognitionTask];

    UInt32 recordingDurationInMilliseconds = 10000;
    SDLPerformAudioPassThru *performAudioPassThru = [[SDLPerformAudioPassThru alloc] initWithInitialPrompt:@"Starting sound recording" audioPassThruDisplayText1:@"Say Something" audioPassThruDisplayText2:[NSString stringWithFormat:@"Recording for %d seconds", (recordingDurationInMilliseconds / 1000)] samplingRate:SDLSamplingRate16KHZ bitsPerSample:SDLBitsPerSample16Bit audioType:SDLAudioTypePCM maxDuration:recordingDurationInMilliseconds muteAudio:true audioDataHandler:self.audioDataReceivedHandler];

    [self.sdlManager sendRequest:performAudioPassThru withResponseHandler:self.audioPassThruEndedHandler];
}

/**
 *  Manually stop an ongoing audio recording.
 */
- (void)stopRecording {
    if (self.audioRecordingState != AudioRecordingStateListening) { return; }
    self.audioRecordingState = AudioRecordingStateNotListening;

    SDLEndAudioPassThru *endAudioPassThru = [[SDLEndAudioPassThru alloc] init];
    [self.sdlManager sendRequest:endAudioPassThru];
}

#pragma mark - Audio Pass Thru Notifications

/**
 * SDL streams the audio data as it is collected.
 */
- (nullable void (^)(NSData * _Nullable))audioDataReceivedHandler {
    if (!_audioDataReceivedHandler) {
        __weak typeof(self) weakSelf = self;
        self.audioDataReceivedHandler = ^(NSData * _Nullable audioData) {
            if (audioData.length == 0) { return; }
            if (weakSelf.audioRecordingState == AudioRecordingStateNotListening) {
                weakSelf.audioData = [NSMutableData data];
                weakSelf.audioRecordingState = AudioRecordingStateListening;
            }

            AVAudioPCMBuffer *buffer = [weakSelf sdlex_createPCMBufferWithData:[NSMutableData dataWithData:audioData]];
            if (buffer == nil) { return; }
            [weakSelf.speechRecognitionRequest appendAudioPCMBuffer:buffer];
        };
    }

    return _audioDataReceivedHandler;
}

/**
 *  Called when `PerformAudioPassThru` request times out or when a `EndAudioPassThru` request is sent
 *
 *  @return    A SDLResponseHandler
 */
- (nullable SDLResponseHandler)audioPassThruEndedHandler {
    if (!_audioPassThruEndedHandler) {
        __weak typeof(self) weakSelf = self;
        self.audioPassThruEndedHandler = ^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (response == nil) { return; }
            weakSelf.audioRecordingState = AudioRecordingStateNotListening;

            SDLResult resultCode = response.resultCode;
            if ([resultCode isEqualToEnum:SDLResultSuccess]) {
                // The `PerformAudioPassThru` timed out or the "Done" button was pressed in the pop-up.
                SDLLogD(@"Audio Pass Thru ended successfully");
                NSString *alertMessage = [NSString stringWithFormat:@"You said: %@", weakSelf.speechTranscription.length == 0 ? @"No speech detected" : weakSelf.speechTranscription];
                [weakSelf.sdlManager sendRequest:[AlertManager alertWithMessageAndCloseButton:alertMessage textField2:nil iconName:nil]];
            } else if ([resultCode isEqualToEnum:SDLResultAborted]) {
                // The "Cancel" button was pressed in the pop-up. Ignore this audio pass thru.
                SDLLogD(@"Audio recording canceled");
            } else {
                SDLLogD(@"Audio recording not successful: \(response.resultCode)");
            }

            [weakSelf sdlex_stopSpeechRecognitionTask];
        };
    }

    return _audioPassThruEndedHandler;
}

#pragma mark - Audio Data Conversion

/**
 *  Converts the audio data to PCM formatted audio that can be passed, if desired, to the iOS SFSpeech framework (SDL does not provide speech recognition, however the SFSpeech framework or another third party library can be used for speech recognition). The audio format and sample rate should match those set in the `SDLPerformAudioPassThru`.
 *
 *  @param data The audio data
 *  @return     An AVAudioPCMBuffer object
 */
- (AVAudioPCMBuffer *)sdlex_createPCMBufferWithData:(NSMutableData *)data {
    [self.audioData appendData:data];

    AVAudioFormat *audioFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatInt16 sampleRate:16000 channels:1 interleaved:NO];
    UInt32 numberOfFrames = (UInt32)data.length / audioFormat.streamDescription->mBytesPerFrame;
    AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:audioFormat frameCapacity:numberOfFrames];
    buffer.frameLength = numberOfFrames;

    memcpy(buffer.int16ChannelData[0], data.bytes, data.length);

    return buffer;
}

#pragma mark - Speech Recognition

/**
 *  Configures speech recognition
 */
- (void)sdlex_startSpeechRecognitionTask {
    self.speechRecognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];

    if (self.speechRecognitionRequest == nil || self.speechRecognizer == nil) {
        SDLLogE(@"Unable to do speech recognition");
        return;
    }

    self.speechRecognitionRequest.shouldReportPartialResults = YES;
    self.speechRecognitionRequest.taskHint = SFSpeechRecognitionTaskHintSearch;

    self.speechRecognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.speechRecognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (result == nil) { return; }
        if (error != nil) {
            SDLLogE(@"Speech recognition error: %@", error.localizedDescription);
            return;
        }

        NSString *speechTranscription = result.bestTranscription.formattedString;
        SDLLogD(@"Ongoing transcription: %@", speechTranscription);
        self.speechTranscription = speechTranscription;
    }];
}

/**
 *  Cleans up a speech detection session that has ended
 */
- (void)sdlex_stopSpeechRecognitionTask {
    self.audioRecordingState = AudioRecordingStateNotListening;
    self.audioData = [NSMutableData data];
    self.speechTranscription = @"";
    [self.speechRecognitionTask cancel];
    [self.speechRecognitionRequest endAudio];
    self.speechRecognitionTask = nil;
    self.speechRecognitionRequest = nil;
}

#pragma mark - Speech Recognition Authorization

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    self.speechRecognitionAuthState = [AudioManager sdlex_checkSpeechRecognizerAuth:speechRecognizer];
}

/**
 *  Checks the current authorization status of the Speech Recognition API. The user can change this status via the native Settings app.
 *
 *  @param speechRecognizer     The SFSpeechRecognizer
 *  @return                     The current authorization status
 */
+ (SpeechRecognitionAuthState)sdlex_checkSpeechRecognizerAuth:(SFSpeechRecognizer *)speechRecognizer {
    if (speechRecognizer == nil) {
        return SpeechRecognitionAuthStateBadRegion;
    }

    if (SFSpeechRecognizer.authorizationStatus == SFSpeechRecognizerAuthorizationStatusAuthorized) {
        return SpeechRecognitionAuthStateAuthorized;
    } else {
        return SpeechRecognitionAuthStateNotAuthorized;
    }
}

/**
 *  Asks the user via an alert if they want to authorize this app to access the Speech Recognition API.
 */
- (void)sdlex_requestSFSpeechRecognizerAuthorization {
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                self.speechRecognitionAuthState = SpeechRecognitionAuthStateAuthorized;
            } else {
                self.speechRecognitionAuthState = SpeechRecognitionAuthStateNotAuthorized;
            }
        });
    }];
}

@end

NS_ASSUME_NONNULL_END
