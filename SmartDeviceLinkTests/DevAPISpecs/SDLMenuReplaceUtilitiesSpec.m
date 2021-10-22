#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLMenuReplaceUtilities.h"

#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLMenuCell.h"
#import "SDLMenuReplaceUtilitiesSpecHelpers.h"
#import "SDLMenuManagerPrivateConstants.h"
#import "SDLVersion.h"
#import "SDLWindowCapability.h"
#import "TestConnectionManager.h"

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;
@property (copy, nonatomic, readwrite, nullable) NSArray<SDLMenuCell *> *subCells;

@end

@interface SDLMenuReplaceUtilities ()

@property (class, assign, nonatomic) UInt32 nextMenuId;

@end

QuickSpecBegin(SDLMenuReplaceUtilitiesSpec)

__block NSMutableArray<SDLMenuCell *> *testMenuCells = nil;
__block SDLFileManager *mockFileManager = nil;
__block SDLWindowCapability *testWindowCapability = nil;
__block NSArray<SDLTextField *> *allSupportedTextFields = @[
    [[SDLTextField alloc] initWithName:SDLTextFieldNameMenuCommandSecondaryText characterSet:SDLCharacterSetUtf8 width:100 rows:1],
    [[SDLTextField alloc] initWithName:SDLTextFieldNameMenuCommandTertiaryText characterSet:SDLCharacterSetUtf8 width:100 rows:1],
    [[SDLTextField alloc] initWithName:SDLTextFieldNameMenuSubMenuSecondaryText characterSet:SDLCharacterSetUtf8 width:100 rows:1],
    [[SDLTextField alloc] initWithName:SDLTextFieldNameMenuSubMenuTertiaryText characterSet:SDLCharacterSetUtf8 width:100 rows:1]
];
__block NSArray<SDLImageField *> *allSupportedImageFields = @[
    [[SDLImageField alloc] initWithName:SDLImageFieldNameCommandIcon imageTypeSupported:@[SDLImageTypeDynamic] imageResolution:nil],
    [[SDLImageField alloc] initWithName:SDLImageFieldNameMenuCommandSecondaryImage imageTypeSupported:@[SDLImageTypeDynamic] imageResolution:nil],
    [[SDLImageField alloc] initWithName:SDLImageFieldNameSubMenuIcon imageTypeSupported:@[SDLImageTypeDynamic] imageResolution:nil],
    [[SDLImageField alloc] initWithName:SDLImageFieldNameMenuSubMenuSecondaryImage imageTypeSupported:@[SDLImageTypeDynamic] imageResolution:nil]
];

describe(@"adding ids", ^{
    it(@"should properly add ids", ^{
        SDLMenuReplaceUtilities.nextMenuId = 0;
        testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.deepMenu;

        [SDLMenuReplaceUtilities addIdsToMenuCells:testMenuCells parentId:ParentIdNotFound];

        expect(testMenuCells[0].cellId).to(equal(1));
        expect(testMenuCells[1].cellId).to(equal(6));
        expect(testMenuCells[2].cellId).to(equal(7));

        NSArray<SDLMenuCell *> *subCellList1 = testMenuCells[0].subCells;
        expect(subCellList1[0].cellId).to(equal(2));
        expect(subCellList1[0].parentCellId).to(equal(1));
        expect(subCellList1[1].cellId).to(equal(5));
        expect(subCellList1[1].parentCellId).to(equal(1));

        NSArray<SDLMenuCell *> *subCell1SubCellList1 = subCellList1[0].subCells;
        expect(subCell1SubCellList1[0].cellId).to(equal(3));
        expect(subCell1SubCellList1[0].parentCellId).to(equal(2));
        expect(subCell1SubCellList1[1].cellId).to(equal(4));
        expect(subCell1SubCellList1[1].parentCellId).to(equal(2));

        NSArray<SDLMenuCell *> *subCellList2 = testMenuCells[2].subCells;
        expect(subCellList2[0].cellId).to(equal(8));
        expect(subCellList2[0].parentCellId).to(equal(7));
        expect(subCellList2[1].cellId).to(equal(9));
        expect(subCellList2[1].parentCellId).to(equal(7));
    });
});

