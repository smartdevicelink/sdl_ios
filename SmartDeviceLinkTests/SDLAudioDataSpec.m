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
    __block NSString *testSpeechSynthesizerString = nil;

    beforeEach(^{
        testSpeechSynthesizerString = @"testSpeechSynthesizerString";
    });

    it(@"Should get correctly when initialized with initWithAudioFile:", ^{
        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        NSURL *testAudioFileURL = [testBundle URLForResource:@"testAudio" withExtension:@"mp3"];
        NSString *testAudioFileName = @"testAudioFile";
        SDLFile *testAudioFile = testAudioFile = [[SDLFile alloc] initWithFileURL:testAudioFileURL name:testAudioFileName persistent:YES];

        SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];

        expect(testAudioData.audioFile).to(equal(testAudioFile));
        expect(testAudioData.prompt).to(beNil());
    });

    it(@"Should get correctly when initialized with initWithSpeechSynthesizerString:", ^{
        SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString];

        expect(testAudioData.audioFile).to(beNil());
        expect(testAudioData.prompt.count).to(equal(1));
        expect(testAudioData.prompt.firstObject.text).to(equal(testSpeechSynthesizerString));
        expect(testAudioData.prompt.firstObject.type).to(equal(SDLSpeechCapabilitiesText));
    });

    it(@"Should get correctly when initialized with initWithPhoneticSpeechSynthesizerString:phoneticType:", ^{
        SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesLHPlusPhonemes;
        SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString phoneticType:testSpeechCapabilities];

        expect(testAudioData.audioFile).to(beNil());
        expect(testAudioData.prompt.count).to(equal(1));
        expect(testAudioData.prompt.firstObject.text).to(equal(testSpeechSynthesizerString));
        expect(testAudioData.prompt.firstObject.type).to(equal(testSpeechCapabilities));
    });

    it(@"Should fail if initialized with an invalid phoneticType in initWithPhoneticSpeechSynthesizerString:phoneticType:", ^{
        SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesSilence;
        SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString phoneticType:testSpeechCapabilities];

        expect(testAudioData).to(beNil());
    });
});

QuickSpecEnd
