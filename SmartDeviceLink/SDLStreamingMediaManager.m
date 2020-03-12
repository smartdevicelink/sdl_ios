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
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLSecondaryTransportManager.h"
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
@property (strong, nonatomic, nullable) SDLProtocol *audioProtocol;
@property (strong, nonatomic, nullable) SDLProtocol *videoProtocol;

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
    self.audioProtocol = nil;
    self.videoProtocol = nil;
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

- (void)startSecondaryTransportWithProtocol:(SDLProtocol *)protocol {
     [self didUpdateFromOldVideoProtocol:nil toNewVideoProtocol:protocol fromOldAudioProtocol:nil toNewAudioProtocol:protocol];
}

- (void)sdl_disconnectSecondaryTransport {
    if (self.secondaryTransportManager == nil) {
        SDLLogV(@"Attempting to disconnect a non-existent secondary transport. Returning.");
        return;
    }

    [self.secondaryTransportManager disconnectSecondaryTransport];
}

# pragma mark SDLStreamingProtocolDelegate

- (void)didUpdateFromOldVideoProtocol:(nullable SDLProtocol *)oldVideoProtocol
                   toNewVideoProtocol:(nullable SDLProtocol *)newVideoProtocol
                 fromOldAudioProtocol:(nullable SDLProtocol *)oldAudioProtocol
                   toNewAudioProtocol:(nullable SDLProtocol *)newAudioProtocol {
    BOOL videoProtocolUpdated = (oldVideoProtocol != newVideoProtocol);
    BOOL audioProtocolUpdated = (oldAudioProtocol != newAudioProtocol);

    if (!videoProtocolUpdated && !audioProtocolUpdated) {
        SDLLogV(@"The video and audio transports did not update.");
        return;
    }

    dispatch_group_t endServiceTask = dispatch_group_create();
    dispatch_group_enter(endServiceTask);
    dispatch_group_enter(endServiceTask);

    __weak typeof(self) weakSelf = self;
    if (oldVideoProtocol != nil) {
        [self.videoLifecycleManager endVideoServiceWithCompletionHandler:^ {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.videoStarted = NO;
            dispatch_group_leave(endServiceTask);
        }];
    } else {
        dispatch_group_leave(endServiceTask);
    }

    if (oldAudioProtocol != nil) {
        __weak typeof(self) weakSelf = self;
        [self.audioLifecycleManager endAudioServiceWithCompletionHandler:^ {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.audioStarted = NO;
            dispatch_group_leave(endServiceTask);
        }];
    } else {
        dispatch_group_leave(endServiceTask);
    }

    dispatch_group_notify(endServiceTask, [SDLGlobals sharedGlobals].sdlProcessingQueue, ^{
        [self sdl_disconnectSecondaryTransport];

        if (oldVideoProtocol != nil) {
            SDLLogV(@"Destroying the video protocol");
            self.videoProtocol = nil;
        }
        if (oldAudioProtocol != nil) {
            SDLLogV(@"Destroying the audio protocol");
            self.audioProtocol = nil;
        }

        [self sdl_startNewProtocolForAudio:newAudioProtocol forVideo:newVideoProtocol];
    });
}

/// Starts the audio and/or video services using the new protocol.
/// @param newAudioProtocol The new audio protocol
/// @param newVideoProtocol The new video protocol
- (void)sdl_startNewProtocolForAudio:(nullable SDLProtocol *)newAudioProtocol forVideo:(nullable SDLProtocol *)newVideoProtocol {
    if (newAudioProtocol != nil) {
        self.audioProtocol = newAudioProtocol;
        [self.audioLifecycleManager startWithProtocol:newAudioProtocol];
        self.audioStarted = YES;
    }
    if (newVideoProtocol != nil) {
        self.videoProtocol = newVideoProtocol;
        [self.videoLifecycleManager startWithProtocol:newVideoProtocol];
        self.videoStarted = YES;
    }
}

- (void)startWithProtocol:(SDLProtocol *)protocol {
    self.audioProtocol = protocol;
    self.videoProtocol = protocol;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self startAudioWithProtocol:protocol];
    [self startVideoWithProtocol:protocol];
#pragma clang diagnostic pop
}

 - (void)startAudioWithProtocol:(SDLProtocol *)protocol {
    self.audioProtocol = protocol;
    [self.audioLifecycleManager startWithProtocol:protocol];
    self.audioStarted = YES;
}

 - (void)startVideoWithProtocol:(SDLProtocol *)protocol {
    self.videoProtocol = protocol;
    [self.videoLifecycleManager startWithProtocol:protocol];
    self.videoStarted = YES;
}


#pragma mark - Getters

- (SDLTouchManager *)touchManager {
    return self.videoLifecycleManager.touchManager;
}

- (SDLAudioStreamManager *)audioManager {
    return self.audioLifecycleManager.audioTranscodingManager;
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
