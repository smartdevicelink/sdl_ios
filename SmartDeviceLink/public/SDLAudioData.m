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
@property (nullable, copy, nonatomic, readonly) NSMutableDictionary<NSString *, SDLFile *> *audioFileData;
@property (nullable, copy, nonatomic, readonly) NSMutableArray<SDLTTSChunk *> *mutableAudioData;

@end

@implementation SDLAudioData

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _audioDataTTSChunks = [NSMutableArray array];
    _audioFileData = [NSMutableDictionary dictionary];

    return self;
}

- (instancetype)initWithAudioFile:(SDLFile *)audioFile {
    self = [self init];
    if (!self) { return nil; }

    [_audioDataTTSChunks addObjectsFromArray:[SDLTTSChunk fileChunksWithName:audioFile.name];
    _audioFileData[audioFile.name] = audioFile;

    return self;
}

- (instancetype)initWithSpeechSynthesizerString:(NSString *)spokenString {
    self = [self init];
    if (!self) { return nil; }

    [_audioDataTTSChunks addObjectsFromArray:[SDLTTSChunk textChunksFromString:spokenString]];

    return self;
}

- (instancetype)initWithPhoneticSpeechSynthesizerString:(NSString *)phoneticString phoneticType:(SDLSpeechCapabilities)phoneticType {
    self = [self init];
    if (!self) { return nil; }

    if (![self.class sdl_isValidPhoneticType:phoneticType]) {
        return nil;
    }

    [_audioDataTTSChunks addObjectsFromArray:[[SDLTTSChunk alloc] initWithText:phoneticString type:phoneticType]];

    return self;
}

#pragma mark - Adding additional audio data
- (void)addAudioFiles:(NSArray<SDLFile *> *)audioFiles {
    if (audioFiles.count == 0) { return; }

    for (SDLFile *audioFile in audioFiles) {
        self.audioFileData[audioFile.name] = audioFile;
        [self.audioDataTTSChunks addObjectsFromArray:[SDLTTSChunk fileChunksWithName:audioFile.name]];
    }
}

- (void)addSpeechSynthesizerStrings:(NSArray<NSString *> *)spokenStrings {
    if (spokenStrings.count == 0) { return; }

    for (NSString *spokenString in spokenStrings) {
        if (spokenString.length == 0) { continue; }
        [self.audioDataTTSChunks addObjectsFromArray:[SDLTTSChunk textChunksFromString:spokenString]];
    }
}

- (void)addPhoneticSpeechSynthesizerStrings:(NSArray<NSString *> *)phoneticStrings phoneticType:(SDLSpeechCapabilities)phoneticType {
    if (![self.class sdl_isValidPhoneticType:phoneticType] || phoneticStrings.count == 0) {
        return;
    }

    for (NSString *phoneticString in phoneticStrings) {
        if (phoneticString.length == 0) { continue; }
        [self.audioDataTTSChunks addObject:[[SDLTTSChunk alloc] initWithText:phoneticString type:phoneticType]];
    }
}

#pragma mark - Private Utilities

/// Checks if the phonetic type can be used to create a text-to-speech string.
/// @param phoneticType The phonetic type of the text-to-speech string
/// @return True if the phoneticType is of type `SAPI_PHONEMES`, `LHPLUS_PHONEMES`, `TEXT`, or `PRE_RECORDED`; false if not.
+ (BOOL)sdl_isValidPhoneticType:(SDLSpeechCapabilities)phoneticType {
    if (!([phoneticType isEqualToEnum:SDLSpeechCapabilitiesSAPIPhonemes] || [phoneticType isEqualToEnum:SDLSpeechCapabilitiesLHPlusPhonemes] || [phoneticType isEqualToEnum:SDLSpeechCapabilitiesText] || [phoneticType isEqualToEnum:SDLSpeechCapabilitiesPrerecorded])) {
        return NO;
    }

    return YES;
}

#pragma mark - Getters

- (nullable NSArray<SDLTTSChunk *> *)audioData {
    return [_audioDataTTSChunks copy];
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLAudioData *newAudioData = [[self class] allocWithZone:zone];
    newAudioData->_audioDataTTSChunks = [_audioDataTTSChunks copyWithZone:zone];
    newAudioData->_audioFileData = [_audioFileData copyWithZone:zone];
    return newAudioData;
}

@end

NS_ASSUME_NONNULL_END
