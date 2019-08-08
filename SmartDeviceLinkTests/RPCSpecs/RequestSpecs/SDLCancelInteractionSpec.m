//
//  SDLCancelInteractionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCancelInteraction.h"
#import "SDLFunctionID.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLCancelInteractionSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLCancelInteraction *testRequest = nil;
    __block UInt32 testFunctionID = 45;
    __block UInt32 testCancelID = 23;

    it(@"Should set and get correctly", ^{
        testRequest = [[SDLCancelInteraction alloc] init];
        testRequest.cancelID = @(testCancelID);
        testRequest.functionID = @(testFunctionID);

        expect(testRequest.cancelID).to(equal(testCancelID));
        expect(testRequest.functionID).to(equal(testFunctionID));

        expect(testRequest.name).to(match(SDLRPCFunctionNameCancelInteraction));
        expect(testRequest.parameters.count).to(equal(2));
    });

    it(@"Should return nil if not set", ^{
        testRequest = [[SDLCancelInteraction alloc] init];

        expect(testRequest.cancelID).to(beNil());
        expect(testRequest.functionID).to(beNil());

        expect(testRequest.parameters.count).to(equal(0));
    });

    describe(@"initializing", ^{
        it(@"Should initialize correctly with a dictionary", ^{
            NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                           SDLRPCParameterNameParameters:@{
                                                   SDLRPCParameterNameCancelID:@(testCancelID),
                                                   SDLRPCParameterNameFunctionID:@(testFunctionID)
                                                   },
                                           SDLRPCParameterNameOperationName:SDLRPCFunctionNameCancelInteraction}};
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLCancelInteraction alloc] initWithDictionary:dict];
            #pragma clang diagnostic pop

            expect(testRequest.cancelID).to(equal(testCancelID));
            expect(testRequest.functionID).to(equal(testFunctionID));

            expect(testRequest.parameters.count).to(equal(2));
        });

        it(@"Should initialize correctly with initWithfunctionID:", ^{
            testRequest = [[SDLCancelInteraction alloc] initWithfunctionID:testFunctionID];

            expect(testRequest.functionID).to(equal(testFunctionID));
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithfunctionID:cancelID:", ^{
            testRequest = [[SDLCancelInteraction alloc] initWithfunctionID:testFunctionID cancelID:testCancelID];

            expect(testRequest.functionID).to(equal(testFunctionID));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithAlertCancelID:", ^{
            testRequest = [[SDLCancelInteraction alloc] initWithAlertCancelID:testCancelID];

            expect(testRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameAlert]));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithSliderCancelID:", ^{
            testRequest = [[SDLCancelInteraction alloc] initWithSliderCancelID:testCancelID];

            expect(testRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameSlider]));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithScrollableMessageCancelID:", ^{
            testRequest = [[SDLCancelInteraction alloc] initWithScrollableMessageCancelID:testCancelID];

            expect(testRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameScrollableMessage]));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithPerformInteractionCancelID:", ^{
            testRequest = [[SDLCancelInteraction alloc] initWithPerformInteractionCancelID:testCancelID];

            expect(testRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNamePerformInteraction]));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithAlert:", ^{
            testRequest = [[SDLCancelInteraction alloc] initWithAlert];

            expect(testRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameAlert]));
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithSlider:", ^{
            testRequest = [[SDLCancelInteraction alloc] initWithSlider];

            expect(testRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameSlider]));
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithScrollableMessage:", ^{
            testRequest = [[SDLCancelInteraction alloc] initWithScrollableMessage];

            expect(testRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameScrollableMessage]));
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithPerformInteraction:", ^{
            testRequest = [[SDLCancelInteraction alloc] initWithPerformInteraction];

            expect(testRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNamePerformInteraction]));
            expect(testRequest.cancelID).to(beNil());
        });
    });

    afterEach(^{
        expect(testRequest.name).to(match(SDLRPCFunctionNameCancelInteraction));
    });
});

QuickSpecEnd


