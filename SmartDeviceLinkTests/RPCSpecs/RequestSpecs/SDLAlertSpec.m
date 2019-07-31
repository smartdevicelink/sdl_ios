//
//  SDLAlertSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAlert.h"
#import "SDLImage.h"
#import "SDLTTSChunk.h"
#import "SDLSoftButton.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLAlertSpec)

SDLTTSChunk *tts = [[SDLTTSChunk alloc] init];
SDLSoftButton *button = [[SDLSoftButton alloc] init];
SDLImage *testImage = [[SDLImage alloc] initWithName:@"testImage" isTemplate:YES];

describe(@"Alert spec", ^{
    UInt16 defaultDuration = 5000;

    NSString *testText1 = @"Test Text 1";
    NSString *testText2 = @"Test Text 2";
    NSString *testText3 = @"Test Text 3";
    NSString *testTTSString = @"Test TTS";
    BOOL testPlayTone = YES;
    BOOL testProgressIndicator = YES;
    UInt16 testDuration = 7847;

    describe(@"initializer tests", ^{
        it(@"should initialize correctly with initWithAlertText1:alertText2:duration:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLAlert *testAlert = [[SDLAlert alloc] initWithAlertText1:testText1 alertText2:testText2 duration:testDuration];
#pragma clang diagnostic pop

            expect(testAlert.alertText1).to(equal(testText1));
            expect(testAlert.alertText2).to(equal(testText2));
            expect(testAlert.alertText3).to(beNil());
            expect(testAlert.ttsChunks).to(beNil());
            expect(testAlert.duration).to(equal(testDuration));
            expect(testAlert.playTone).to(beFalse());
            expect(testAlert.progressIndicator).to(beFalse());
            expect(testAlert.softButtons).to(beNil());
            expect(testAlert.alertIcon).to(beNil());
        });

        it(@"should initialize correctly with initWithAlertText1:alertText2:alertText3:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLAlert *testAlert = [[SDLAlert alloc] initWithAlertText1:testText1 alertText2:testText2 alertText3:testText3];
#pragma clang diagnostic pop

            expect(testAlert.alertText1).to(equal(testText1));
            expect(testAlert.alertText2).to(equal(testText2));
            expect(testAlert.alertText3).to(equal(testText3));
            expect(testAlert.ttsChunks).to(beNil());
            expect(testAlert.duration).to(equal(defaultDuration));
            expect(testAlert.playTone).to(beFalse());
            expect(testAlert.progressIndicator).to(beFalse());
            expect(testAlert.softButtons).to(beNil());
            expect(testAlert.alertIcon).to(beNil());
        });

        it(@"should initialize correctly with initWithAlertText1:alertText2:alertText3:duration:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLAlert *testAlert = [[SDLAlert alloc] initWithAlertText1:testText1 alertText2:testText2 alertText3:testText3 duration:testDuration];
#pragma clang diagnostic pop

            expect(testAlert.alertText1).to(equal(testText1));
            expect(testAlert.alertText2).to(equal(testText2));
            expect(testAlert.alertText3).to(equal(testText3));
            expect(testAlert.ttsChunks).to(beNil());
            expect(testAlert.duration).to(equal(testDuration));
            expect(testAlert.playTone).to(beFalse());
            expect(testAlert.progressIndicator).to(beFalse());
            expect(testAlert.softButtons).to(beNil());
            expect(testAlert.alertIcon).to(beNil());
        });

        it(@"should initialize correctly with initWithAlertText1:alertText2:alertText3:duration:softButtons:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLAlert *testAlert = [[SDLAlert alloc] initWithAlertText1:testText1 alertText2:testText2 alertText3:testText3 duration:testDuration softButtons:@[button]];
#pragma clang diagnostic pop

            expect(testAlert.alertText1).to(equal(testText1));
            expect(testAlert.alertText2).to(equal(testText2));
            expect(testAlert.alertText3).to(equal(testText3));
            expect(testAlert.ttsChunks).to(beNil());
            expect(testAlert.duration).to(equal(testDuration));
            expect(testAlert.playTone).to(beFalse());
            expect(testAlert.progressIndicator).to(beFalse());
            expect(testAlert.softButtons).to(haveCount(1));
            expect(testAlert.alertIcon).to(beNil());
        });

        it(@"should initialize correctly with initWithTTS:alertText1:alertText2:playTone:duration:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLAlert *testAlert = [[SDLAlert alloc] initWithTTS:testTTSString alertText1:testText1 alertText2:testText2 playTone:testPlayTone duration:testDuration];
#pragma clang diagnostic pop

            expect(testAlert.alertText1).to(equal(testText1));
            expect(testAlert.alertText2).to(equal(testText2));
            expect(testAlert.alertText3).to(beNil());
            expect(testAlert.ttsChunks.firstObject.text).to(equal(testTTSString));
            expect(testAlert.duration).to(equal(testDuration));
            expect(testAlert.playTone).to(beTrue());
            expect(testAlert.progressIndicator).to(beFalse());
            expect(testAlert.softButtons).to(beNil());
            expect(testAlert.alertIcon).to(beNil());
        });

        it(@"should initialize correctly with initWithTTS:alertText1:alertText2:alertText3:playTone:duration:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLAlert *testAlert = [[SDLAlert alloc] initWithTTS:testTTSString alertText1:testText1 alertText2:testText2 alertText3:testText3 playTone:testPlayTone duration:testDuration];
#pragma clang diagnostic pop

            expect(testAlert.alertText1).to(equal(testText1));
            expect(testAlert.alertText2).to(equal(testText2));
            expect(testAlert.alertText3).to(equal(testText3));
            expect(testAlert.ttsChunks.firstObject.text).to(equal(testTTSString));
            expect(testAlert.duration).to(equal(testDuration));
            expect(testAlert.playTone).to(equal(testPlayTone));
            expect(testAlert.progressIndicator).to(beFalse());
            expect(testAlert.softButtons).to(beNil());
            expect(testAlert.alertIcon).to(beNil());
        });

        it(@"should initialize correctly with initWithTTS:playTone:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLAlert *testAlert = [[SDLAlert alloc] initWithTTS:testTTSString playTone:testPlayTone];
#pragma clang diagnostic pop

            expect(testAlert.alertText1).to(beNil());
            expect(testAlert.alertText2).to(beNil());
            expect(testAlert.alertText3).to(beNil());
            expect(testAlert.ttsChunks.firstObject.text).to(equal(testTTSString));
            expect(testAlert.duration).to(equal(defaultDuration));
            expect(testAlert.playTone).to(equal(testPlayTone));
            expect(testAlert.progressIndicator).to(beFalse());
            expect(testAlert.softButtons).to(beNil());
            expect(testAlert.alertIcon).to(beNil());
        });

        it(@"should initialize correctly with initWithTTSChunks:alertText1:alertText2:alertText3:playTone:softButtons:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLAlert *testAlert = [[SDLAlert alloc] initWithTTSChunks:@[tts] alertText1:testText1 alertText2:testText2 alertText3:testText3 playTone:testPlayTone softButtons:@[button]];
#pragma clang diagnostic pop

            expect(testAlert.alertText1).to(equal(testText1));
            expect(testAlert.alertText2).to(equal(testText2));
            expect(testAlert.alertText3).to(equal(testText3));
            expect(testAlert.ttsChunks).to(haveCount(1));
            expect(testAlert.duration).to(equal(defaultDuration));
            expect(testAlert.playTone).to(equal(testPlayTone));
            expect(testAlert.progressIndicator).to(beFalse());
            expect(testAlert.softButtons).to(haveCount(1));
            expect(testAlert.alertIcon).to(beNil());
        });

        it(@"should initialize correctly with initWithTTSChunks:alertText1:alertText2:alertText3:playTone:duration:softButtons:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLAlert *testAlert = [[SDLAlert alloc] initWithTTSChunks:@[tts] alertText1:testText1 alertText2:testText2 alertText3:testText3 playTone:testPlayTone duration:testDuration softButtons:@[button]];
#pragma clang diagnostic pop

            expect(testAlert.alertText1).to(equal(testText1));
            expect(testAlert.alertText2).to(equal(testText2));
            expect(testAlert.alertText3).to(equal(testText3));
            expect(testAlert.ttsChunks).to(haveCount(1));
            expect(testAlert.duration).to(equal(testDuration));
            expect(testAlert.playTone).to(equal(testPlayTone));
            expect(testAlert.progressIndicator).to(beFalse());
            expect(testAlert.softButtons).to(haveCount(1));
            expect(testAlert.alertIcon).to(beNil());
        });

        it(@"should initialize correctly with initWithAlertText1:alertText2:", ^{
            SDLAlert *testAlert = [[SDLAlert alloc] initWithAlertText1:testText1 alertText2:testText2];

            expect(testAlert.alertText1).to(equal(testText1));
            expect(testAlert.alertText2).to(equal(testText2));
            expect(testAlert.alertText3).to(beNil());
            expect(testAlert.ttsChunks).to(beNil());
            expect(testAlert.duration).to(equal(defaultDuration));
            expect(testAlert.playTone).to(beFalse());
            expect(testAlert.progressIndicator).to(beFalse());
            expect(testAlert.softButtons).to(beNil());
            expect(testAlert.alertIcon).to(beNil());
        });

        it(@"should initialize correctly with initWithTTSChunks:playTone:", ^{
            SDLAlert *testAlert = [[SDLAlert alloc] initWithTTSChunks:@[tts] playTone:testPlayTone];

            expect(testAlert.alertText1).to(beNil());
            expect(testAlert.alertText2).to(beNil());
            expect(testAlert.alertText3).to(beNil());
            expect(testAlert.ttsChunks).to(haveCount(1));
            expect(testAlert.duration).to(equal(defaultDuration));
            expect(testAlert.playTone).to(equal(testPlayTone));
            expect(testAlert.progressIndicator).to(beFalse());
            expect(testAlert.softButtons).to(beNil());
            expect(testAlert.alertIcon).to(beNil());
        });

        it(@"should initialize correctly with initWithAlertText1:alertText2:alertText3:ttsChunks:playTone:progressIndicator:duration:softButtons:alertIcon:", ^{
            SDLAlert *testAlert = [[SDLAlert alloc] initWithAlertText1:testText1 alertText2:testText2 alertText3:testText3 ttsChunks:@[tts] playTone:testPlayTone progressIndicator:testProgressIndicator duration:testDuration softButtons:@[button] alertIcon:testImage];

            expect(testAlert.alertText1).to(equal(testText1));
            expect(testAlert.alertText2).to(equal(testText2));
            expect(testAlert.alertText3).to(equal(testText3));
            expect(testAlert.ttsChunks).to(haveCount(1));
            expect(testAlert.duration).to(equal(testDuration));
            expect(testAlert.playTone).to(equal(testPlayTone));
            expect(testAlert.progressIndicator).to(beTrue());
            expect(testAlert.softButtons).to(haveCount(1));
            expect(testAlert.alertIcon.value).to(equal(testImage.value));
        });
    });

    describe(@"Getter/Setter Tests", ^ {
        it(@"Should set and get correctly", ^ {
            SDLAlert* testRequest = [[SDLAlert alloc] init];

            testRequest.alertText1 = @"alert#1";
            testRequest.alertText2 = @"alert#2";
            testRequest.alertText3 = @"alert#3";
            testRequest.ttsChunks = @[tts];
            testRequest.duration = @4357;
            testRequest.playTone = @YES;
            testRequest.progressIndicator = @NO;
            testRequest.softButtons = @[button];
            testRequest.alertIcon = testImage;

            expect(testRequest.alertText1).to(equal(@"alert#1"));
            expect(testRequest.alertText2).to(equal(@"alert#2"));
            expect(testRequest.alertText3).to(equal(@"alert#3"));
            expect(testRequest.ttsChunks).to(equal(@[tts]));
            expect(testRequest.duration).to(equal(@4357));
            expect(testRequest.playTone).to(equal(@YES));
            expect(testRequest.progressIndicator).to(equal(@NO));
            expect(testRequest.softButtons).to(equal(@[button]));
            expect(testRequest.alertIcon).to(equal(testImage));
        });

        it(@"Should get correctly when initialized", ^ {
            NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameRequest:
                                                       @{SDLRPCParameterNameParameters:
                                                             @{SDLRPCParameterNameAlertText1: @"alert#1",
                                                               SDLRPCParameterNameAlertText2: @"alert#2",
                                                               SDLRPCParameterNameAlertText3: @"alert#3",
                                                               SDLRPCParameterNameTTSChunks: @[tts],
                                                               SDLRPCParameterNameDuration: @4357,
                                                               SDLRPCParameterNamePlayTone: @YES,
                                                               SDLRPCParameterNameProgressIndicator: @NO,
                                                               SDLRPCParameterNameSoftButtons: @[button],
                                                               SDLRPCParameterNameAlertIcon: testImage
                                                               },
                                                         SDLRPCParameterNameOperationName: SDLRPCFunctionNameAlert
                                                         }
                                                   };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLAlert* testRequest = [[SDLAlert alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

            expect(testRequest.alertText1).to(equal(@"alert#1"));
            expect(testRequest.alertText2).to(equal(@"alert#2"));
            expect(testRequest.alertText3).to(equal(@"alert#3"));
            expect(testRequest.ttsChunks).to(equal([@[tts] mutableCopy]));
            expect(testRequest.duration).to(equal(@4357));
            expect(testRequest.playTone).to(equal(@YES));
            expect(testRequest.progressIndicator).to(equal(@NO));
            expect(testRequest.softButtons).to(equal([@[button] mutableCopy]));
        });

        it(@"Should handle NSNull", ^{
            NSDictionary* dict = @{SDLRPCParameterNameRequest:
                                       @{SDLRPCParameterNameParameters:
                                             @{SDLRPCParameterNameAlertText1: @"alert#1",
                                               SDLRPCParameterNameAlertText2: @"alert#2",
                                               SDLRPCParameterNameAlertText3: @"alert#3",
                                               SDLRPCParameterNameTTSChunks: @[tts],
                                               SDLRPCParameterNameDuration: @4357,
                                               SDLRPCParameterNamePlayTone: @YES,
                                               SDLRPCParameterNameProgressIndicator: @NO,
                                               SDLRPCParameterNameSoftButtons: [NSNull null],
                                               SDLRPCParameterNameAlertIcon: testImage
                                               },
                                         SDLRPCParameterNameOperationName:SDLRPCFunctionNameAlert}
                                   };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLAlert* testRequest = [[SDLAlert alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
            expectAction(^{
                NSArray<SDLSoftButton *> *softButtons = testRequest.softButtons;
            }).to(raiseException());
        });

        it(@"Should return nil if not set", ^ {
            SDLAlert* testRequest = [[SDLAlert alloc] init];

            expect(testRequest.alertText1).to(beNil());
            expect(testRequest.alertText2).to(beNil());
            expect(testRequest.alertText3).to(beNil());
            expect(testRequest.ttsChunks).to(beNil());
            expect(testRequest.duration).to(beNil());
            expect(testRequest.playTone).to(beNil());
            expect(testRequest.progressIndicator).to(beNil());
            expect(testRequest.softButtons).to(beNil());
        });
    });
});

QuickSpecEnd
