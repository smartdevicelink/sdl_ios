//
//  SDLH264VideoEncoder
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 12/5/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLH264VideoEncoder.h"

#import "SDLLogMacros.h"
#import "SDLRAWH264Packetizer.h"
#import "SDLRTPH264Packetizer.h"


NS_ASSUME_NONNULL_BEGIN

NSString *const SDLErrorDomainVideoEncoder = @"com.sdl.videoEncoder";
static NSDictionary<NSString *, id>* _defaultVideoEncoderSettings;


@interface SDLH264VideoEncoder ()

@property (assign, nonatomic, nullable) VTCompressionSessionRef compressionSession;
@property (assign, nonatomic, nullable) CFDictionaryRef pixelBufferOptions;
@property (assign, nonatomic) NSUInteger currentFrameNumber;
@property (assign, nonatomic) double timestampOffset;

@property (assign, nonatomic, readwrite) CVPixelBufferPoolRef CV_NULLABLE pixelBufferPool;

/// Width and height of the video frame.
@property (assign, nonatomic) CGSize dimensions;

@end


@implementation SDLH264VideoEncoder

+ (void)initialize {
    if (self != [SDLH264VideoEncoder class]) {
        return;
    }

    // https://support.google.com/youtube/answer/1722171?hl=en
    _defaultVideoEncoderSettings = @{
                                     (__bridge NSString *)kVTCompressionPropertyKey_ProfileLevel: (__bridge NSString *)kVTProfileLevel_H264_Baseline_AutoLevel,
                                     (__bridge NSString *)kVTCompressionPropertyKey_RealTime: @YES,
                                     (__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate: @15,
                                     (__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate: @600000,
                                     };
}

- (instancetype)initWithProtocol:(SDLVideoStreamingProtocol)protocol dimensions:(CGSize)dimensions ssrc:(UInt32)ssrc properties:(NSDictionary<NSString *, id> *)properties delegate:(id<SDLVideoEncoderDelegate> __nullable)delegate error:(NSError **)error {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _compressionSession = NULL;
    _currentFrameNumber = 0;
    _videoEncoderSettings = properties;
    _dimensions = dimensions;
    _delegate = delegate;

    BOOL compressionSessionCreated = [self sdl_createCompressionSessionWithError:error];
    if (!compressionSessionCreated) {
        return nil;
    }

    BOOL videoEncoderPropertiesValid = [self sdl_validateVideoEncoderPropertiesOnCompressionSession:self.compressionSession withError:error];
    if (!videoEncoderPropertiesValid) {
        return nil;
    }

    BOOL propertiesSetOnCompressionSession = [self sdl_setPropertiesOnCompressionSession:self.compressionSession withError:error];
    if (!propertiesSetOnCompressionSession) {
        return nil;
    }

    if ([protocol isEqualToEnum:SDLVideoStreamingProtocolRAW]) {
        _packetizer = [[SDLRAWH264Packetizer alloc] init];
    } else if ([protocol isEqualToEnum:SDLVideoStreamingProtocolRTP]) {
        _packetizer = [[SDLRTPH264Packetizer alloc] initWithSSRC:ssrc];
    } else {
        if (error != NULL) {
            *error = [NSError errorWithDomain:SDLErrorDomainVideoEncoder code:SDLVideoEncoderErrorProtocolUnknown userInfo:@{@"encoder": protocol}];
        }
        return nil;
    }

    return self;
}

- (void)stop {
    _currentFrameNumber = 0;
    _timestampOffset = 0.0;

    CFRelease(_pixelBufferOptions);
    _pixelBufferOptions = nil;

    [self sdl_invalidateCompressionSession];
}

- (BOOL)encodeFrame:(CVImageBufferRef)imageBuffer {
    return [self encodeFrame:imageBuffer presentationTimestamp:kCMTimeInvalid];
}

- (BOOL)encodeFrame:(CVImageBufferRef)imageBuffer presentationTimestamp:(CMTime)presentationTimestamp {
    if (!CMTIME_IS_VALID(presentationTimestamp)) {
        int32_t timeRate = 30;
        if (self.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate] != nil) {
            timeRate = ((NSNumber *)self.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate]).intValue;
        }
        
        presentationTimestamp = CMTimeMake((int64_t)self.currentFrameNumber, timeRate);
    }
    self.currentFrameNumber++;

    OSStatus status = VTCompressionSessionEncodeFrame(_compressionSession, imageBuffer, presentationTimestamp, kCMTimeInvalid, NULL, (__bridge void *)self, NULL);

    // HAX: [#1620](https://github.com/smartdevicelink/sdl_ios/issues/1620) On some older iPhones VTCompressionSessionEncodeFrame fails with a kVTInvalidSessionErr when the device is locked. Attempt to fix this by recreating the compression session.
    if (status == kVTInvalidSessionErr) {
        [self sdl_resetCompressionSession];
    }

    return (status == noErr);
}

