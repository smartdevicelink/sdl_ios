//
//  SDLAlertSpec.m
//  SmartDeviceLink

@import Quick;
@import Nimble;

#import "SDLAlert.h"
#import "SDLImage.h"
#import "SDLTTSChunk.h"
#import "SDLSoftButton.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLAlertSpec)

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
    __block SDLImage *testImage = nil;
    __block int testCancelID = 456;

    beforeEach(^{
        testTTSChunks = @[[[SDLTTSChunk alloc] init]];
        testTTSString = @"Hello World";
        testSoftButtons = @[[[SDLSoftButton alloc] init]];
        testImage = [[SDLImage alloc] initWithStaticIconName:SDLStaticIconNameBack];
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
            testRequest.alertIcon = testImage;
            testRequest.cancelID = @(testCancelID);

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(equal(testProgressIndicator));
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.alertIcon).to(equal(testImage));
            expect(testRequest.cancelID).to(equal(testCancelID));

            expect(testRequest.parameters.count).to(equal(10));
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
            expect(testRequest.alertIcon).to(beNil());
            expect(testRequest.cancelID).to(beNil());

            expect(testRequest.parameters.count).to(equal(0));
        });
    });

    describe(@"Initializing", ^{
        it(@"Should initialize correctly with a dictionary", ^{
            NSDictionary *dict = @{SDLRPCParameterNameRequest:
                                       @{SDLRPCParameterNameParameters:
                                             @{SDLRPCParameterNameAlertText1:testAlertText1,
                                               SDLRPCParameterNameAlertText2:testAlertText2,
                                               SDLRPCParameterNameAlertText3:testAlertText3,
                                               SDLRPCParameterNameTTSChunks:testTTSChunks,
                                               SDLRPCParameterNameDuration:@(testDuration),
                                               SDLRPCParameterNamePlayTone:@(testPlayTone),
                                               SDLRPCParameterNameProgressIndicator:@(testProgressIndicator),
                                               SDLRPCParameterNameSoftButtons:testSoftButtons,
                                               SDLRPCParameterNameAlertIcon:testImage,
                                               SDLRPCParameterNameCancelID:@(testCancelID)},
                                         SDLRPCParameterNameOperationName:SDLRPCFunctionNameAlert}};
            testRequest = [[SDLAlert alloc] initWithDictionary:dict];

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(equal(testProgressIndicator));
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.alertIcon).to(equal(testImage));
            expect(testRequest.cancelID).to(equal(testCancelID));

            expect(testRequest.parameters.count).to(equal(10));
        });

        it(@"Should initialize correctly with initWithAlertText:softButtons:playTone:ttsChunks:cancelID:", ^{
            testRequest = [[SDLAlert alloc] initWithAlertText:testAlertText1 softButtons:testSoftButtons playTone:testPlayTone ttsChunks:testTTSChunks alertIcon:testImage cancelID:testCancelID];

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(beNil());
            expect(testRequest.alertText3).to(beNil());
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(beNil());
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.alertIcon).to(equal(testImage));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithAlertText:softButtons:playTone:ttsChunks:cancelID:", ^{
            testRequest = [[SDLAlert alloc] initWithAlertText1:testAlertText1 alertText2:testAlertText2 alertText3:testAlertText3 softButtons:testSoftButtons playTone:testPlayTone ttsChunks:testTTSChunks duration:testDuration progressIndicator:testProgressIndicator alertIcon:testImage cancelID:testCancelID];

            expect(testRequest.alertText1).to(equal(testAlertText1));
            expect(testRequest.alertText2).to(equal(testAlertText2));
            expect(testRequest.alertText3).to(equal(testAlertText3));
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(equal(testDuration));
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(equal(testProgressIndicator));
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.alertIcon).to(equal(testImage));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithTTSChunks:playTone:", ^{
            testRequest = [[SDLAlert alloc] initWithTTSChunks:testTTSChunks playTone:testPlayTone];

            expect(testRequest.alertText1).to(beNil());
            expect(testRequest.alertText2).to(beNil());
            expect(testRequest.alertText3).to(beNil());
            expect(testRequest.ttsChunks).to(equal(testTTSChunks));
            expect(testRequest.duration).to(beNil());
            expect(testRequest.playTone).to(equal(testPlayTone));
            expect(testRequest.progressIndicator).to(beFalse());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.alertIcon).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });
    });

    afterEach(^{
        expect(testRequest.name).to(equal(SDLRPCFunctionNameAlert));
    });
});

QuickSpecEnd
