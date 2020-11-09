//
//  SDLAlertAudioData.h
//  SmartDeviceLink
//
//  Created by Nicole on 11/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAudioData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAlertAudioData : SDLAudioData

/// Whether the alert tone should be played before the prompt (if any) is spoken. Defaults to NO.
@property (assign, nonatomic) BOOL playTone;

/// Initialize with an SDLFile holding data or pointing to a file on the file system. When this object is passed to an `Alert` or `Speak`, the file will be uploaded if it is not already, then played if the system supports that feature.
/// @discussion Only available on systems supporting RPC Spec v.5.0+
///
/// @param audioFile The audio file to be played by the system
/// @param tone Whether or not to play a system tone before the audio file
- (instancetype)initWithAudioFile:(SDLFile *)audioFile playSystemTone:(BOOL)tone;

/// Initialize with a string to be spoken by the system speech synthesizer.
/// @param spokenString The string to be spoken by the system speech synthesizer
/// @param tone Whether or not to play a system tone before the synthesized speech
- (instancetype)initWithSpeechSynthesizerString:(NSString *)spokenString playSystemTone:(BOOL)tone;

/// Initialize with a string to be spoken by the system speech synthesizer using a phonetic string.
/// @param phoneticString The string to be spoken by the system speech synthesizer
/// @param phoneticType Must be one of `SAPI_PHONEMES`, `LHPLUS_PHONEMES`, `TEXT`, or `PRE_RECORDED` or no object will be created
/// @param tone Whether or not to play a system tone before the synthesized speech
- (instancetype)initWithPhoneticSpeechSynthesizerString:(NSString *)phoneticString phoneticType:(SDLSpeechCapabilities)phoneticType playSystemTone:(BOOL)tone;

/// Initialize with only a tone.
- (instancetype)initWithTone;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
