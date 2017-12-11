//
//  SDLStreamingDataManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/11/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLStreamingMediaManager.h"

#import <UIKit/UIKit.h>

#import "SDLAbstractProtocol.h"
#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadAudioStartServiceAck.h"
#import "SDLControlFramePayloadVideoStartService.h"
#import "SDLControlFramePayloadVideoStartServiceAck.h"
#import "SDLDebugTool.h"
#import "SDLDisplayCapabilities.h"
#import "SDLGlobals.h"
#import "SDLImageResolution.h"
#import "SDLProtocolMessage.h"
#import "SDLScreenParams.h"
#import "SDLTouchManager.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingProtocol.h"


NSString *const SDLErrorDomainStreamingMediaVideo = @"com.sdl.streamingmediamanager.video";
NSString *const SDLErrorDomainStreamingMediaAudio = @"com.sdl.streamingmediamanager.audio";

CGSize const SDLDefaultScreenSize = {800, 480};

NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingMediaManager ()

@property (assign, nonatomic, nullable) VTCompressionSessionRef compressionSession;

@property (assign, nonatomic, nullable) CFDictionaryRef pixelBufferOptions;

@property (assign, nonatomic) NSUInteger currentFrameNumber;

@property (assign, nonatomic, readwrite) BOOL videoSessionConnected;
@property (assign, nonatomic, readwrite) BOOL audioSessionConnected;

@property (assign, nonatomic, readwrite) BOOL videoSessionEncrypted;
@property (assign, nonatomic, readwrite) BOOL audioSessionEncrypted;

@property (weak, nonatomic) SDLAbstractProtocol *protocol;

@property (copy, nonatomic, nullable) SDLStreamingEncryptionStartBlock videoStartBlock;
@property (copy, nonatomic, nullable) SDLStreamingEncryptionStartBlock audioStartBlock;

@property (nonatomic, strong, readwrite) SDLTouchManager *touchManager;

@end


@implementation SDLStreamingMediaManager

#pragma mark - Class Lifecycle

- (instancetype)initWithProtocol:(SDLAbstractProtocol *)protocol displayCapabilities:(SDLDisplayCapabilities *)displayCapabilities {
    self = [self init];
    if (!self) {
        return nil;
    }

    _protocol = protocol;

    _displayCapabilties = displayCapabilities;
    [self sdl_updateScreenSizeFromDisplayCapabilities:displayCapabilities];

    return self;
}

- (instancetype)initWithProtocol:(SDLAbstractProtocol *)protocol {
    self = [self init];
    if (!self) {
        return nil;
    }

    _protocol = protocol;

    return self;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _compressionSession = NULL;

    _currentFrameNumber = 0;
    _videoSessionConnected = NO;
    _audioSessionConnected = NO;
    _videoSessionEncrypted = NO;
    _audioSessionEncrypted = NO;
    _protocol = nil;

    _videoStartBlock = nil;
    _audioStartBlock = nil;

    _screenSize = SDLDefaultScreenSize;
    _videoEncoderSettings = self.defaultVideoEncoderSettings;
    _touchManager = [[SDLTouchManager alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_applicationDidResignActive:) name:UIApplicationWillResignActiveNotification object:nil];

    return self;
}

- (void)dealloc {
    _pixelBufferOptions = nil;
}

#pragma mark - Streaming media lifecycle

- (void)startVideoSessionWithStartBlock:(SDLStreamingStartBlock)startBlock {
    [self startVideoSessionWithHeight:SDLControlFrameInt32NotFound width:SDLControlFrameInt32NotFound startBlock:startBlock];
}

- (void)startVideoSessionWithHeight:(int32_t)height width:(int32_t)width startBlock:(SDLStreamingStartBlock)startBlock {
    [self startVideoSessionWithTLS:SDLEncryptionFlagNone height:height width:width startBlock:^(BOOL success, BOOL encryption, NSError *_Nullable error) {
        startBlock(success, error);
    }];
}

