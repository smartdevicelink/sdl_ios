//
//  SDLBinaryAudioManager.m
//  SmartDeviceLink-Example
//
//  Created by Joel Fischer on 10/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLAudioStreamManager.h"

#import "SDLAudioFile.h"
#import "SDLAudioStreamManagerDelegate.h"
#import "SDLError.h"
#import "SDLFile.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLManager.h"
#import "SDLPCMAudioConverter.h"
#import "SDLStreamingAudioManagerType.h"
#import "dispatch_timer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAudioStreamManager ()

@property (weak, nonatomic) id<SDLStreamingAudioManagerType> streamManager;
@property (strong, nonatomic) NSMutableArray<SDLAudioFile *> *mutableQueue;
@property (strong, nonatomic) dispatch_queue_t audioQueue;
@property (assign, nonatomic, readwrite, getter=isPlaying) BOOL playing;

@property (assign, nonatomic) BOOL shouldPlayWhenReady;
@property (nonatomic, strong, nullable) dispatch_source_t audioStreamTimer;
@property (nonatomic) NSTimeInterval streamingEndTimeOfHU;

@end

@implementation SDLAudioStreamManager

// Byte length of voice data per second
static const NSInteger PerSecondVoiceData = 32000;

// How many seconds the handset can precede the head unit
static const NSTimeInterval ThresholdPrecedeSec = 3.0f;

- (instancetype)initWithManager:(id<SDLStreamingAudioManagerType>)streamManager {
    self = [super init];
    if (!self) { return nil; }

    _mutableQueue = [NSMutableArray array];
    _shouldPlayWhenReady = NO;
    _audioQueue = dispatch_queue_create_with_target("com.sdl.audiomanager.transcode", DISPATCH_QUEUE_SERIAL, [SDLGlobals sharedGlobals].sdlProcessingQueue);
    _streamManager = streamManager;

    return self;
}

- (void)stop {
    dispatch_async(_audioQueue, ^{
        [self sdl_stop];
    });
}

- (void)sdl_stop {
    NSError *error = nil;
    for (SDLAudioFile *file in self.mutableQueue) {
        if (file.outputFileURL != nil) {
            [[NSFileManager defaultManager] removeItemAtURL:file.outputFileURL error:&error];
        }
    }
    [self.mutableQueue removeAllObjects];

    if (self.audioStreamTimer != nil) {
        dispatch_stop_timer(self.audioStreamTimer);
        self.audioStreamTimer = nil;
    }
    self.shouldPlayWhenReady = NO;
    self.playing = NO;
}

#pragma mark - Getters

- (NSArray<SDLFile *> *)queue {
    return [_mutableQueue copy];
}

#pragma mark - Pushing to the Queue
#pragma mark Files

- (void)pushWithFileURL:(NSURL *)fileURL forceInterrupt:(BOOL)forceInterrupt {    dispatch_async(_audioQueue, ^{
        [self sdl_pushWithContentsOfURL:fileURL forceInterrupt:forceInterrupt];
    });
}

- (void)sdl_pushWithContentsOfURL:(NSURL *)fileURL forceInterrupt:(BOOL)forceInterrupt {
    // Convert and store in the queue
    NSError *error = nil;
    SDLPCMAudioConverter *converter = [[SDLPCMAudioConverter alloc] initWithFileURL:fileURL];
    NSURL *_Nullable outputFileURL = [converter convertFileWithError:&error];
    UInt32 estimatedDuration = converter.estimatedDuration;

    if (outputFileURL == nil) {
        SDLLogE(@"Error converting file to CAF / PCM: %@", error);
        if (self.delegate != nil) {
            [self.delegate audioStreamManager:self errorDidOccurForFile:fileURL error:error];
        }
        return;
    }

    if (self.mutableQueue.count == 0) {
        NSTimeInterval precedeTime = self.streamingEndTimeOfHU - [[NSDate date] timeIntervalSince1970];
        if (precedeTime > 0.0f) {
            SDLLogD(@"Time when handset is ahead of head unit: %f", precedeTime);
            [NSThread sleepForTimeInterval:precedeTime];
        }
        self.streamingEndTimeOfHU = [[NSDate date] timeIntervalSince1970];
    }

    if (forceInterrupt) {
        [self sdl_stop];
    }

    SDLAudioFile *audioFile = [[SDLAudioFile alloc] initWithInputFileURL:fileURL outputFileURL:outputFileURL estimatedDuration:estimatedDuration];
    [self.mutableQueue addObject:audioFile];

    if (self.shouldPlayWhenReady) {
        [self sdl_playNextWhenReady];
    }
}

#pragma mark Raw Data

- (void)pushWithData:(NSData *)data {
    dispatch_async(_audioQueue, ^{
        [self sdl_pushWithData:data];
    });
}

- (void)sdl_pushWithData:(NSData *)data {
    SDLAudioFile *audioFile = [[SDLAudioFile alloc] initWithData:data];
    [self.mutableQueue addObject:audioFile];
}

