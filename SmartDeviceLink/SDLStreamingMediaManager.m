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
#import "SDLStreamingMediaLifecycleManager.h"
#import "SDLTouchManager.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingMediaManager ()

@property (strong, nonatomic) SDLStreamingMediaLifecycleManager *lifecycleManager;

@end


@implementation SDLStreamingMediaManager

#pragma mark - Public
#pragma mark Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLStreamingMediaConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _lifecycleManager = [[SDLStreamingMediaLifecycleManager alloc] initWithConnectionManager:connectionManager configuration:configuration];

    return self;
}

- (void)startWithProtocol:(SDLAbstractProtocol *)protocol {
    [self.lifecycleManager startWithProtocol:protocol];
}

- (void)stop {
    [self.lifecycleManager stop];
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer {
    return [self.lifecycleManager sendVideoData:imageBuffer];
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer presentationTimestamp:(CMTime)presentationTimestamp {
    return [self.lifecycleManager sendVideoData:imageBuffer presentationTimestamp:presentationTimestamp];
}

- (BOOL)sendAudioData:(NSData*)audioData {
    return [self.lifecycleManager sendAudioData:audioData];
}


#pragma mark - Getters

- (SDLTouchManager *)touchManager {
    return self.lifecycleManager.touchManager;
}

- (SDLAudioStreamManager *)audioManager {
    return self.lifecycleManager.audioManager;
}

- (UIViewController *)rootViewController {
    return self.lifecycleManager.rootViewController;
}

- (nullable id<SDLFocusableItemLocatorType>)focusableItemManager {
    return self.lifecycleManager.focusableItemManager;
}

- (BOOL)isStreamingSupported {
    return self.lifecycleManager.isStreamingSupported;
}

- (BOOL)isAudioConnected {
    return self.lifecycleManager.isAudioConnected;
}

- (BOOL)isVideoConnected {
    return self.lifecycleManager.isVideoConnected;
}

- (BOOL)isAudioEncrypted {
    return self.lifecycleManager.isAudioEncrypted;
}

- (BOOL)isVideoEncrypted {
    return self.lifecycleManager.isVideoEncrypted;
}
    
- (BOOL)isVideoStreamingPaused {
    return self.lifecycleManager.isVideoStreamingPaused;
}

- (CGSize)screenSize {
    return self.lifecycleManager.screenSize;
}

- (nullable SDLVideoStreamingFormat *)videoFormat {
    return self.lifecycleManager.videoFormat;
}

- (NSArray<SDLVideoStreamingFormat *> *)supportedFormats {
    return self.lifecycleManager.supportedFormats;
}

- (CVPixelBufferPoolRef __nullable)pixelBufferPool {
    return self.lifecycleManager.pixelBufferPool;
}

- (SDLStreamingEncryptionFlag)requestedEncryptionType {
    return self.lifecycleManager.requestedEncryptionType;
}

#pragma mark - Setters
- (void)setRootViewController:(UIViewController *)rootViewController {
    self.lifecycleManager.rootViewController = rootViewController;
}

- (void)setRequestedEncryptionType:(SDLStreamingEncryptionFlag)requestedEncryptionType {
    self.lifecycleManager.requestedEncryptionType = requestedEncryptionType;
}

@end

NS_ASSUME_NONNULL_END