- (void)startVideoSessionWithTLS:(SDLEncryptionFlag)encryptionFlag startBlock:(SDLStreamingEncryptionStartBlock)startBlock {
    [self startVideoSessionWithTLS:encryptionFlag height:SDLControlFrameInt32NotFound width:SDLControlFrameInt32NotFound startBlock:startBlock];
}

- (void)startVideoSessionWithTLS:(SDLEncryptionFlag)encryptionFlag height:(int32_t)height width:(int32_t)width startBlock:(SDLStreamingEncryptionStartBlock)startBlock {
    if (SDL_SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        NSAssert(NO, @"SDL Video Sessions can only be run on iOS 8+ devices");
        startBlock(NO, NO, [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorInvalidOperatingSystemVersion userInfo:nil]);

        return;
    }

    self.videoStartBlock = [startBlock copy];
    self.videoSessionEncrypted = (encryptionFlag == SDLEncryptionFlagAuthenticateAndEncrypt ? YES : NO);

    // H264 RAW is the only currently supported SMM format, so we will use hardcode that in to make sure that future Core's that may have different defaults still use our default.
    SDLControlFramePayloadVideoStartService *payload = [[SDLControlFramePayloadVideoStartService alloc] initWithVideoHeight:height width:width protocol:[SDLVideoStreamingProtocol RAW] codec:[SDLVideoStreamingCodec H264]];
    if (encryptionFlag != SDLEncryptionFlagNone) {
        __weak typeof(self) weakSelf = self;
        [self.protocol startSecureServiceWithType:SDLServiceType_Video payload:payload.data completionHandler:^(BOOL success, NSError *error) {
            typeof(weakSelf) strongSelf = weakSelf;
            // If success, we will get an ACK or NACK, so those methods will handle calling the video block
            if (!success) {
                if (strongSelf.videoStartBlock == nil) {
                    return;
                }

                strongSelf.videoStartBlock(NO, NO, error);
                strongSelf.videoStartBlock = nil;
            }
        }];
    } else {
        [self.protocol startServiceWithType:SDLServiceType_Video payload:payload.data];
    }
}

- (void)stopVideoSession {
    if (!self.videoSessionConnected) {
        return;
    }

    [self.protocol endServiceWithType:SDLServiceType_Video];
}

- (void)startAudioSessionWithStartBlock:(SDLStreamingStartBlock)startBlock {
    [self startAudioSessionWithTLS:SDLEncryptionFlagNone
                        startBlock:^(BOOL success, BOOL encryption, NSError *_Nullable error) {
                            startBlock(success, error);
                        }];
}

- (void)startAudioSessionWithTLS:(SDLEncryptionFlag)encryptionFlag startBlock:(SDLStreamingEncryptionStartBlock)startBlock {
    self.audioStartBlock = [startBlock copy];
    self.audioSessionEncrypted = (encryptionFlag == SDLEncryptionFlagAuthenticateAndEncrypt ? YES : NO);

    if (encryptionFlag != SDLEncryptionFlagNone) {
        __weak typeof(self) weakSelf = self;
        [self.protocol startSecureServiceWithType:SDLServiceType_Audio payload:nil
                                completionHandler:^(BOOL success, NSError *error) {
                                    typeof(weakSelf) strongSelf = weakSelf;
                                    // If this passes, we will get an ACK or NACK, so those methods will handle calling the audio block
                                    if (!success) {
                                        if (strongSelf.audioStartBlock == nil) {
                                            return;
                                        }

                                        strongSelf.audioStartBlock(NO, NO, error);
                                        strongSelf.audioStartBlock = nil;
                                    }
                                }];
    } else {
        [self.protocol startServiceWithType:SDLServiceType_Audio payload:nil];
    }
}

- (void)stopAudioSession {
    if (!self.audioSessionConnected) {
        return;
    }

    [self.protocol endServiceWithType:SDLServiceType_Audio];
}


