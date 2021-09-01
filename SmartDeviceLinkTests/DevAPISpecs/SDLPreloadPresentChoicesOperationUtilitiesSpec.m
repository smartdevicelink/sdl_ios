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

#import "SDLChoiceCell.h"
#import "SDLPreloadPresentChoicesOperationUtilities.h"

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLPreloadPresentChoicesOperationUtilitiesSpec : QuickSpec @end
@implementation SDLPreloadPresentChoicesOperationUtilitiesSpec

- (NSOrderedSet<SDLChoiceCell *> *)sdl_cellsToLoadWithCount:(UInt16)count {
    NSMutableOrderedSet<SDLChoiceCell *> *mutableCells = [NSMutableOrderedSet orderedSetWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
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
                SDLPreloadPresentChoicesOperationUtilities.choiceId = 0;
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
                        expect((NSUInteger)testCellsToLoad[i].choiceId).to(equal(i));
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
                SDLPreloadPresentChoicesOperationUtilities.choiceId = 0;
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

    QuickSpecEnd
