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

describe(@"finding all artworks from cells", ^{
    __block NSArray<SDLMenuCell *> *testMenuCells = nil;
    __block SDLFileManager *mockFileManager = nil;
    __block SDLWindowCapability *testWindowCapability = nil;
    __block NSArray<SDLTextField *> *allSupportedTextFields = nil;
    __block NSArray<SDLImageField *> *allSupportedImageFields = nil;

    beforeEach(^{
        mockFileManager = OCMClassMock([SDLFileManager class]);
    });

    context(@"when all the files are uploaded", ^{
        beforeEach(^{
            OCMStub([mockFileManager fileNeedsUpload:[OCMArg any]]);
        });

        context(@"when the window capability doesn't support the primary image", ^{
            beforeEach(^{

            });
        });

        context(@"when the window capability supports primary but not secondary image", ^{

        });

        context(@"when the window capability supports both images", ^{

        });
    });

    context(@"when no files are uploaded", ^{

    });
});

describe(@"retrieving a commandId", ^{

});

describe(@"retrieving a position", ^{

});

describe(@"generating RPCs", ^{
    context(@"delete commands", ^{

    });

    context(@"main menu commands", ^{

    });

    context(@"sub menu commands", ^{

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
