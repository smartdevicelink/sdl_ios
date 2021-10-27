//
//  SDLPreloadPresentChoiceSetOperationUtilitiesSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 8/27/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLPreloadPresentChoicesOperationUtilities.h"

#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLGlobals.h"
#import "SDLImageField+ScreenManagerExtensions.h"
#import "SDLTextField+ScreenManagerExtensions.h"
#import "SDLVersion.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLPreloadPresentChoicesOperationUtilitiesSpec : QuickSpec @end
@implementation SDLPreloadPresentChoicesOperationUtilitiesSpec

- (NSOrderedSet<SDLChoiceCell *> *)sdl_cellsToLoadWithCount:(UInt16)count {
    NSMutableOrderedSet<SDLChoiceCell *> *mutableCells = [NSMutableOrderedSet orderedSetWithCapacity:count];
    for (NSUInteger i = 1; i <= count; i++) {
        [mutableCells addObject:[[SDLChoiceCell alloc] initWithText:[NSString stringWithFormat:@"Cell %lu", i]]];
    }

    return mutableCells.copy;
}

- (NSSet<SDLChoiceCell *> *)sdl_loadedCellsWithStartNum:(UInt16)startNum endNum:(UInt16)endNum {
    NSMutableSet<SDLChoiceCell *> *mutableCells = [NSMutableSet setWithCapacity:(endNum - startNum)];
    for (NSUInteger i = startNum; i <= endNum; i++) {
        SDLChoiceCell *cell = [[SDLChoiceCell alloc] initWithText:[NSString stringWithFormat:@"Loaded Cell %lu", i]];
        cell.choiceId = (UInt16)i;

        [mutableCells addObject:cell];
    }

    return mutableCells.copy;
}

