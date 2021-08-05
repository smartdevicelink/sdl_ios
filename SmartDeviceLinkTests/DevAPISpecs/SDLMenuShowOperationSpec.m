//
//  SDLMenuShowOperationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/16/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>
#import <Quick/Quick.h>

#import <SmartDeviceLink/SmartDeviceLink.h>
#import "SDLMenuShowOperation.h"
#import "TestConnectionManager.h"

@interface SDLMenuShowOperation ()

@property (strong, nonatomic, nullable) SDLMenuCell *submenuCell;

@end

QuickSpecBegin(SDLMenuShowOperationSpec)

describe(@"the show menu operation", ^{
    __block SDLMenuShowOperation *testOp = nil;
    __block TestConnectionManager *testConnectionManager = nil;
    __block NSError *resultError = nil;
    __block BOOL callbackCalled = NO;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testOp = [[SDLMenuShowOperation alloc] initWithConnectionManager:testConnectionManager toMenuCell:nil completionHandler:^(NSError * _Nullable error) {
            resultError = error;
            callbackCalled = YES;
        }];
        resultError = nil;
        callbackCalled = NO;
    });

    // opening to the main menu
    context(@"opening to the main menu", ^{
        beforeEach(^{
            [testOp start];
        });

        it(@"should send the RPC request", ^{
            expect(testConnectionManager.receivedRequests).to(haveCount(1));
        });

        // when the response is not SUCCESS or WARNINGS
        context(@"when the response is not SUCCESS or WARNINGS", ^{
            beforeEach(^{
                SDLShowAppMenuResponse *response = [[SDLShowAppMenuResponse alloc] init];
                response.success = @NO;
                response.resultCode = SDLResultRejected;

                [testConnectionManager respondToLastRequestWithResponse:response];
            });

            it(@"should set the error and finish", ^{
                expect(testOp.isFinished).to(beTrue());
                expect(resultError).toNot(beNil());
                expect(callbackCalled).to(beTrue());
            });
        });

        // when the response is SUCCESS
        context(@"when the response is SUCCESS", ^{
            beforeEach(^{
                SDLShowAppMenuResponse *response = [[SDLShowAppMenuResponse alloc] init];
                response.success = @YES;
                response.resultCode = SDLResultSuccess;

                [testConnectionManager respondToLastRequestWithResponse:response];
            });

            it(@"should not set the error and finish", ^{
                expect(testOp.isFinished).to(beTrue());
                expect(resultError).to(beNil());
                expect(callbackCalled).to(beTrue());
            });
        });

        // when the response is WARNINGS
        context(@"when the response is WARNINGS", ^{
            beforeEach(^{
                SDLShowAppMenuResponse *response = [[SDLShowAppMenuResponse alloc] init];
                response.success = @YES;
                response.resultCode = SDLResultWarnings;

                [testConnectionManager respondToLastRequestWithResponse:response];
            });

            it(@"should not set the error and finish", ^{
                expect(testOp.isFinished).to(beTrue());
                expect(resultError).to(beNil());
                expect(callbackCalled).to(beTrue());
            });
        });
    });

    // opening to an inner menu
    context(@"opening to an inner menu", ^{
        __block SDLMenuCell *openToCell = nil;
        __block SDLMenuCell *subcell = nil;
        beforeEach(^{
            subcell = [[SDLMenuCell alloc] initWithTitle:@"Subcell" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) { }];
            openToCell = [[SDLMenuCell alloc] initWithTitle:@"Test submenu" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil submenuLayout:nil subCells:@[subcell]];
            testOp.submenuCell = openToCell;
            [testOp start];
        });

        // when the response is not SUCCESS or WARNINGS
        context(@"when the response is not SUCCESS or WARNINGS", ^{
            beforeEach(^{
                SDLShowAppMenuResponse *response = [[SDLShowAppMenuResponse alloc] init];
                response.success = @NO;
                response.resultCode = SDLResultRejected;

                [testConnectionManager respondToLastRequestWithResponse:response];
            });

            it(@"should set the error and finish", ^{
                expect(resultError).toNot(beNil());
                expect(callbackCalled).to(beTrue());
                expect(testOp.isFinished).to(beTrue());
            });
        });

        // when the response is SUCCESS
        context(@"when the response is SUCCESS", ^{
            beforeEach(^{
                SDLShowAppMenuResponse *response = [[SDLShowAppMenuResponse alloc] init];
                response.success = @YES;
                response.resultCode = SDLResultSuccess;

                [testConnectionManager respondToLastRequestWithResponse:response];
            });

            it(@"should not set the error and finish", ^{
                expect(resultError).to(beNil());
                expect(callbackCalled).to(beTrue());
                expect(testOp.isFinished).to(beTrue());
            });
        });

        // when the response is WARNINGS
        context(@"when the response is WARNINGS", ^{
            beforeEach(^{
                SDLShowAppMenuResponse *response = [[SDLShowAppMenuResponse alloc] init];
                response.success = @YES;
                response.resultCode = SDLResultWarnings;

                [testConnectionManager respondToLastRequestWithResponse:response];
            });

            it(@"should not set the error and finish", ^{
                expect(resultError).to(beNil());
                expect(callbackCalled).to(beTrue());
                expect(testOp.isFinished).to(beTrue());
            });
        });
    });
});

QuickSpecEnd
