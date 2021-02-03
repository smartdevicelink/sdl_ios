#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLArtwork.h"
#import "SDLMenuCell.h"

QuickSpecBegin(SDLMenuCellSpec)

describe(@"a menu cell", ^{
    __block SDLMenuCell *testCell = nil;
    __block SDLMenuCell *testCell2 = nil;
    __block SDLMenuLayout testLayout = SDLMenuLayoutList;

    describe(@"initializing", ^{
        __block NSString *someTitle = nil;
        __block SDLArtwork *someArtwork = nil;
        __block NSArray<NSString *> *someVoiceCommands = nil;
        __block NSArray<SDLMenuCell *> *someSubcells = nil;

        beforeEach(^{
            someTitle = @"Some Title";
            someArtwork = [[SDLArtwork alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:@"data" options:kNilOptions] name:@"Some artwork" fileExtension:@"png" persistent:NO];
            someVoiceCommands = @[@"some command"];

            SDLMenuCell *subcell = [[SDLMenuCell alloc] initWithTitle:@"Hello" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            someSubcells = @[subcell];
        });

        it(@"should initialize properly as a menu item", ^{
            testCell = [[SDLMenuCell alloc] initWithTitle:someTitle icon:someArtwork voiceCommands:someVoiceCommands handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

            expect(testCell.title).to(equal(someTitle));
            expect(testCell.icon).to(equal(someArtwork));
            expect(testCell.voiceCommands).to(equal(someVoiceCommands));
            expect(testCell.subCells).to(beNil());
            expect(testCell.uniqueTitle).to(equal(someTitle));
        });

        it(@"should initialize properly as a submenu item with icon and layout", ^{
            testCell = [[SDLMenuCell alloc] initWithTitle:someTitle icon:someArtwork submenuLayout:testLayout subCells:someSubcells];

            expect(testCell.title).to(equal(someTitle));
            expect(testCell.icon).to(equal(someArtwork));
            expect(testCell.voiceCommands).to(beNil());
            expect(testCell.subCells).to(equal(someSubcells));
            expect(testCell.submenuLayout).to(equal(testLayout));
            expect(testCell.uniqueTitle).to(equal(someTitle));
        });
    });
    describe(@"check cell eqality", ^{
        it(@"should compare cells and return true if cells equal", ^{
            testCell = [[SDLMenuCell alloc] initWithTitle:@"Title" icon:nil submenuLayout:testLayout subCells:@[]];
            testCell2 = [[SDLMenuCell alloc] initWithTitle:@"Title" icon:nil submenuLayout:testLayout subCells:@[]];

            expect([testCell isEqual:testCell2]).to(equal(true));
        });

        it(@"should compare cells and return false if not equal ", ^{
            testCell = [[SDLMenuCell alloc] initWithTitle:@"True" icon:nil submenuLayout:testLayout subCells:@[]];
            testCell2 = [[SDLMenuCell alloc] initWithTitle:@"False" icon:nil submenuLayout:testLayout subCells:@[]];

            expect([testCell isEqual:testCell2]).to(equal(false));
        });
    });
});

QuickSpecEnd
