#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLMenuReplaceUtilities.h"

#import "SDLFileManager.h"
#import "SDLMenuCell.h"
#import "SDLMenuReplaceUtilitiesSpecHelpers.h"
#import "SDLWindowCapability.h"
#import "TestConnectionManager.h"

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;
@property (copy, nonatomic, readwrite, nullable) NSArray<SDLMenuCell *> *subCells;

@end

QuickSpecBegin(SDLMenuReplaceUtilitiesSpec)

__block NSArray<SDLMenuCell *> *testMenuCells = nil;
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

describe(@"finding all artworks from cells", ^{
    beforeEach(^{
        mockFileManager = OCMClassMock([SDLFileManager class]);
        testWindowCapability = [[SDLWindowCapability alloc] init];
    });

    context(@"when all the files need to be uploaded", ^{
        beforeEach(^{
            OCMStub([mockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(NO);
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

                expect(artworksToUpload).to(haveCount(1));
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

                    expect(artworksToUpload).to(haveCount(2));
                });
            });
        });
    });

    context(@"when no files need to be uploaded", ^{
        beforeEach(^{
            OCMStub([mockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(YES);
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
            rpc.menuParams.position = @12345;
            expect(@([SDLMenuReplaceUtilities positionForRPCRequest:rpc])).to(equal(@12345));
        });
    });

    context(@"with an AddSubMenu", ^{
        it(@"should return the command id", ^{
            SDLAddSubMenu *rpc = [[SDLAddSubMenu alloc] init];
            rpc.position = @12345;
            expect(@([SDLMenuReplaceUtilities positionForRPCRequest:rpc])).to(equal(@12345));
        });
    });
});

describe(@"generating RPCs", ^{
    __block SDLMenuLayout testMenuLayout = SDLMenuLayoutList;

    beforeEach(^{
        mockFileManager = OCMClassMock([SDLFileManager class]);
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
                expect(requests).to(haveCount(6));
                expect(requests[0]).to(beAnInstanceOf(SDLDeleteSubMenu.class));
                expect(requests[1]).to(beAnInstanceOf(SDLDeleteCommand.class));
                expect(requests[2]).to(beAnInstanceOf(SDLDeleteSubMenu.class));
            });
        });
    });

    context(@"main menu commands", ^{
        context(@"shallow menu", ^{
            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.topLevelOnlyMenu;
            });

            it(@"should generate the correct RPCs", ^{
                NSArray<SDLRPCRequest *> *requests = [SDLMenuReplaceUtilities mainMenuCommandsForCells:testMenuCells fileManager:mockFileManager usingIndexesFrom:@[] windowCapability:testWindowCapability defaultSubmenuLayout:testMenuLayout];
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
                NSArray<SDLRPCRequest *> *requests = [SDLMenuReplaceUtilities mainMenuCommandsForCells:testMenuCells fileManager:mockFileManager usingIndexesFrom:@[] windowCapability:testWindowCapability defaultSubmenuLayout:testMenuLayout];
                expect(requests).to(haveCount(3));
                expect(requests[0]).to(beAnInstanceOf(SDLAddSubMenu.class));
                expect(requests[1]).to(beAnInstanceOf(SDLAddCommand.class));
                expect(requests[2]).to(beAnInstanceOf(SDLAddSubMenu.class));
            });
        });
    });

    context(@"sub menu commands", ^{
        context(@"shallow menu", ^{
            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.topLevelOnlyMenu;
            });
        });

        context(@"deep menu", ^{
            beforeEach(^{
                testMenuCells = SDLMenuReplaceUtilitiesSpecHelpers.deepMenu;
            });
        });
    });
});

// updating menu cells
describe(@"updating menu cell lists", ^{
    __block NSArray<SDLMenuCell *> *testNewMenuCells = nil;
    __block UInt32 testCommandId = 0;

    // removeMenuCellFromList:withCmdId:
    describe(@"removing commands from a list", ^{
        context(@"the list only has one level", ^{

        });
    });

    describe(@"add commands to the list", ^{
        __block NSMutableArray<SDLMenuCell *> *testMenuCells = nil;
        __block UInt16 testPosition = 0;
    });
});

QuickSpecEnd
