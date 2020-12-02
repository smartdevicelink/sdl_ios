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
    __block SDLFile *testAudioFile2 = nil;

    beforeEach(^{
        testSpeechSynthesizerString = @"testSpeechSynthesizerString";

        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        testAudioFile = [[SDLFile alloc] initWithFileURL:[testBundle URLForResource:@"testAudio" withExtension:@"mp3"] name:@"testAudioFile" persistent:YES];
        testAudioFile2 = [[SDLFile alloc] initWithFileURL:[testBundle URLForResource:@"testAudio" withExtension:@"mp3"] name:@"testAudioFile2" persistent:YES];
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

        context(@"If adding audio files", ^{
            it(@"Should append the new audio files to the current existing audio files", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];
                [testAudioData addAudioFiles:@[testAudioFile, testAudioFile]];

                expect(testAudioData.audioFiles.count).to(equal(3));
                expect(testAudioData.prompts).to(beNil());
            });

            it(@"Should add the new audio files to a nil list of audio files", ^{
                testAudioData = [[SDLAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString1];
                [testAudioData addAudioFiles:@[testAudioFile, testAudioFile]];

                expect(testAudioData.audioFiles.count).to(equal(2));
                expect(testAudioData.prompts.count).to(equal(1));
            });
        });

        context(@"If adding speech synthesizer strings", ^{
            it(@"Should append the additional speech synthesizer strings to the existing prompts", ^{
                testAudioData = [[SDLAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString1];
                [testAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString2, testSpeechSynthesizerString3]];

                expect(testAudioData.audioFiles).to(beNil());
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

            it(@"Should add the new speech synthesizer strings to a nil list of prompts", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];
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

            it(@"Should not append any additional speech synthesizer strings that are empty", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];
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

            it(@"Should not append an array with only empty additional speech synthesizer strings", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];
                [testAudioData addSpeechSynthesizerStrings:@[testEmptySpeechSynthesizerString]];

                expect(testAudioData.audioFiles.count).to(equal(1));
                expect(testAudioData.prompts).to(beNil());
            });

            it(@"Should not append an empty array of speech synthesizer strings", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];
                [testAudioData addSpeechSynthesizerStrings:@[]];

                expect(testAudioData.audioFiles.count).to(equal(1));
                expect(testAudioData.prompts).to(beNil());
            });
        });

        context(@"If adding phonetic speech synthesizer strings", ^{
            it(@"Should append the additional phonetic speech synthesizer strings to the existing prompts", ^{
                SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesSAPIPhonemes;
                testAudioData = [[SDLAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString1 phoneticType:testSpeechCapabilities];
                [testAudioData addPhoneticSpeechSynthesizerStrings:@[testSpeechSynthesizerString2] phoneticType:testSpeechCapabilities];

                expect(testAudioData.audioFiles).to(beNil());
                expect(testAudioData.prompts.count).to(equal(2));

                SDLTTSChunk *firstPrompt = testAudioData.prompts[0];
                expect(firstPrompt.text).to(equal(testSpeechSynthesizerString1));
                expect(firstPrompt.type).to(equal(testSpeechCapabilities));

                SDLTTSChunk *secondPrompt = testAudioData.prompts[1];
                expect(secondPrompt.text).to(equal(testSpeechSynthesizerString2));
                expect(secondPrompt.type).to(equal(testSpeechCapabilities));
            });

            it(@"Should add the new phonetic speech synthesizer strings to a nil list of prompts", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];

                SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesSAPIPhonemes;
                [testAudioData addPhoneticSpeechSynthesizerStrings:@[testSpeechSynthesizerString1] phoneticType:testSpeechCapabilities];

                expect(testAudioData.audioFiles.count).to(equal(1));
                expect(testAudioData.prompts.count).to(equal(1));

                SDLTTSChunk *firstPrompt = testAudioData.prompts[0];
                expect(firstPrompt.text).to(equal(testSpeechSynthesizerString1));
                expect(firstPrompt.type).to(equal(testSpeechCapabilities));
            });

            it(@"Should not append any additional phonetic speech synthesizer strings that are empty", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];

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

            it(@"Should not append an array with only empty additional phonetic speech synthesizer strings", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];
                SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesText;
                [testAudioData addPhoneticSpeechSynthesizerStrings:@[testEmptySpeechSynthesizerString] phoneticType:testSpeechCapabilities];

                expect(testAudioData.audioFiles.count).to(equal(1));
                expect(testAudioData.prompts).to(beNil());
            });

            it(@"Should not append an empty array of phonetic speech synthesizer strings", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];

                SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesText;
                [testAudioData addPhoneticSpeechSynthesizerStrings:@[] phoneticType:testSpeechCapabilities];

                expect(testAudioData.audioFiles.count).to(equal(1));
                expect(testAudioData.prompts).to(beNil());
            });

            it(@"Should not append additional phonetic speech synthesizer strings with an invalid phonetic type", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];

                SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesFile;
                [testAudioData addPhoneticSpeechSynthesizerStrings:@[testSpeechSynthesizerString1, testSpeechSynthesizerString2] phoneticType:testSpeechCapabilities];

                expect(testAudioData.audioFiles.count).to(equal(1));
                expect(testAudioData.prompts).to(beNil());
            });
        });
    });

    describe(@"Copying audio data", ^{
        __block SDLAudioData *testAudioData = nil;
        __block SDLAudioData *copiedTestAudioData = nil;
        __block NSString *testSpeechSynthesizerString1 = @"testSpeechSynthesizerString1";
        __block NSString *testSpeechSynthesizerString2 = @"testSpeechSynthesizerString2";
        __block NSString *testSpeechSynthesizerString3 = @"testSpeechSynthesizerString3";

        beforeEach(^{
            testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile];
            [testAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString1, testSpeechSynthesizerString2]];

            copiedTestAudioData = [testAudioData copy];
        });

        it(@"Should copy correctly", ^{
            expect(testAudioData).toNot(equal(copiedTestAudioData));
            expect(testAudioData.audioFiles).to(equal(copiedTestAudioData.audioFiles));
            expect(testAudioData.prompts).to(equal(copiedTestAudioData.prompts));
        });

        it(@"Should not update the copy if changes are made to the original", ^{
            [testAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString3]];
            [testAudioData addAudioFiles:@[testAudioFile2]];

            expect(testAudioData.prompts.count).to(equal(3));
            expect(testAudioData.prompts[0].text).to(contain(testSpeechSynthesizerString1));
            expect(testAudioData.prompts[1].text).to(contain(testSpeechSynthesizerString2));
            expect(testAudioData.prompts[2].text).to(contain(testSpeechSynthesizerString3));

            expect(copiedTestAudioData.prompts.count).to(equal(2));
            expect(copiedTestAudioData.prompts[0].text).to(contain(testSpeechSynthesizerString1));
            expect(copiedTestAudioData.prompts[1].text).to(contain(testSpeechSynthesizerString2));

            expect(testAudioData.audioFiles.count).to(equal(2));
            expect(testAudioData.audioFiles[0].name).to(equal(testAudioFile.name));
            expect(testAudioData.audioFiles[1].name).to(equal(testAudioFile2.name));

            expect(copiedTestAudioData.audioFiles.count).to(equal(1));
            expect(copiedTestAudioData.audioFiles[0].name).to(equal(testAudioFile.name));
        });
    });
});

QuickSpecEnd
