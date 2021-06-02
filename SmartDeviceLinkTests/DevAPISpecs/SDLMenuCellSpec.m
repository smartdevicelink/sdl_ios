#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLArtwork.h"
#import "SDLMenuCell.h"

QuickSpecBegin(SDLMenuCellSpec)

describe(@"a menu cell", ^{
    __block SDLMenuCell *testCell = nil;
    __block SDLMenuCell *testCell2 = nil;
    __block SDLMenuLayout testLayout = SDLMenuLayoutList;
    __block NSString *someTitle = nil;
    __block NSString *someSecondaryTitle = nil;
    __block NSString *someTertiaryTitle = nil;
    __block SDLArtwork *someArtwork = nil;
    __block SDLArtwork *someSecondaryArtwork = nil;

    beforeEach(^{
        someTitle = @"Some Title";
        someSecondaryTitle = @"Some Title 2";
        someTertiaryTitle = @"Some Title 3";
        someArtwork = [[SDLArtwork alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:@"data" options:kNilOptions] name:@"Some artwork" fileExtension:@"png" persistent:NO];
        someSecondaryArtwork = [[SDLArtwork alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:@"data" options:kNilOptions] name:@"Some artwork 2" fileExtension:@"png" persistent:NO];
    });

    describe(@"initializing", ^{
        __block NSArray<NSString *> *someVoiceCommands = nil;
        __block NSArray<SDLMenuCell *> *someSubcells = nil;

        beforeEach(^{
            someVoiceCommands = @[@"some command"];

            SDLMenuCell *subcell = [[SDLMenuCell alloc] initWithTitle:@"Hello" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            someSubcells = @[subcell];
        });

        it(@"should set initWithTitle:icon:submenuLayout:subCells: propertly", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCell = [[SDLMenuCell alloc] initWithTitle:someTitle icon:someArtwork submenuLayout:testLayout subCells:someSubcells];
#pragma clang diagnostic pop

            expect(testCell.title).to(equal(someTitle));
            expect(testCell.icon).to(equal(someArtwork));
            expect(testCell.voiceCommands).to(beNil());
            expect(testCell.subCells).to(equal(someSubcells));
            expect(testCell.secondaryText).to(beNil());
            expect(testCell.tertiaryText).to(beNil());
            expect(testCell.secondaryArtwork).to(beNil());
        });

        it(@"should set initWithTitle:icon:voiceCommands:handler: properly", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCell = [[SDLMenuCell alloc] initWithTitle:someTitle icon:someArtwork voiceCommands:someVoiceCommands handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
#pragma clang diagnostic pop

            expect(testCell.title).to(equal(someTitle));
            expect(testCell.icon).to(equal(someArtwork));
            expect(testCell.voiceCommands).to(equal(someVoiceCommands));
            expect(testCell.subCells).to(beNil());
            expect(testCell.uniqueTitle).to(equal(someTitle));
            expect(testCell.secondaryText).to(beNil());
            expect(testCell.tertiaryText).to(beNil());
            expect(testCell.secondaryArtwork).to(beNil());
        });

        it(@"should set initWithTitle:icon:voiceCommands:secondaryText:tertiaryText:secondaryArtwork:handler: properly", ^{
            testCell = [[SDLMenuCell alloc] initWithTitle:someTitle secondaryText:someSecondaryTitle tertiaryText:someTertiaryTitle icon:someArtwork secondaryArtwork:someSecondaryArtwork voiceCommands:someVoiceCommands handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

            expect(testCell.title).to(equal(someTitle));
            expect(testCell.icon).to(equal(someArtwork));
            expect(testCell.voiceCommands).to(equal(someVoiceCommands));
            expect(testCell.subCells).to(beNil());
            expect(testCell.secondaryText).to(equal(someSecondaryTitle));
            expect(testCell.tertiaryText).to(equal(someTertiaryTitle));
            expect(testCell.secondaryArtwork).to(equal(someSecondaryArtwork));
        });

        it(@"should initWithTitle:icon:submenuLayout:subCells:secondaryText:tertiaryText:secondaryArtwork: initialize", ^{
            testCell = [[SDLMenuCell alloc] initWithTitle:someTitle secondaryText:someSecondaryTitle tertiaryText:someTertiaryTitle icon:someArtwork secondaryArtwork:someSecondaryArtwork submenuLayout:testLayout subCells:someSubcells];

            expect(testCell.title).to(equal(someTitle));
            expect(testCell.icon).to(equal(someArtwork));
            expect(testCell.voiceCommands).to(beNil());
            expect(testCell.subCells).to(equal(someSubcells));
            expect(testCell.submenuLayout).to(equal(testLayout));
            expect(testCell.uniqueTitle).to(equal(someTitle));
            expect(testCell.secondaryText).to(equal(someSecondaryTitle));
            expect(testCell.tertiaryText).to(equal(someTertiaryTitle));
            expect(testCell.secondaryArtwork).to(equal(someSecondaryArtwork));
        });
    });

    describe(@"check cell equality", ^{
        it(@"should compare cells and return true if cells equal", ^{
            testCell = [[SDLMenuCell alloc] initWithTitle:someTitle secondaryText:someSecondaryTitle tertiaryText:someTertiaryTitle icon:nil secondaryArtwork:someSecondaryArtwork submenuLayout:testLayout subCells:@[]];
            testCell2 = [[SDLMenuCell alloc] initWithTitle:someTitle secondaryText:someSecondaryTitle tertiaryText:someTertiaryTitle icon:nil secondaryArtwork:someSecondaryArtwork submenuLayout:testLayout subCells:@[]];

            expect([testCell isEqual:testCell2]).to(beTrue());
        });

        it(@"should compare cells and return false if not equal ", ^{
            testCell = [[SDLMenuCell alloc] initWithTitle:@"True" secondaryText:someSecondaryTitle tertiaryText:someTertiaryTitle icon:nil secondaryArtwork:someSecondaryArtwork submenuLayout:testLayout subCells:@[]];
            testCell2 = [[SDLMenuCell alloc] initWithTitle:@"False" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil submenuLayout:testLayout subCells:@[]];

            expect([testCell isEqual:testCell2]).to(beFalse());
        });

        it(@"should compare cells and return true if cells equal", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCell = [[SDLMenuCell alloc] initWithTitle:someTitle icon:nil submenuLayout:testLayout subCells:@[]];
            testCell2 = [[SDLMenuCell alloc] initWithTitle:someTitle icon:nil submenuLayout:testLayout subCells:@[]];
#pragma clang diagnostic pop

            expect([testCell isEqual:testCell2]).to(beTrue());
        });

        it(@"should compare cells and return false if not equal ", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCell = [[SDLMenuCell alloc] initWithTitle:@"True" icon:nil submenuLayout:testLayout subCells:@[]];
            testCell2 = [[SDLMenuCell alloc] initWithTitle:@"False" icon:nil submenuLayout:testLayout subCells:@[]];
#pragma clang diagnostic pop

            expect([testCell isEqual:testCell2]).to(beFalse()));
        });
    });
});

QuickSpecEnd