- (void)spec {
    __block NSOrderedSet<SDLChoiceCell *> *testCellsToLoad = nil;
    __block NSSet<SDLChoiceCell *> *testLoadedCells = nil;

    describe(@"assigning ids", ^{
        context(@"when we're on the first loop of assigning ids", ^{
            beforeEach(^{
                SDLPreloadPresentChoicesOperationUtilities.reachedMaxId = NO;
                SDLPreloadPresentChoicesOperationUtilities.choiceId = 1;
            });

            context(@"when there's no ids already set", ^{
                beforeEach(^{
                    testLoadedCells = [NSSet set];
                    testCellsToLoad = [self sdl_cellsToLoadWithCount:50];
                });

                it(@"should set ids starting at 0", ^{
                    [SDLPreloadPresentChoicesOperationUtilities assignIdsToCells:testCellsToLoad loadedCells:testLoadedCells];
                    expect(testCellsToLoad.count).to(equal(50));
                    for (NSUInteger i = 0; i < testCellsToLoad.count; i++) {
                        expect((NSUInteger)testCellsToLoad[i].choiceId).to(equal(i + 1));
                    }
                });
            });

            context(@"when ids are already set", ^{
                context(@"when not reaching the max value", ^{
                    beforeEach(^{
                        SDLPreloadPresentChoicesOperationUtilities.choiceId = 100;

                        testLoadedCells = [NSSet set];
                        testCellsToLoad = [self sdl_cellsToLoadWithCount:50];
                    });

                    it(@"should set ids starting at the next id", ^{
                        [SDLPreloadPresentChoicesOperationUtilities assignIdsToCells:testCellsToLoad loadedCells:testLoadedCells];
                        expect(testCellsToLoad.count).to(equal(50));
                        for (NSUInteger i = 0; i < testCellsToLoad.count; i++) {
                            expect((NSUInteger)testCellsToLoad[i].choiceId).to(equal(i + 100));
                        }
                        expect(SDLPreloadPresentChoicesOperationUtilities.reachedMaxId).to(beFalse());
                    });
                });

                context(@"when reaching the max value", ^{
                    beforeEach(^{
                        SDLPreloadPresentChoicesOperationUtilities.choiceId = 65500;

                        testLoadedCells = [self sdl_loadedCellsWithStartNum:0 endNum:65499];
                        testCellsToLoad = [self sdl_cellsToLoadWithCount:35];
                    });

                    it(@"should set the reachedMaxId BOOL and not loop back over yet", ^{
                        [SDLPreloadPresentChoicesOperationUtilities assignIdsToCells:testCellsToLoad loadedCells:testLoadedCells];
                        expect(testCellsToLoad.count).to(equal(35));
                        for (NSUInteger i = 0; i < testCellsToLoad.count; i++) {
                            expect((NSUInteger)testCellsToLoad[i].choiceId).to(equal(i + 65500));
                        }
                        expect(SDLPreloadPresentChoicesOperationUtilities.reachedMaxId).to(beFalse());
                    });
                });
            });
        });

        context(@"on subsequent loops of assigning ids", ^{
            beforeEach(^{
                SDLPreloadPresentChoicesOperationUtilities.reachedMaxId = YES;
                SDLPreloadPresentChoicesOperationUtilities.choiceId = 1;
            });

            context(@"when loadedCells is not full", ^{
                context(@"when loaded cells are contiguous at the beginning", ^{
                    beforeEach(^{
                        SDLPreloadPresentChoicesOperationUtilities.choiceId = 99;

                        testLoadedCells = [self sdl_loadedCellsWithStartNum:0 endNum:99];
                        testCellsToLoad = [self sdl_cellsToLoadWithCount:35];
                    });

                    it(@"should assign ids after those", ^{
                        [SDLPreloadPresentChoicesOperationUtilities assignIdsToCells:testCellsToLoad loadedCells:testLoadedCells];
                        expect(testCellsToLoad.count).to(equal(35));
                        for (NSUInteger i = 0; i < testCellsToLoad.count; i++) {
                            expect((NSUInteger)testCellsToLoad[i].choiceId).to(equal(i + 100));
                        }
                        expect(SDLPreloadPresentChoicesOperationUtilities.reachedMaxId).to(beTrue());
                    });
                });

                context(@"when those items are contiguous in the middle so that assigning cells overlap", ^{
                    beforeEach(^{
                        SDLPreloadPresentChoicesOperationUtilities.choiceId = 10;

                        testLoadedCells = [self sdl_loadedCellsWithStartNum:3 endNum:10];
                        testCellsToLoad = [self sdl_cellsToLoadWithCount:13];
                    });

                    it(@"should start assigning from the last used id", ^{
                        [SDLPreloadPresentChoicesOperationUtilities assignIdsToCells:testCellsToLoad loadedCells:testLoadedCells];
                        expect(testCellsToLoad.count).to(equal(13));
                        for (NSUInteger i = 0; i < testCellsToLoad.count; i++) {
                            expect((NSUInteger)testCellsToLoad[i].choiceId).to(equal(i + 11));
                        }
                        expect(SDLPreloadPresentChoicesOperationUtilities.reachedMaxId).to(beTrue());
                    });
                });

                context(@"when there are items scattered and overlapping setting cells", ^{
                    beforeEach(^{
                        SDLPreloadPresentChoicesOperationUtilities.choiceId = 10;

                        testLoadedCells = [self sdl_loadedCellsWithStartNum:3 endNum:10];
                        NSSet<SDLChoiceCell *> *secondLoadedCells = [self sdl_loadedCellsWithStartNum:50 endNum:55];
                        testLoadedCells = [testLoadedCells setByAddingObjectsFromSet:secondLoadedCells];

                        testCellsToLoad = [self sdl_cellsToLoadWithCount:10];
                    });

                    it(@"start from the last used id", ^{
                        [SDLPreloadPresentChoicesOperationUtilities assignIdsToCells:testCellsToLoad loadedCells:testLoadedCells];
                        expect(testCellsToLoad.count).to(equal(10));
                        for (NSUInteger i = 0; i < testCellsToLoad.count; i++) {
                            expect((NSUInteger)testCellsToLoad[i].choiceId).to(equal(i + 56));
                        }
                        expect(SDLPreloadPresentChoicesOperationUtilities.reachedMaxId).to(beTrue());
                    });
                });

                context(@"when not enough open ids are available", ^{
                    beforeEach(^{
                        SDLPreloadPresentChoicesOperationUtilities.choiceId = 10;

                        testLoadedCells = [self sdl_loadedCellsWithStartNum:3 endNum:10];
                        NSSet<SDLChoiceCell *> *secondLoadedCells = [self sdl_loadedCellsWithStartNum:12 endNum:65533];
                        testLoadedCells = [testLoadedCells setByAddingObjectsFromSet:secondLoadedCells];

                        testCellsToLoad = [self sdl_cellsToLoadWithCount:10];
                    });
                    it(@"should assign what it can and the rest should be UINT16_MAX", ^{
                        [SDLPreloadPresentChoicesOperationUtilities assignIdsToCells:testCellsToLoad loadedCells:testLoadedCells];
                        expect(testCellsToLoad.count).to(equal(10));

                        expect((NSUInteger)testCellsToLoad[0].choiceId).to(equal(65534));
                        expect((NSUInteger)testCellsToLoad[1].choiceId).to(equal(65535));
                        expect((NSUInteger)testCellsToLoad[2].choiceId).to(equal(0));
                        expect((NSUInteger)testCellsToLoad[3].choiceId).to(equal(1));
                        expect((NSUInteger)testCellsToLoad[4].choiceId).to(equal(2));
                        expect((NSUInteger)testCellsToLoad[5].choiceId).to(equal(11));
                        expect((NSUInteger)testCellsToLoad[6].choiceId).to(equal(65535));
                        expect((NSUInteger)testCellsToLoad[7].choiceId).to(equal(65535));
                        expect((NSUInteger)testCellsToLoad[8].choiceId).to(equal(65535));
                        expect((NSUInteger)testCellsToLoad[9].choiceId).to(equal(65535));

                        expect(SDLPreloadPresentChoicesOperationUtilities.reachedMaxId).to(beTrue());
                    });
                });
            });

            context(@"when loadedCells is full", ^{
                beforeEach(^{
                    SDLPreloadPresentChoicesOperationUtilities.choiceId = 65535;

                    testLoadedCells = [self sdl_loadedCellsWithStartNum:0 endNum:65535];
                    testCellsToLoad = [self sdl_cellsToLoadWithCount:10];
                });

                it(@"should set all ids to UINT16_MAX", ^{
                    [SDLPreloadPresentChoicesOperationUtilities assignIdsToCells:testCellsToLoad loadedCells:testLoadedCells];
                    expect(testCellsToLoad.count).to(equal(10));
                    for (NSUInteger i = 0; i < testCellsToLoad.count; i++) {
                        expect((NSUInteger)testCellsToLoad[i].choiceId).to(equal(65535));
                    }
                    expect(SDLPreloadPresentChoicesOperationUtilities.reachedMaxId).to(beTrue());
                });
            });
        });
    });

    describe(@"making cells unique", ^{
        __block SDLWindowCapability *enabledWindowCapability = nil;
        __block SDLWindowCapability *primaryTextOnlyCapability = nil;

        beforeEach(^{
            enabledWindowCapability = [[SDLWindowCapability alloc] init];
            enabledWindowCapability.textFields = @[
                [[SDLTextField alloc] initWithName:SDLTextFieldNameMenuName characterSet:SDLCharacterSetUtf8 width:500 rows:1],
                [[SDLTextField alloc] initWithName:SDLTextFieldNameSecondaryText characterSet:SDLCharacterSetUtf8 width:500 rows:1],
                [[SDLTextField alloc] initWithName:SDLTextFieldNameTertiaryText characterSet:SDLCharacterSetUtf8 width:500 rows:1]
            ];
            enabledWindowCapability.imageFields = @[
                [[SDLImageField alloc] initWithName:SDLImageFieldNameChoiceImage imageTypeSupported:@[SDLFileTypePNG] imageResolution:nil],
                [[SDLImageField alloc] initWithName:SDLImageFieldNameChoiceSecondaryImage imageTypeSupported:@[SDLFileTypePNG] imageResolution:nil]
            ];
            primaryTextOnlyCapability = [[SDLWindowCapability alloc] init];
            primaryTextOnlyCapability.textFields = @[
                [[SDLTextField alloc] initWithName:SDLTextFieldNameMenuName characterSet:SDLCharacterSetUtf8 width:500 rows:1],
            ];

            testLoadedCells = [NSSet set];
        });

        context(@"at RPC v7.1", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:7 minor:1 patch:0];
            });

            context(@"when cells are unique except when stripped", ^{
                beforeEach(^{
                    testCellsToLoad = [NSOrderedSet orderedSetWithArray:@[
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:@"Unique 1" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:@"Unique 2" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:@"Unique 3" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 2" secondaryText:@"Unique 1" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil]
                    ]];
                });

                context(@"with full window capability", ^{
                    beforeEach(^{
                        [SDLPreloadPresentChoicesOperationUtilities makeCellsToUploadUnique:testCellsToLoad.mutableCopy basedOnLoadedCells:testLoadedCells.mutableCopy windowCapability:enabledWindowCapability];
                    });

                    it(@"should not set unique titles", ^{
                        expect(testCellsToLoad[0].uniqueText).to(equal(testCellsToLoad[0].text));
                        expect(testCellsToLoad[1].uniqueText).to(equal(testCellsToLoad[1].text));
                        expect(testCellsToLoad[2].uniqueText).to(equal(testCellsToLoad[2].text));
                        expect(testCellsToLoad[3].uniqueText).to(equal(testCellsToLoad[3].text));
                    });
                });

                context(@"with primary text only capability", ^{
                    beforeEach(^{
                        [SDLPreloadPresentChoicesOperationUtilities makeCellsToUploadUnique:testCellsToLoad.mutableCopy basedOnLoadedCells:testLoadedCells.mutableCopy windowCapability:primaryTextOnlyCapability];
                    });

                    it(@"should set unique titles", ^{
                        expect(testCellsToLoad[0].uniqueText).to(equal(testCellsToLoad[0].text));
                        expect(testCellsToLoad[1].uniqueText).toNot(equal(testCellsToLoad[1].text));
                        expect(testCellsToLoad[2].uniqueText).toNot(equal(testCellsToLoad[2].text));
                        expect(testCellsToLoad[3].uniqueText).to(equal(testCellsToLoad[3].text));
                    });
                });
            });

            context(@"when cells are unique", ^{
                beforeEach(^{
                    testCellsToLoad = [NSOrderedSet orderedSetWithArray:@[
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 2" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 3" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 4" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil]
                    ]];

                    [SDLPreloadPresentChoicesOperationUtilities makeCellsToUploadUnique:testCellsToLoad.mutableCopy basedOnLoadedCells:testLoadedCells.mutableCopy windowCapability:enabledWindowCapability];
                });

                it(@"should not set unique titles", ^{
                    expect(testCellsToLoad[0].uniqueText).to(equal(testCellsToLoad[0].text));
                    expect(testCellsToLoad[1].uniqueText).to(equal(testCellsToLoad[1].text));
                    expect(testCellsToLoad[2].uniqueText).to(equal(testCellsToLoad[2].text));
                    expect(testCellsToLoad[3].uniqueText).to(equal(testCellsToLoad[3].text));
                });
            });

            context(@"when loaded cells match the cells when stripped", ^{
                beforeEach(^{
                    testLoadedCells = [NSSet setWithArray:@[
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1"],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 2"],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 3"],
                    ]];

                    testCellsToLoad = [NSOrderedSet orderedSetWithArray:@[
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:@"Unique" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 2" secondaryText:@"Unique" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:@"Unique 2" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 4" secondaryText:@"Unique" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil]
                    ]];
                });

                context(@"with full window capability", ^{
                    beforeEach(^{
                        [SDLPreloadPresentChoicesOperationUtilities makeCellsToUploadUnique:testCellsToLoad.mutableCopy basedOnLoadedCells:testLoadedCells.mutableCopy windowCapability:enabledWindowCapability];
                    });

                    it(@"should not make unique text", ^{
                        expect(testCellsToLoad[0].uniqueText).to(equal(testCellsToLoad[0].text));
                        expect(testCellsToLoad[1].uniqueText).to(equal(testCellsToLoad[1].text));
                        expect(testCellsToLoad[2].uniqueText).to(equal(testCellsToLoad[2].text));
                        expect(testCellsToLoad[3].uniqueText).to(equal(testCellsToLoad[3].text));
                    });
                });

                context(@"with primary text only capability", ^{
                    beforeEach(^{
                        [SDLPreloadPresentChoicesOperationUtilities makeCellsToUploadUnique:testCellsToLoad.mutableCopy basedOnLoadedCells:testLoadedCells.mutableCopy windowCapability:primaryTextOnlyCapability];
                    });

                    it(@"should not make unique text", ^{
                        expect(testCellsToLoad[0].uniqueText).toNot(equal(testCellsToLoad[0].text));
                        expect(testCellsToLoad[1].uniqueText).toNot(equal(testCellsToLoad[1].text));
                        expect(testCellsToLoad[2].uniqueText).toNot(equal(testCellsToLoad[2].text));
                        expect(testCellsToLoad[3].uniqueText).to(equal(testCellsToLoad[3].text));
                    });
                });
            });
        });

        context(@"below RPC v7.1", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:7 minor:0 patch:0];
            });

            context(@"when cells are unique except when stripped", ^{
                beforeEach(^{
                    testCellsToLoad = [NSOrderedSet orderedSetWithArray:@[
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:@"Unique 1" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:@"Unique 2" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:@"Unique 3" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 2" secondaryText:@"Unique 1" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil]
                    ]];

                    [SDLPreloadPresentChoicesOperationUtilities makeCellsToUploadUnique:testCellsToLoad.mutableCopy basedOnLoadedCells:testLoadedCells.mutableCopy windowCapability:enabledWindowCapability];
                });

                it(@"should set unique titles except the first and last", ^{
                    expect(testCellsToLoad[0].uniqueText).to(equal(testCellsToLoad[0].text));
                    expect(testCellsToLoad[1].uniqueText).toNot(equal(testCellsToLoad[1].text));
                    expect(testCellsToLoad[2].uniqueText).toNot(equal(testCellsToLoad[2].text));
                    expect(testCellsToLoad[3].uniqueText).to(equal(testCellsToLoad[3].text));
                });
            });

            context(@"when cells are unique", ^{
                beforeEach(^{
                    testCellsToLoad = [NSOrderedSet orderedSetWithArray:@[
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 2" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 3" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 4" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil]
                    ]];

                    [SDLPreloadPresentChoicesOperationUtilities makeCellsToUploadUnique:testCellsToLoad.mutableCopy basedOnLoadedCells:testLoadedCells.mutableCopy windowCapability:enabledWindowCapability];
                });

                it(@"should not set unique titles", ^{
                    expect(testCellsToLoad[0].uniqueText).to(equal(testCellsToLoad[0].text));
                    expect(testCellsToLoad[1].uniqueText).to(equal(testCellsToLoad[1].text));
                    expect(testCellsToLoad[2].uniqueText).to(equal(testCellsToLoad[2].text));
                    expect(testCellsToLoad[3].uniqueText).to(equal(testCellsToLoad[3].text));
                });
            });

            context(@"when loaded cells match the cells when stripped", ^{
                beforeEach(^{
                    testLoadedCells = [NSSet setWithArray:@[
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1"],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 2"],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 3"],
                    ]];

                    testCellsToLoad = [NSOrderedSet orderedSetWithArray:@[
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:@"Unique" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 2" secondaryText:@"Unique" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 1" secondaryText:@"Unique 2" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil],
                        [[SDLChoiceCell alloc] initWithText:@"Cell 4" secondaryText:@"Unique" tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil]
                    ]];
                });

                context(@"with full window capability", ^{
                    beforeEach(^{
                        [SDLPreloadPresentChoicesOperationUtilities makeCellsToUploadUnique:testCellsToLoad.mutableCopy basedOnLoadedCells:testLoadedCells.mutableCopy windowCapability:enabledWindowCapability];
                    });

                    it(@"should make unique text", ^{
                        expect(testCellsToLoad[0].uniqueText).toNot(equal(testCellsToLoad[0].text));
                        expect(testCellsToLoad[1].uniqueText).toNot(equal(testCellsToLoad[1].text));
                        expect(testCellsToLoad[2].uniqueText).toNot(equal(testCellsToLoad[2].text));
                        expect(testCellsToLoad[3].uniqueText).to(equal(testCellsToLoad[3].text));
                    });
                });

                context(@"with primary text only capability", ^{
                    beforeEach(^{
                        [SDLPreloadPresentChoicesOperationUtilities makeCellsToUploadUnique:testCellsToLoad.mutableCopy basedOnLoadedCells:testLoadedCells.mutableCopy windowCapability:primaryTextOnlyCapability];
                    });

                    it(@"should not make unique text", ^{
                        expect(testCellsToLoad[0].uniqueText).toNot(equal(testCellsToLoad[0].text));
                        expect(testCellsToLoad[1].uniqueText).toNot(equal(testCellsToLoad[1].text));
                        expect(testCellsToLoad[2].uniqueText).toNot(equal(testCellsToLoad[2].text));
                        expect(testCellsToLoad[3].uniqueText).to(equal(testCellsToLoad[3].text));
                    });
                });
            });
        });
    });

    describe(@"updating a choice set based on loaded cells and cells to upload", ^{
        __block SDLChoiceSet *testChoiceSet = nil;
        __block NSArray<SDLChoiceCell *> *basicChoiceCells = nil;
        __block NSMutableArray<SDLChoiceCell *> *testLoadedCellsArray = nil;

        beforeEach(^{
            basicChoiceCells = @[
                [[SDLChoiceCell alloc] initWithText:@"Cell 1"],
                [[SDLChoiceCell alloc] initWithText:@"Cell 2"],
                [[SDLChoiceCell alloc] initWithText:@"Cell 3"],
            ];

            // Has all three cells with no ids
            testChoiceSet = [[SDLChoiceSet alloc] init];
            testChoiceSet.choices = basicChoiceCells;

            // Has all three cells with different ids
            testCellsToLoad = [NSOrderedSet orderedSetWithArray:basicChoiceCells range:NSMakeRange(0, 3) copyItems:YES];
            for (NSUInteger i = 0; i < testCellsToLoad.count; i++) {
                testCellsToLoad[i].choiceId = i;
            }

            // Loaded cells has first two items with different ids
            testLoadedCellsArray = [[NSMutableArray alloc] initWithArray:basicChoiceCells copyItems:YES];
            [testLoadedCellsArray removeLastObject];
            for (NSUInteger i = 0; i < testLoadedCellsArray.count; i++) {
                testLoadedCellsArray[i].choiceId = i + 10;
            }
            testLoadedCells = [NSSet setWithArray:testLoadedCellsArray];
        });

        context(@"when there are no loaded cells", ^{
            it(@"should have all cells the same as cells to upload", ^{
                [SDLPreloadPresentChoicesOperationUtilities updateChoiceSet:testChoiceSet withLoadedCells:[NSSet set] cellsToUpload:testCellsToLoad.set];

                for (NSUInteger i = 0; i < testChoiceSet.choices.count; i++) {
                    expect((NSUInteger)testChoiceSet.choices[i].choiceId).to(equal(testCellsToLoad[i].choiceId));
                }
            });
        });

        context(@"when some loaded cells match", ^{
            it(@"should use the loaded cells when possible", ^{
                [SDLPreloadPresentChoicesOperationUtilities updateChoiceSet:testChoiceSet withLoadedCells:testLoadedCells cellsToUpload:testCellsToLoad.set];

                expect((NSUInteger)testChoiceSet.choices[0].choiceId).to(equal(testLoadedCellsArray[0].choiceId));
                expect((NSUInteger)testChoiceSet.choices[1].choiceId).to(equal(testLoadedCellsArray[1].choiceId));
                expect((NSUInteger)testChoiceSet.choices[2].choiceId).to(equal(testCellsToLoad[2].choiceId));
            });
        });
    });
}

@end
