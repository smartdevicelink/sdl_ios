//
//  SDLAudioData.h
//  SmartDeviceLink
//
//  Created by Nicole on 11/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLSpeechCapabilities.h"

@class SDLFile;
@class SDLTTSChunk;

NS_ASSUME_NONNULL_BEGIN

@interface SDLAudioData : NSObject <NSCopying>

/// The text-to-speech prompts that will used and/or audio files that will be played. The audio prompts and files will be played in the same order they are added.
@property (nullable, copy, nonatomic, readonly) NSArray<SDLTTSChunk *> *audioData;

/// Initialize with an SDLFile holding data or pointing to a file on the file system. When this object is passed to an `Alert` or `Speak`, the file will be uploaded if it is not already, then played if the system supports that feature.
/// @discussion Only available on systems supporting RPC Spec v5.0+
///
/// @param audioFile The audio file to be played by the system
- (instancetype)initWithAudioFile:(SDLFile *)audioFile;

/// Initialize with a string to be spoken by the system speech synthesizer.
/// @param spokenString The string to be spoken by the system speech synthesizer
- (instancetype)initWithSpeechSynthesizerString:(NSString *)spokenString;

/// Initialize with a string to be spoken by the system speech synthesizer using a phonetic string.
/// @param phoneticString The string to be spoken by the system speech synthesizer
/// @param phoneticType Must be one of `SAPI_PHONEMES`, `LHPLUS_PHONEMES`, `TEXT`, or `PRE_RECORDED` or no object will be created
- (instancetype)initWithPhoneticSpeechSynthesizerString:(NSString *)phoneticString phoneticType:(SDLSpeechCapabilities)phoneticType;

- (instancetype)init NS_UNAVAILABLE;

/// Add additional SDLFiles holding data or pointing to a file on the file system. When this object is passed to an `Alert` or `Speak`, the file will be uploaded if it is not already, then played if the system supports that feature.
/// @param audioFiles An array of audio file to be played by the system
- (void)addAudioFiles:(NSArray<SDLFile *> *)audioFiles;

/// Create additional strings to be spoken by the system speech synthesizer.
/// @param spokenStrings The strings to be spoken by the system speech synthesizer
- (void)addSpeechSynthesizerStrings:(NSArray<NSString *> *)spokenStrings;

/// Create additional strings to be spoken by the system speech synthesizer using a phonetic string.
/// @param phoneticStrings The strings to be spoken by the system speech synthesizer
/// @param phoneticType Must be one of `SAPI_PHONEMES`, `LHPLUS_PHONEMES`, `TEXT`, or `PRE_RECORDED` or no object will be created
- (void)addPhoneticSpeechSynthesizerStrings:(NSArray<NSString *> *)phoneticStrings phoneticType:(SDLSpeechCapabilities)phoneticType;

@end

NS_ASSUME_NONNULL_END
