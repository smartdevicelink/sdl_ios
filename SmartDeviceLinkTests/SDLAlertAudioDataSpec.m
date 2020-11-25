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
    __block SDLFile *testAudioFile2 = nil;

    beforeEach(^{
        testSpeechSynthesizerString = @"testSpeechSynthesizerString";

        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        testAudioFile = [[SDLFile alloc] initWithFileURL:[testBundle URLForResource:@"testAudio" withExtension:@"mp3"] name:@"testAudioFile" persistent:YES];
        testAudioFile2 = [[SDLFile alloc] initWithFileURL:[testBundle URLForResource:@"testAudio" withExtension:@"mp3"] name:@"testAudioFile2" persistent:YES];
    });

    describe(@"Initialization", ^{
        it(@"Should get correctly when initialized with initWithAudioFile:", ^{
            SDLAlertAudioData *testAlertAudioData = [[SDLAlertAudioData alloc] initWithAudioFile:testAudioFile];

            expect(testAlertAudioData.playTone).to(beFalse());
            expect(testAlertAudioData.audioFiles).to(equal(@[testAudioFile]));
            expect(testAlertAudioData.prompts).to(beNil());
        });

        it(@"Should get correctly when initialized with initWithSpeechSynthesizerString:", ^{
            SDLAlertAudioData *testAlertAudioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString];

            expect(testAlertAudioData.playTone).to(beFalse());
            expect(testAlertAudioData.audioFiles).to(beNil());
            expect(testAlertAudioData.prompts.count).to(equal(1));
            expect(testAlertAudioData.prompts.firstObject.text).to(equal(testSpeechSynthesizerString));
            expect(testAlertAudioData.prompts.firstObject.type).to(equal(SDLSpeechCapabilitiesText));
        });

        it(@"Should get correctly when initialized with initWithPhoneticSpeechSynthesizerString:phoneticType:", ^{
            SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesLHPlusPhonemes;
            SDLAlertAudioData *testAlertAudioData = [[SDLAlertAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString phoneticType:testSpeechCapabilities];

            expect(testAlertAudioData.playTone).to(beFalse());
            expect(testAlertAudioData.audioFiles).to(beNil());
            expect(testAlertAudioData.prompts.count).to(equal(1));
            expect(testAlertAudioData.prompts.firstObject.text).to(equal(testSpeechSynthesizerString));
            expect(testAlertAudioData.prompts.firstObject.type).to(equal(testSpeechCapabilities));
        });

        it(@"Should get and set playTone correctly", ^{
            SDLAlertAudioData *testAlertAudioData = [[SDLAlertAudioData alloc] initWithAudioFile:testAudioFile];
            testAlertAudioData.playTone = YES;

            expect(testAlertAudioData.playTone).to(beTrue());
            expect(testAlertAudioData.audioFiles).to(equal(@[testAudioFile]));
            expect(testAlertAudioData.prompts).to(beNil());
        });
    });

    describe(@"Copying alert audio data", ^{
        __block SDLAlertAudioData *testAlertAudioData = nil;
        __block SDLAlertAudioData *copiedTestAlertAudioData = nil;
        __block NSString *testSpeechSynthesizerString1 = @"testSpeechSynthesizerString1";
        __block NSString *testSpeechSynthesizerString2 = @"testSpeechSynthesizerString2";

        beforeEach(^{
            testAlertAudioData = [[SDLAlertAudioData alloc] initWithAudioFile:testAudioFile];
            [testAlertAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString1]];
            testAlertAudioData.playTone = YES;

            copiedTestAlertAudioData = [testAlertAudioData copy];
        });

        it(@"Should copy correctly", ^{
            expect(testAlertAudioData).toNot(equal(copiedTestAlertAudioData));
            expect(testAlertAudioData.audioFiles).to(equal(copiedTestAlertAudioData.audioFiles));
            expect(testAlertAudioData.prompts).to(equal(copiedTestAlertAudioData.prompts));
            expect(testAlertAudioData.playTone).to(equal(copiedTestAlertAudioData.playTone));
        });

        it(@"Should not update the copy if changes are made to the original", ^{
            [testAlertAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString2]];
            [testAlertAudioData addAudioFiles:@[testAudioFile2]];
            testAlertAudioData.playTone = NO;

            expect(testAlertAudioData.prompts.count).to(equal(2));
            expect(testAlertAudioData.prompts[0].text).to(contain(testSpeechSynthesizerString1));
            expect(testAlertAudioData.prompts[1].text).to(contain(testSpeechSynthesizerString2));

            expect(copiedTestAlertAudioData.prompts.count).to(equal(1));
            expect(copiedTestAlertAudioData.prompts[0].text).to(contain(testSpeechSynthesizerString1));

            expect(testAlertAudioData.audioFiles.count).to(equal(2));
            expect(testAlertAudioData.audioFiles[0].name).to(equal(testAudioFile.name));
            expect(testAlertAudioData.audioFiles[1].name).to(equal(testAudioFile2.name));

            expect(testAlertAudioData.playTone).to(beFalse());
            expect(copiedTestAlertAudioData.playTone).to(beTrue());
        });
    });
});

QuickSpecEnd