#pragma mark - Send media data

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer {
    if (!self.videoSessionConnected) {
        return NO;
    }

    // TODO (Joel F.)[2015-08-17]: Somehow monitor connection to make sure we're not clogging the connection with data.
    // This will come out in -[self sdl_videoEncoderOutputCallback]
    OSStatus status = VTCompressionSessionEncodeFrame(_compressionSession, imageBuffer, CMTimeMake(self.currentFrameNumber++, 30), kCMTimeInvalid, NULL, (__bridge void *)self, NULL);

    return (status == noErr);
}

- (BOOL)sendAudioData:(NSData *)pcmAudioData {
    if (!self.audioSessionConnected) {
        return NO;
    }

    dispatch_async([self.class sdl_streamingDataSerialQueue], ^{
        @autoreleasepool {
            if (self.audioSessionEncrypted) {
                [self.protocol sendEncryptedRawData:pcmAudioData onService:SDLServiceType_Audio];
            } else {
                [self.protocol sendRawData:pcmAudioData withServiceType:SDLServiceType_Audio];
            }
        }
    });

    return YES;
}

#pragma mark - Update video encoder

- (void)setVideoEncoderSettings:(NSDictionary *_Nullable)videoEncoderSettings {
    if (self.videoSessionConnected) {
        @throw [NSException exceptionWithName:SDLErrorDomainStreamingMediaVideo reason:@"Cannot update video encoder settings while video session is connected." userInfo:nil];
        return;
    }

    if (videoEncoderSettings) {
        _videoEncoderSettings = videoEncoderSettings;
    } else {
        _videoEncoderSettings = self.defaultVideoEncoderSettings;
    }
}

- (void)setDisplayCapabilties:(SDLDisplayCapabilities *_Nullable)displayCapabilties {
    if (self.videoSessionConnected) {
        @throw [NSException exceptionWithName:SDLErrorDomainStreamingMediaVideo reason:@"Cannot update video encoder settings while video session is connected." userInfo:nil];
        return;
    }

    _displayCapabilties = displayCapabilties;
    [self sdl_updateScreenSizeFromDisplayCapabilities:displayCapabilties];
}

- (NSDictionary *)defaultVideoEncoderSettings {
    static NSDictionary *defaultVideoEncoderSettings = nil;
    if (defaultVideoEncoderSettings == nil) {
        defaultVideoEncoderSettings = @{
            (__bridge NSString *)kVTCompressionPropertyKey_ProfileLevel: (__bridge NSString *)kVTProfileLevel_H264_Baseline_AutoLevel,
            (__bridge NSString *)kVTCompressionPropertyKey_RealTime: @YES
        };
    }
    return defaultVideoEncoderSettings;
}

- (CVPixelBufferPoolRef _Nullable)pixelBufferPool {
    return VTCompressionSessionGetPixelBufferPool(self.compressionSession);
}

#pragma mark - SDLProtocolListener Methods

#pragma mark Protocol Ack

- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    switch (startServiceACK.header.serviceType) {
        case SDLServiceType_Audio: {
            [self sdl_handleAudioStartServiceAck:startServiceACK];
        } break;
        case SDLServiceType_Video: {
            [self sdl_handleVideoStartServiceAck:startServiceACK];
        } break;
        default: break;
    }
}

- (void)sdl_handleAudioStartServiceAck:(SDLProtocolMessage *)audioStartAck {
    SDLControlFramePayloadAudioStartServiceAck *audioAckPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithData:audioStartAck.payload];

    if (audioAckPayload.mtu != SDLControlFrameInt64NotFound) {
        [[SDLGlobals globals] setDynamicMTUSize:audioAckPayload.mtu forServiceType:SDLServiceType_Audio];
    }

    self.audioSessionConnected = YES;
    self.audioSessionEncrypted = audioStartAck.header.encrypted;

    if (self.audioStartBlock == nil) {
        return;
    }

    self.audioStartBlock(YES, audioStartAck.header.encrypted, nil);
    self.audioStartBlock = nil;
}

