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
#import "SDLLogMacros.h"
#import "SDLStreamingAudioLifecycleManager.h"
#import "SDLStreamingProtocolDelegate.h"
#import "SDLStreamingVideoLifecycleManager.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLTouchManager.h"



NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingMediaManager () <SDLStreamingProtocolDelegate>

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

- (void)stop {
    [self stopAudio];
    [self stopVideo];
}

#pragma mark Audio

- (void)stopAudio {
    [self.audioLifecycleManager stop];
    self.audioStarted = NO;
}

- (BOOL)sendAudioData:(NSData*)audioData {
    return [self.audioLifecycleManager sendAudioData:audioData];
}

#pragma mark Video

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

- (void)startSecondaryTransportOnProtocol:(SDLProtocol *)protocol {
     [self streamingServiceProtocolDidUpdateFromOldVideoProtocol:nil toNewVideoProtocol:protocol fromOldAudioProtocol:nil toNewAudioProtocol:protocol];
}

#pragma mark Video

/// Stops the video feature of the manager on the secondary transport.
/// @param completionHandler Called when video has stopped.
- (void)sdl_stopVideoWithCompletionHandler:(void(^)(void))completionHandler {
    __weak typeof(self) weakSelf = self;
    [self.videoLifecycleManager endVideoServiceWithCompletionHandler:^() {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.videoStarted = NO;
        return completionHandler();
    }];
}

- (void)sdl_destroyVideoProtocol {
    [self.videoLifecycleManager destroyProtocol];
}

#pragma mark Audio

/// Stops the audio feature of the manager on the secondary transport.
/// @param completionHandler Called when audio has stopped.
- (void)sdl_stopAudioWithCompletionHandler:(void(^)(void))completionHandler {
    __weak typeof(self) weakSelf = self;
    [self.audioLifecycleManager endAudioServiceWithCompletionHandler:^ {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.audioStarted = NO;
        return completionHandler();
    }];
}

- (void)sdl_destroyAudioProtocol {
    [self.audioLifecycleManager destroyProtocol];
}

# pragma mark SDLStreamingProtocolDelegate

- (void)streamingServiceProtocolDidUpdateFromOldVideoProtocol:(nullable SDLProtocol *)oldVideoProtocol toNewVideoProtocol:(nullable SDLProtocol *)newVideoProtocol fromOldAudioProtocol:(nullable SDLProtocol *)oldAudioProtocol toNewAudioProtocol:(nullable SDLProtocol *)newAudioProtocol {

    BOOL videoProtocolUpdated = oldVideoProtocol != newVideoProtocol;
    BOOL audioProtocolUpdated = oldAudioProtocol != newAudioProtocol;

    if (!videoProtocolUpdated && !audioProtocolUpdated) {
        SDLLogV(@"The video and audio protocols did not update. Nothing will update.");
        return;
    }

    if (oldVideoProtocol != nil && oldAudioProtocol != nil) {
        // Both an audio and video service are currently running. Make sure *BOTH* audio and video services have been stopped before destroying the secondary transport. Once the secondary transport has been destroyed, start the audio/video services using the new protocol.
         __weak typeof(self) weakSelf = self;
        [self sdl_stopAudioWithCompletionHandler:^ {
        __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf sdl_stopVideoWithCompletionHandler:^ {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf.secondaryTransportDelegate != nil) {
                    [strongSelf.secondaryTransportDelegate destroySecondaryTransport];
                }
                [strongSelf sdl_destroyAudioProtocol];
                [strongSelf sdl_destroyVideoProtocol];
                [strongSelf sdl_startNewProtocolForAudio:newAudioProtocol forVideo:newVideoProtocol];
            }];
        }];
    } else if (oldVideoProtocol != nil) {
        // Only a video service is running. Make sure the video service has stopped before destroying the secondary transport and starting the new audio/video services using the new protocol.
         __weak typeof(self) weakSelf = self;
        [self sdl_stopVideoWithCompletionHandler:^ {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.secondaryTransportDelegate != nil) {
                [strongSelf.secondaryTransportDelegate destroySecondaryTransport];
            }
            [strongSelf sdl_destroyVideoProtocol];
            [strongSelf sdl_startNewProtocolForAudio:newAudioProtocol forVideo:newVideoProtocol];
        }];
    } else if (oldAudioProtocol != nil) {
        // Only an audio service is running. Make sure the audio service has stopped before destroying the secondary transport and starting the new audio/video services using the new protocol.
         __weak typeof(self) weakSelf = self;
        [self sdl_stopAudioWithCompletionHandler:^ {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.secondaryTransportDelegate != nil) {
                [strongSelf.secondaryTransportDelegate destroySecondaryTransport];
            }
            [strongSelf sdl_destroyAudioProtocol];
            [strongSelf sdl_startNewProtocolForAudio:newAudioProtocol forVideo:newVideoProtocol];
        }];
    } else {
        // No audio and/or video service currently running. Just start the new audio and/or video services.
        [self sdl_startNewProtocolForAudio:newAudioProtocol forVideo:newVideoProtocol];
    }
}

/// Starts the audio and/or video services using the new protocol.
/// @param newAudioProtocol The new audio protocol
/// @param newVideoProtocol The new video protocol
- (void)sdl_startNewProtocolForAudio:(nullable SDLProtocol *)newAudioProtocol forVideo:(nullable SDLProtocol *)newVideoProtocol {
    if (newAudioProtocol != nil) {
        [self.audioLifecycleManager startWithProtocol:newAudioProtocol];
        self.audioStarted = YES;
    }
    if (newVideoProtocol != nil) {
        [self.videoLifecycleManager startWithProtocol:newVideoProtocol];
        self.videoStarted = YES;
    }
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