describe(@"transferring cell ids", ^{
    it(@"should properly transfer ids and set parent ids", ^{
        testMenuCells = [[NSMutableArray alloc] initWithArray:SDLMenuReplaceUtilitiesSpecHelpers.deepMenu copyItems:YES];
        [SDLMenuReplaceUtilities addIdsToMenuCells:testMenuCells parentId:ParentIdNotFound];

        NSArray<SDLMenuCell *> *toCells = [[NSArray alloc] initWithArray:SDLMenuReplaceUtilitiesSpecHelpers.deepMenu copyItems:YES];
        [SDLMenuReplaceUtilities transferCellIDsFromCells:testMenuCells toCells:toCells];

        // Top-level cells should have same cell ids
        for (NSUInteger i = 0; i < testMenuCells.count; i++) {
            expect(toCells[i].cellId).to(equal(testMenuCells[i].cellId));
        }

        // Sub-cells should _not_ have the same cell ids
        for (NSUInteger i = 0; i < testMenuCells[0].subCells.count; i++) {
            expect(toCells[0].subCells[i].cellId).toNot(equal(testMenuCells[0].subCells[i].cellId));
        }

        // Sub-cells should have proper parent ids
        for (NSUInteger i = 0; i < testMenuCells[0].subCells.count; i++) {
            expect(toCells[0].subCells[i].parentCellId).to(equal(toCells[0].cellId));
        }
    });
});

describe(@"transferring cell handlers", ^{
    __block BOOL cell1HandlerTriggered = NO;
    __block BOOL cell2HandlerTriggered = NO;
    beforeEach(^{
        cell1HandlerTriggered = NO;
        cell2HandlerTriggered = NO;
    });

    it(@"should properly transfer cell handlers", ^{
        SDLMenuCell *cell1 = [[SDLMenuCell alloc] initWithTitle:@"Cell1" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
            cell1HandlerTriggered = YES;
        }];
        SDLMenuCell *cell2 = [[SDLMenuCell alloc] initWithTitle:@"Cell1" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
            cell2HandlerTriggered = YES;
        }];

        [SDLMenuReplaceUtilities transferCellHandlersFromCells:@[cell1] toCells:@[cell2]];
        cell2.handler(SDLTriggerSourceMenu);

        expect(cell1HandlerTriggered).to(beTrue());
        expect(cell2HandlerTriggered).to(beFalse());
    });
});