- (void)sdl_handleVideoStartServiceAck:(SDLProtocolMessage *)videoStartAck {
    SDLControlFramePayloadVideoStartServiceAck *videoAckPayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithData:videoStartAck.payload];

    if (videoAckPayload.mtu != SDLControlFrameInt64NotFound) {
        [[SDLGlobals globals] setDynamicMTUSize:videoAckPayload.mtu forServiceType:SDLServiceType_Video];
    }

    if (videoAckPayload.height != SDLControlFrameInt32NotFound && videoAckPayload.width != SDLControlFrameInt32NotFound) {
        _screenSize = CGSizeMake(videoAckPayload.width, videoAckPayload.height);
    }

    NSError *error = nil;
    BOOL success = [self sdl_configureVideoEncoderWithError:&error];

    if (!success) {
        [self sdl_teardownCompressionSession];
        [self.protocol endServiceWithType:SDLServiceType_Video];

        if (self.videoStartBlock == nil) {
            return;
        }

        self.videoStartBlock(NO, videoStartAck.header.encrypted, error);
        self.videoStartBlock = nil;

        return;
    }

    self.videoSessionConnected = YES;
    self.videoSessionEncrypted = videoStartAck.header.encrypted;

    if (self.videoStartBlock == nil) {
        return;
    }

    self.videoStartBlock(YES, videoStartAck.header.encrypted, nil);
    self.videoStartBlock = nil;
}

- (void)handleProtocolStartSessionNACK:(SDLServiceType)serviceType {
    switch (serviceType) {
        case SDLServiceType_Audio: {
            NSError *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaAudio code:SDLStreamingAudioErrorHeadUnitNACK userInfo:nil];

            if (self.audioStartBlock == nil) {
                return;
            }

            self.audioStartBlock(NO, NO, error);
            self.audioStartBlock = nil;
        } break;
        case SDLServiceType_Video: {
            NSError *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorHeadUnitNACK userInfo:nil];

            if (self.videoStartBlock == nil) {
                return;
            }

            self.videoStartBlock(NO, NO, error);
            self.videoStartBlock = nil;
        } break;
        default: break;
    }
}

- (void)handleProtocolEndSessionACK:(SDLServiceType)serviceType {
    switch (serviceType) {
        case SDLServiceType_Audio: {
            self.audioSessionConnected = NO;
        } break;
        case SDLServiceType_Video: {
            self.videoSessionConnected = NO;
            [self sdl_teardownCompressionSession];
        } break;
        default: break;
    }
}

- (void)handleProtocolEndSessionNACK:(SDLServiceType)serviceType {
    // TODO (Joel F.)[2015-08-17]: This really, really shouldn't ever happen. Should we assert? Do nothing? We don't have any additional info on why this failed.
}


#pragma mark - Video Encoding

#pragma mark Lifecycle

- (void)sdl_teardownCompressionSession {
    if (self.compressionSession != NULL) {
        VTCompressionSessionInvalidate(self.compressionSession);
        CFRelease(self.compressionSession);
        self.compressionSession = NULL;
    }
}


#pragma mark Callbacks

void sdl_videoEncoderOutputCallback(void *CM_NULLABLE outputCallbackRefCon, void *CM_NULLABLE sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CM_NULLABLE CMSampleBufferRef sampleBuffer) {
    // If there was an error in the encoding, drop the frame
    if (status != noErr) {
        [SDLDebugTool logFormat:@"Error encoding video, err=%lld", (int64_t)status];
        return;
    }

    if (outputCallbackRefCon == NULL || sourceFrameRefCon == NULL || sampleBuffer == NULL) {
        return;
    }

    SDLStreamingMediaManager *mediaManager = (__bridge SDLStreamingMediaManager *)sourceFrameRefCon;
    NSData *elementaryStreamData = [mediaManager.class sdl_encodeElementaryStreamWithSampleBuffer:sampleBuffer];

    if (mediaManager.videoSessionEncrypted) {
        [mediaManager.protocol sendEncryptedRawData:elementaryStreamData onService:SDLServiceType_Video];
    } else {
        [mediaManager.protocol sendRawData:elementaryStreamData withServiceType:SDLServiceType_Video];
    }
}


