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

    _audioFile = audioFile;

    return self;
}

- (instancetype)initWithSpeechSynthesizerString:(NSString *)spokenString {
    self = [super init];
    if (!self) { return nil; }

    _prompt = [SDLTTSChunk textChunksFromString:spokenString];

    return self;
}

- (instancetype)initWithPhoneticSpeechSynthesizerString:(NSString *)phoneticString phoneticType:(SDLSpeechCapabilities)phoneticType {
    self = [super init];
    if (!self) { return nil; }

    _prompt = @[[[SDLTTSChunk alloc] initWithText:phoneticString type:phoneticType]];

    return self;
}

@end

NS_ASSUME_NONNULL_END
