//
//  SDLTTSChunkSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSpeechCapabilities.h"
#import "SDLTTSChunk.h"


QuickSpecBegin(SDLTTSChunkSpec)

describe(@"TTS Chunk Tests", ^{
    __block SDLTTSChunk *testStruct = nil;
    __block NSArray<SDLTTSChunk *> *testChunks = nil;
    __block NSString *testText = @"Text";
    __block SDLSpeechCapabilities testCapabilities = SDLSpeechCapabilitiesFile;

    describe(@"initializers", ^{
        it(@"should correctly initialize with init", ^{
            testStruct = [[SDLTTSChunk alloc] init];

            expect(testStruct.text).to(beNil());
            expect(testStruct.type).to(beNil());
        });

        it(@"should correctly initialize with initWithDictionary", ^{
            NSDictionary* dict = @{SDLNameText: testText,
                                   SDLNameType: testCapabilities};
            testStruct = [[SDLTTSChunk alloc] initWithDictionary:dict];

            expect(testStruct.text).to(equal(testText));
            expect(testStruct.type).to(equal(testCapabilities));
        });

        it(@"should correctly initialize with initWithText:type:", ^{
            testStruct = [[SDLTTSChunk alloc] initWithText:testText type:testCapabilities];

            expect(testStruct.text).to(equal(testText));
            expect(testStruct.type).to(equal(testCapabilities));
        });

        it(@"should correctly initialize with textChunksFromString:", ^{
            testChunks = [SDLTTSChunk textChunksFromString:testText];

            expect(testChunks).to(haveCount(1));
            expect(testChunks[0].text).to(equal(testText));
            expect(testChunks[0].type).to(equal(SDLSpeechCapabilitiesText));
        });

        it(@"should correctly initialize with sapiChunksFromString:", ^{
            testChunks = [SDLTTSChunk sapiChunksFromString:testText];

            expect(testChunks).to(haveCount(1));
            expect(testChunks[0].text).to(equal(testText));
            expect(testChunks[0].type).to(equal(SDLSpeechCapabilitiesSAPIPhonemes));
        });

        it(@"should correctly initialize with lhPlusChunksFromString:", ^{
            testChunks = [SDLTTSChunk lhPlusChunksFromString:testText];

            expect(testChunks).to(haveCount(1));
            expect(testChunks[0].text).to(equal(testText));
            expect(testChunks[0].type).to(equal(SDLSpeechCapabilitiesLHPlusPhonemes));
        });

        it(@"should correctly initialize with prerecordedChunksFromString:", ^{
            testChunks = [SDLTTSChunk prerecordedChunksFromString:testText];

            expect(testChunks).to(haveCount(1));
            expect(testChunks[0].text).to(equal(testText));
            expect(testChunks[0].type).to(equal(SDLSpeechCapabilitiesPrerecorded));
        });

        it(@"should correctly initialize with silenceChunksFromString:", ^{
            testChunks = [SDLTTSChunk silenceChunks];

            expect(testChunks).to(haveCount(1));
            expect(testChunks[0].text).to(beEmpty());
            expect(testChunks[0].type).to(equal(SDLSpeechCapabilitiesSilence));
        });

        it(@"should correctly initialize with fileChunksWithName:", ^{
            testChunks = [SDLTTSChunk fileChunksWithName:testText];

            expect(testChunks).to(haveCount(1));
            expect(testChunks[0].text).to(equal(testText));
            expect(testChunks[0].type).to(equal(SDLSpeechCapabilitiesFile));
        });
    });

    describe(@"Getter/Setter Tests", ^ {
        it(@"Should set and get correctly", ^ {
            SDLTTSChunk* testStruct = [[SDLTTSChunk alloc] init];

            testStruct.text = testText;
            testStruct.type = testCapabilities;

            expect(testStruct.text).to(equal(testText));
            expect(testStruct.type).to(equal(testCapabilities));
        });
    });
});



QuickSpecEnd
