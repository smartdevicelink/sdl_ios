//
//  SDLBinaryAudioManager.m
//  SmartDeviceLink-Example
//
//  Created by Joel Fischer on 10/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLAudioStreamManager.h"

#import "SDLAudioFile.h"
#import "SDLFile.h"
#import "SDLLogMacros.h"
#import "SDLManager.h"
#import "SDLPCMAudioConverter.h"
#import "SDLAudioStreamManagerDelegate.h"
#import "SDLStreamingAudioManagerType.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const SDLErrorDomainAudioStreamManager = @"com.sdl.extension.pcmAudioStreamManager";

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
    _audioQueue = dispatch_queue_create("com.sdl.audiomanager.transcode", DISPATCH_QUEUE_SERIAL);
    _shouldPlayWhenReady = NO;

    _streamManager = streamManager;

    return self;
}

- (NSArray<SDLFile *> *)queue {
    return [_mutableQueue copy];
}

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
            NSError *error = [NSError errorWithDomain:SDLErrorDomainAudioStreamManager code:SDLAudioStreamManagerErrorNotConnected userInfo:nil];
            [self.delegate audioStreamManager:self errorDidOccurForFile:self.mutableQueue.firstObject.inputFileURL error:error];
        }
        return;
    }

    self.shouldPlayWhenReady = NO;
    __block SDLAudioFile *file = self.mutableQueue.firstObject;
    [self.mutableQueue removeObjectAtIndex:0];

    // Strip the first bunch of bytes (because of how Apple outputs the data) and send to the audio stream, if we don't do this, it will make a weird click sound
    SDLLogD(@"Playing audio file: %@", file);
    NSData *audioData = [file.data subdataWithRange:NSMakeRange(5760, (file.data.length - 5760))];
    __block BOOL success = [self.streamManager sendAudioData:audioData];
    self.playing = YES;

    float audioLengthSecs = (float)audioData.length / (float)32000.0;
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(audioLengthSecs * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.playing = NO;
        NSError *error = nil;
        if (weakself.delegate != nil) {
            [weakself.delegate audioStreamManager:weakself fileDidFinishPlaying:file.inputFileURL successfully:success];
        }
        SDLLogD(@"Ending Audio file: %@", file);
        [[NSFileManager defaultManager] removeItemAtURL:file.outputFileURL error:&error];
        if (weakself.delegate != nil && error != nil) {
            [weakself.delegate audioStreamManager:weakself errorDidOccurForFile:file.inputFileURL error:error];
        }
    });
}

- (void)stop {
    dispatch_async(_audioQueue, ^{
        self.shouldPlayWhenReady = NO;
        [self.mutableQueue removeAllObjects];
    });
}

@end

NS_ASSUME_NONNULL_END