- (CVPixelBufferRef CV_NULLABLE)newPixelBuffer {
    if (self.pixelBufferPool == NULL) {
        return NULL;
    }
    
    CVPixelBufferRef pixelBuffer;
    CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault,
                                       self.pixelBufferPool,
                                       &pixelBuffer);

    return pixelBuffer;
}

#pragma mark - Public
#pragma mark Getters
+ (NSDictionary<NSString *, id> *)defaultVideoEncoderSettings {
    return _defaultVideoEncoderSettings;
}

- (CVPixelBufferPoolRef CV_NULLABLE)pixelBufferPool {
    // HAX: When the app is backgrounded, sometimes the compression session gets invalidated (this can happen the first time the app is backgrounded or the tenth). This causes the pool and/or the compression session to fail when the app is foregrounded and video frames are sent again. Attempt to fix this by recreating the compression session.
    if (_pixelBufferPool == NULL) {
        BOOL success = [self sdl_resetCompressionSession];
        if (!success) {
            return NULL;
        }

        _pixelBufferPool = VTCompressionSessionGetPixelBufferPool(self.compressionSession);
    }

    return _pixelBufferPool;
}

#pragma mark - Private
#pragma mark Callback

/// Callback function that VideoToolbox calls when encoding is complete.
/// @param outputCallbackRefCon The callback's reference value
/// @param sourceFrameRefCon The frame's reference value
/// @param status Returns `noErr` if compression was successful, or an error if not successful
/// @param infoFlags Information about the encode operation (frame dropped or if encode ran asynchronously)
/// @param sampleBuffer Contains the compressed frame if compression was successful and the frame was not dropped; null otherwise
void sdl_videoEncoderOutputCallback(void * CM_NULLABLE outputCallbackRefCon, void * CM_NULLABLE sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CM_NULLABLE CMSampleBufferRef sampleBuffer) {
    // If there was an error in the encoding, drop the frame
    if (status != noErr) {
        SDLLogW(@"Error encoding video frame: %d", (int)status);
        return;
    }
    
    if (outputCallbackRefCon == NULL || sourceFrameRefCon == NULL || sampleBuffer == NULL) {
        return;
    }
    
    SDLH264VideoEncoder *encoder = (__bridge SDLH264VideoEncoder *)sourceFrameRefCon;
    NSArray *nalUnits = [encoder.class sdl_extractNalUnitsFromSampleBuffer:sampleBuffer];

    const CMTime presentationTimestampInCMTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    double presentationTimestamp = 0.0;
    if (CMTIME_IS_VALID(presentationTimestampInCMTime)) {
        presentationTimestamp = CMTimeGetSeconds(presentationTimestampInCMTime);
    }
    if (encoder.timestampOffset == 0.0) {
        // remember this first timestamp as the offset
        encoder.timestampOffset = presentationTimestamp;
    }

    NSArray *packets = [encoder.packetizer createPackets:nalUnits
                                   presentationTimestamp:(presentationTimestamp - encoder.timestampOffset)];
    
    if ([encoder.delegate respondsToSelector:@selector(videoEncoder:hasEncodedFrame:)]) {
        for (NSData *packet in packets) {
            [encoder.delegate videoEncoder:encoder hasEncodedFrame:packet];
        }
    }
}

#pragma mark Getters
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

#pragma mark Helpers
+ (NSArray *)sdl_extractNalUnitsFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    // Creating an elementaryStream: http://stackoverflow.com/questions/28396622/extracting-h264-from-cmblockbuffer
    NSMutableArray *nalUnits = [NSMutableArray array];
    BOOL isIFrame = NO;
    CFArrayRef attachmentsArray = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, 0);
    
    if (CFArrayGetCount(attachmentsArray)) {
        CFBooleanRef notSync;
        CFDictionaryRef dict = CFArrayGetValueAtIndex(attachmentsArray, 0);
        BOOL keyExists = CFDictionaryGetValueIfPresent(dict, kCMSampleAttachmentKey_NotSync, (const void **)&notSync);
        
        // Find out if the sample buffer contains an I-Frame (sync frame). If so we will write the SPS and PPS NAL units to the elementary stream.
        isIFrame = !keyExists || !CFBooleanGetValue(notSync);
    }
    
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
                                                               (size_t)i,
                                                               &parameterSetPointer,
                                                               &parameterSetLength,
                                                               NULL,
                                                               NULL);
            
            // Output the parameter set
            NSData *nalUnit = [NSData dataWithBytesNoCopy:(uint8_t *)parameterSetPointer length:parameterSetLength freeWhenDone:NO];
            [nalUnits addObject:nalUnit];
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
        
        // Write the NAL unit without the AVCC length header to the elementary stream
        NSData *nalUnit = [NSData dataWithBytesNoCopy:bufferDataPointer + bufferOffset + AVCCHeaderLength length:NALUnitLength freeWhenDone:NO];
        [nalUnits addObject:nalUnit];
        
        // Move to the next NAL unit in the block buffer
        bufferOffset += AVCCHeaderLength + NALUnitLength;
    }

    return nalUnits;
}

