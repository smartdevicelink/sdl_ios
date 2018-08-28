#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLArtwork.h"
#import "SDLMenuCell.h"

QuickSpecBegin(SDLMenuCellSpec)

describe(@"a menu cell", ^{
    __block SDLMenuCell *testCell = nil;

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
        });

        it(@"should initialize properly as a submenu item", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testCell = [[SDLMenuCell alloc] initWithTitle:someTitle subCells:someSubcells];

            expect(testCell.title).to(equal(someTitle));
            expect(testCell.icon).to(beNil());
            expect(testCell.voiceCommands).to(beNil());
            expect(testCell.subCells).to(equal(someSubcells));
            #pragma clang diagnostic pop
        });

        it(@"should initialize properly as a submenu item with icon", ^{
            testCell = [[SDLMenuCell alloc] initWithTitle:someTitle icon:someArtwork subCells:someSubcells];

            expect(testCell.title).to(equal(someTitle));
            expect(testCell.icon).to(equal(someArtwork));
            expect(testCell.voiceCommands).to(beNil());
            expect(testCell.subCells).to(equal(someSubcells));
        });
    });
});

QuickSpecEnd