describe(@"finding all artworks from cells", ^{
    beforeEach(^{
        mockFileManager = OCMClassMock([SDLFileManager class]);
        testWindowCapability = [[SDLWindowCapability alloc] init];
        testWindowCapability.imageFields = @[[[SDLImageField alloc] initWithName:SDLImageFieldNameCommandIcon imageTypeSupported:@[SDLImageTypeDynamic] imageResolution:nil]];
        [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"8.0.0"];
    });

    context(@"when checking a submenu cell artwork on RPC 5.0–7.0 without the submenu image field", ^{
        beforeEach(^{
            OCMStub([mockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(YES);
            OCMStub([mockFileManager hasUploadedFile:[OCMArg any]]).andReturn(YES);
            [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"6.0.0"];
        });

        it(@"should include the submenu primary artwork", ^{
            NSArray<SDLArtwork *> *artworksToUpload = [SDLMenuReplaceUtilities findAllArtworksToBeUploadedFromCells:SDLMenuReplaceUtilitiesSpecHelpers.deepMenu fileManager:mockFileManager windowCapability:testWindowCapability];
            expect(artworksToUpload).to(haveCount(3));
        });
    });

    context(@"when all the files need to be uploaded", ^{
        beforeEach(^{
            OCMStub([mockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(YES);
        });

        context(@"when the window capability doesn't support the primary image", ^{
            beforeEach(^{
                testWindowCapability.textFields = allSupportedTextFields;
            });

            it(@"should return an empty list of artworks to upload", ^{
                NSArray<SDLArtwork *> *artworksToUpload = [SDLMenuReplaceUtilities findAllArtworksToBeUploadedFromCells:SDLMenuReplaceUtilitiesSpecHelpers.topLevelOnlyMenu fileManager:mockFileManager windowCapability:testWindowCapability];

                expect(artworksToUpload).to(beEmpty());
            });
        });

        context(@"when the window capability supports primary but not secondary image", ^{
            beforeEach(^{
                testWindowCapability.textFields = allSupportedTextFields;
                testWindowCapability.imageFields = @[allSupportedImageFields[0], allSupportedImageFields[2]];
            });

            it(@"should only return primary images to upload", ^{
                NSArray<SDLArtwork *> *artworksToUpload = [SDLMenuReplaceUtilities findAllArtworksToBeUploadedFromCells:SDLMenuReplaceUtilitiesSpecHelpers.topLevelOnlyMenu fileManager:mockFileManager windowCapability:testWindowCapability];

                expect(artworksToUpload).to(haveCount(2));
            });
        });

        context(@"when the window capability supports both images", ^{
            beforeEach(^{
                testWindowCapability.textFields = allSupportedTextFields;
                testWindowCapability.imageFields = allSupportedImageFields;
            });

            context(@"with a shallow menu", ^{
                it(@"should only return all images to upload", ^{
                    NSArray<SDLArtwork *> *artworksToUpload = [SDLMenuReplaceUtilities findAllArtworksToBeUploadedFromCells:SDLMenuReplaceUtilitiesSpecHelpers.topLevelOnlyMenu fileManager:mockFileManager windowCapability:testWindowCapability];

                    expect(artworksToUpload).to(haveCount(2));
                });
            });

            context(@"with a deep menu", ^{
                it(@"should only return all images to upload", ^{
                    NSArray<SDLArtwork *> *artworksToUpload = [SDLMenuReplaceUtilities findAllArtworksToBeUploadedFromCells:SDLMenuReplaceUtilitiesSpecHelpers.deepMenu fileManager:mockFileManager windowCapability:testWindowCapability];

                    expect(artworksToUpload).to(haveCount(4));
                });
            });
        });
    });

    context(@"when no files need to be uploaded", ^{
        beforeEach(^{
            OCMStub([mockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(NO);
        });

        context(@"when the window capability supports both images", ^{
            beforeEach(^{
                testWindowCapability.textFields = allSupportedTextFields;
                testWindowCapability.imageFields = allSupportedImageFields;
            });

            it(@"should not return any images to upload", ^{
                NSArray<SDLArtwork *> *artworksToUpload = [SDLMenuReplaceUtilities findAllArtworksToBeUploadedFromCells:SDLMenuReplaceUtilitiesSpecHelpers.topLevelOnlyMenu fileManager:mockFileManager windowCapability:testWindowCapability];

                expect(artworksToUpload).to(beEmpty());
            });
        });
    });
});

describe(@"retrieving a commandId", ^{
    context(@"with an AddCommand", ^{
        it(@"should return the command id", ^{
            SDLAddCommand *rpc = [[SDLAddCommand alloc] init];
            rpc.cmdID = @12345;
            expect([SDLMenuReplaceUtilities commandIdForRPCRequest:rpc]).to(equal(12345));
        });
    });

    context(@"with an AddSubMenu", ^{
        it(@"should return the command id", ^{
            SDLAddSubMenu *rpc = [[SDLAddSubMenu alloc] init];
            rpc.menuID = @12345;
            expect([SDLMenuReplaceUtilities commandIdForRPCRequest:rpc]).to(equal(12345));
        });
    });

    context(@"with a DeleteCommand", ^{
        it(@"should return the command id", ^{
            SDLDeleteCommand *rpc = [[SDLDeleteCommand alloc] init];
            rpc.cmdID = @12345;
            expect([SDLMenuReplaceUtilities commandIdForRPCRequest:rpc]).to(equal(12345));
        });
    });

    context(@"with a DeleteSubMenu", ^{
        it(@"should return the command id", ^{
            SDLDeleteSubMenu *rpc = [[SDLDeleteSubMenu alloc] init];
            rpc.menuID = @12345;
            expect([SDLMenuReplaceUtilities commandIdForRPCRequest:rpc]).to(equal(12345));
        });
    });

    context(@"with an Alert", ^{
        it(@"should return 0", ^{
            SDLAlert *rpc = [[SDLAlert alloc] init];
            expect([SDLMenuReplaceUtilities commandIdForRPCRequest:rpc]).to(equal(0));
        });
    });
});

describe(@"retrieving a position", ^{
    context(@"with an AddCommand", ^{
        it(@"should return the position", ^{
            SDLAddCommand *rpc = [[SDLAddCommand alloc] init];
            rpc.menuParams = [[SDLMenuParams alloc] init];
            rpc.menuParams.position = @123;
            expect(@([SDLMenuReplaceUtilities positionForRPCRequest:rpc])).to(equal(@123));
        });
    });

    context(@"with an AddSubMenu", ^{
        it(@"should return the command id", ^{
            SDLAddSubMenu *rpc = [[SDLAddSubMenu alloc] init];
            rpc.position = @123;
            expect(@([SDLMenuReplaceUtilities positionForRPCRequest:rpc])).to(equal(@123));
        });
    });
});

describe(@"generating RPCs", ^{
    __block SDLMenuLayout testMenuLayout = SDLMenuLayoutList;

    beforeEach(^{
        mockFileManager = OCMClassMock([SDLFileManager class]);
        OCMStub([mockFileManager hasUploadedFile:[OCMArg any]]).andReturn(YES);
        testWindowCapability = [[SDLWindowCapability alloc] init];
    });

    context(@"delete commands", ^{
        context(@"shallow menu", ^{
            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.topLevelOnlyMenu;
            });

            it(@"should generate the correct RPCs", ^{
                NSArray<SDLRPCRequest *> *requests = [SDLMenuReplaceUtilities deleteCommandsForCells:testMenuCells];
                expect(requests).to(haveCount(3));
                expect(requests[0]).to(beAnInstanceOf(SDLDeleteCommand.class));
                expect(requests[1]).to(beAnInstanceOf(SDLDeleteCommand.class));
                expect(requests[2]).to(beAnInstanceOf(SDLDeleteCommand.class));
            });
        });

        context(@"deep menu", ^{
            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.deepMenu;
            });

            it(@"should generate the correct RPCs", ^{
                NSArray<SDLRPCRequest *> *requests = [SDLMenuReplaceUtilities deleteCommandsForCells:testMenuCells];
                expect(requests).to(haveCount(3));
                expect(requests[0]).to(beAnInstanceOf(SDLDeleteSubMenu.class));
                expect(requests[1]).to(beAnInstanceOf(SDLDeleteCommand.class));
                expect(requests[2]).to(beAnInstanceOf(SDLDeleteSubMenu.class));
            });
        });
    });

    context(@"main menu commands", ^{
        beforeEach(^{
            [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"8.0.0"];
        });

        context(@"shallow menu", ^{
            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.topLevelOnlyMenu;
            });

            it(@"should generate the correct RPCs", ^{
                NSArray<SDLRPCRequest *> *requests = [SDLMenuReplaceUtilities mainMenuCommandsForCells:testMenuCells fileManager:mockFileManager usingPositionsFromFullMenu:testMenuCells windowCapability:testWindowCapability defaultSubmenuLayout:testMenuLayout];
                expect(requests).to(haveCount(3));
                expect(requests[0]).to(beAnInstanceOf(SDLAddCommand.class));
                expect(requests[1]).to(beAnInstanceOf(SDLAddCommand.class));
                expect(requests[2]).to(beAnInstanceOf(SDLAddCommand.class));
            });
        });

        context(@"deep menu", ^{
            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.deepMenu;
            });

            it(@"should generate the correct RPCs", ^{
                NSArray<SDLRPCRequest *> *requests = [SDLMenuReplaceUtilities mainMenuCommandsForCells:testMenuCells fileManager:mockFileManager usingPositionsFromFullMenu:testMenuCells windowCapability:testWindowCapability defaultSubmenuLayout:testMenuLayout];
                expect(requests).to(haveCount(3));
                expect(requests[0]).to(beAnInstanceOf(SDLAddSubMenu.class));
                SDLAddSubMenu *request0 = (SDLAddSubMenu *)requests[0];
                expect(request0.menuIcon).to(beNil());

                expect(requests[1]).to(beAnInstanceOf(SDLAddCommand.class));
                expect(requests[2]).to(beAnInstanceOf(SDLAddSubMenu.class));
            });
        });

        context(@"deep menu on RPC >= 5.0 && < 7.0", ^{
            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.deepMenu;
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"6.0.0"];
            });

            fit(@"should generate the correct RPCs", ^{
                NSArray<SDLRPCRequest *> *requests = [SDLMenuReplaceUtilities mainMenuCommandsForCells:testMenuCells fileManager:mockFileManager usingPositionsFromFullMenu:testMenuCells windowCapability:testWindowCapability defaultSubmenuLayout:testMenuLayout];
                expect(requests).to(haveCount(3));
                expect(requests[0]).to(beAnInstanceOf(SDLAddSubMenu.class));
                SDLAddSubMenu *request0 = (SDLAddSubMenu *)requests[0];
                expect(request0.menuIcon).toNot(beNil());

                expect(requests[1]).to(beAnInstanceOf(SDLAddCommand.class));
                expect(requests[2]).to(beAnInstanceOf(SDLAddSubMenu.class));
            });
        });
    });
});

