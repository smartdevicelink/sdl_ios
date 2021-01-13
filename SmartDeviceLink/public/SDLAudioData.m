//
//  SDLAudioData.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAudioData.h"

#import "SDLFile.h"
#import "SDLSpeak.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAudioData()

/// The audio file data that will be uploaded.
@property (nullable, copy, nonatomic, readonly) NSDictionary<NSString *, SDLFile *> *audioFileData;

@end

@implementation SDLAudioData

- (instancetype)initWithAudioFile:(SDLFile *)audioFile {
    self = [super init];
    if (!self) { return nil; }

    _audioData = [SDLTTSChunk fileChunksWithName:audioFile.name];
    _audioFileData = @{audioFile.name: audioFile};

    return self;
}

- (instancetype)initWithSpeechSynthesizerString:(NSString *)spokenString {
    self = [super init];
    if (!self) { return nil; }

    _audioData = [SDLTTSChunk textChunksFromString:spokenString];

    return self;
}

- (instancetype)initWithPhoneticSpeechSynthesizerString:(NSString *)phoneticString phoneticType:(SDLSpeechCapabilities)phoneticType {
    self = [super init];
    if (!self) { return nil; }

    if (![self.class sdl_isValidPhoneticType:phoneticType]) {
        return nil;
    }

    _audioData = @[[[SDLTTSChunk alloc] initWithText:phoneticString type:phoneticType]];

    return self;
}

- (void)addAudioFiles:(NSArray<SDLFile *> *)audioFiles {
    NSMutableArray *newAudioFiles = [NSMutableArray arrayWithCapacity:audioFiles.count];
    NSMutableDictionary *newAudioFileData = [NSMutableDictionary dictionaryWithCapacity:audioFiles.count];
    for (SDLFile *audioFile in audioFiles) {
        [newAudioFiles addObjectsFromArray:[SDLTTSChunk fileChunksWithName:audioFile.name]];
        newAudioFileData[audioFile.name] = audioFile;
    }

    _audioData = (_audioData == nil) ? newAudioFiles : [_audioData arrayByAddingObjectsFromArray:newAudioFiles];

    [newAudioFileData addEntriesFromDictionary:_audioFileData];
    _audioFileData = newAudioFileData;
}

- (void)addSpeechSynthesizerStrings:(NSArray<NSString *> *)spokenStrings {
    if (spokenStrings.count == 0) { return; }

    NSMutableArray *newPrompts = [NSMutableArray array];
    for (NSString *spokenString in spokenStrings) {
        if (spokenString.length == 0) { continue; }
        [newPrompts addObjectsFromArray:[SDLTTSChunk textChunksFromString:spokenString]];
    }
    if (newPrompts.count == 0) { return; }

    _audioData = (_audioData == nil) ? [newPrompts copy] : [_audioData arrayByAddingObjectsFromArray:newPrompts];
}

- (void)addPhoneticSpeechSynthesizerStrings:(NSArray<NSString *> *)phoneticStrings phoneticType:(SDLSpeechCapabilities)phoneticType {
    if (![self.class sdl_isValidPhoneticType:phoneticType] || phoneticStrings.count == 0) {
        return;
    }

    NSMutableArray *newPrompts = [NSMutableArray array];
    for (NSString *phoneticString in phoneticStrings) {
        if (phoneticString.length == 0) { continue; }
        [newPrompts addObject:[[SDLTTSChunk alloc] initWithText:phoneticString type:phoneticType]];
    }
    if (newPrompts.count == 0) { return; }

    _audioData = (_audioData == nil) ? [newPrompts copy] : [_audioData arrayByAddingObjectsFromArray:newPrompts];
}

/// Checks if the phonetic type can be used to create a text-to-speech string.
/// @param phoneticType The phonetic type of the text-to-speech string
/// @return True if the phoneticType is of type `SAPI_PHONEMES`, `LHPLUS_PHONEMES`, `TEXT`, or `PRE_RECORDED`; false if not.
+ (BOOL)sdl_isValidPhoneticType:(SDLSpeechCapabilities)phoneticType {
    if (!([phoneticType isEqualToEnum:SDLSpeechCapabilitiesSAPIPhonemes] || [phoneticType isEqualToEnum:SDLSpeechCapabilitiesLHPlusPhonemes] || [phoneticType isEqualToEnum:SDLSpeechCapabilitiesText] || [phoneticType isEqualToEnum:SDLSpeechCapabilitiesPrerecorded])) {
        return NO;
    }

    return YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLAudioData *newAudioData = [[self class] allocWithZone:zone];
    newAudioData->_audioData = [_audioData copyWithZone:zone];
    newAudioData->_audioFileData = [_audioFileData copyWithZone:zone];
    return newAudioData;
}


@end

NS_ASSUME_NONNULL_END