#pragma mark Configuration

- (BOOL)sdl_configureVideoEncoderWithError:(NSError *__autoreleasing *)error {
    OSStatus status;

    // Create a compression session
    status = VTCompressionSessionCreate(NULL, self.screenSize.width, self.screenSize.height, kCMVideoCodecType_H264, NULL, self.pixelBufferOptions, NULL, &sdl_videoEncoderOutputCallback, (__bridge void *)self, &_compressionSession);

    if (status != noErr) {
        // TODO: Log the error
        if (error != NULL) {
            *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorConfigurationCompressionSessionCreationFailure userInfo:@{ @"OSStatus": @(status) }];
        }

        return NO;
    }

    CFRelease(self.pixelBufferOptions);
    _pixelBufferOptions = nil;

    // Validate that the video encoder properties are valid.
    CFDictionaryRef supportedProperties;
    status = VTSessionCopySupportedPropertyDictionary(self.compressionSession, &supportedProperties);
    if (status != noErr) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{ @"OSStatus": @(status) }];
        }

        return NO;
    }

    for (NSString *key in self.videoEncoderSettings.allKeys) {
        if (CFDictionaryContainsKey(supportedProperties, (__bridge CFStringRef)key) == false) {
            if (error != NULL) {
                NSString *description = [NSString stringWithFormat:@"\"%@\" is not a supported key.", key];
                *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{NSLocalizedDescriptionKey: description}];
            }
            CFRelease(supportedProperties);
            return NO;
        }
    }
    CFRelease(supportedProperties);

    // Populate the video encoder settings from provided dictionary.
    for (NSString *key in self.videoEncoderSettings.allKeys) {
        id value = self.videoEncoderSettings[key];

        status = VTSessionSetProperty(self.compressionSession, (__bridge CFStringRef)key, (__bridge CFTypeRef)value);
        if (status != noErr) {
            if (error != NULL) {
                *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{ @"OSStatus": @(status) }];
            }

            return NO;
        }
    }

    return YES;
}

#pragma mark Elementary Stream Formatting

+ (NSData *)sdl_encodeElementaryStreamWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    // Creating an elementaryStream: http://stackoverflow.com/questions/28396622/extracting-h264-from-cmblockbuffer

    NSMutableData *elementaryStream = [NSMutableData data];
    BOOL isIFrame = NO;
    CFArrayRef attachmentsArray = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, 0);

    if (CFArrayGetCount(attachmentsArray)) {
        CFBooleanRef notSync;
        CFDictionaryRef dict = CFArrayGetValueAtIndex(attachmentsArray, 0);
        BOOL keyExists = CFDictionaryGetValueIfPresent(dict,
                                                       kCMSampleAttachmentKey_NotSync,
                                                       (const void **)&notSync);

        // Find out if the sample buffer contains an I-Frame (sync frame). If so we will write the SPS and PPS NAL units to the elementary stream.
        isIFrame = !keyExists || !CFBooleanGetValue(notSync);
    }

    // This is the start code that we will write to the elementary stream before every NAL unit
    static const size_t startCodeLength = 4;
    static const uint8_t startCode[] = {0x00, 0x00, 0x00, 0x01};

    // Write the SPS and PPS NAL units to the elementary stream before every I-Frame
    if (isIFrame) {
        CMFormatDescriptionRef description = CMSampleBufferGetFormatDescription(sampleBuffer);

        // Find out how many parameter sets there are
        size_t numberOfParameterSets;
        CMVideoFormatDescriptionGetH264ParameterSetAtIndex(description,
                                                           0,
                                                           NULL,
                                                           NULL,
                                                           &numberOfParameterSets,
                                                           NULL);

        // Write each parameter set to the elementary stream
        for (int i = 0; i < numberOfParameterSets; i++) {
            const uint8_t *parameterSetPointer;
            size_t parameterSetLength;
            CMVideoFormatDescriptionGetH264ParameterSetAtIndex(description,
                                                               i,
                                                               &parameterSetPointer,
                                                               &parameterSetLength,
                                                               NULL,
                                                               NULL);

            // Write the parameter set to the elementary stream
            [elementaryStream appendBytes:startCode length:startCodeLength];
            [elementaryStream appendBytes:parameterSetPointer length:parameterSetLength];
        }
    }

    // Get a pointer to the raw AVCC NAL unit data in the sample buffer
    size_t blockBufferLength = 0;
    char *bufferDataPointer = NULL;
    CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBuffer);

    CMBlockBufferGetDataPointer(blockBufferRef, 0, NULL, &blockBufferLength, &bufferDataPointer);

    // Loop through all the NAL units in the block buffer and write them to the elementary stream with start codes instead of AVCC length headers
    size_t bufferOffset = 0;
    static const int AVCCHeaderLength = 4;
    while (bufferOffset < blockBufferLength - AVCCHeaderLength) {
        // Read the NAL unit length
        uint32_t NALUnitLength = 0;
        memcpy(&NALUnitLength, bufferDataPointer + bufferOffset, AVCCHeaderLength);

        // Convert the length value from Big-endian to Little-endian
        NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
        [elementaryStream appendBytes:startCode length:startCodeLength];

        // Write the NAL unit without the AVCC length header to the elementary stream
        [elementaryStream appendBytes:bufferDataPointer + bufferOffset + AVCCHeaderLength length:NALUnitLength];

        // Move to the next NAL unit in the block buffer
        bufferOffset += AVCCHeaderLength + NALUnitLength;
    }


    return elementaryStream;
}