describe(@"updating menu cell lists", ^{
    __block UInt32 testCommandId = 0;

    describe(@"removing commands", ^{
        context(@"from a shallow list", ^{
            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.topLevelOnlyMenu;
                [SDLMenuReplaceUtilities addIdsToMenuCells:testMenuCells parentId:ParentIdNotFound];
            });

            context(@"when the cell is in the menu", ^{
                beforeEach(^{
                    testCommandId = testMenuCells[1].cellId;
                });

                it(@"should return the menu without the cell and return YES", ^{
                    NSMutableArray<SDLMenuCell *> *testMutableMenuCells = [testMenuCells mutableCopy];
                    BOOL foundItem = [SDLMenuReplaceUtilities removeCellFromList:testMutableMenuCells withCellId:testCommandId];

                    expect(foundItem).to(beTrue());
                    expect(testMutableMenuCells).to(haveCount(2));
                    expect(testMutableMenuCells[0]).to(equal(testMenuCells[0]));
                    expect(testMutableMenuCells[1]).to(equal(testMenuCells[2]));
                });
            });

            context(@"when the cell is not in the menu", ^{
                beforeEach(^{
                    testCommandId = 100;
                });

                it(@"should return the menu with all cells and return NO", ^{
                    NSMutableArray<SDLMenuCell *> *testMutableMenuCells = [testMenuCells mutableCopy];
                    BOOL foundItem = [SDLMenuReplaceUtilities removeCellFromList:testMutableMenuCells withCellId:testCommandId];

                    expect(foundItem).to(beFalse());
                    expect(testMutableMenuCells).to(haveCount(3));
                });
            });
        });

        context(@"from a deep list", ^{
            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.deepMenu;
                [SDLMenuReplaceUtilities addIdsToMenuCells:testMenuCells parentId:ParentIdNotFound];
            });

            context(@"when the cell is in the top menu", ^{
                beforeEach(^{
                    testCommandId = testMenuCells[1].cellId;
                });

                it(@"should return the menu without the cell and return YES", ^{
                    NSMutableArray<SDLMenuCell *> *testMutableMenuCells = [testMenuCells mutableCopy];
                    BOOL foundItem = [SDLMenuReplaceUtilities removeCellFromList:testMutableMenuCells withCellId:testCommandId];

                    expect(foundItem).to(beTrue());
                    expect(testMutableMenuCells).to(haveCount(2));
                    expect(testMutableMenuCells[0]).to(equal(testMenuCells[0]));
                    expect(testMutableMenuCells[1]).to(equal(testMenuCells[2]));
                });
            });

            context(@"when the cell is in the submenu", ^{
                beforeEach(^{
                    testCommandId = testMenuCells[0].subCells[0].cellId;
                });

                it(@"should return the menu without the cell and return YES", ^{
                    NSMutableArray<SDLMenuCell *> *testMutableMenuCells = [testMenuCells mutableCopy];
                    BOOL foundItem = [SDLMenuReplaceUtilities removeCellFromList:testMutableMenuCells withCellId:testCommandId];

                    expect(foundItem).to(beTrue());
                    expect(testMutableMenuCells).to(haveCount(3));
                    expect(testMutableMenuCells[0].subCells).to(haveCount(1));
                });
            });

            context(@"when the cell is not in the menu", ^{
                beforeEach(^{
                    testCommandId = 100;
                });

                it(@"should return the menu with all cells and return NO", ^{
                    NSMutableArray<SDLMenuCell *> *testMutableMenuCells = [testMenuCells mutableCopy];
                    BOOL foundItem = [SDLMenuReplaceUtilities removeCellFromList:testMutableMenuCells withCellId:testCommandId];

                    expect(foundItem).to(beFalse());
                    expect(testMutableMenuCells).to(haveCount(3));
                    expect(testMutableMenuCells[0].subCells).to(haveCount(2));
                    expect(testMutableMenuCells[2].subCells).to(haveCount(2));
                });
            });
        });
    });

    describe(@"add commands to the main list", ^{
        __block NSMutableArray<SDLMenuCell *> *newCellList = nil;

        context(@"from a shallow list", ^{
            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.topLevelOnlyMenu;
                [SDLMenuReplaceUtilities addIdsToMenuCells:testMenuCells parentId:ParentIdNotFound];

                SDLMenuCell *newCell = [[SDLMenuCell alloc] initWithTitle:@"New Cell" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
                newCell.cellId = 99;
                newCellList = [@[newCell] mutableCopy];
            });

            describe(@"if the cell is not in the cell list", ^{
                beforeEach(^{
                    newCellList = [[NSMutableArray alloc] init];
                });

                it(@"should return NO", ^{
                    BOOL didAddCell = [SDLMenuReplaceUtilities addCellWithCellId:99 position:0 fromNewMenuList:newCellList toMainMenuList:testMenuCells];

                    expect(didAddCell).to(beFalse());
                });
            });

            context(@"at the beginning", ^{
                it(@"should return YES and the cell should be included", ^{
                    BOOL didAddCell = [SDLMenuReplaceUtilities addCellWithCellId:newCellList[0].cellId position:0 fromNewMenuList:newCellList toMainMenuList:testMenuCells];

                    expect(didAddCell).to(beTrue());
                    expect(testMenuCells).to(haveCount(4));
                    expect(testMenuCells[0]).to(equal(newCellList[0]));
                });
            });

            context(@"in the middle", ^{
                it(@"should return YES and the cell should be included", ^{
                    BOOL didAddCell = [SDLMenuReplaceUtilities addCellWithCellId:newCellList[0].cellId position:1 fromNewMenuList:newCellList toMainMenuList:testMenuCells];

                    expect(didAddCell).to(beTrue());
                    expect(testMenuCells).to(haveCount(4));
                    expect(testMenuCells[1]).to(equal(newCellList[0]));
                });
            });

            context(@"at the end", ^{
                it(@"should return YES and the cell should be included", ^{
                    BOOL didAddCell = [SDLMenuReplaceUtilities addCellWithCellId:newCellList[0].cellId position:3 fromNewMenuList:newCellList toMainMenuList:testMenuCells];

                    expect(didAddCell).to(beTrue());
                    expect(testMenuCells).to(haveCount(4));
                    expect(testMenuCells[3]).to(equal(newCellList[0]));
                });
            });
        });

        context(@"from a deep list", ^{
            __block SDLMenuCell *subCell = nil;
            __block NSMutableArray<SDLMenuCell *> *newMenu = nil;

            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.deepMenu.copy;
                [SDLMenuReplaceUtilities addIdsToMenuCells:testMenuCells parentId:ParentIdNotFound];

                newMenu = [[NSMutableArray alloc] initWithArray:testMenuCells copyItems:YES];
                NSMutableArray<SDLMenuCell *> *subMenuToUpdate = newMenu[0].subCells.mutableCopy;

                subCell = [[SDLMenuCell alloc] initWithTitle:@"New SubCell" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
                subCell.cellId = 98;
                subCell.parentCellId = newMenu[0].cellId;
                [subMenuToUpdate insertObject:subCell atIndex:0];
                newMenu[0].subCells = subMenuToUpdate.copy;
            });

            it(@"should properly add the subcell to the list", ^{
                BOOL didAddCell = [SDLMenuReplaceUtilities addCellWithCellId:newMenu[0].subCells[0].cellId position:0 fromNewMenuList:newMenu toMainMenuList:testMenuCells];

                expect(didAddCell).to(beTrue());
                expect(testMenuCells).to(haveCount(3));
                expect(testMenuCells[0].subCells).to(haveCount(3));
                expect(testMenuCells[0].subCells[0]).to(equal(subCell));
            });
        });
    });
});

QuickSpecEnd
