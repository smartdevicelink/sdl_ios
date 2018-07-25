//
//  SDLLifecycleConfigurationUpdateSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 7/25/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLifecycleConfigurationUpdate.h"
#import "SDLTTSChunk.h"

QuickSpecBegin(SDLLifecycleConfigurationUpdateSpec)

describe(@"A lifecycle configuration update", ^{
    __block SDLLifecycleConfigurationUpdate *update = nil;

    it(@"should have set all properties to nil when initalized with init:", ^{
        update = [[SDLLifecycleConfigurationUpdate alloc] init];
        expect(update.appName).to(beNil());
        expect(update.shortAppName).to(beNil());
        expect(update.ttsName).to(beNil());
        expect(update.voiceRecognitionCommandNames).to(beNil());
    });

    describe(@"created with the default init", ^{
        beforeEach(^{
            update = [[SDLLifecycleConfigurationUpdate alloc] init];
        });

        it(@"should have set all properties to nil", ^{
            expect(update.appName).to(beNil());
            expect(update.shortAppName).to(beNil());
            expect(update.ttsName).to(beNil());
            expect(update.voiceRecognitionCommandNames).to(beNil());
        });

        context(@"when individual properties are set", ^{
            it(@"should correctly set the app name", ^{
                NSString *test = @"Some Test String";
                update.appName = test;
                expect(update.appName).to(match(test));
                expect(update.shortAppName).to(beNil());
                expect(update.ttsName).to(beNil());
                expect(update.voiceRecognitionCommandNames).to(beNil());
            });

            it(@"should correctly set the short app name", ^{
                NSString *test = @"Some Test String";
                update.shortAppName = test;
                expect(update.appName).to(beNil());
                expect(update.shortAppName).to(match(test));
                expect(update.ttsName).to(beNil());
                expect(update.voiceRecognitionCommandNames).to(beNil());
            });

            it(@"should correctly set the tts app name", ^{
                NSArray<SDLTTSChunk *> *test = [SDLTTSChunk textChunksFromString:@"Some Test String"];
                update.ttsName = test;
                expect(update.appName).to(beNil());
                expect(update.shortAppName).to(beNil());
                expect(update.ttsName).to(equal(test));
                expect(update.voiceRecognitionCommandNames).to(beNil());
            });

            it(@"should correctly set the vr synonyms", ^{
                NSArray<NSString *> *test = @[@"Some Test String"];
                update.voiceRecognitionCommandNames = test;
                expect(update.appName).to(beNil());
                expect(update.shortAppName).to(beNil());
                expect(update.ttsName).to(beNil());
                expect(update.voiceRecognitionCommandNames).to(equal(test));
            });
        });
    });

    describe(@"created with the default debug init", ^{
        it(@"should have set all properties correctly", ^{
            NSString *testAppName = @"Test App Name";
            NSString *testShortAppName = @"Test Short";
            NSArray<SDLTTSChunk *> *testTTSName = [SDLTTSChunk textChunksFromString:@"Some TTS String"];
            NSArray<NSString *> *testVRCommandNames = @[@"VR Command One", @"VR Command Two"];

            update = [[SDLLifecycleConfigurationUpdate alloc] initWithAppName:testAppName shortAppName:testShortAppName ttsName:testTTSName voiceRecognitionCommandNames:testVRCommandNames];

            expect(update.appName).to(equal(testAppName));
            expect(update.shortAppName).to(equal(testShortAppName));
            expect(update.ttsName).to(equal(testTTSName));
            expect(update.voiceRecognitionCommandNames).to(equal(testVRCommandNames));
        });

        it(@"should have set all properties to nil if no parameters set", ^{
            update = [[SDLLifecycleConfigurationUpdate alloc] init];

            expect(update.appName).to(beNil());
            expect(update.shortAppName).to(beNil());
            expect(update.ttsName).to(beNil());
            expect(update.voiceRecognitionCommandNames).to(beNil());
        });
    });
});

QuickSpecEnd