#pragma mark - Private static singleton variables

+ (dispatch_queue_t)sdl_streamingDataSerialQueue {
    static dispatch_queue_t streamingDataQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamingDataQueue = dispatch_queue_create("com.sdl.videoaudiostreaming.encoder", DISPATCH_QUEUE_SERIAL);
    });

    return streamingDataQueue;
}

- (CFDictionaryRef _Nullable)pixelBufferOptions {
    if (_pixelBufferOptions == nil) {
        CFMutableDictionaryRef pixelBufferOptions = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

        OSType pixelFormatType = kCVPixelFormatType_32BGRA;

        CFNumberRef pixelFormatNumberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &pixelFormatType);

        CFDictionarySetValue(pixelBufferOptions, kCVPixelBufferCGImageCompatibilityKey, kCFBooleanFalse);
        CFDictionarySetValue(pixelBufferOptions, kCVPixelBufferCGBitmapContextCompatibilityKey, kCFBooleanFalse);
        CFDictionarySetValue(pixelBufferOptions, kCVPixelBufferPixelFormatTypeKey, pixelFormatNumberRef);

        CFRelease(pixelFormatNumberRef);

        _pixelBufferOptions = pixelBufferOptions;
    }
    return _pixelBufferOptions;
}

#pragma mark - Private Functions

- (void)sdl_applicationDidEnterBackground:(NSNotification *)notification {
    [self.touchManager cancelPendingTouches];
}

- (void)sdl_applicationDidResignActive:(NSNotification *)notification {
    [self.touchManager cancelPendingTouches];
}

- (void)sdl_updateScreenSizeFromDisplayCapabilities:(SDLDisplayCapabilities *)displayCapabilities {
    if (displayCapabilities.graphicSupported.boolValue == false) {
        [SDLDebugTool logInfo:@"Graphics are not supported. We are assuming screen size is also unavailable"];
        return;
    }
    SDLImageResolution *resolution = displayCapabilities.screenParams.resolution;
    if (resolution != nil) {
        _screenSize = CGSizeMake(resolution.resolutionWidth.floatValue,
                                 resolution.resolutionHeight.floatValue);
    } else {
        _screenSize = SDLDefaultScreenSize;
    }
    _pixelBufferOptions = nil;
}

@end

NS_ASSUME_NONNULL_END
