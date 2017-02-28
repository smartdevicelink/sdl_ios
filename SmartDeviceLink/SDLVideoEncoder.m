//
//  SDLVideoEncoder.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 12/5/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLVideoEncoder.h"

#import "SDLDebugTool.h"

NSString *const SDLErrorDomainVideoEncoder = @"com.sdl.videoEncoder";

static NSDictionary<NSString *, id>* _defaultVideoEncoderSettings;

@interface SDLVideoEncoder ()

@property (assign, nonatomic, nullable) VTCompressionSessionRef compressionSession;

@property (assign, nonatomic, nullable) CFDictionaryRef sdl_pixelBufferOptions;

@property (assign, nonatomic) NSUInteger currentFrameNumber;

@end

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVideoEncoder

+ (void)initialize {
    if (self != [SDLVideoEncoder class]) {
        return;
    }
    
    _defaultVideoEncoderSettings = @{
                                     (__bridge NSString *)kVTCompressionPropertyKey_ProfileLevel: (__bridge NSString *)kVTProfileLevel_H264_Baseline_AutoLevel,
                                     (__bridge NSString *)kVTCompressionPropertyKey_RealTime: @YES
                                     };
}

- (instancetype)initWithDimensions:(CGSize)dimensions properties:(NSDictionary<NSString *,id> *)properties delegate:(id<SDLVideoEncoderDelegate> __nullable)delegate error:(NSError * _Nullable __autoreleasing *)error {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _compressionSession = NULL;
    _currentFrameNumber = 0;
    _videoEncoderSettings = properties;
    
    _delegate = delegate;
    
    OSStatus status;
    
    // Create a compression session
    status = VTCompressionSessionCreate(NULL, dimensions.width, dimensions.height, kCMVideoCodecType_H264, NULL, self.sdl_pixelBufferOptions, NULL, &sdl_videoEncoderOutputCallback, (__bridge void *)self, &_compressionSession);
    
    if (status != noErr) {
        // TODO: Log the error
        if (!*error) {
            *error = [NSError errorWithDomain:SDLErrorDomainVideoEncoder code:SDLVideoEncoderErrorConfigurationCompressionSessionCreationFailure userInfo:@{ @"OSStatus": @(status) }];
        }
        
        return nil;
    }
    
    CFRelease(self.sdl_pixelBufferOptions);
    _sdl_pixelBufferOptions = nil;
    
    // Validate that the video encoder properties are valid.
    CFDictionaryRef supportedProperties;
    status = VTSessionCopySupportedPropertyDictionary(self.compressionSession, &supportedProperties);
    if (status != noErr) {
        if (!*error) {
            *error = [NSError errorWithDomain:SDLErrorDomainVideoEncoder code:SDLVideoEncoderErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{ @"OSStatus": @(status) }];
        }
        
        return nil;
    }
    
    NSArray* videoEncoderKeys = self.videoEncoderSettings.allKeys;
    
    for (NSString *key in videoEncoderKeys) {
        if (CFDictionaryContainsKey(supportedProperties, (__bridge CFStringRef)key) == false) {
            if (!*error) {
                NSString *description = [NSString stringWithFormat:@"\"%@\" is not a supported key.", key];
                *error = [NSError errorWithDomain:SDLErrorDomainVideoEncoder code:SDLVideoEncoderErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{NSLocalizedDescriptionKey: description}];
            }
            CFRelease(supportedProperties);
            return nil;
        }
    }
    CFRelease(supportedProperties);
    
    // Populate the video encoder settings from provided dictionary.
    for (NSString *key in videoEncoderKeys) {
        id value = self.videoEncoderSettings[key];
        
        status = VTSessionSetProperty(self.compressionSession, (__bridge CFStringRef)key, (__bridge CFTypeRef)value);
        if (status != noErr) {
            if (!*error) {
                *error = [NSError errorWithDomain:SDLErrorDomainVideoEncoder code:SDLVideoEncoderErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{ @"OSStatus": @(status) }];
            }
            
            return nil;
        }
    }
    
    return self;
}

- (void)stop {
    if (self.compressionSession != NULL) {
        VTCompressionSessionInvalidate(self.compressionSession);
        CFRelease(self.compressionSession);
        self.compressionSession = NULL;
    }
}

- (BOOL)encodeFrame:(CVImageBufferRef)imageBuffer {
    OSStatus status = VTCompressionSessionEncodeFrame(_compressionSession, imageBuffer, CMTimeMake(self.currentFrameNumber++, 30), kCMTimeInvalid, NULL, (__bridge void *)self, NULL);

    return (status == noErr);
}

#pragma mark - Public
#pragma mark Getters
+ (NSDictionary<NSString *, id> *)defaultVideoEncoderSettings {
    return _defaultVideoEncoderSettings;
}

- (CVPixelBufferPoolRef _Nullable)pixelBufferPool {
    return VTCompressionSessionGetPixelBufferPool(self.compressionSession);
}

#pragma mark - Private
#pragma mark Callback
void sdl_videoEncoderOutputCallback(void * CM_NULLABLE outputCallbackRefCon, void * CM_NULLABLE sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CM_NULLABLE CMSampleBufferRef sampleBuffer) {
    // If there was an error in the encoding, drop the frame
    if (status != noErr) {
        [SDLDebugTool logFormat:@"Error encoding video, err=%lld", (int64_t)status];
        return;
    }
    
    if (outputCallbackRefCon == NULL || sourceFrameRefCon == NULL || sampleBuffer == NULL) {
        return;
    }
    
    SDLVideoEncoder *encoder = (__bridge SDLVideoEncoder *)sourceFrameRefCon;
    NSData *elementaryStreamData = [encoder.class sdl_encodeElementaryStreamWithSampleBuffer:sampleBuffer];
    
    if ([encoder.delegate respondsToSelector:@selector(videoEncoder:hasEncodedFrame:)]) {
        [encoder.delegate videoEncoder:encoder hasEncodedFrame:elementaryStreamData];
    }
}

#pragma mark Getters
- (CFDictionaryRef _Nullable)sdl_pixelBufferOptions {
    if (_sdl_pixelBufferOptions == nil) {
        CFMutableDictionaryRef pixelBufferOptions = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        
        OSType pixelFormatType = kCVPixelFormatType_32BGRA;
        
        CFNumberRef pixelFormatNumberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &pixelFormatType);
        
        CFDictionarySetValue(pixelBufferOptions, kCVPixelBufferCGImageCompatibilityKey, kCFBooleanFalse);
        CFDictionarySetValue(pixelBufferOptions, kCVPixelBufferCGBitmapContextCompatibilityKey, kCFBooleanFalse);
        CFDictionarySetValue(pixelBufferOptions, kCVPixelBufferPixelFormatTypeKey, pixelFormatNumberRef);
        
        CFRelease(pixelFormatNumberRef);
        
        _sdl_pixelBufferOptions = pixelBufferOptions;
    }
    return _sdl_pixelBufferOptions;
}

#pragma mark Helpers
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

@end

NS_ASSUME_NONNULL_END
