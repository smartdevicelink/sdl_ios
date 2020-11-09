//
//  SDLAlertAudioData.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAlertAudioData.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAlertAudioData

- (instancetype)initWithAudioFile:(SDLFile *)audioFile playSystemTone:(BOOL)tone {
    self = [super initWithAudioFile:audioFile];
    if (!self) { return nil; }

    _playTone = tone;

    return self;
}

- (instancetype)initWithSpeechSynthesizerString:(NSString *)spokenString playSystemTone:(BOOL)tone {
    self = [super initWithSpeechSynthesizerString:spokenString];
    if (!self) { return nil; }

    _playTone = tone;

    return self;
}

- (instancetype)initWithPhoneticSpeechSynthesizerString:(NSString *)phoneticString phoneticType:(SDLSpeechCapabilities)phoneticType playSystemTone:(BOOL)tone {
    self = [super initWithPhoneticSpeechSynthesizerString:phoneticString phoneticType:phoneticType];
    if (!self) { return nil; }

    _playTone = tone;

    return self;
}

- (instancetype)initWithTone {
    self = [self init];
    if (!self) { return nil; }

    _playTone = YES;
    
    return self;
}

@end

NS_ASSUME_NONNULL_END
