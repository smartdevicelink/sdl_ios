//
//  SDLAlertAudioDataSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 11/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAlertAudioData.h"
#import "SDLFile.h"
#import "SDLTTSChunk.h"

QuickSpecBegin(SDLAlertAudioDataSpec)

describe(@"SDLAlertAudioData", ^{
    __block NSString *testSpeechSynthesizerString = nil;
    __block SDLFile *testAudioFile = nil;

    beforeEach(^{
        testSpeechSynthesizerString = @"testSpeechSynthesizerString";

        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        NSURL *testAudioFileURL = [testBundle URLForResource:@"testAudio" withExtension:@"mp3"];
        NSString *testAudioFileName = @"testAudioFile";
        testAudioFile = [[SDLFile alloc] initWithFileURL:testAudioFileURL name:testAudioFileName persistent:YES];
    });

    it(@"Should get correctly when initialized with initWithAudioFile:", ^{
        SDLAlertAudioData *testAudioData = [[SDLAlertAudioData alloc] initWithAudioFile:testAudioFile];

        expect(testAudioData.playTone).to(beFalse());
        expect(testAudioData.audioFiles).to(equal(@[testAudioFile]));
        expect(testAudioData.prompts).to(beNil());
    });

    it(@"Should get correctly when initialized with initWithSpeechSynthesizerString:", ^{
        SDLAlertAudioData *testAudioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString];

        expect(testAudioData.playTone).to(beFalse());
        expect(testAudioData.audioFiles).to(beNil());
        expect(testAudioData.prompts.count).to(equal(1));
        expect(testAudioData.prompts.firstObject.text).to(equal(testSpeechSynthesizerString));
        expect(testAudioData.prompts.firstObject.type).to(equal(SDLSpeechCapabilitiesText));
    });

    it(@"Should get correctly when initialized with initWithPhoneticSpeechSynthesizerString:phoneticType:", ^{
        SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesLHPlusPhonemes;
        SDLAlertAudioData *testAudioData = [[SDLAlertAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString phoneticType:testSpeechCapabilities];

        expect(testAudioData.playTone).to(beFalse());
        expect(testAudioData.audioFiles).to(beNil());
        expect(testAudioData.prompts.count).to(equal(1));
        expect(testAudioData.prompts.firstObject.text).to(equal(testSpeechSynthesizerString));
        expect(testAudioData.prompts.firstObject.type).to(equal(testSpeechCapabilities));
    });

    it(@"Should get and set playTone correctly", ^{
        SDLAlertAudioData *testAudioData = [[SDLAlertAudioData alloc] initWithAudioFile:testAudioFile];
        testAudioData.playTone = YES;

        expect(testAudioData.playTone).to(beTrue());
        expect(testAudioData.audioFiles).to(equal(@[testAudioFile]));
        expect(testAudioData.prompts).to(beNil());
    });
});

QuickSpecEnd
