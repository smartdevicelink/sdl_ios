//
//  SDLAudioData.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAudioData.h"

#import "SDLSpeak.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAudioData

- (instancetype)initWithAudioFile:(SDLFile *)audioFile {
    self = [super init];
    if (!self) { return nil; }

    _audioFiles = @[audioFile];

    return self;
}

- (instancetype)initWithSpeechSynthesizerString:(NSString *)spokenString {
    self = [super init];
    if (!self) { return nil; }

    _prompts = [SDLTTSChunk textChunksFromString:spokenString];

    return self;
}

- (instancetype)initWithPhoneticSpeechSynthesizerString:(NSString *)phoneticString phoneticType:(SDLSpeechCapabilities)phoneticType {
    self = [super init];
    if (!self) { return nil; }

    if (![self.class sdl_isValidPhoneticType:phoneticType]) {
        return nil;
    }

    _prompts = @[[[SDLTTSChunk alloc] initWithText:phoneticString type:phoneticType]];

    return self;
}

- (void)addAudioFiles:(NSArray<SDLFile *> *)audioFiles {
    _audioFiles = (_audioFiles == nil) ? audioFiles : [_audioFiles arrayByAddingObjectsFromArray:audioFiles];
}

- (void)addSpeechSynthesizerStrings:(NSArray<NSString *> *)spokenStrings {
    if (spokenStrings.count == 0) { return; }

    NSMutableArray *newPrompts = [NSMutableArray array];
    for (NSString *spokenString in spokenStrings) {
        if (spokenString.length == 0) { continue; }
        [newPrompts addObjectsFromArray:[SDLTTSChunk textChunksFromString:spokenString]];
    }
    if (newPrompts.count == 0) { return; }

    _prompts = (_prompts == nil) ? [newPrompts copy] : [_prompts arrayByAddingObjectsFromArray:newPrompts];
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

    _prompts = (_prompts == nil) ? [newPrompts copy] : [_prompts arrayByAddingObjectsFromArray:newPrompts];
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
    SDLAudioData *new = [[[self class] allocWithZone:zone] init];
    new->_audioFiles = [_audioFiles copyWithZone:zone];
    new->_prompts = [_prompts copyWithZone:zone];
    return new;
}


@end

NS_ASSUME_NONNULL_END
