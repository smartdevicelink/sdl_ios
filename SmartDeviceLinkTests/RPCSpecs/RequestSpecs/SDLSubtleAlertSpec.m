//
//  SDLSubtleAlertSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 7/28/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLImage.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSoftButton.h"
#import "SDLSubtleAlert.h"
#import "SDLTTSChunk.h"

QuickSpecBegin(SDLSubtleAlertSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLSubtleAlert *testSubtleAlert = nil;
    __block NSString *testAlertText1 = nil;
    __block NSString *testAlertText2 = nil;
    __block SDLImage *testAlertIcon = nil;
    __block NSArray<SDLTTSChunk *> *testTTSChunks = nil;
    __block int testDuration = 5600;
    __block NSArray<SDLSoftButton *> *testSoftButtons = nil;
    __block int testCancelID = 34;

    beforeEach(^{
        testAlertText1 = @"test alert text 1";
        testAlertText2 = @"test alert text 2";
        testAlertIcon = [[SDLImage alloc] initWithStaticIconName:SDLStaticIconNameKey];
        testTTSChunks = [SDLTTSChunk textChunksFromString:@"alert text"];
        testSoftButtons = @[[[SDLSoftButton alloc] init]];
    });

    it(@"Should set and get correctly", ^{
        testSubtleAlert = [[SDLSubtleAlert alloc] init];
        testSubtleAlert.alertText1 = testAlertText1;
        testSubtleAlert.alertText2 = testAlertText2;
        testSubtleAlert.alertIcon = testAlertIcon;
        testSubtleAlert.ttsChunks = testTTSChunks;
        testSubtleAlert.duration = @(testDuration);
        testSubtleAlert.softButtons = testSoftButtons;
        testSubtleAlert.cancelID = @(testCancelID);

        expect(testSubtleAlert.alertText1).to(equal(testAlertText1));
        expect(testSubtleAlert.alertText2).to(equal(testAlertText2));
        expect(testSubtleAlert.alertIcon).to(equal(testAlertIcon));
        expect(testSubtleAlert.ttsChunks).to(equal(testTTSChunks));
        expect(testSubtleAlert.duration).to(equal(testDuration));
        expect(testSubtleAlert.softButtons).to(equal(testSoftButtons));
        expect(testSubtleAlert.cancelID).to(equal(testCancelID));
    });

    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameAlertText1:testAlertText1,
                                               SDLRPCParameterNameAlertText2:testAlertText2,
                                               SDLRPCParameterNameAlertIcon:testAlertIcon,
                                               SDLRPCParameterNameTTSChunks:testTTSChunks,
                                               SDLRPCParameterNameDuration:@(testDuration),
                                               SDLRPCParameterNameSoftButtons:testSoftButtons,
                                               SDLRPCParameterNameCancelID:@(testCancelID)
                                       },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameSubtleAlert}};
        testSubtleAlert = [[SDLSubtleAlert alloc] initWithDictionary:dict];

        expect(testSubtleAlert.alertText1).to(equal(testAlertText1));
        expect(testSubtleAlert.alertText2).to(equal(testAlertText2));
        expect(testSubtleAlert.alertIcon).to(equal(testAlertIcon));
        expect(testSubtleAlert.ttsChunks).to(equal(testTTSChunks));
        expect(testSubtleAlert.duration).to(equal(testDuration));
        expect(testSubtleAlert.softButtons).to(equal(testSoftButtons));
        expect(testSubtleAlert.cancelID).to(equal(testCancelID));
    });

    it(@"Should initialize correctly with initWithAlertText1:alertText2:alertIcon:ttsChunks:duration:softButtons:cancelID:", ^{
        testSubtleAlert = [[SDLSubtleAlert alloc] initWithAlertText1:testAlertText1 alertText2:testAlertText2 alertIcon:testAlertIcon ttsChunks:testTTSChunks duration:@(testDuration) softButtons:testSoftButtons cancelID:@(testCancelID)];

        expect(testSubtleAlert.alertText1).to(equal(testAlertText1));
        expect(testSubtleAlert.alertText2).to(equal(testAlertText2));
        expect(testSubtleAlert.alertIcon).to(equal(testAlertIcon));
        expect(testSubtleAlert.ttsChunks).to(equal(testTTSChunks));
        expect(testSubtleAlert.duration).to(equal(testDuration));
        expect(testSubtleAlert.softButtons).to(equal(testSoftButtons));
        expect(testSubtleAlert.cancelID).to(equal(testCancelID));
    });

    it(@"Should return nil if not set", ^{
        testSubtleAlert = [[SDLSubtleAlert alloc] init];

        expect(testSubtleAlert.alertText1).to(beNil());
        expect(testSubtleAlert.alertText2).to(beNil());
        expect(testSubtleAlert.alertIcon).to(beNil());
        expect(testSubtleAlert.ttsChunks).to(beNil());
        expect(testSubtleAlert.duration).to(beNil());
        expect(testSubtleAlert.softButtons).to(beNil());
        expect(testSubtleAlert.cancelID).to(beNil());
    });
});

QuickSpecEnd

