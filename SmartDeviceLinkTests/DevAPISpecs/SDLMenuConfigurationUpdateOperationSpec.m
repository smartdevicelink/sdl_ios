//
//  SDLMenuConfigurationUpdateOperationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/16/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>
#import <Quick/Quick.h>

#import <SmartDeviceLink/SmartDeviceLink.h>
#import "SDLMenuConfigurationUpdateOperation.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLMenuConfigurationUpdateOperationSpec)

describe(@"a menu configuration update operation", ^{
    __block SDLMenuConfigurationUpdateOperation *testOp = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block SDLWindowCapability *testWindowCapability = nil;
    SDLMenuConfiguration *testMenuConfiguration = [[SDLMenuConfiguration alloc] initWithMainMenuLayout:SDLMenuLayoutList defaultSubmenuLayout:SDLMenuLayoutTiles];

    __block SDLMenuConfigurationUpdatedBlock testUpdatedBlock = nil;
    __block SDLMenuConfiguration *resultMenuConfiguration = nil;
    __block NSError *resultError = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);
        testWindowCapability = [[SDLWindowCapability alloc] initWithWindowID:@0 textFields:nil imageFields:nil imageTypeSupported:nil templatesAvailable:nil numCustomPresetsAvailable:nil buttonCapabilities:nil softButtonCapabilities:nil menuLayoutsAvailable:@[] dynamicUpdateCapabilities:nil keyboardCapabilities:nil];

        resultMenuConfiguration = nil;
        resultError = nil;
        testUpdatedBlock = ^(SDLMenuConfiguration *newConfiguration, NSError *_Nullable error) {
            resultMenuConfiguration = newConfiguration;
            resultError = error;
        };
    });

    // when the layout check fails
    describe(@"when the layout check fails", ^{
        // when there are no known menu layouts
        context(@"when there are no known menu layouts", ^{
            it(@"should return an error and finish", ^{
                testOp = [[SDLMenuConfigurationUpdateOperation alloc] initWithConnectionManager:testConnectionManager windowCapability:testWindowCapability newMenuConfiguration:testMenuConfiguration configurationUpdatedHandler:testUpdatedBlock];
                [testOp start];

                expect(testConnectionManager.receivedRequests).to(beEmpty());
                expect(testOp.isFinished).to(beTrue());
                expect(resultMenuConfiguration).to(beNil());
                expect(resultError).toNot(beNil());
                expect(testOp.error).toNot(beNil());
            });
        });

        // when the set main menu layout is not available
        context(@"when the set main menu layout is not available", ^{
            beforeEach(^{
                testWindowCapability.menuLayoutsAvailable = @[SDLMenuLayoutTiles];
            });

            it(@"should return an error and finish", ^{
                testOp = [[SDLMenuConfigurationUpdateOperation alloc] initWithConnectionManager:testConnectionManager windowCapability:testWindowCapability newMenuConfiguration:testMenuConfiguration configurationUpdatedHandler:testUpdatedBlock];
                [testOp start];

                expect(testConnectionManager.receivedRequests).to(beEmpty());
                expect(testOp.isFinished).to(beTrue());
                expect(resultMenuConfiguration).to(beNil());
                expect(resultError).toNot(beNil());
                expect(testOp.error).toNot(beNil());
            });
        });

        // when the set default submenu layout is not available
        context(@"when the set default submenu layout is not available", ^{
            beforeEach(^{
                testWindowCapability.menuLayoutsAvailable = @[SDLMenuLayoutList];
            });

            it(@"should return an error and finish", ^{
                testOp = [[SDLMenuConfigurationUpdateOperation alloc] initWithConnectionManager:testConnectionManager windowCapability:testWindowCapability newMenuConfiguration:testMenuConfiguration configurationUpdatedHandler:testUpdatedBlock];
                [testOp start];

                expect(testConnectionManager.receivedRequests).to(beEmpty());
                expect(testOp.isFinished).to(beTrue());
                expect(resultMenuConfiguration).to(beNil());
                expect(resultError).toNot(beNil());
                expect(testOp.error).toNot(beNil());
            });
        });
    });

    // when the set layouts are available
    describe(@"when the set layouts are available", ^{
        __block SDLSetGlobalPropertiesResponse *response = [[SDLSetGlobalPropertiesResponse alloc] init];

        beforeEach(^{
            testWindowCapability.menuLayoutsAvailable = @[SDLMenuLayoutList, SDLMenuLayoutTiles];

            testOp = [[SDLMenuConfigurationUpdateOperation alloc] initWithConnectionManager:testConnectionManager windowCapability:testWindowCapability newMenuConfiguration:testMenuConfiguration configurationUpdatedHandler:testUpdatedBlock];
            [testOp start];
        });

        // should send the RPC
        it(@"should send the RPC", ^{
            expect(testOp.error).to(beNil());
            expect(testConnectionManager.receivedRequests).toNot(beEmpty());
            expect(testOp.isFinished).to(beFalse());
            expect(resultMenuConfiguration).to(beNil());
            expect(resultError).to(beNil());

            SDLSetGlobalProperties *receivedSGP = (SDLSetGlobalProperties *)testConnectionManager.receivedRequests[0];
            expect(receivedSGP.menuLayout).to(equal(testMenuConfiguration.mainMenuLayout));
        });

        // if an error returned
        context(@"if an error returned", ^{
            beforeEach(^{
                response.success = @NO;
                response.resultCode = SDLResultRejected;
            });

            it(@"should return an error and finish", ^{
                [testConnectionManager respondToLastRequestWithResponse:response];

                expect(testOp.error).toNot(beNil());
                expect(testConnectionManager.receivedRequests).toNot(beEmpty());
                expect(testOp.isFinished).to(beTrue());
                expect(resultMenuConfiguration).to(beNil());
            });
        });

        // if it succeeded
        context(@"if it succeeded", ^{
            beforeEach(^{
                response.success = @YES;
                response.resultCode = SDLResultSuccess;
            });

            it(@"should not return an error and finish", ^{
                [testConnectionManager respondToLastRequestWithResponse:response];

                expect(testOp.error).to(beNil());
                expect(testConnectionManager.receivedRequests).toNot(beEmpty());
                expect(testOp.isFinished).to(beTrue());
                expect(resultMenuConfiguration).to(equal(testMenuConfiguration));
                expect(resultError).to(beNil());
            });
        });
    });

    describe(@"cancelling the operation", ^{
        testOp = [[SDLMenuConfigurationUpdateOperation alloc] initWithConnectionManager:testConnectionManager windowCapability:testWindowCapability newMenuConfiguration:testMenuConfiguration configurationUpdatedHandler:testUpdatedBlock];

        beforeEach(^{
            [testOp cancel];
            [testOp start];
        });

        it(@"should finish with an error", ^{
            expect(testOp.error).toNot(beNil());
            expect(testConnectionManager.receivedRequests).to(beEmpty());
            expect(testOp.isFinished).to(beTrue());
            expect(resultMenuConfiguration).to(beNil());
            expect(resultError).toNot(beNil());
        });
    });
});

QuickSpecEnd
