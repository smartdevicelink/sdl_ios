//
//  SDLStreamingDataManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/11/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLStreamingMediaManager.h"

@import UIKit;

#import "SDLAbstractProtocol.h"
#import "SDLGlobals.h"


NSString *const SDLErrorDomainStreamingMediaVideo = @"com.sdl.streamingmediamanager.video";
NSString *const SDLErrorDomainStreamingMediaAudio = @"com.sdl.streamingmediamanager.audio";


NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingMediaManager ()

@property (assign, nonatomic) VTCompressionSessionRef compressionSession;

@property (assign, nonatomic) NSUInteger currentFrameNumber;

@property (assign, nonatomic, readwrite) BOOL videoSessionConnected;
@property (assign, nonatomic, readwrite) BOOL audioSessionConnected;

@property (weak, nonatomic) SDLAbstractProtocol *protocol;

@property (copy, nonatomic, nullable) SDLStreamingStartBlock videoStartBlock;
@property (copy, nonatomic, nullable) SDLStreamingStartBlock audioStartBlock;

@end


@implementation SDLStreamingMediaManager

#pragma mark - Class Lifecycle

- (instancetype)initWithProtocol:(SDLAbstractProtocol *)protocol {
    self = [super init];
    if (!self) {
        return nil;
    }

    _compressionSession = NULL;

    _currentFrameNumber = 0;
    _videoSessionConnected = NO;
    _audioSessionConnected = NO;
    _protocol = protocol;

    _videoStartBlock = nil;
    _audioStartBlock = nil;

    return self;
}


#pragma mark - Streaming media lifecycle

- (void)startVideoSessionWithStartBlock:(SDLStreamingStartBlock)startBlock {
    if (SDL_SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        NSAssert(NO, @"SDL Video Sessions can only be run on iOS 8+ devices");
        startBlock(NO, [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLSTreamingVideoErrorInvalidOperatingSystemVersion userInfo:nil]);

        return;
    }


    self.videoStartBlock = [startBlock copy];

    [self.protocol sendStartSessionWithType:SDLServiceType_Video];
}

- (void)stopVideoSession {
    if (!self.videoSessionConnected) {
        return;
    }

    [self.protocol sendEndSessionWithType:SDLServiceType_Video];
}

- (void)startAudioStreamingWithStartBlock:(SDLStreamingStartBlock)startBlock {
    self.audioStartBlock = [startBlock copy];

    [self.protocol sendStartSessionWithType:SDLServiceType_Audio];
}

- (void)stopAudioSession {
    if (!self.audioSessionConnected) {
        return;
    }

    [self.protocol sendEndSessionWithType:SDLServiceType_Audio];
}


#pragma mark - Send media data

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer {
    if (!self.videoSessionConnected) {
        return NO;
    }

    // TODO (Joel F.)[2015-08-17]: Somehow monitor connection to make sure we're not clogging the connection with data.
    OSStatus status = VTCompressionSessionEncodeFrame(_compressionSession, imageBuffer, CMTimeMake(self.currentFrameNumber++, 30), kCMTimeInvalid, NULL, (__bridge void *)self, NULL);

    return (status == noErr);
}

- (BOOL)sendAudioData:(NSData *)pcmAudioData {
    if (!self.audioSessionConnected) {
        return NO;
    }

    dispatch_async([self.class sdl_streamingDataSerialQueue], ^{
        @autoreleasepool {
            [self.protocol sendRawData:pcmAudioData withServiceType:SDLServiceType_Audio];
        }
    });

    return YES;
}


#pragma mark - SDLProtocolListener Methods

- (void)handleProtocolStartSessionACK:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version {
    switch (serviceType) {
        case SDLServiceType_Audio: {
            self.audioSessionConnected = YES;
            self.audioStartBlock(YES, nil);
            self.audioStartBlock = nil;
        } break;
        case SDLServiceType_Video: {
            NSError *error = nil;
            BOOL success = [self sdl_configureVideoEncoderWithError:&error];

            if (!success) {
                [self sdl_teardownCompressionSession];
                self.videoStartBlock(NO, error);
                self.videoStartBlock = nil;

                return;
            }

            self.videoSessionConnected = YES;
            self.videoStartBlock(YES, nil);
            self.videoStartBlock = nil;
        } break;
        default: break;
    }
}

