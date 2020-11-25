//
//  SDLAlertViewSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 11/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAlertView.h"
#import "SDLAlertAudioData.h"
#import "SDLArtwork.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"
#import "SDLStaticIconName.h"

@interface SDLAlertView()

@property (nullable, copy, nonatomic) SDLAlertCanceledHandler canceledHandler;

@end

QuickSpecBegin(SDLAlertViewSpec)

describe(@"An SDLAlertView", ^{
    __block NSString *testTextField1 = nil;
    __block NSString *testTextField2 = nil;
    __block NSString *testTextField3 = nil;
    __block NSTimeInterval testTimeout = 0;
    __block SDLAlertAudioData *testAudio = nil;
    __block BOOL testShowWaitIndicator = NO;
    __block NSArray<SDLSoftButtonObject *> *testSoftButtons = nil;
    __block SDLArtwork *testIcon = nil;
    __block SDLArtwork *testIcon2 = nil;
    
    beforeEach(^{
        testTextField1 = @"testTextField1";
        testTextField2 = @"testTextField2";
        testTextField3 = @"testTextField3";
        testAudio = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"test speech synthesizer string"];
        testSoftButtons = @[[[SDLSoftButtonObject alloc] initWithName:@"test soft button" text:@"test soft button text" artwork:nil handler:nil]];

        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        UIImage *testImage = [[UIImage alloc] initWithContentsOfFile:[testBundle pathForResource:@"testImageJPEG" ofType:@"jpeg"]];
        testIcon = [SDLArtwork artworkWithImage:testImage asImageFormat:SDLArtworkImageFormatJPG];
        UIImage *testImage2 = [[UIImage alloc] initWithContentsOfFile:[testBundle pathForResource:@"testImagePNG" ofType:@"png"]];
        testIcon2 = [SDLArtwork artworkWithImage:testImage2 asImageFormat:SDLArtworkImageFormatPNG];
    });
    
    it(@"should get and set correctly", ^{
        SDLAlertView *testAlertView = [[SDLAlertView alloc] init];
        testAlertView.text = testTextField1;
        testAlertView.secondaryText = testTextField2;
        testAlertView.tertiaryText = testTextField3;
        testAlertView.timeout = testTimeout;
        testAlertView.audio = testAudio;
        testAlertView.showWaitIndicator = testShowWaitIndicator;
        testAlertView.softButtons = testSoftButtons;
        testAlertView.icon = testIcon;
        
        expect(testAlertView.text).to(equal(testTextField1));
        expect(testAlertView.secondaryText).to(equal(testTextField2));
        expect(testAlertView.tertiaryText).to(equal(testTextField3));
        expect(testAlertView.timeout).to(equal(5.0));
        expect(testAlertView.audio).toNot(beNil());
        expect(testAlertView.audio.audioFiles).to(beNil());
        expect(testAlertView.audio.prompts).to(equal(testAudio.prompts));
        expect(testAlertView.showWaitIndicator).to(beFalse());
        expect(testAlertView.softButtons).to(equal(testSoftButtons));
        expect(testAlertView.icon).to(equal(testIcon));
    });
    
    describe(@"initializing", ^{
        it(@"should initialize correctly with initWithText:buttons:", ^{
            SDLAlertView *testAlertView = [[SDLAlertView alloc] initWithText:testTextField1 buttons:testSoftButtons];
            
            expect(testAlertView.text).to(equal(testTextField1));
            expect(testAlertView.secondaryText).to(beNil());
            expect(testAlertView.tertiaryText).to(beNil());
            expect(testAlertView.timeout).to(equal(5.0));
            expect(testAlertView.audio).to(beNil());
            expect(testAlertView.showWaitIndicator).to(beFalse());
            expect(testAlertView.softButtons).to(equal(testSoftButtons));
            expect(testAlertView.icon).to(beNil());
        });
        
        it(@"should initialize correctly with initWithText:secondaryText:tertiaryText:timeout: showWaitIndicator:audioIndication:buttons:icon:", ^{
            SDLAlertView *testAlertView = [[SDLAlertView alloc] initWithText:testTextField1 secondaryText:testTextField2 tertiaryText:testTextField3 timeout:testTimeout showWaitIndicator:testShowWaitIndicator audioIndication:testAudio buttons:testSoftButtons icon:testIcon];
            
            expect(testAlertView.text).to(equal(testTextField1));
            expect(testAlertView.secondaryText).to(equal(testTextField2));
            expect(testAlertView.tertiaryText).to(equal(testTextField3));
            expect(testAlertView.timeout).to(equal(5.0));
            expect(testAlertView.audio).to(equal(testAudio));
            expect(testAlertView.showWaitIndicator).to(beFalse());
            expect(testAlertView.softButtons).to(equal(testSoftButtons));
            expect(testAlertView.icon).to(equal(testIcon));
        });
        
        it(@"should return nil if not set", ^{
            SDLAlertView *testAlertView = [[SDLAlertView alloc] init];
            
            expect(testAlertView.text).to(beNil());
            expect(testAlertView.secondaryText).to(beNil());
            expect(testAlertView.tertiaryText).to(beNil());
            expect(testAlertView.timeout).to(equal(5.0));
            expect(testAlertView.audio).to(beNil());
            expect(testAlertView.showWaitIndicator).to(beFalse());
            expect(testAlertView.softButtons).to(beNil());
            expect(testAlertView.icon).to(beNil());
        });
    });

    describe(@"setting invalid data", ^{
        it(@"should thow an exception if any button has multiple states", ^{
            SDLAlertView *testAlertView = [[SDLAlertView alloc] init];

            SDLSoftButtonState *state1 = [[SDLSoftButtonState alloc] initWithStateName:@"state1" text:@"state 1" image:nil];
            SDLSoftButtonState *state2 = [[SDLSoftButtonState alloc] initWithStateName:@"state2" text:@"state 2" image:nil];
            SDLSoftButtonObject *testInvalidSoftButton = [[SDLSoftButtonObject alloc] initWithName:@"invalid soft button" states:@[state1, state2] initialStateName:state1.name handler:nil];
            SDLSoftButtonObject *testValidSoftButton = [[SDLSoftButtonObject alloc] initWithName:@"valid soft button" text:@"state 3" artwork:nil handler:nil];
            __block NSArray<SDLSoftButtonObject *> *testInvalidSoftButtons = @[testValidSoftButton, testInvalidSoftButton];

            expectAction(^{
                [testAlertView setSoftButtons:testInvalidSoftButtons];
            }).to(raiseException().named(@"InvalidSoftButtonStates"));
        });
    });

    describe(@"setting the default timeout", ^{
        it(@"should return 10 if a value greater than 10 has been set", ^{
            SDLAlertView.defaultTimeout = 15.0;
            expect(SDLAlertView.defaultTimeout).to(equal(10.0));
        });

        it(@"should return 3 if a value less than 3 has been set", ^{
            SDLAlertView.defaultTimeout = -2.0;
            expect(SDLAlertView.defaultTimeout).to(equal(3.0));
        });

        it(@"should return the set value if a value between 3 and 10 has been set", ^{
            SDLAlertView.defaultTimeout = 4.5;
            expect(SDLAlertView.defaultTimeout).to(equal(4.5));
        });

        it(@"should return the set value if 3 has been set", ^{
            SDLAlertView.defaultTimeout = 3.0;
            expect(SDLAlertView.defaultTimeout).to(equal(3.0));
        });

        it(@"should return the set value if 10 has been set", ^{
            SDLAlertView.defaultTimeout = 10.0;
            expect(SDLAlertView.defaultTimeout).to(equal(10.0));
        });
    });

    describe(@"setting the timeout", ^{
        __block SDLAlertView *testAlertView = nil;

        beforeEach(^{
            SDLAlertView.defaultTimeout = 5.0;
            testAlertView = [[SDLAlertView alloc] init];
        });

        it(@"should return the default timeout if it has not been set", ^{
            expect(testAlertView.timeout).to(equal(SDLAlertView.defaultTimeout));
        });

        it(@"should return the default timeout if 0 has been set", ^{
            testAlertView.timeout = 0.0;
            expect(testAlertView.timeout).to(equal(5.0));
        });

        it(@"should return 10 if a value greater than 10 has been set", ^{
            testAlertView.timeout = 15.0;
            expect(testAlertView.timeout).to(equal(10.0));
        });

        it(@"should return 3 if a value less than 3 has been set", ^{
            testAlertView.timeout = 2.25;
            expect(testAlertView.timeout).to(equal(3.0));
        });

        it(@"should return the set value if a value between 3 and 10 has been set", ^{
            testAlertView.timeout = 9.5;
            expect(testAlertView.timeout).to(equal(9.5));
        });

        it(@"should return the set value if 3 has been set", ^{
            testAlertView.timeout = 3.0;
            expect(testAlertView.timeout).to(equal(3.0));
        });

        it(@"should return the set value if 10 has been set", ^{
            testAlertView.timeout = 10.0;
            expect(testAlertView.timeout).to(equal(10.0));
        });
    });

    describe(@"canceling the alert", ^{
        __block SDLAlertView *testAlertView = nil;
        __block BOOL canceledHandlerCalled = NO;

        beforeEach(^{
            testAlertView = [[SDLAlertView alloc] init];
            testAlertView.canceledHandler = ^{
                canceledHandlerCalled = YES;
            };
        });

        it(@"should call the cancelled handler", ^{
            [testAlertView cancel];
            expect(canceledHandlerCalled).to(beTrue());
        });
    });

    describe(@"copying the alert", ^{
        __block SDLAlertView *testAlertView = nil;
        __block SDLAlertView *copiedTestAlertView = nil;

        beforeEach(^{
            testAlertView = [[SDLAlertView alloc] initWithText:testTextField1 secondaryText:testTextField2 tertiaryText:testTextField3 timeout:testTimeout showWaitIndicator:testShowWaitIndicator audioIndication:testAudio buttons:testSoftButtons icon:testIcon];
            copiedTestAlertView = [testAlertView copy];
        });

        it(@"should correctly copy the alert view", ^{
            expect(testAlertView).toNot(equal(copiedTestAlertView));

            expect(copiedTestAlertView.text).to(equal(testAlertView.text));
            expect(copiedTestAlertView.secondaryText).to(equal(testAlertView.secondaryText));
            expect(copiedTestAlertView.tertiaryText).to(equal(testAlertView.tertiaryText));
            expect(copiedTestAlertView.timeout).to(equal(testAlertView.timeout));
            expect(copiedTestAlertView.audio).toNot(equal(testAlertView.audio));
            expect(copiedTestAlertView.audio.prompts).to(equal(testAlertView.audio.prompts));
            expect(copiedTestAlertView.audio.audioFiles).to(beNil());
            expect(testAlertView.audio.audioFiles).to(beNil());
            expect(copiedTestAlertView.audio.playTone).to(equal(testAlertView.audio.playTone));
            expect(copiedTestAlertView.showWaitIndicator).to(equal(testAlertView.showWaitIndicator));
            expect(copiedTestAlertView.softButtons).to(equal(testAlertView.softButtons));
            expect(copiedTestAlertView.icon).to(equal(testAlertView.icon));
        });

        it(@"Should not update the copy if changes are made to the original", ^{
            testAlertView.text = @"changedText";
            testAlertView.secondaryText = @"changedSecondaryText";
            testAlertView.tertiaryText = @"changedTertiaryText";
            testAlertView.timeout = 45;
            testAlertView.audio = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"changedAudio"];
            testAlertView.showWaitIndicator = YES;
            testAlertView.softButtons = @[];
            testAlertView.icon = testIcon2;

            expect(copiedTestAlertView.text).toNot(equal(testAlertView.text));
            expect(copiedTestAlertView.secondaryText).toNot(equal(testAlertView.secondaryText));
            expect(copiedTestAlertView.tertiaryText).toNot(equal(testAlertView.tertiaryText));
            expect(copiedTestAlertView.timeout).toNot(equal(testAlertView.timeout));
            expect(copiedTestAlertView.audio).toNot(equal(testAlertView.audio));
            expect(copiedTestAlertView.showWaitIndicator).toNot(equal(testAlertView.showWaitIndicator));
            expect(copiedTestAlertView.softButtons).toNot(equal(testAlertView.softButtons));
            expect(copiedTestAlertView.icon).toNot(equal(testAlertView.icon));
        });
    });
});

QuickSpecEnd
