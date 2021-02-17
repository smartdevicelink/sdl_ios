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
    __block SDLMenuConfiguration *updatedBlockMenuConfiguration = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);
        testWindowCapability = nil;

        updatedBlockMenuConfiguration = nil;
        testUpdatedBlock = ^(SDLMenuConfiguration *newConfiguration) {
            updatedBlockMenuConfiguration = newConfiguration;
        };
    });

    describe(@"when the layout check fails", ^{
        context(@"when there are no known menu layouts", ^{
            beforeEach(^{
                testWindowCapability = [[SDLWindowCapability alloc] initWithWindowID:@0 textFields:nil imageFields:nil imageTypeSupported:nil templatesAvailable:nil numCustomPresetsAvailable:nil buttonCapabilities:nil softButtonCapabilities:nil menuLayoutsAvailable:@[] dynamicUpdateCapabilities:nil];
            });

            it(@"should return an error and finish", ^{
                testOp = [[SDLMenuConfigurationUpdateOperation alloc] initWithConnectionManager:testConnectionManager windowCapability:testWindowCapability newMenuConfiguration:testMenuConfiguration configurationUpdatedHandler:testUpdatedBlock];
                [testOp start];

                expect(testOp.error).toNot(beNil());
                expect(testConnectionManager.receivedRequests).to(beEmpty());
                expect(testOp.isFinished).to(beTrue());
            });
        });

        context(@"when the set main menu layout is not available", ^{
            beforeEach(^{
                testWindowCapability = [[SDLWindowCapability alloc] initWithWindowID:@0 textFields:nil imageFields:nil imageTypeSupported:nil templatesAvailable:nil numCustomPresetsAvailable:nil buttonCapabilities:nil softButtonCapabilities:nil menuLayoutsAvailable:@[SDLMenuLayoutTiles] dynamicUpdateCapabilities:nil];
            });

            it(@"should return an error and finish", ^{
                testOp = [[SDLMenuConfigurationUpdateOperation alloc] initWithConnectionManager:testConnectionManager windowCapability:testWindowCapability newMenuConfiguration:testMenuConfiguration configurationUpdatedHandler:testUpdatedBlock];
                [testOp start];

                expect(testOp.error).toNot(beNil());
                expect(testConnectionManager.receivedRequests).to(beEmpty());
                expect(testOp.isFinished).to(beTrue());
            });
        });

        context(@"when the set default submenu layout is not available", ^{
            beforeEach(^{
                testWindowCapability = [[SDLWindowCapability alloc] initWithWindowID:@0 textFields:nil imageFields:nil imageTypeSupported:nil templatesAvailable:nil numCustomPresetsAvailable:nil buttonCapabilities:nil softButtonCapabilities:nil menuLayoutsAvailable:@[SDLMenuLayoutList] dynamicUpdateCapabilities:nil];
            });

            it(@"should return an error and finish", ^{
                testOp = [[SDLMenuConfigurationUpdateOperation alloc] initWithConnectionManager:testConnectionManager windowCapability:testWindowCapability newMenuConfiguration:testMenuConfiguration configurationUpdatedHandler:testUpdatedBlock];
                [testOp start];

                expect(testOp.error).toNot(beNil());
                expect(testConnectionManager.receivedRequests).to(beEmpty());
                expect(testOp.isFinished).to(beTrue());
            });
        });
    });

    describe(@"when the set layouts are available", ^{
        beforeEach(^{
            testWindowCapability = [[SDLWindowCapability alloc] initWithWindowID:@0 textFields:nil imageFields:nil imageTypeSupported:nil templatesAvailable:nil numCustomPresetsAvailable:nil buttonCapabilities:nil softButtonCapabilities:nil menuLayoutsAvailable:@[SDLMenuLayoutList, SDLMenuLayoutTiles] dynamicUpdateCapabilities:nil];
        });

        it(@"should send the RPC", ^{
            testOp = [[SDLMenuConfigurationUpdateOperation alloc] initWithConnectionManager:testConnectionManager windowCapability:testWindowCapability newMenuConfiguration:testMenuConfiguration configurationUpdatedHandler:testUpdatedBlock];
            [testOp start];

            expect(testOp.error).to(beNil());
            expect(testConnectionManager.receivedRequests).toNot(beEmpty());
            expect(testOp.isFinished).to(beFalse());
        });

        context(@"if an error returned", ^{
            it(@"should return an error and finish", ^{

            });
        });

        context(@"if it succeeded", ^{
            it(@"should not return an error and finish", ^{

            });
        });
    });
});

QuickSpecEnd