/// Forces the completion of any pending frames and invalidates the current VTCompressionSession
- (void)sdl_invalidateCompressionSession {
    if (self.compressionSession == NULL) { return; }

    VTCompressionSessionCompleteFrames(self.compressionSession, kCMTimeInvalid);
    VTCompressionSessionInvalidate(self.compressionSession);
    CFRelease(self.compressionSession);
    self.compressionSession = NULL;
}

/// Recreates a compression session and sets the video encoder properties on the session after an error occurs.
/// @return True if the compression session was created successfully; false if not
- (BOOL)sdl_resetCompressionSession {
    // Destroy the current compression session before attempting to create a new one. Otherwise the attempt to create a new compression session sometimes fails.
    [self sdl_invalidateCompressionSession];

    NSError *error = nil;
    BOOL compressionSessionCreated = [self sdl_createCompressionSessionWithError:&error];
    if (!compressionSessionCreated) {
        SDLLogE(@"Error creating the compression session: %@", error.localizedDescription);
        return NO;
    }

    BOOL propertiesSetOnCompressionSession = [self sdl_setPropertiesOnCompressionSession:self.compressionSession withError:&error];
    if (!propertiesSetOnCompressionSession) {
        SDLLogE(@"Error setting the properties on the compression session: %@", error.localizedDescription);
        return NO;
    }

    return YES;
}

/// Creates a compression session using the dimensions passed when the video encoder was created.
/// @param error Error set if the compression session was not created successfully
/// @return True if the compression session was created successfully; false if not
- (BOOL)sdl_createCompressionSessionWithError:(NSError **)error {
    OSStatus status = VTCompressionSessionCreate(NULL, (int32_t)self.dimensions.width, (int32_t)self.dimensions.height, kCMVideoCodecType_H264, NULL, self.pixelBufferOptions, NULL, &sdl_videoEncoderOutputCallback, (__bridge void *)self, &_compressionSession);

    if (status != noErr) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:SDLErrorDomainVideoEncoder code:SDLVideoEncoderErrorConfigurationCompressionSessionCreationFailure userInfo:@{@"OSStatus":@(status), NSLocalizedDescriptionKey:@"Compression session could not be created"}];
        }

        return NO;
    }

    return (status == noErr);
}

/// Validates the properties set by the developer into the encoder settings dictionary. If any are not available for use, the session will be cancelled.
/// @param compressionSession The compression session on which the video encoder properties will be set
/// @param error Error set if the video encoder properties are not valid
/// @return True if the video encoder properties are valid; false if not
- (BOOL)sdl_validateVideoEncoderPropertiesOnCompressionSession:(VTCompressionSessionRef)compressionSession withError:(NSError **)error {
    OSStatus status;

    // Validate that the video encoder properties are valid.
    CFDictionaryRef supportedProperties;
    status = VTSessionCopySupportedPropertyDictionary(compressionSession, &supportedProperties);
    if (status != noErr) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:SDLErrorDomainVideoEncoder code:SDLVideoEncoderErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{@"OSStatus":@(status), NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\"%@\" are not supported properties.", supportedProperties]}];
        }
        return NO;
    }

    NSArray<NSString *> *videoEncoderKeys = self.videoEncoderSettings.allKeys;
    for (NSString *key in videoEncoderKeys) {
        if (CFDictionaryContainsKey(supportedProperties, (__bridge CFStringRef)key) == false) {
            if (error != NULL) {
                *error = [NSError errorWithDomain:SDLErrorDomainVideoEncoder code:SDLVideoEncoderErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\"%@\" is not a supported key.", key]}];
            }
            CFRelease(supportedProperties);
            return NO;
        }
    }
    CFRelease(supportedProperties);

    return YES;
}

/// Sets the video encoding properties on the compression session.
/// @param compressionSession The compression session on which to set the video encoding properties
/// @param error Error set if the properties were not successfully set on the video toolbox session
/// @return True if the video encoding properties were set successfully; false if not
- (BOOL)sdl_setPropertiesOnCompressionSession:(VTCompressionSessionRef)compressionSession withError:(NSError **)error {
    OSStatus status;

    NSArray* videoEncoderKeys = self.videoEncoderSettings.allKeys;
    for (NSString *key in videoEncoderKeys) {
        id value = self.videoEncoderSettings[key];
        status = VTSessionSetProperty(compressionSession, (__bridge CFStringRef)key, (__bridge CFTypeRef)value);
        if (status != noErr) {
            if (error != NULL) {
                *error = [NSError errorWithDomain:SDLErrorDomainVideoEncoder code:SDLVideoEncoderErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{@"OSStatus": @(status), NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Setting key failed \"%@\"", key]}];
            }
            return NO;
        }
    }

    self.currentFrameNumber = 0;
    self.timestampOffset = 0.0;

    return YES;
}

@end

NS_ASSUME_NONNULL_END
