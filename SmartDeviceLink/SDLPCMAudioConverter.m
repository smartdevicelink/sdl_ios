//
//  SDLPCMAudioConverter.m
//  SmartDeviceLink-Example
//
//  Created by Joel Fischer on 10/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#include <AudioToolbox/AudioToolbox.h>

#import "SDLLogMacros.h"
#import "SDLPCMAudioConverter.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const SDLErrorDomainPCMAudioStreamConverter = @"com.sdl.extension.pcmAudioStreamManager.converter";

@interface SDLPCMAudioConverter()

@property (copy, nonatomic) NSURL *inputFileURL;
@property (assign, nonatomic) UInt32 estimatedDuration;

@end

@implementation SDLPCMAudioConverter

- (nullable instancetype)initWithFileURL:(NSURL *)inputFileURL {
    self = [self init];
    if (!self) return nil;

    if (!inputFileURL.isFileURL) {
        return nil;
    }

    _inputFileURL = inputFileURL;
    _estimatedDuration = UINT32_MAX;

    return self;
}

- (nullable NSURL *)convertFileWithError:(NSError *__autoreleasing *)error {
    if (NSTemporaryDirectory() == nil) {
        // We can't write to disk for some reason
        return nil;
    }

    CFURLRef inputFileURL = (__bridge CFURLRef)_inputFileURL;
    NSURL *outputURL = [[[NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES] URLByAppendingPathComponent:[NSUUID UUID].UUIDString] URLByAppendingPathExtension:@"caf"];
    CFURLRef outputFileURL = (__bridge CFURLRef)outputURL;
    ExtAudioFileRef infile, outfile = 0;

    // Open the input file
    OSStatus err = ExtAudioFileOpenURL(inputFileURL, &infile);
    if (err != noErr) {
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainPCMAudioStreamConverter code:err userInfo:@{@"type": @"ExtAudioFileOpenURL"}];
        }
        return nil;
    }

    AudioStreamBasicDescription inputFormat = {};
    UInt32 size = sizeof(inputFormat);
    err = ExtAudioFileGetProperty(infile, kExtAudioFileProperty_FileDataFormat, &size, &inputFormat);
    if (err != noErr) {
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainPCMAudioStreamConverter code:err userInfo:@{@"type": @"kExtAudioFileProperty_FileDataFormat"}];
        }
        return nil;
    }

    SDLLogD(@"PCM Converter input format");
    [self.class printAudioStreamBasicDescription:inputFormat];

    // create the output file (this will erase an existing file)
    AudioStreamBasicDescription outputFormat = [self.class outputFormat];
    SDLLogD(@"PCM Converter output format");
    [self.class printAudioStreamBasicDescription:outputFormat];
    err = ExtAudioFileCreateWithURL(outputFileURL, kAudioFileCAFType, &outputFormat, NULL, kAudioFileFlags_EraseFile, &outfile);
    if (err != noErr) {
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainPCMAudioStreamConverter code:err userInfo:@{@"type": @"ExtAudioFileCreateWithURL"}];
        }
        return nil;
    }

    // get and set the client format - it should be lpcm
    AudioStreamBasicDescription clientFormat = (inputFormat.mFormatID == kAudioFormatLinearPCM ? inputFormat : outputFormat);
    size = sizeof(clientFormat);
    err = ExtAudioFileSetProperty(infile, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat);
    if (err != noErr) {
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainPCMAudioStreamConverter code:err userInfo:@{@"type": @"kExtAudioFileProperty_ClientDataFormat"}];
        }
        return nil;
    }

    size = sizeof(clientFormat);
    err = ExtAudioFileSetProperty(outfile, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat);
    if (err != noErr) {
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainPCMAudioStreamConverter code:err userInfo:@{@"type": @"kExtAudioFileProperty_ClientDataFormat"}];
        }
        return nil;
    }

    AudioConverterRef outConverter;
    size = sizeof(outConverter);
    err = ExtAudioFileGetProperty(outfile, kExtAudioFileProperty_AudioConverter, &size, &outConverter);
    if (err != noErr) {
        if (*error != nil) {
            *error = [NSError errorWithDomain:SDLErrorDomainPCMAudioStreamConverter code:err userInfo:@{@"type": @"kExtAudioFileProperty_AudioConverter"}];
        }
        return nil;
    }

    // set up buffers
    const UInt32 kSrcBufSize = 32768;
    char srcBuffer[kSrcBufSize];

    // do the read and write - the conversion is done on and by the write call
    while (1) {
        AudioBufferList fillBufList;
        fillBufList.mNumberBuffers = 1;
        fillBufList.mBuffers[0].mNumberChannels = inputFormat.mChannelsPerFrame;
        fillBufList.mBuffers[0].mDataByteSize = kSrcBufSize;
        fillBufList.mBuffers[0].mData = srcBuffer;

        // client format is always linear PCM - so here we determine how many frames of lpcm
        // we can read/write given our buffer size
        UInt32 numFrames = (kSrcBufSize / clientFormat.mBytesPerFrame);

        err = ExtAudioFileRead(infile, &numFrames, &fillBufList);
        if (err != noErr) {
            if (*error != nil) {
                *error = [NSError errorWithDomain:SDLErrorDomainPCMAudioStreamConverter code:err userInfo:@{@"type": @"ExtAudioFileRead"}];
            }
            return nil;
        }

        // this is our termination condition
        if (!numFrames) { break; }

        err = ExtAudioFileWrite(outfile, numFrames, &fillBufList);
        if (err != noErr) {
            if (*error != nil) {
                *error = [NSError errorWithDomain:SDLErrorDomainPCMAudioStreamConverter code:err userInfo:@{@"type": @"ExtAudioFileWrite"}];
            }
            return nil;
        }
    }

    _estimatedDuration = [self estimatedDurationForFileRef:outfile];

    // close
    ExtAudioFileDispose(outfile);
    ExtAudioFileDispose(infile);

    // TODO: If error
    return outputURL;
}