- (void)handleProtocolStartSessionNACK:(SDLServiceType)serviceType {
    switch (serviceType) {
        case SDLServiceType_Audio: {
            NSError *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaAudio code:SDLStreamingAudioErrorHeadUnitNACK userInfo:nil];

            self.audioStartBlock(NO, error);
            self.audioStartBlock = nil;
        } break;
        case SDLServiceType_Video: {
            NSError *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorHeadUnitNACK userInfo:nil];

            self.videoStartBlock(NO, error);
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
    VTCompressionSessionInvalidate(self.compressionSession);
    CFRelease(self.compressionSession);
}


#pragma mark Callbacks

void sdl_videoEncoderOutputCallback(void *outputCallbackRefCon, void *sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CMSampleBufferRef sampleBuffer) {
    // If there was an error in the encoding, drop the frame
    if (status != noErr) {
        NSLog(@"Error encoding video, err=%lld", (int64_t)status);
        return;
    }

    SDLStreamingMediaManager *mediaManager = (__bridge SDLStreamingMediaManager *)sourceFrameRefCon;
    NSData *elementaryStreamData = [mediaManager.class sdl_encodeElementaryStreamWithSampleBuffer:sampleBuffer];
    [mediaManager.protocol sendRawData:elementaryStreamData withServiceType:SDLServiceType_Video];
}


#pragma mark Configuration

- (BOOL)sdl_configureVideoEncoderWithError:(NSError *__autoreleasing *)error {
    OSStatus status;

    // Create a compression session
    // TODO (Joel F.)[2015-08-18]: Dimensions should be from the Head Unit
    status = VTCompressionSessionCreate(NULL, 640, 480, kCMVideoCodecType_H264, NULL, NULL, NULL, &sdl_videoEncoderOutputCallback, (__bridge void *)self, &_compressionSession);

    if (status != noErr) {
        // TODO: Log the error
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorConfigurationCompressionSessionCreationFailure userInfo:@{ @"OSStatus" : @(status) }];
        }

        return NO;
    }

    // Set the bitrate of our video compression
    int bitRate = 5000;
    CFNumberRef bitRateNumRef = CFNumberCreate(NULL, kCFNumberSInt32Type, &bitRate);
    if (bitRateNumRef == NULL) {
        // TODO: Log & end session
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorConfigurationAllocationFailure userInfo:nil];
        }

        return NO;
    }

    status = VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_AverageBitRate, bitRateNumRef);

    // Release our bitrate number
    CFRelease(bitRateNumRef);
    bitRateNumRef = NULL;

    if (status != noErr) {
        // TODO: Log & End session
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{ @"OSStatus" : @(status) }];
        }

        return NO;
    }

    // Set the profile level of the video stream
    status = VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_AutoLevel);
    if (status != noErr) {
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{ @"OSStatus" : @(status) }];
        }

        return NO;
    }

    // Set the session to compress in real time
    status = VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
    if (status != noErr) {
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{ @"OSStatus" : @(status) }];
        }

        return NO;
    }

    // Set the key-frame interval
    // TODO: This may be unnecessary, can the encoder do a better job than us?
    int interval = 50;
    CFNumberRef intervalNumRef = CFNumberCreate(NULL, kCFNumberSInt32Type, &interval);
    if (intervalNumRef == NULL) {
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorConfigurationAllocationFailure userInfo:nil];
        }

        return NO;
    }

    status = VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, intervalNumRef);

    CFRelease(intervalNumRef);
    intervalNumRef = NULL;

    if (status != noErr) {
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainStreamingMediaVideo code:SDLStreamingVideoErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{ @"OSStatus" : @(status) }];
        }

        return NO;
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

    return [elementaryStream copy];
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

@end

NS_ASSUME_NONNULL_END
