//
//  SDLAlertSpec.m
//  SmartDeviceLink

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAlert.h"
#import "SDLTTSChunk.h"
#import "SDLSoftButton.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLAlertSpec)

static UInt16 const SDLDefaultDuration = 5000;

describe(@"Getter/Setter Tests", ^ {
    __block SDLAlert *testRequest = nil;
    __block NSString *testAlertText1 = @"alert#1";
    __block NSString *testAlertText2 = @"alert#2";
    __block NSString *testAlertText3 = @"alert#3";
    __block int testDuration = 45;
    __block BOOL testPlayTone = YES;
    __block BOOL testProgressIndicator = NO;
    __block NSArray<SDLSoftButton *> *testSoftButtons = nil;
    __block NSArray<SDLTTSChunk *> *testTTSChunks = nil;
    __block NSString *testTTSString = nil;
    __block int testCancelID = 456;

    beforeEach(^{
        testTTSChunks = @[[[SDLTTSChunk alloc] init]];
        testTTSString = @"Hello World";
        testSoftButtons = @[[[SDLSoftButton alloc] init]];
    });

    context(@"Getter/Setter Tests", ^{
        it(@"Should set and get correctly", ^{
            testRequest = [[SDLAlert alloc] init];

            testRequest.alertText1 = testAlertText1;
            testRequest.alertText2 = testAlertText2;
            testRequest.alertText3 = testAlertText3;
            testRequest.ttsChunks = testTTSChunks;
            testRequest.duration = @(testDuration);
            testRequest.playTone = @(testPlayTone);
            testRequest.progressIndicator = @(testProgressIndicator);
            testRequest.softButtons = testSoftButtons;
            testRequest.cancelID = @(testCancelID);

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(equal(testProgressIndicator));
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.cancelID).to(equal(testCancelID));

            expect(testRequest.parameters.count).to(equal(9));
        });

        it(@"Should return nil if not set", ^{
            testRequest = [[SDLAlert alloc] init];

            expect(testRequest.alertText1).to(beNil());
            expect(testRequest.alertText2).to(beNil());
            expect(testRequest.alertText3).to(beNil());
            expect(testRequest.ttsChunks).to(beNil());
            expect(testRequest.duration).to(beNil());
            expect(testRequest.playTone).to(beNil());
            expect(testRequest.progressIndicator).to(beNil());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(beNil());

            expect(testRequest.parameters.count).to(equal(0));
        });
    });

    describe(@"Initializing", ^{
        it(@"Should initialize correctly with a dictionary", ^{
            NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameRequest:
                                                       @{SDLRPCParameterNameParameters:
                                                             @{SDLRPCParameterNameAlertText1:testAlertText1,
                                                               SDLRPCParameterNameAlertText2:testAlertText2,
                                                               SDLRPCParameterNameAlertText3:testAlertText3,
                                                               SDLRPCParameterNameTTSChunks:testTTSChunks,
                                                               SDLRPCParameterNameDuration:@(testDuration),
                                                               SDLRPCParameterNamePlayTone:@(testPlayTone),
                                                               SDLRPCParameterNameProgressIndicator:@(testProgressIndicator),
                                                               SDLRPCParameterNameSoftButtons:testSoftButtons,
                                                               SDLRPCParameterNameCancelID:@(testCancelID)},
                                                         SDLRPCParameterNameOperationName:SDLRPCFunctionNameAlert}};
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLAlert alloc] initWithDictionary:dict];
            #pragma clang diagnostic pop

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(equal(testProgressIndicator));
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.cancelID).to(equal(testCancelID));

            expect(testRequest.parameters.count).to(equal(9));
        });

        it(@"Should initialize correctly with initWithAlertText:softButtons:playTone:ttsChunks:cancelID:", ^{
            testRequest = [[SDLAlert alloc] initWithAlertText:testAlertText1 softButtons:testSoftButtons playTone:testPlayTone ttsChunks:testTTSChunks cancelID:testCancelID];

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(beNil());
            expect(testRequest.alertText3).to(beNil());
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(beNil());
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithTTS:playTone:cancelID:", ^{
            testRequest = [[SDLAlert alloc] initWithTTS:testTTSChunks playTone:testPlayTone cancelID:testCancelID];

            expect(testRequest.alertText1).to(beNil());
            expect(testRequest.alertText2).to(beNil());
            expect(testRequest.alertText3).to(beNil());
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(beNil());
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithAlertText:softButtons:playTone:ttsChunks:cancelID:", ^{
            testRequest = [[SDLAlert alloc] initWithAlertText1:testAlertText1 alertText2:testAlertText2 alertText3:testAlertText3 softButtons:testSoftButtons playTone:testPlayTone ttsChunks:testTTSChunks duration:testDuration progressIndicator:testProgressIndicator cancelID:testCancelID];

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(equal(testProgressIndicator));
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithAlertText1:alertText2:duration:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLAlert alloc] initWithAlertText1:testAlertText1 alertText2:testAlertText2 duration:testDuration];
            #pragma clang diagnostic pop

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(beNil());
            expect(testRequest.ttsChunks).to(beNil());
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(beFalse());
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithAlertText1:alertText2:alertText3:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLAlert alloc] initWithAlertText1:testAlertText1 alertText2:testAlertText2 alertText3:testAlertText3];
            #pragma clang diagnostic pop

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(beNil());
            expect(testRequest.duration).to(equal(SDLDefaultDuration));
            expect(testRequest.playTone).to(beFalse());
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithAlertText1:alertText2:alertText3:duration", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLAlert alloc] initWithAlertText1:testAlertText1 alertText2:testAlertText2 alertText3:testAlertText3 duration:testDuration];
            #pragma clang diagnostic pop

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(beNil());
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(beFalse());
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithAlertText1:alertText2:alertText3:duration:softButtons:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLAlert alloc] initWithAlertText1:testAlertText1 alertText2:testAlertText2 alertText3:testAlertText3 duration:testDuration softButtons:testSoftButtons];
            #pragma clang diagnostic pop

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(beNil());
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(beFalse());
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithTTS:playTone:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLAlert alloc] initWithTTS:testTTSString playTone:testPlayTone];
            #pragma clang diagnostic pop

            expect(testRequest.alertText1).to(beNil());
            expect(testRequest.alertText2).to(beNil());
            expect(testRequest.alertText3).to(beNil());
            expect(testRequest.ttsChunks).to(equal([SDLTTSChunk textChunksFromString:testTTSString]));
            expect(testRequest.duration).to(equal(SDLDefaultDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithTTS:alertText1:alertText2:playTone:duration:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLAlert alloc] initWithTTS:testTTSString alertText1:testAlertText1 alertText2:testAlertText2 playTone:testPlayTone duration:testDuration];
            #pragma clang diagnostic pop

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(beNil());
            expect(testRequest.ttsChunks).to(equal([SDLTTSChunk textChunksFromString:testTTSString]));
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithTTS:alertText1:alertText2:alertText3:playTone:duration:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLAlert alloc] initWithTTS:testTTSString alertText1:testAlertText1 alertText2:testAlertText2 alertText3:testAlertText3 playTone:testPlayTone duration:testDuration];
            #pragma clang diagnostic pop

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(equal([SDLTTSChunk textChunksFromString:testTTSString]));
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithTTSChunks:playTone:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLAlert alloc] initWithTTSChunks:testTTSChunks playTone:testPlayTone];
            #pragma clang diagnostic pop

            expect(testRequest.alertText1).to(beNil());
            expect(testRequest.alertText2).to(beNil());
            expect(testRequest.alertText3).to(beNil());
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(equal(SDLDefaultDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithTTSChunks:alertText1:alertText2:alertText3:playTone:softButtons:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLAlert alloc] initWithTTSChunks:testTTSChunks alertText1:testAlertText1 alertText2:testAlertText2 alertText3:testAlertText3 playTone:testPlayTone softButtons:testSoftButtons];
            #pragma clang diagnostic pop

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(equal(SDLDefaultDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithTTSChunks:alertText1:alertText2:alertText3:playTone:duration:softButtons:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLAlert alloc] initWithTTSChunks:testTTSChunks alertText1:testAlertText1 alertText2:testAlertText2 alertText3:testAlertText3 playTone:testPlayTone duration:testDuration softButtons:testSoftButtons];
            #pragma clang diagnostic pop

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.cancelID).to(beNil());
        });
    });

    afterEach(^{
        expect(testRequest.name).to(equal(SDLRPCFunctionNameAlert));
    });
});

QuickSpecEnd