#pragma mark Playing from the Queue

- (void)playNextWhenReady {
    dispatch_async(_audioQueue, ^{
        [self sdl_playNextWhenReady];
    });
}

- (void)sdl_playNextWhenReady {
    if (self.mutableQueue.count == 0) {
        self.shouldPlayWhenReady = YES;
        return;
    }

    if (!self.streamManager.isAudioConnected) {
        if (self.delegate != nil) {
            NSError *error = [NSError sdl_audioStreamManager_notConnected];
            [self.delegate audioStreamManager:self errorDidOccurForFile:self.mutableQueue.firstObject.inputFileURL error:error];
        }
        return;
    }

    self.shouldPlayWhenReady = NO;
    if (self.playing == NO) {
        self.playing = YES;
        SDLAudioFile *file = self.mutableQueue.firstObject;

        // Strip the first bunch of bytes (because of how Apple outputs the data) and send to the audio stream, if we don't do this, it will make a weird click sound
        __block NSData *audioData = nil;
        if (file.inputFileURL != nil) {
            audioData = [file.data subdataWithRange:NSMakeRange(5760, (file.data.length - 5760))];
        } else {
            audioData = file.data;
        }

        NSTimeInterval precedeTime = self.streamingEndTimeOfHU - [[NSDate date] timeIntervalSince1970];
        if(precedeTime > ThresholdPrecedeSec){
            SDLLogD(@"The time during which the handset precedes the head unit exceeds the threshold: %f", precedeTime);
            [NSThread sleepForTimeInterval:ThresholdPrecedeSec];
        }

        // Send the audio file, which starts it playing immediately
        SDLLogD(@"Playing audio file: %@", file);
        BOOL success = [self sendAudioData:&audioData of:PerSecondVoiceData * 2];
        if ((success) && (audioData.length > 0)) {
            __weak typeof(self) weakSelf = self;
            self.audioStreamTimer = dispatch_create_timer(1.0f, YES, ^{
                BOOL success = [weakSelf sendAudioData:&audioData of:PerSecondVoiceData];
                if ((success) && (audioData.length > 0)) {
                    SDLLogD(@"sendAudioData continue: %lu", (unsigned long)audioData.length);
                } else {
                    SDLLogD(@"sendAudioData end");
                    dispatch_stop_timer(weakSelf.audioStreamTimer);
                    weakSelf.audioStreamTimer = nil;

                    [weakSelf sdl_finishAudioStreaming:file success:success];
                }
            });
        } else {
            [self sdl_finishAudioStreaming:file success:success];
        }
    }
}

- (void)sdl_finishAudioStreaming:(SDLAudioFile *)file success:(BOOL)success {
    __weak typeof(self) weakself = self;
    dispatch_async(_audioQueue, ^{
        weakself.playing = NO;
        if (weakself.mutableQueue.count > 0) {
            [weakself.mutableQueue removeObjectAtIndex:0];
            [weakself sdl_playNextWhenReady];
        }
    });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        NSError *error = nil;
        if (weakself.delegate != nil) {
            if (file.inputFileURL != nil) {
                [weakself.delegate audioStreamManager:weakself fileDidFinishPlaying:file.inputFileURL successfully:success];
            } else if ([weakself.delegate respondsToSelector:@selector(audioStreamManager:dataBufferDidFinishPlayingSuccessfully:)]) {
                [weakself.delegate audioStreamManager:weakself dataBufferDidFinishPlayingSuccessfully:success];
            }
        }

        SDLLogD(@"Ending Audio file: %@", file);
        [[NSFileManager defaultManager] removeItemAtURL:file.outputFileURL error:&error];
        if (weakself.delegate != nil && error != nil) {
            if (file.inputFileURL != nil) {
                [weakself.delegate audioStreamManager:weakself errorDidOccurForFile:file.inputFileURL error:error];
            } else if ([weakself.delegate respondsToSelector:@selector(audioStreamManager:errorDidOccurForDataBuffer:)]) {
                [weakself.delegate audioStreamManager:weakself errorDidOccurForDataBuffer:error];
            }
        }
    });
}

- (BOOL)sendAudioData:(NSData **)data of:(NSUInteger)byteLength{
    if (self.streamManager.isAudioConnected == NO) {
        return NO;
    }

    NSUInteger sByte = byteLength;
    if ((*data).length < byteLength) {
        sByte = (*data).length;
    }

    if ([self.streamManager sendAudioData:[*data subdataWithRange:NSMakeRange(0, sByte)]]) {
        // Set remaining voice data
        *data = [(*data) subdataWithRange:NSMakeRange(sByte, (*data).length - sByte)];

        // Calculate the AudioStreaming end time on the HU side.
        self.streamingEndTimeOfHU += (double)sByte / (double)PerSecondVoiceData;
        return YES;
    }
    return NO;
}

@end

NS_ASSUME_NONNULL_END
