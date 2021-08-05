//
//  SDLMenuReplaceOperationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/16/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>
#import <Quick/Quick.h>

#import <SmartDeviceLink/SmartDeviceLink.h>
#import "SDLMenuReplaceOperation.h"
#import "SDLMenuReplaceUtilities.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLMenuReplaceOperationSpec)

describe(@"a menu replace operation", ^{
    __block SDLMenuReplaceOperation *testOp = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block SDLWindowCapability *testWindowCapability = nil;
    __block SDLMenuConfiguration *testMenuConfiguration = nil;
    __block NSArray<SDLMenuCell *> *testCurrentMenu = nil;
    __block NSArray<SDLMenuCell *> *testNewMenu = nil;

    __block SDLArtwork *testArtwork = nil;
    __block SDLArtwork *testArtwork2 = nil;
    __block SDLArtwork *testArtwork3 = nil;

    __block SDLMenuCell *textOnlyCell = nil;
    __block SDLMenuCell *textOnlyCell2 = nil;
    __block SDLMenuCell *textAndImageCell = nil;
    __block SDLMenuCell *submenuCell = nil;
    __block SDLMenuCell *submenuImageCell = nil;

    __block SDLAddCommandResponse *addCommandSuccessResponse = nil;

    __block NSArray<SDLMenuCell *> *receivedMenuCells = nil;
    __block NSError *receivedError = nil;
    __block SDLCurrentMenuUpdatedBlock testCurrentMenuUpdatedBlock = nil;

    __block SDLMenuReplaceUtilities *mockReplaceUtilities = nil;

    beforeEach(^{
        testArtwork = [[SDLArtwork alloc] initWithData:[@"Test data" dataUsingEncoding:NSUTF8StringEncoding] name:@"some artwork name" fileExtension:@"png" persistent:NO];
        testArtwork2 = [[SDLArtwork alloc] initWithData:[@"Test data 2" dataUsingEncoding:NSUTF8StringEncoding] name:@"some artwork name 2" fileExtension:@"png" persistent:NO];
        testArtwork3 = [[SDLArtwork alloc] initWithData:[@"Test data 3" dataUsingEncoding:NSUTF8StringEncoding] name:@"some artwork name" fileExtension:@"png" persistent:NO];
        testArtwork3.overwrite = YES;

        textOnlyCell = [[SDLMenuCell alloc] initWithTitle:@"Test 1" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
        textAndImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 2" secondaryText:nil tertiaryText:nil icon:testArtwork secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
        submenuCell = [[SDLMenuCell alloc] initWithTitle:@"Test 3" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil submenuLayout:nil subCells:@[textOnlyCell, textAndImageCell]];
        submenuImageCell = [[SDLMenuCell alloc] initWithTitle:@"Test 4" secondaryText:nil tertiaryText:nil icon:testArtwork2 secondaryArtwork:nil submenuLayout:SDLMenuLayoutTiles subCells:@[textOnlyCell]];
        textOnlyCell2 = [[SDLMenuCell alloc] initWithTitle:@"Test 5" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

        addCommandSuccessResponse = [[SDLAddCommandResponse alloc] init];
        addCommandSuccessResponse.success = @YES;
        addCommandSuccessResponse.resultCode = SDLResultSuccess;

        testOp = nil;
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);

        SDLImageField *commandImageField = [[SDLImageField alloc] initWithName:SDLImageFieldNameCommandIcon imageTypeSupported:@[SDLFileTypePNG] imageResolution:nil];
        SDLImageField *submenuImageField = [[SDLImageField alloc] initWithName:SDLImageFieldNameSubMenuIcon imageTypeSupported:@[SDLFileTypePNG] imageResolution:nil];
        testWindowCapability = [[SDLWindowCapability alloc] initWithWindowID:@0 textFields:nil imageFields:@[commandImageField, submenuImageField] imageTypeSupported:nil templatesAvailable:nil numCustomPresetsAvailable:nil buttonCapabilities:nil softButtonCapabilities:nil menuLayoutsAvailable:nil dynamicUpdateCapabilities:nil keyboardCapabilities:nil];
        testMenuConfiguration = [[SDLMenuConfiguration alloc] initWithMainMenuLayout:SDLMenuLayoutList defaultSubmenuLayout:SDLMenuLayoutList];
        testCurrentMenu = @[];
        testNewMenu = nil;

        receivedMenuCells = nil;
        receivedError = nil;
        testCurrentMenuUpdatedBlock = ^(NSArray<SDLMenuCell *> *currentMenuCells, NSError *error) {
            receivedMenuCells = currentMenuCells;
            receivedError = error;
        };

        mockReplaceUtilities = OCMClassMock([SDLMenuReplaceUtilities class]);
    });

    // sending initial batch of cells
    describe(@"sending initial batch of cells", ^{
        // when setting no cells
        context(@"when setting no cells", ^{
            it(@"should finish without doing anything", ^{
                testOp = [[SDLMenuReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager windowCapability:testWindowCapability menuConfiguration:testMenuConfiguration currentMenu:testCurrentMenu updatedMenu:testNewMenu compatibilityModeEnabled:YES currentMenuUpdatedHandler:testCurrentMenuUpdatedBlock];
                [testOp start];

                expect(testConnectionManager.receivedRequests).to(beEmpty());
                expect(testOp.isFinished).to(beTrue());
            });
        });

        // when starting while cancelled
        context(@"when starting while cancelled", ^{
            it(@"should finish without doing anything", ^{
                testOp = [[SDLMenuReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager windowCapability:testWindowCapability menuConfiguration:testMenuConfiguration currentMenu:testCurrentMenu updatedMenu:testNewMenu compatibilityModeEnabled:YES currentMenuUpdatedHandler:testCurrentMenuUpdatedBlock];
                [testOp cancel];
                [testOp start];

                expect(testConnectionManager.receivedRequests).to(beEmpty());
                expect(testOp.isFinished).to(beTrue());
            });
        });

        // when uploading a text-only cell
        context(@"when uploading a text-only cell", ^{
            beforeEach(^{
                testNewMenu = @[textOnlyCell];
                OCMStub([testFileManager fileNeedsUpload:[OCMArg any]]).andReturn(NO);
            });

            it(@"should properly send the RPCs and finish the operation", ^{
                testOp = [[SDLMenuReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager windowCapability:testWindowCapability menuConfiguration:testMenuConfiguration currentMenu:testCurrentMenu updatedMenu:testNewMenu compatibilityModeEnabled:YES currentMenuUpdatedHandler:testCurrentMenuUpdatedBlock];
                [testOp start];

                OCMReject([testFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLDeleteCommand class]];
                NSArray *deletes = [[testConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
                expect(deletes).to(beEmpty());

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
                NSArray *add = [[testConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
                expect(add).to(haveCount(1));

                [testConnectionManager respondToLastRequestWithResponse:addCommandSuccessResponse];
                [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                expect(testOp.isFinished).to(beTrue());
            });
        });

        // when uploading text and image cell
        context(@"when uploading text and image cell", ^{
            beforeEach(^{
                testNewMenu = @[textAndImageCell];

                OCMStub([testFileManager uploadArtworks:[OCMArg any] progressHandler:([OCMArg invokeBlockWithArgs:textAndImageCell.icon.name, @1.0, [NSNull null], nil]) completionHandler:([OCMArg invokeBlockWithArgs: @[textAndImageCell.icon.name], [NSNull null], nil])]);
            });

            // when the image is already on the head unit
            context(@"when the image is already on the head unit", ^{
                beforeEach(^{
                    OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);
                    OCMStub([testFileManager fileNeedsUpload:[OCMArg isNotNil]]).andReturn(NO);
                });

                it(@"should properly update an image cell", ^{
                    testOp = [[SDLMenuReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager windowCapability:testWindowCapability menuConfiguration:testMenuConfiguration currentMenu:testCurrentMenu updatedMenu:testNewMenu compatibilityModeEnabled:YES currentMenuUpdatedHandler:testCurrentMenuUpdatedBlock];
                    [testOp start];

                    NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
                    NSArray *add = [[testConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
                    SDLAddCommand *sentCommand = add.firstObject;

                    expect(add).to(haveCount(1));
                    expect(sentCommand.cmdIcon.value).to(equal(testArtwork.name));
                    OCMReject([testFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);
                });
            });

            // when the image is not on the head unit
            context(@"when the image is not on the head unit", ^{
                beforeEach(^{
                    OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);
                    OCMStub([testFileManager fileNeedsUpload:[OCMArg isNotNil]]).andReturn(YES);
                });

                it(@"should attempt to upload artworks then send the add", ^{
                    testOp = [[SDLMenuReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager windowCapability:testWindowCapability menuConfiguration:testMenuConfiguration currentMenu:testCurrentMenu updatedMenu:testNewMenu compatibilityModeEnabled:YES currentMenuUpdatedHandler:testCurrentMenuUpdatedBlock];
                    [testOp start];

                    OCMVerify([testFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                    NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLDeleteCommand class]];
                    NSArray *deletes = [[testConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
                    expect(deletes).to(beEmpty());

                    NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
                    NSArray *add = [[testConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
                    expect(add).toNot(beEmpty());
                });
            });
        });

        // when uploading a cell with subcells
        context(@"when uploading a cell with subcells", ^{
            beforeEach(^{
                testNewMenu = @[submenuCell];
            });

            it(@"should send an appropriate number of AddSubmenu and AddCommandRequests", ^{
                testOp = [[SDLMenuReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager windowCapability:testWindowCapability menuConfiguration:testMenuConfiguration currentMenu:testCurrentMenu updatedMenu:testNewMenu compatibilityModeEnabled:YES currentMenuUpdatedHandler:testCurrentMenuUpdatedBlock];
                [testOp start];

                SDLAddSubMenuResponse *response = [[SDLAddSubMenuResponse alloc] init];
                response.success = @YES;
                response.resultCode = SDLResultSuccess;
                [testConnectionManager respondToLastRequestWithResponse:response];
                [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
                NSArray *adds = [[testConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                NSPredicate *submenuCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
                NSArray *submenus = [[testConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:submenuCommandPredicate];

                expect(adds).to(haveCount(2));
                expect(submenus).to(haveCount(1));
            });
        });
    });

    // updating a menu without dynamic updates
    describe(@"updating a menu without dynamic updates", ^{
        context(@"adding a text cell", ^{
            beforeEach(^{
                testCurrentMenu = @[textOnlyCell];
                testNewMenu = @[textOnlyCell, textOnlyCell2];
            });

            it(@"should send a delete and two adds", ^{
                testOp = [[SDLMenuReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager windowCapability:testWindowCapability menuConfiguration:testMenuConfiguration currentMenu:testCurrentMenu updatedMenu:testNewMenu compatibilityModeEnabled:YES currentMenuUpdatedHandler:testCurrentMenuUpdatedBlock];
                [testOp start];

                SDLDeleteCommandResponse *deleteCommandResponse = [[SDLDeleteCommandResponse alloc] init];
                deleteCommandResponse.success = @YES;
                deleteCommandResponse.resultCode = SDLResultSuccess;
                [testConnectionManager respondToLastRequestWithResponse:deleteCommandResponse];

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[testConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[testConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                expect(deletes).to(haveCount(1));
                expect(adds).to(haveCount(2));
            });
        });
    });

    // updating a menu with dynamic updates
    describe(@"updating a menu with dynamic updates", ^{
        context(@"adding a text cell", ^{
            beforeEach(^{
                testCurrentMenu = @[textOnlyCell];
                testNewMenu = @[textOnlyCell, textOnlyCell2];
            });

            it(@"should only send an add", ^{
                testOp = [[SDLMenuReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager windowCapability:testWindowCapability menuConfiguration:testMenuConfiguration currentMenu:testCurrentMenu updatedMenu:testNewMenu compatibilityModeEnabled:NO currentMenuUpdatedHandler:testCurrentMenuUpdatedBlock];
                [testOp start];

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
                NSArray *deletes = [[testConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
                NSArray *adds = [[testConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                expect(deletes).to(haveCount(0));
                expect(adds).to(haveCount(1));
            });
        });
    });

//        it(@"should send dynamic deletes first then dynamic adds case with 2 submenu cells", ^{
//            testManager.menuCells = @[textOnlyCell, submenuCell, submenuImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[submenuCell, submenuImageCell, textOnlyCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//            NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//
//            expect(deletes).to(haveCount(1));
//            expect(adds).to(haveCount(5));
//            expect(submenu).to(haveCount(2));
//        });
//
//        it(@"should send dynamic deletes first then dynamic adds when removing one submenu cell", ^{
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *deleteSubCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteSubMenu class]];
//            NSArray *subDeletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteSubCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//            NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//
//            expect(deletes).to(haveCount(0));
//            expect(subDeletes).to(haveCount(1));
//            expect(adds).to(haveCount(5));
//            expect(submenu).to(haveCount(2));
//        });
//
//        it(@"should send dynamic deletes first then dynamic adds when adding one new cell", ^{
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell, textOnlyCell2];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//            NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//
//            expect(deletes).to(haveCount(0));
//            expect(adds).to(haveCount(6));
//            expect(submenu).to(haveCount(2));
//        });
//
//        it(@"should send dynamic deletes first then dynamic adds when cells stay the same", ^{
//            testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            expect(deletes).to(haveCount(0));
//            expect(adds).to(haveCount(3));
//        });
//    });
//
//    describe(@"updating when a menu already exists with dynamic updates off", ^{
//        beforeEach(^{
//             testManager.dynamicMenuUpdatesMode = SDLDynamicMenuUpdatesModeForceOff;
//             OCMStub([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
//        });
//
//        it(@"should send deletes first", ^{
//            testManager.menuCells = @[textOnlyCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            expect(deletes).to(haveCount(1));
//            expect(adds).to(haveCount(2));
//        });
//
//        it(@"should deletes first case 2", ^{
//            testManager.menuCells = @[textOnlyCell, textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textAndImageCell, textOnlyCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            expect(deletes).to(haveCount(2));
//            expect(adds).to(haveCount(4));
//        });
//
//        it(@"should send deletes first case 3", ^{
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, submenuImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *deleteSubCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteSubMenu class]];
//            NSArray *subDeletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteSubCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//            NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//
//            expect(deletes).to(haveCount(2));
//            expect(subDeletes).to(haveCount(2));
//            expect(adds).to(haveCount(9));
//            expect(submenu).to(haveCount(3));
//        });
//
//        it(@"should send deletes first case 4", ^{
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textAndImageCell, submenuCell, textOnlyCell2];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            NSPredicate *addSubmenuPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddSubMenu class]];
//            NSArray *submenu = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addSubmenuPredicate];
//
//            NSPredicate *deleteSubCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteSubMenu class]];
//            NSArray *subDeletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteSubCommandPredicate];
//
//            expect(deletes).to(haveCount(2));
//            expect(adds).to(haveCount(9));
//            expect(submenu).to(haveCount(2));
//            expect(subDeletes).to(haveCount(1));
//        });
//
//        it(@"should deletes first case 5", ^{
//            testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            testManager.menuCells = @[textOnlyCell, textOnlyCell2, textAndImageCell];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//            [mockConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
//
//            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLDeleteCommand class]];
//            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
//
//            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass:%@", [SDLAddCommand class]];
//            NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
//
//            expect(deletes).to(haveCount(3));
//            expect(adds).to(haveCount(6));
//        });
//    });
});

QuickSpecEnd
