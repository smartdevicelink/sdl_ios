//
//  SDLStreamingDataManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/11/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLStreamingMediaManager.h"

#import "SDLStreamingMediaLifecycleManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingMediaManager ()

@property (strong, nonatomic) SDLStreamingMediaLifecycleManager *lifecycleManager;

@end

@implementation SDLStreamingMediaManager

#pragma mark - Public
#pragma mark Lifecycle

- (instancetype)init {
    return [self initWithEncryption:SDLStreamingEncryptionFlagAuthenticateAndEncrypt videoEncoderSettings:nil];
}

- (instancetype)initWithEncryption:(SDLStreamingEncryptionFlag)encryption videoEncoderSettings:(nullable NSDictionary<NSString *, id> *)videoEncoderSettings {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _lifecycleManager = [[SDLStreamingMediaLifecycleManager alloc] initWithEncryption:encryption videoEncoderSettings:videoEncoderSettings];
    

    return self;
}

- (void)startWithProtocol:(SDLAbstractProtocol *)protocol completionHandler:(void (^)(BOOL, NSError * _Nullable))completionHandler {
    [self.lifecycleManager startWithProtocol:protocol completionHandler:completionHandler];
}

- (void)stop {
    [self.lifecycleManager stop];
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer {
    return [self.lifecycleManager sendVideoData:imageBuffer];
}

- (BOOL)sendAudioData:(NSData*)audioData {
    return [self.lifecycleManager sendAudioData:audioData];
}

#pragma mark - Getters
- (SDLTouchManager *)touchManager {
    return self.lifecycleManager.touchManager;
}

- (BOOL)isAudioStreamingSupported {
    return self.lifecycleManager.isAudioStreamingSupported;
}

- (BOOL)isVideoStreamingSupported {
    return self.lifecycleManager.isVideoStreamingSupported;
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

- (CVPixelBufferPoolRef __nullable)pixelBufferPool {
    return self.lifecycleManager.pixelBufferPool;
}

- (SDLStreamingEncryptionFlag)requestedEncryptionType {
    return self.lifecycleManager.requestedEncryptionType;
}

#pragma mark - Setters
- (void)setRequestedEncryptionType:(SDLStreamingEncryptionFlag)requestedEncryptionType {
    self.lifecycleManager.requestedEncryptionType = requestedEncryptionType;
}

@end

NS_ASSUME_NONNULL_END
