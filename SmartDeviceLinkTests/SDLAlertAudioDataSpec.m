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
        expect(testAudioData.audioFile).to(equal(testAudioFile));
        expect(testAudioData.prompt).to(beNil());
    });

    it(@"Should get correctly when initialized with initWithSpeechSynthesizerString:", ^{
        SDLAlertAudioData *testAudioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString];

        expect(testAudioData.playTone).to(beFalse());
        expect(testAudioData.audioFile).to(beNil());
        expect(testAudioData.prompt.count).to(equal(1));
        expect(testAudioData.prompt.firstObject.text).to(equal(testSpeechSynthesizerString));
        expect(testAudioData.prompt.firstObject.type).to(equal(SDLSpeechCapabilitiesText));
    });

    it(@"Should get correctly when initialized with initWithPhoneticSpeechSynthesizerString:phoneticType:", ^{
        SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesLHPlusPhonemes;
        SDLAlertAudioData *testAudioData = [[SDLAlertAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString phoneticType:testSpeechCapabilities];

        expect(testAudioData.playTone).to(beFalse());
        expect(testAudioData.audioFile).to(beNil());
        expect(testAudioData.prompt.count).to(equal(1));
        expect(testAudioData.prompt.firstObject.text).to(equal(testSpeechSynthesizerString));
        expect(testAudioData.prompt.firstObject.type).to(equal(testSpeechCapabilities));
    });

    it(@"Should get correctly when initialized with initWithAudioFile:playSystemTone:", ^{
        SDLAlertAudioData *testAudioData = [[SDLAlertAudioData alloc] initWithAudioFile:testAudioFile playSystemTone:YES];

        expect(testAudioData.playTone).to(beTrue());
        expect(testAudioData.audioFile).to(equal(testAudioFile));
        expect(testAudioData.prompt).to(beNil());
    });

    it(@"Should get correctly when initialized with initWithSpeechSynthesizerString:playSystemTone:", ^{
        SDLAlertAudioData *testAudioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString playSystemTone:YES];

        expect(testAudioData.playTone).to(beTrue());
        expect(testAudioData.audioFile).to(beNil());
        expect(testAudioData.prompt.count).to(equal(1));
        expect(testAudioData.prompt.firstObject.text).to(equal(testSpeechSynthesizerString));
        expect(testAudioData.prompt.firstObject.type).to(equal(SDLSpeechCapabilitiesText));
    });

    it(@"Should get correctly when initialized with initWithPhoneticSpeechSynthesizerString:phoneticType:playSystemTone:", ^{
        SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesLHPlusPhonemes;
        SDLAlertAudioData *testAudioData = [[SDLAlertAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString phoneticType:testSpeechCapabilities playSystemTone:YES];

        expect(testAudioData.playTone).to(beTrue());
        expect(testAudioData.audioFile).to(beNil());
        expect(testAudioData.prompt.count).to(equal(1));
        expect(testAudioData.prompt.firstObject.text).to(equal(testSpeechSynthesizerString));
        expect(testAudioData.prompt.firstObject.type).to(equal(testSpeechCapabilities));
    });

    it(@"Should get correctly when initialized with initWithTone", ^{
        SDLAlertAudioData *testAudioData = [[SDLAlertAudioData alloc] initWithTone];

        expect(testAudioData.playTone).to(beTrue());
        expect(testAudioData.audioFile).to(beNil());
        expect(testAudioData.prompt).to(beNil());
    });
});

QuickSpecEnd
