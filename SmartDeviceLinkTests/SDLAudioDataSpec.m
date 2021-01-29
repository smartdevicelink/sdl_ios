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
#import "SDLFileManagerConstants.h"
#import "SDLTTSChunk.h"

@interface SDLAudioData()

@property (nullable, copy, nonatomic, readonly) NSDictionary<SDLFileName *, SDLFile *> *audioFileData;

@end

QuickSpecBegin(SDLAudioDataSpec)

describe(@"SDLAudioData", ^{
    __block NSString *testSpeechSynthesizerString = nil;
    __block SDLFile *testAudioFile1 = nil;
    __block SDLFile *testAudioFile2 = nil;
    __block SDLFile *testAudioFile3 = nil;
    
    beforeEach(^{
        testSpeechSynthesizerString = @"testSpeechSynthesizerString";
        
        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        testAudioFile1 = [[SDLFile alloc] initWithFileURL:[testBundle URLForResource:@"testAudio" withExtension:@"mp3"] name:@"testAudioFile1" persistent:YES];
        testAudioFile2 = [[SDLFile alloc] initWithFileURL:[testBundle URLForResource:@"testAudio" withExtension:@"mp3"] name:@"testAudioFile2" persistent:YES];
        testAudioFile3 = [[SDLFile alloc] initWithFileURL:[testBundle URLForResource:@"testAudio" withExtension:@"mp3"] name:@"testAudioFile3" persistent:YES];
    });
    
    describe(@"Initialization", ^{
        it(@"Should get correctly when initialized with initWithAudioFile:", ^{
            SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile1];
            
            expect(testAudioData.audioFileData).to(haveCount(1));
            expect(testAudioData.audioFileData[testAudioFile1.name]).to(equal(testAudioFile1));
            
            expect(testAudioData.audioData).to(haveCount(1));
            expect(testAudioData.audioData[0].text).to(equal(testAudioFile1.name));
            expect(testAudioData.audioData[0].type).to(equal(SDLSpeechCapabilitiesFile));
        });
        
        it(@"Should get correctly when initialized with initWithSpeechSynthesizerString:", ^{
            SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString];
            
            expect(testAudioData.audioFileData).to(beEmpty());
            
            expect(testAudioData.audioData).to(haveCount(1));
            expect(testAudioData.audioData[0].text).to(equal(testSpeechSynthesizerString));
            expect(testAudioData.audioData[0].type).to(equal(SDLSpeechCapabilitiesText));
        });
        
        it(@"Should get correctly when initialized with initWithPhoneticSpeechSynthesizerString:phoneticType:", ^{
            SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesLHPlusPhonemes;
            SDLAudioData *testAudioData = [[SDLAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString phoneticType:testSpeechCapabilities];
            
            expect(testAudioData.audioFileData).to(beEmpty());
            
            expect(testAudioData.audioData).to(haveCount(1));
            expect(testAudioData.audioData[0].text).to(equal(testSpeechSynthesizerString));
            expect(testAudioData.audioData[0].type).to(equal(testSpeechCapabilities));
        });
        
        it(@"Should fail if initialized with an invalid phoneticType in initWithPhoneticSpeechSynthesizerString:phoneticType:", ^{
            SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesSilence;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
            expectAction(^{ [[SDLAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString phoneticType:testSpeechCapabilities]; }).to(raiseException().named(@"InvalidTTSSpeechCapabilities"));
#pragma clang diagnostic pop
        });
    });
    
    describe(@"Adding additional audio data", ^{
        __block SDLAudioData *testAudioData = nil;
        __block NSString *testSpeechSynthesizerString1 = @"testSpeechSynthesizerString1";
        __block NSString *testSpeechSynthesizerString2 = @"testSpeechSynthesizerString2";
        __block NSString *testSpeechSynthesizerString3 = @"testSpeechSynthesizerString3";
        __block NSString *testEmptySpeechSynthesizerString = @"";
        
        context(@"If adding audio files", ^{
            it(@"Should append the audio file data to the current existing lists if the first added item was an audio file", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile1];
                [testAudioData addAudioFiles:@[testAudioFile2, testAudioFile3]];
                
                expect(testAudioData.audioData).to(haveCount(3));
                expect(testAudioData.audioData[0].text).to(equal(testAudioFile1.name));
                expect(testAudioData.audioData[1].text).to(equal(testAudioFile2.name));
                expect(testAudioData.audioData[2].text).to(equal(testAudioFile3.name));
                
                expect(testAudioData.audioFileData).to(haveCount(3));
                expect(testAudioData.audioFileData[testAudioFile1.name]).to(equal(testAudioFile1));
                expect(testAudioData.audioFileData[testAudioFile2.name]).to(equal(testAudioFile2));
                expect(testAudioData.audioFileData[testAudioFile3.name]).to(equal(testAudioFile3));
            });

            it(@"Should append the audio file data to the current existing lists if the first added item was a prompt", ^{
                testAudioData = [[SDLAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString];
                [testAudioData addAudioFiles:@[testAudioFile1]];

                expect(testAudioData.audioData).to(haveCount(2));
                expect(testAudioData.audioData[0].text).to(equal(testSpeechSynthesizerString));
                expect(testAudioData.audioData[1].text).to(equal(testAudioFile1.name));

                expect(testAudioData.audioFileData).to(haveCount(1));
                expect(testAudioData.audioFileData[testAudioFile1.name]).to(equal(testAudioFile1));
            });
            
            it(@"Should replace audio file data with duplicate file names", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile1];
                [testAudioData addAudioFiles:@[testAudioFile1, testAudioFile2, testAudioFile2]];
                
                expect(testAudioData.audioData).to(haveCount(4));
                expect(testAudioData.audioData[0].text).to(equal(testAudioFile1.name));
                expect(testAudioData.audioData[1].text).to(equal(testAudioFile1.name));
                expect(testAudioData.audioData[2].text).to(equal(testAudioFile2.name));
                expect(testAudioData.audioData[3].text).to(equal(testAudioFile2.name));
                
                expect(testAudioData.audioFileData).to(haveCount(2));
                expect(testAudioData.audioFileData[testAudioFile1.name]).to(equal(testAudioFile1));
                expect(testAudioData.audioFileData[testAudioFile2.name]).to(equal(testAudioFile2));
            });
        });
        
        context(@"If adding speech synthesizer strings", ^{
            it(@"Should append the additional speech synthesizer strings to the existing audio data", ^{
                testAudioData = [[SDLAudioData alloc] initWithSpeechSynthesizerString:testSpeechSynthesizerString1];
                [testAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString2, testSpeechSynthesizerString3]];
                
                expect(testAudioData.audioFileData).to(beEmpty());
                
                expect(testAudioData.audioData).to(haveCount(3));
                expect(testAudioData.audioData[0].text).to(equal(testSpeechSynthesizerString1));
                expect(testAudioData.audioData[0].type).to(equal(SDLSpeechCapabilitiesText));
                expect(testAudioData.audioData[1].text).to(equal(testSpeechSynthesizerString2));
                expect(testAudioData.audioData[1].type).to(equal(SDLSpeechCapabilitiesText));
                expect(testAudioData.audioData[2].text).to(equal(testSpeechSynthesizerString3));
                expect(testAudioData.audioData[2].type).to(equal(SDLSpeechCapabilitiesText));
            });
            
            it(@"Should not append any additional speech synthesizer strings that are empty", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile1];
                [testAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString1, testEmptySpeechSynthesizerString, testSpeechSynthesizerString2]];
                
                expect(testAudioData.audioFileData).to(haveCount(1));
                expect(testAudioData.audioFileData[testAudioFile1.name]).to(equal(testAudioFile1));
                
                expect(testAudioData.audioData).to(haveCount(3));
                expect(testAudioData.audioData[0].text).to(equal(testAudioFile1.name));
                expect(testAudioData.audioData[0].type).to(equal(SDLSpeechCapabilitiesFile));
                expect(testAudioData.audioData[1].text).to(equal(testSpeechSynthesizerString1));
                expect(testAudioData.audioData[1].type).to(equal(SDLSpeechCapabilitiesText));
                expect(testAudioData.audioData[2].text).to(equal(testSpeechSynthesizerString2));
                expect(testAudioData.audioData[2].type).to(equal(SDLSpeechCapabilitiesText));
            });
            
            it(@"Should not append an array with only empty additional speech synthesizer strings", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile1];
                [testAudioData addSpeechSynthesizerStrings:@[testEmptySpeechSynthesizerString]];
                
                expect(testAudioData.audioFileData).to(haveCount(1));
                expect(testAudioData.audioFileData[testAudioFile1.name]).to(equal(testAudioFile1));
                
                expect(testAudioData.audioData).to(haveCount(1));
                expect(testAudioData.audioData[0].text).to(equal(testAudioFile1.name));
                expect(testAudioData.audioData[0].type).to(equal(SDLSpeechCapabilitiesFile));
            });
            
            it(@"Should not append an empty array of speech synthesizer strings", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile1];
                [testAudioData addSpeechSynthesizerStrings:@[]];
                
                expect(testAudioData.audioFileData).to(haveCount(1));
                expect(testAudioData.audioFileData[testAudioFile1.name]).to(equal(testAudioFile1));
                
                expect(testAudioData.audioData).to(haveCount(1));
                expect(testAudioData.audioData[0].text).to(equal(testAudioFile1.name));
                expect(testAudioData.audioData[0].type).to(equal(SDLSpeechCapabilitiesFile));
            });
        });
        
        context(@"If adding phonetic speech synthesizer strings", ^{
            it(@"Should append the additional phonetic speech synthesizer strings to the existing audio data", ^{
                SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesSAPIPhonemes;
                testAudioData = [[SDLAudioData alloc] initWithPhoneticSpeechSynthesizerString:testSpeechSynthesizerString1 phoneticType:testSpeechCapabilities];
                [testAudioData addPhoneticSpeechSynthesizerStrings:@[testSpeechSynthesizerString2] phoneticType:testSpeechCapabilities];
                
                expect(testAudioData.audioFileData).to(beEmpty());
                
                expect(testAudioData.audioData).to(haveCount(2));
                expect(testAudioData.audioData[0].text).to(equal(testSpeechSynthesizerString1));
                expect(testAudioData.audioData[0].type).to(equal(testSpeechCapabilities));
                expect(testAudioData.audioData[1].text).to(equal(testSpeechSynthesizerString2));
                expect(testAudioData.audioData[1].type).to(equal(testSpeechCapabilities));
            });
            
            it(@"Should not append any additional phonetic speech synthesizer strings that are empty", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile1];
                
                SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesText;
                [testAudioData addPhoneticSpeechSynthesizerStrings:@[testSpeechSynthesizerString1, testSpeechSynthesizerString2, testEmptySpeechSynthesizerString] phoneticType:testSpeechCapabilities];
                
                expect(testAudioData.audioFileData).to(haveCount(1));
                expect(testAudioData.audioFileData[testAudioFile1.name]).to(equal(testAudioFile1));
                
                expect(testAudioData.audioData).to(haveCount(3));
                expect(testAudioData.audioData[0].text).to(equal(testAudioFile1.name));
                expect(testAudioData.audioData[0].type).to(equal(SDLSpeechCapabilitiesFile));
                expect(testAudioData.audioData[1].text).to(equal(testSpeechSynthesizerString1));
                expect(testAudioData.audioData[1].type).to(equal(testSpeechCapabilities));
                expect(testAudioData.audioData[2].text).to(equal(testSpeechSynthesizerString2));
                expect(testAudioData.audioData[2].type).to(equal(testSpeechCapabilities));
            });
            
            it(@"Should not append an array with only empty additional phonetic speech synthesizer strings", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile1];
                SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesText;
                [testAudioData addPhoneticSpeechSynthesizerStrings:@[testEmptySpeechSynthesizerString] phoneticType:testSpeechCapabilities];
                
                expect(testAudioData.audioFileData).to(haveCount(1));
                expect(testAudioData.audioFileData[testAudioFile1.name]).to(equal(testAudioFile1));
                
                expect(testAudioData.audioFileData).to(haveCount(1));
                expect(testAudioData.audioData[0].text).to(equal(testAudioFile1.name));
                expect(testAudioData.audioData[0].type).to(equal(SDLSpeechCapabilitiesFile));
            });
            
            it(@"Should not append an empty array of phonetic speech synthesizer strings", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile1];
                
                SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesText;
                [testAudioData addPhoneticSpeechSynthesizerStrings:@[] phoneticType:testSpeechCapabilities];
                
                expect(testAudioData.audioFileData).to(haveCount(1));
                expect(testAudioData.audioFileData[testAudioFile1.name]).to(equal(testAudioFile1));
                
                expect(testAudioData.audioData).to(haveCount(1));
                expect(testAudioData.audioData[0].text).to(equal(testAudioFile1.name));
                expect(testAudioData.audioData[0].type).to(equal(SDLSpeechCapabilitiesFile));
            });
            
            it(@"Should not append additional phonetic speech synthesizer strings with an invalid phonetic type", ^{
                testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile1];
                SDLSpeechCapabilities testSpeechCapabilities = SDLSpeechCapabilitiesFile;

                 expectAction(^{ [testAudioData addPhoneticSpeechSynthesizerStrings:@[testSpeechSynthesizerString1] phoneticType:testSpeechCapabilities]; }).to(raiseException().named(@"InvalidTTSSpeechCapabilities"));
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
            testAudioData = [[SDLAudioData alloc] initWithAudioFile:testAudioFile1];
            [testAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString1, testSpeechSynthesizerString2]];
            
            copiedTestAudioData = [testAudioData copy];
        });
        
        it(@"Should copy correctly", ^{
            expect(testAudioData == copiedTestAudioData).to(beFalse());
            expect(testAudioData.audioData).to(equal(copiedTestAudioData.audioData));
            expect(testAudioData.audioFileData).to(equal(copiedTestAudioData.audioFileData));
        });
        
        it(@"Should not update the copy if changes are made to the original", ^{
            [testAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString3]];
            [testAudioData addAudioFiles:@[testAudioFile2]];
            
            expect(testAudioData.audioData).to(haveCount(5));
            expect(testAudioData.audioData[0].text).to(contain(testAudioFile1.name));
            expect(testAudioData.audioData[1].text).to(contain(testSpeechSynthesizerString1));
            expect(testAudioData.audioData[2].text).to(contain(testSpeechSynthesizerString2));
            expect(testAudioData.audioData[3].text).to(contain(testSpeechSynthesizerString3));
            expect(testAudioData.audioData[4].text).to(contain(testAudioFile2.name));
            
            expect(testAudioData.audioFileData).to(haveCount(2));
            expect(testAudioData.audioFileData[testAudioFile1.name]).to(equal(testAudioFile1));
            expect(testAudioData.audioFileData[testAudioFile2.name]).to(equal(testAudioFile2));
            
            expect(copiedTestAudioData.audioData).to(haveCount(3));
            expect(copiedTestAudioData.audioFileData).to(haveCount(1));
        });
    });
});

QuickSpecEnd
