//
//  SDLAudioFile.h
//  SmartDeviceLink-Example
//
//  Created by Joel Fischer on 10/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Includes inforamtion about a given audio file
 */
@interface SDLAudioFile : NSObject

/**
 If initialized with a file URL, the file URL it came from
 */
@property (nullable, copy, nonatomic, readonly) NSURL *inputFileURL;

/**
 If initialized with a file URL, where the transcoder should produce the transcoded PCM audio file
 */
@property (nullable, copy, nonatomic, readonly) NSURL *outputFileURL;

/**
 In seconds. UINT32_MAX if unknown.
 */
@property (assign, nonatomic) UInt32 estimatedDuration;

/**
 The PCM audio data to be transferred and played
 */
@property (copy, nonatomic, readonly) NSData *data;

/**
 The size of the PCM audio data in bytes
 */
@property (assign, nonatomic, readonly) unsigned long long fileSize;

/**
 Initialize an audio file to be queued and played

 @param inputURL The file that exists on the device to be transcoded and queued
 @param outputURL The target URL that the transcoded file will be output to
 @param duration The duration of the file
 @return The audio file object
 */
- (instancetype)initWithInputFileURL:(NSURL *)inputURL outputFileURL:(NSURL *)outputURL estimatedDuration:(UInt32)duration;

/**
 Initialize a buffer of PCM audio data to be queued and played

 @param data The PCM audio data buffer
 @return The audio file object
 */
- (instancetype)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
