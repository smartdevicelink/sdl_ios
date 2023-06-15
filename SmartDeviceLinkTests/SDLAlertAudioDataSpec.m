//
//  SDLAlertAudioDataSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 11/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLAlertAudioData.h"
#import "SDLFile.h"
#import "SDLTTSChunk.h"


@interface SDLAlertAudioData()

@property (nullable, copy, nonatomic, readonly) NSDictionary<NSString *, SDLFile *> *audioFileData;

@end

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
        it(@"Should get and set playTone correctly", ^{
            SDLAlertAudioData *testAlertAudioData = [[SDLAlertAudioData alloc] initWithAudioFile:testAudioFile];
            testAlertAudioData.playTone = YES;

            expect(testAlertAudioData.playTone).to(beTrue());
            expect(testAlertAudioData.audioData).to(haveCount(1));
            expect(testAlertAudioData.audioFileData).to(haveCount(1));
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
            expect(testAlertAudioData == copiedTestAlertAudioData).to(beFalse());
            expect(testAlertAudioData.audioData).to(equal(copiedTestAlertAudioData.audioData));
            expect(testAlertAudioData.audioFileData).to(equal(copiedTestAlertAudioData.audioFileData));
            expect(testAlertAudioData.playTone).to(equal(copiedTestAlertAudioData.playTone));
        });

        it(@"Should not update the copy if changes are made to the original", ^{
            [testAlertAudioData addSpeechSynthesizerStrings:@[testSpeechSynthesizerString2]];
            [testAlertAudioData addAudioFiles:@[testAudioFile2]];
            testAlertAudioData.playTone = NO;

            expect(testAlertAudioData.audioData).to(haveCount(4));
            expect(testAlertAudioData.audioData[0].text).to(equal(testAudioFile.name));
            expect(testAlertAudioData.audioData[1].text).to(equal(testSpeechSynthesizerString1));
            expect(testAlertAudioData.audioData[2].text).to(equal(testSpeechSynthesizerString2));
            expect(testAlertAudioData.audioData[3].text).to(equal(testAudioFile2.name));

            expect(copiedTestAlertAudioData.audioData).to(haveCount(2));
            expect(copiedTestAlertAudioData.audioData[0].text).to(equal(testAudioFile.name));
            expect(copiedTestAlertAudioData.audioData[1].text).to(equal(testSpeechSynthesizerString1));

            expect(testAlertAudioData.audioFileData).to(haveCount(2));
            expect(testAlertAudioData.audioFileData[testAudioFile.name]).to(equal(testAudioFile));
            expect(testAlertAudioData.audioFileData[testAudioFile2.name]).to(equal(testAudioFile2));

            expect(copiedTestAlertAudioData.audioFileData).to(haveCount(1));
            expect(testAlertAudioData.audioFileData[testAudioFile.name]).to(equal(testAudioFile));

            expect(testAlertAudioData.playTone).to(beFalse());
            expect(copiedTestAlertAudioData.playTone).to(beTrue());
        });
    });
});

QuickSpecEnd
