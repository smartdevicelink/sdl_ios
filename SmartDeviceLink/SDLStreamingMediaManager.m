//
//  SDLStreamingDataManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/11/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLStreamingMediaManager.h"

#import "SDLAudioStreamManager.h"
#import "SDLConfiguration.h"
#import "SDLConnectionManagerType.h"
#import "SDLStreamingAudioLifecycleManager.h"
#import "SDLStreamingVideoLifecycleManager.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLTouchManager.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingMediaManager ()

@property (strong, nonatomic) SDLStreamingAudioLifecycleManager *audioLifecycleManager;
@property (strong, nonatomic) SDLStreamingVideoLifecycleManager *videoLifecycleManager;
@property (assign, nonatomic) BOOL audioStarted;
@property (assign, nonatomic) BOOL videoStarted;

@end


@implementation SDLStreamingMediaManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }

    _audioLifecycleManager = [[SDLStreamingAudioLifecycleManager alloc] initWithConnectionManager:connectionManager streamingConfiguration: configuration.streamingMediaConfig encryptionConfiguration:configuration.encryptionConfig];
    _videoLifecycleManager = [[SDLStreamingVideoLifecycleManager alloc] initWithConnectionManager:connectionManager configuration:configuration];

    return self;
}

- (void)dealloc {
    [_audioLifecycleManager stop];
    [_videoLifecycleManager stop];
}

- (void)startWithProtocol:(SDLProtocol *)protocol {
    [self startAudioWithProtocol:protocol];
    [self startVideoWithProtocol:protocol];
}

- (void)stop {
    [self stopAudio];
    [self stopVideo];
}

#pragma mark Audio

- (void)startAudioWithProtocol:(SDLProtocol *)protocol {
    [self.audioLifecycleManager startWithProtocol:protocol];
    self.audioStarted = YES;
}

- (void)stopAudio {
    [self.audioLifecycleManager stop];
    self.audioStarted = NO;
}

- (BOOL)sendAudioData:(NSData*)audioData {
    return [self.audioLifecycleManager sendAudioData:audioData];
}

#pragma mark Video

- (void)startVideoWithProtocol:(SDLProtocol *)protocol {
    [self.videoLifecycleManager startWithProtocol:protocol];
    self.videoStarted = YES;
}

- (void)stopVideo {
    [self.videoLifecycleManager stop];
    self.videoStarted = NO;
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer {
    return [self.videoLifecycleManager sendVideoData:imageBuffer];
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer presentationTimestamp:(CMTime)presentationTimestamp {
    return [self.videoLifecycleManager sendVideoData:imageBuffer presentationTimestamp:presentationTimestamp];
}

#pragma mark - Secondary Transport

- (void)startNewProtocolForAudio:(nullable SDLProtocol *)newAudioProtocol forVideo:(nullable SDLProtocol *)newVideoProtocol {
    if (newAudioProtocol != nil) {
        [self startAudioWithProtocol:newAudioProtocol];
    }
    if (newVideoProtocol != nil) {
        [self startVideoWithProtocol:newVideoProtocol];
    }
}

#pragma mark Video

- (void)stopVideoWithCompletionHandler:(nullable void(^)(BOOL success))completionHandler {
    __weak typeof(self) weakSelf = self;
    [self.videoLifecycleManager stopVideoWithCompletionHandler:^(BOOL success) {
        weakSelf.videoStarted = NO;

        if (completionHandler == nil) { return; }
        return completionHandler(success);
    }];
}

- (void)destroyVideoProtocol {
    [self.videoLifecycleManager destroyProtocol];
}

#pragma mark Audio

- (void)stopAudioWithCompletionHandler:(nullable void(^)(BOOL success))completionHandler {
    __weak typeof(self) weakSelf = self;
    [self.audioLifecycleManager stopAudioWithCompletionHandler:^(BOOL success) {
        weakSelf.audioStarted = NO;

        if (completionHandler == nil) { return; }
        return completionHandler(success);
    }];
}

- (void)destroyAudioProtocol {
    [self.audioLifecycleManager destroyProtocol];
}

#pragma mark - Getters

- (SDLTouchManager *)touchManager {
    return self.videoLifecycleManager.touchManager;
}

- (SDLAudioStreamManager *)audioManager {
    return self.audioLifecycleManager.audioManager;
}

- (nullable UIViewController *)rootViewController {
    return self.videoLifecycleManager.rootViewController;
}

- (nullable id<SDLFocusableItemLocatorType>)focusableItemManager {
    return self.videoLifecycleManager.focusableItemManager;
}

- (BOOL)isStreamingSupported {
    // both audio and video lifecycle managers checks the param in Register App Interface response,
    // hence the flag should be same between two managers if they are started
    if (self.videoStarted) {
        return self.videoLifecycleManager.isStreamingSupported;
    } else if (self.audioStarted) {
        return self.audioLifecycleManager.isStreamingSupported;
    }
    return NO;
}

- (BOOL)isAudioConnected {
    return self.audioLifecycleManager.isAudioConnected;
}

- (BOOL)isVideoConnected {
    return self.videoLifecycleManager.isVideoConnected;
}

- (BOOL)isAudioEncrypted {
    return self.audioLifecycleManager.isAudioEncrypted;
}

- (BOOL)isVideoEncrypted {
    return self.videoLifecycleManager.isVideoEncrypted;
}
    
- (BOOL)isVideoStreamingPaused {
    return self.videoLifecycleManager.isVideoStreamingPaused;
}

- (CGSize)screenSize {
    return self.videoLifecycleManager.videoScaleManager.displayViewportResolution;
}

- (nullable SDLVideoStreamingFormat *)videoFormat {
    return self.videoLifecycleManager.videoFormat;
}

- (NSArray<SDLVideoStreamingFormat *> *)supportedFormats {
    return self.videoLifecycleManager.supportedFormats;
}

- (CVPixelBufferPoolRef __nullable)pixelBufferPool {
    return self.videoLifecycleManager.pixelBufferPool;
}

- (SDLStreamingEncryptionFlag)requestedEncryptionType {
    // both audio and video managers should have same type
    return self.videoLifecycleManager.requestedEncryptionType;
}

- (BOOL)showVideoBackgroundDisplay {
    // both audio and video managers should have same type
    return self.videoLifecycleManager.showVideoBackgroundDisplay;
}

#pragma mark - Setters

- (void)setRootViewController:(nullable UIViewController *)rootViewController {
    self.videoLifecycleManager.rootViewController = rootViewController;
}

- (void)setRequestedEncryptionType:(SDLStreamingEncryptionFlag)requestedEncryptionType {
    self.videoLifecycleManager.requestedEncryptionType = requestedEncryptionType;
    self.audioLifecycleManager.requestedEncryptionType = requestedEncryptionType;
}

- (void)setShowVideoBackgroundDisplay:(BOOL)showVideoBackgroundDisplay {
    self.videoLifecycleManager.showVideoBackgroundDisplay = showVideoBackgroundDisplay;
}

@end

NS_ASSUME_NONNULL_END
