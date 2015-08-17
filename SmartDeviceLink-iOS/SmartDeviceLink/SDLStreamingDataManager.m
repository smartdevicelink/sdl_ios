//
//  SDLStreamingDataManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/11/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLStreamingDataManager.h"

#import "SDLAbstractProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingDataManager ()

@property (assign, nonatomic) BOOL videoSessionConnected;
@property (assign, nonatomic) BOOL audioSessionConnected;

@property (weak, nonatomic) SDLAbstractProtocol *protocol;

@property (copy, nonatomic) SDLStreamingLifecycleBlock startBlock;

@end


@implementation SDLStreamingDataManager

- (instancetype)initWithProtocol:(SDLAbstractProtocol *)protocol {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _videoSessionConnected = NO;
    _audioSessionConnected = NO;
    _protocol = protocol;
    
    return self;
}

- (void)startVideoSessionWithStartBlock:(SDLStreamingLifecycleBlock)startBlock {
    self.startBlock = [startBlock copy];
    
    [self.protocol sendStartSessionWithType:SDLServiceType_Video];
}

- (void)startAudioStreamingWithStartBlock:(SDLStreamingLifecycleBlock)startBlock {
    self.startBlock = [startBlock copy];
    
    [self.protocol sendStartSessionWithType:SDLServiceType_Audio];
}

- (void)stopVideoSession {
    [self.protocol sendEndSessionWithType:SDLServiceType_Video];
}

- (void)stopAudioSession {
    [self.protocol sendEndSessionWithType:SDLServiceType_Audio];
}

- (void)sendVideoData:(CMSampleBufferRef)bufferRef {
    if (!self.videoSessionConnected) {
        return;
    }
    
    dispatch_async([self.class sdl_streamingDataSerialQueue], ^{
        NSData *elementaryStreamData = [self.class sdl_encodeElementaryStreamWithBufferRef:bufferRef];
        [self.protocol sendRawData:elementaryStreamData withServiceType:SDLServiceType_Video];
    });
}

- (void)sendAudioData:(NSData *)pcmData {
    if (!self.audioSessionConnected) {
        return;
    }
    
    dispatch_async([self.class sdl_streamingDataSerialQueue], ^{
        [self.protocol sendRawData:pcmData withServiceType:SDLServiceType_Audio];
    });
}


#pragma mark - SDLProtocolListener Methods

- (void)handleProtocolStartSessionACK:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version {
    switch (serviceType) {
        case SDLServiceType_Audio: {
            self.audioSessionConnected = YES;
            self.startBlock(YES);
            
        } break;
        case SDLServiceType_Video: {
            self.videoSessionConnected = YES;
            self.startBlock(YES);
        } break;
        default: break;
    }
}

- (void)handleProtocolStartSessionNACK:(SDLServiceType)serviceType {
    switch (serviceType) {
        case SDLServiceType_Audio: {
            self.startBlock(NO);
        } break;
        case SDLServiceType_Video: {
            self.startBlock(NO);
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
        } break;
        default: break;
    }
}

- (void)handleProtocolEndSessionNACK:(SDLServiceType)serviceType {
    
}


#pragma mark - Encoding

+ (NSData *)sdl_encodeElementaryStreamWithBufferRef:(CMSampleBufferRef)bufferRef {
    NSMutableData *elementaryStream = [NSMutableData data];
    
    
    // Find out if the sample buffer contains an I-Frame.
    // If so we will write the SPS and PPS NAL units to the elementary stream.
    BOOL isIFrame = NO;
    CFArrayRef attachmentsArray = CMSampleBufferGetSampleAttachmentsArray(bufferRef, 0);
    if (CFArrayGetCount(attachmentsArray)) {
        CFBooleanRef notSync;
        CFDictionaryRef dict = CFArrayGetValueAtIndex(attachmentsArray, 0);
        BOOL keyExists = CFDictionaryGetValueIfPresent(dict,
                                                       kCMSampleAttachmentKey_NotSync,
                                                       (const void **)&notSync);
        // An I-Frame is a sync frame
        isIFrame = !keyExists || !CFBooleanGetValue(notSync);
    }
    
    // This is the start code that we will write to the elementary stream before every NAL unit
    static const size_t startCodeLength = 4;
    static const uint8_t startCode[] = {0x00, 0x00, 0x00, 0x01};
    
    // Write the SPS and PPS NAL units to the elementary stream before every I-Frame
    if (isIFrame) {
        CMFormatDescriptionRef description = CMSampleBufferGetFormatDescription(bufferRef);
        
        // Find out how many parameter sets there are
        size_t numberOfParameterSets;
        CMVideoFormatDescriptionGetH264ParameterSetAtIndex(description,
                                                           0, NULL, NULL,
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
                                                               NULL, NULL);
            
            // Write the parameter set to the elementary stream
            [elementaryStream appendBytes:startCode length:startCodeLength];
            [elementaryStream appendBytes:parameterSetPointer length:parameterSetLength];
        }
    }
    
    // Get a pointer to the raw AVCC NAL unit data in the sample buffer
    size_t blockBufferLength = 0;
    uint8_t *bufferDataPointer = NULL;
    CMBlockBufferGetDataPointer(CMSampleBufferGetDataBuffer(bufferRef),
                                0,
                                NULL,
                                &blockBufferLength,
                                (char **)&bufferDataPointer);
    
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
