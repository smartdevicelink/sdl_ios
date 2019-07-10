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

    describe(@"Created with the default init", ^{
        beforeEach(^{
            update = [[SDLLifecycleConfigurationUpdate alloc] init];
        });

        it(@"should return nil if not set", ^{
            expect(update.appName).to(beNil());
            expect(update.shortAppName).to(beNil());
            expect(update.ttsName).to(beNil());
            expect(update.voiceRecognitionCommandNames).to(beNil());
        });

        it(@"should set and get correctly", ^{
            NSString *testAppName = @"Some Test String";
            NSString *testShortAppName = @"Short";
            NSArray<SDLTTSChunk *> *testTTSName = [SDLTTSChunk textChunksFromString:@"Some TTS String"];
            NSArray<NSString *> *testVRCommandNames = @[@"VR Command One", @"VR Command Two"];

            update.appName = testAppName;
            update.shortAppName = testShortAppName;
            update.ttsName = testTTSName;
            update.voiceRecognitionCommandNames = testVRCommandNames;

            expect(update.appName).to(equal(testAppName));
            expect(update.shortAppName).to(equal(testShortAppName));
            expect(update.ttsName).to(equal(testTTSName));
            expect(update.voiceRecognitionCommandNames).to(equal(testVRCommandNames));
        });
    });

    describe(@"Created with the default debug initalizer", ^{
        it(@"should have set all properties correctly", ^{
            NSString *testAppName = @"Test App Name";
            NSString *testShortAppName = @"Short";
            NSArray<SDLTTSChunk *> *testTTSName = [SDLTTSChunk textChunksFromString:@"Some TTS String"];
            NSArray<NSString *> *testVRCommandNames = @[@"VR Command One", @"VR Command Two"];

            update = [[SDLLifecycleConfigurationUpdate alloc] initWithAppName:testAppName shortAppName:testShortAppName ttsName:testTTSName voiceRecognitionCommandNames:testVRCommandNames];

            expect(update.appName).to(equal(testAppName));
            expect(update.shortAppName).to(equal(testShortAppName));
            expect(update.ttsName).to(equal(testTTSName));
            expect(update.voiceRecognitionCommandNames).to(equal(testVRCommandNames));
        });

        it(@"should have left all properties as nil if no parameters set", ^{
            update = [[SDLLifecycleConfigurationUpdate alloc] initWithAppName:nil shortAppName:nil ttsName:nil voiceRecognitionCommandNames:nil];

            expect(update.appName).to(beNil());
            expect(update.shortAppName).to(beNil());
            expect(update.ttsName).to(beNil());
            expect(update.voiceRecognitionCommandNames).to(beNil());
        });
    });
});

QuickSpecEnd

