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
    __block SDLFile *testAudioFile = nil;

    beforeEach(^{
        testSpeechSynthesizerString = @"testSpeechSynthesizerString";

        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        NSURL *testAudioFileURL = [testBundle URLForResource:@"testAudio" withExtension:@"mp3"];
        NSString *testAudioFileName = @"testAudioFile";
        testAudioFile = [[SDLFile alloc] initWithFileURL:testAudioFileURL name:testAudioFileName persistent:YES];
    });

    describe(@"Initialization", ^{
        it(@"Should get correctly when initialized with initWithAudioFile:", ^{
            SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];

            expect(testAudioData.audioFiles).to(equal(@[testAudioFile]));
            expect(testAudioData.prompts).to(beNil());
        });

        it(@"Should get correctly when initialized with initWithSpeechSynthesizerString:", ^{
            SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString];

            expect(testAudioData.audioFiles).to(beNil());
            expect(testAudioData.prompts.count).to(equal(1));
            expect(testAudioData.prompts.firstObject.text).to(equal(testSpeechSynthesizerString));
            expect(testAudioData.prompts.firstObject.type).to(equal(SDLSpeechCapabilitiesText));
        });

        it(@"Should get correctly when initialized with initWithPhoneticSpeechSynthesizerString:phoneticType:", ^{
            SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesLHPlusPhonemes;
            SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString phoneticType:testSpeechCapabilities];

            expect(testAudioData.audioFiles).to(beNil());
            expect(testAudioData.prompts.count).to(equal(1));
            expect(testAudioData.prompts.firstObject.text).to(equal(testSpeechSynthesizerString));
            expect(testAudioData.prompts.firstObject.type).to(equal(testSpeechCapabilities));
        });

        it(@"Should fail if initialized with an invalid phoneticType in initWithPhoneticSpeechSynthesizerString:phoneticType:", ^{
            SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesSilence;
            SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString phoneticType:testSpeechCapabilities];

            expect(testAudioData).to(beNil());
        });
    });

    describe(@"Adding additional audio data", ^{
        __block SDLAudioData *testAudioData = nil;
        __block NSString *testSpeechSynthesizerString1 = @"testSpeechSynthesizerString1";
        __block NSString *testSpeechSynthesizerString2 = @"testSpeechSynthesizerString2";
        __block NSString *testSpeechSynthesizerString3 = @"testSpeechSynthesizerString3";
        __block NSString *testEmptySpeechSynthesizerString = @"";

        beforeEach(^{
            testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];
        });

        it(@"Should append the additional audio files", ^{
            [testAudioData addAudioFiles:@[testAudioFile, testAudioFile]];

            expect(testAudioData.audioFiles.count).to(equal(3));
            expect(testAudioData.prompts).to(beNil());
        });

        it(@"Should append the additional speech synthesizer strings", ^{
            [testAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString1, testSpeechSynthesizerString2, testSpeechSynthesizerString3]];

            expect(testAudioData.audioFiles.count).to(equal(1));
            expect(testAudioData.prompts.count).to(equal(3));

            SDLTTSChunk *firstPrompt = testAudioData.prompts[0];
            expect(firstPrompt.text).to(equal(testSpeechSynthesizerString1));
            expect(firstPrompt.type).to(equal(SDLSpeechCapabilitiesText));

            SDLTTSChunk *secondPrompt = testAudioData.prompts[1];
            expect(secondPrompt.text).to(equal(testSpeechSynthesizerString2));
            expect(secondPrompt.type).to(equal(SDLSpeechCapabilitiesText));

            SDLTTSChunk *thirdPrompt = testAudioData.prompts[2];
            expect(thirdPrompt.text).to(equal(testSpeechSynthesizerString3));
            expect(thirdPrompt.type).to(equal(SDLSpeechCapabilitiesText));
        });

        it(@"Should not append empty additional speech synthesizer strings", ^{
            [testAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString1, testEmptySpeechSynthesizerString, testSpeechSynthesizerString2]];

            expect(testAudioData.audioFiles.count).to(equal(1));
            expect(testAudioData.prompts.count).to(equal(2));

            SDLTTSChunk *firstPrompt = testAudioData.prompts[0];
            expect(firstPrompt.text).to(equal(testSpeechSynthesizerString1));
            expect(firstPrompt.type).to(equal(SDLSpeechCapabilitiesText));

            SDLTTSChunk *secondPrompt = testAudioData.prompts[1];
            expect(secondPrompt.text).to(equal(testSpeechSynthesizerString2));
            expect(secondPrompt.type).to(equal(SDLSpeechCapabilitiesText));
        });

        it(@"Should not append an empty array of speech synthesizer strings", ^{
            [testAudioData addSpeechSynthesizerStrings:@[]];

            expect(testAudioData.audioFiles.count).to(equal(1));
            expect(testAudioData.prompts).to(beNil());
        });

        it(@"Should append the additional phonetic speech synthesizer strings", ^{
            SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesSAPIPhonemes;
            [testAudioData addPhoneticSpeechSynthesizerStrings:@[testSpeechSynthesizerString1] phoneticType:testSpeechCapabilities];

            expect(testAudioData.audioFiles.count).to(equal(1));
            expect(testAudioData.prompts.count).to(equal(1));

            SDLTTSChunk *firstPrompt = testAudioData.prompts[0];
            expect(firstPrompt.text).to(equal(testSpeechSynthesizerString1));
            expect(firstPrompt.type).to(equal(testSpeechCapabilities));
        });

        it(@"Should not append empty additional phonetic speech synthesizer strings", ^{
            SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesText;
            [testAudioData addPhoneticSpeechSynthesizerStrings:@[testSpeechSynthesizerString1, testSpeechSynthesizerString2, testEmptySpeechSynthesizerString] phoneticType:testSpeechCapabilities];

            expect(testAudioData.audioFiles.count).to(equal(1));
            expect(testAudioData.prompts.count).to(equal(2));

            SDLTTSChunk *firstPrompt = testAudioData.prompts[0];
            expect(firstPrompt.text).to(equal(testSpeechSynthesizerString1));
            expect(firstPrompt.type).to(equal(testSpeechCapabilities));

            SDLTTSChunk *secondPrompt = testAudioData.prompts[1];
            expect(secondPrompt.text).to(equal(testSpeechSynthesizerString2));
            expect(secondPrompt.type).to(equal(testSpeechCapabilities));
        });

        it(@"Should not append an empty array of phonetic speech synthesizer strings", ^{
            SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesText;
            [testAudioData addPhoneticSpeechSynthesizerStrings:@[] phoneticType:testSpeechCapabilities];

            expect(testAudioData.audioFiles.count).to(equal(1));
            expect(testAudioData.prompts).to(beNil());
        });

        it(@"Should not append additional phonetic speech synthesizer strings with an invalid phonetic type", ^{
            SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesFile;
            [testAudioData addPhoneticSpeechSynthesizerStrings:@[testSpeechSynthesizerString1, testSpeechSynthesizerString2] phoneticType:testSpeechCapabilities];

            expect(testAudioData.audioFiles.count).to(equal(1));
            expect(testAudioData.prompts).to(beNil());
        });
    });
});

QuickSpecEnd
