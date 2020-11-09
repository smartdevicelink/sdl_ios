//
//  SDLAudioDataSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 11/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioData.h"
#import "SDLFile.h"
#import "SDLTTSChunk.h"

QuickSpecBegin(SDLAudioDataSpec)

describe(@"SDLAudioData", ^{
    __block SDLFile *testAudioFile = nil;
    __block SDLTTSChunk *testSpeechSynthesizerString = nil;
    __block SDLTTSChunk *testPhoneticSpeechSynthesizerString = nil;

    beforeEach(^{
        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        NSURL *testAudioFileURL = [testBundle URLForResource:@"testAudio" withExtension:@"mp3"];
        NSString *testAudioFileName = @"testAudioFile";
        testAudioFile = [[SDLFile alloc] initWithFileURL:testAudioFileURL name:testAudioFileName persistent:YES];

        testSpeechSynthesizerString = [[SDLTTSChunk alloc] initWithText:@"testSpeechSynthesizerString" type:SDLSpeechCapabilitiesText];
        testPhoneticSpeechSynthesizerString = [[SDLTTSChunk alloc] initWithText:@"testSpeechSynthesizerString" type:SDLSpeechCapabilitiesLHPlusPhonemes];
    });

    it(@"Should get correctly when initialized with initWithAudioFile:", ^{
        SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];

        expect(testAudioData.audioFile).to(equal(testAudioFile));
        expect(testAudioData.prompt).to(beNil());
    });

    it(@"Should get correctly when initialized with initWithSpeechSynthesizerString:", ^{
        SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString.text];

        expect(testAudioData.audioFile).to(beNil());
        expect(testAudioData.prompt.count).to(equal(1));
        expect(testAudioData.prompt.firstObject.text).to(equal(testSpeechSynthesizerString.text));
        expect(testAudioData.prompt.firstObject.type).to(equal(testSpeechSynthesizerString.type));
    });

    it(@"Should get correctly when initialized with initWithPhoneticSpeechSynthesizerString:phoneticType:", ^{
        SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithPhoneticSpeechSynthesizerString:testPhoneticSpeechSynthesizerString.text phoneticType:testPhoneticSpeechSynthesizerString.type];

        expect(testAudioData.audioFile).to(beNil());
        expect(testAudioData.prompt.count).to(equal(1));
        expect(testAudioData.prompt.firstObject.text).to(equal(testPhoneticSpeechSynthesizerString.text));
        expect(testAudioData.prompt.firstObject.type).to(equal(testPhoneticSpeechSynthesizerString.type));
    });
});

QuickSpecEnd