- (UInt32)estimatedDurationForFileRef:(ExtAudioFileRef)fileRef {
    UInt32 estimatedDuration = 0;
    UInt32 size = sizeof(estimatedDuration);
    OSStatus err = ExtAudioFileGetProperty(fileRef, kAudioFilePropertyEstimatedDuration, &size, &estimatedDuration);
    if (err != noErr) {
        SDLLogW(@"Could not get estimated duration for file ref");
        return UINT32_MAX;
    }

    return estimatedDuration;
}

+ (AudioStreamBasicDescription)outputFormat {
    AudioStreamBasicDescription outputFormat;
    outputFormat.mSampleRate = 16000;
    outputFormat.mFormatID = kAudioFormatLinearPCM;
    outputFormat.mChannelsPerFrame = 1;
    outputFormat.mBitsPerChannel = 16;
    outputFormat.mBytesPerPacket = (outputFormat.mBitsPerChannel / 8);
    outputFormat.mFramesPerPacket = 1;
    outputFormat.mBytesPerFrame = outputFormat.mBytesPerPacket;
    outputFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger;

    return outputFormat;
}

+ (void)printAudioStreamBasicDescription:(AudioStreamBasicDescription)asbd {
    char formatID[5];
    UInt32 mFormatID = CFSwapInt32HostToBig(asbd.mFormatID);
    bcopy (&mFormatID, formatID, 4);
    formatID[4] = '\0';
    SDLLogD(@"Sample Rate:        %10.0f\n"
            "Format ID:           %10s\n"
            "Format Flags:        %10X\n"
            "Bytes per Packet:    %10d\n"
            "Frames per Packet:   %10d\n"
            "Bytes per Frame:     %10d\n"
            "Channels per Frame:  %10d\n"
            "Bits per Channel:    %10d\n", asbd.mSampleRate, formatID, (unsigned int)asbd.mFormatFlags, (unsigned int)asbd.mBytesPerPacket, (unsigned int)asbd.mFramesPerPacket, (unsigned int)asbd.mBytesPerFrame, (unsigned int)asbd.mChannelsPerFrame, (unsigned int)asbd.mBitsPerChannel);
}

@end

NS_ASSUME_NONNULL_END
