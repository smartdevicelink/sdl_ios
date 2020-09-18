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

NS_ASSUME_NONNULL_BEGIN

@interface SDLAudioStreamManager ()

@property (weak, nonatomic) id<SDLStreamingAudioManagerType> streamManager;
@property (strong, nonatomic) NSMutableArray<SDLAudioFile *> *mutableQueue;
@property (strong, nonatomic) dispatch_queue_t audioQueue;
@property (assign, nonatomic, readwrite, getter=isPlaying) BOOL playing;

@property (assign, nonatomic) BOOL shouldPlayWhenReady;

@end

@implementation SDLAudioStreamManager

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
        self.shouldPlayWhenReady = NO;
        [self.mutableQueue removeAllObjects];
    });
}

#pragma mark - Getters

- (NSArray<SDLFile *> *)queue {
    return [_mutableQueue copy];
}

#pragma mark - Pushing to the Queue
#pragma mark Files

- (void)pushWithFileURL:(NSURL *)fileURL {
    dispatch_async(_audioQueue, ^{
        [self sdl_pushWithContentsOfURL:fileURL];
    });
}

- (void)sdl_pushWithContentsOfURL:(NSURL *)fileURL {
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
    __block SDLAudioFile *file = self.mutableQueue.firstObject;
    [self.mutableQueue removeObjectAtIndex:0];

    // Strip the first bunch of bytes (because of how Apple outputs the data) and send to the audio stream, if we don't do this, it will make a weird click sound
    NSData *audioData = nil;
    if (file.inputFileURL != nil) {
        audioData = [file.data subdataWithRange:NSMakeRange(5760, (file.data.length - 5760))];
    } else {
        audioData = file.data;
    }

    // Send the audio file, which starts it playing immediately
    SDLLogD(@"Playing audio file: %@", file);
    __block BOOL success = [self.streamManager sendAudioData:audioData];
    self.playing = YES;

    // Determine the length of the audio PCM data and perform a few items once the audio has finished playing
    float audioLengthSecs = (float)audioData.length / (float)32000.0;
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(audioLengthSecs * NSEC_PER_SEC)), [SDLGlobals sharedGlobals].sdlProcessingQueue, ^{
        __strong typeof(weakself) strongSelf = weakself;

        strongSelf.playing = NO;
        NSError *error = nil;
        if (strongSelf.delegate != nil) {
            if (file.inputFileURL != nil) {
                [strongSelf.delegate audioStreamManager:strongSelf fileDidFinishPlaying:file.inputFileURL successfully:success];
            } else if ([strongSelf.delegate respondsToSelector:@selector(audioStreamManager:dataBufferDidFinishPlayingSuccessfully:)]) {
                [strongSelf.delegate audioStreamManager:strongSelf dataBufferDidFinishPlayingSuccessfully:success];
            }
        }

        SDLLogD(@"Ending Audio file: %@", file);
        [[NSFileManager defaultManager] removeItemAtURL:file.outputFileURL error:&error];
        if (strongSelf.delegate != nil && error != nil) {
            if (file.inputFileURL != nil) {
                [strongSelf.delegate audioStreamManager:strongSelf errorDidOccurForFile:file.inputFileURL error:error];
            } else if ([strongSelf.delegate respondsToSelector:@selector(audioStreamManager:errorDidOccurForDataBuffer:)]) {
                [strongSelf.delegate audioStreamManager:strongSelf errorDidOccurForDataBuffer:error];
            }
        }
    });
}

@end

NS_ASSUME_NONNULL_END
