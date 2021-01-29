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

    beforeEach(^{
        mockFileManager = OCMClassMock([SDLFileManager class]);
    });
});

describe(@"generating RPCs", ^{

});

// updating menu cells
describe(@"updating menu cells", ^{
    __block NSArray<SDLMenuCell *> *testNewMenuCells = nil;
    __block UInt32 testCommandId = 0;

    // removeMenuCellFromList:withCmdId:
    describe(@"removeMenuCellFromList:withCmdId:", ^{
        context(@"the list only has one level", ^{

        });
    });

    describe(@"addMenuRequestWithCommandId:position:fromNewMenuList:toMainMenuList:", ^{
        __block NSMutableArray<SDLMenuCell *> *testMenuCells = nil;
        __block UInt16 testPosition = 0;
    });
});

QuickSpecEnd
