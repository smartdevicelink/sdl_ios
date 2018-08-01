//
//  SDLStreamingDataManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/11/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLStreamingMediaManager.h"

#import "SDLAudioStreamManager.h"
#import "SDLConnectionManagerType.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLStreamingMediaManagerDataSource.h"
#import "SDLStreamingAudioLifecycleManager.h"
#import "SDLStreamingVideoLifecycleManager.h"
#import "SDLTouchManager.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingMediaManager ()

@property (strong, nonatomic) SDLStreamingAudioLifecycleManager *audioLifecycleManager;
@property (strong, nonatomic) SDLStreamingVideoLifecycleManager *videoLifecycleManager;

@end


@implementation SDLStreamingMediaManager

#pragma mark - Public
#pragma mark Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLStreamingMediaConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _audioLifecycleManager = [[SDLStreamingAudioLifecycleManager alloc] initWithConnectionManager:connectionManager configuration:configuration];
    _videoLifecycleManager = [[SDLStreamingVideoLifecycleManager alloc] initWithConnectionManager:connectionManager configuration:configuration];

    return self;
}

- (void)startWithProtocol:(SDLProtocol *)protocol {
    [self.audioLifecycleManager startWithProtocol:protocol];
    [self.videoLifecycleManager startWithProtocol:protocol];
}

- (void)stop {
    [self.audioLifecycleManager stop];
    [self.videoLifecycleManager stop];
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer {
    return [self.videoLifecycleManager sendVideoData:imageBuffer];
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer presentationTimestamp:(CMTime)presentationTimestamp {
    return [self.videoLifecycleManager sendVideoData:imageBuffer presentationTimestamp:presentationTimestamp];
}

- (BOOL)sendAudioData:(NSData*)audioData {
    return [self.audioLifecycleManager sendAudioData:audioData];
}


#pragma mark - Getters

- (SDLTouchManager *)touchManager {
    return self.videoLifecycleManager.touchManager;
}

- (SDLAudioStreamManager *)audioManager {
    return self.audioLifecycleManager.audioManager;
}

- (UIViewController *)rootViewController {
    return self.videoLifecycleManager.rootViewController;
}

- (nullable id<SDLFocusableItemLocatorType>)focusableItemManager {
    return self.videoLifecycleManager.focusableItemManager;
}

- (BOOL)isStreamingSupported {
    return self.videoLifecycleManager.isStreamingSupported;
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
    return self.videoLifecycleManager.screenSize;
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
    return self.videoLifecycleManager.requestedEncryptionType;
}

#pragma mark - Setters
- (void)setRootViewController:(UIViewController *)rootViewController {
    self.videoLifecycleManager.rootViewController = rootViewController;
}

- (void)setRequestedEncryptionType:(SDLStreamingEncryptionFlag)requestedEncryptionType {
    self.videoLifecycleManager.requestedEncryptionType = requestedEncryptionType;
    self.audioLifecycleManager.requestedEncryptionType = requestedEncryptionType;
}

@end

NS_ASSUME_NONNULL_END
