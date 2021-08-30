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
                            expect((NSUInteger)testCellsToLoad[i].choiceId).to(equal(i));
                        }
                        expect(SDLPreloadPresentChoicesOperationUtilities.reachedMaxId).to(beFalse());
                    });
                });

                context(@"when reaching the max value", ^{
                    beforeEach(^{
                        SDLPreloadPresentChoicesOperationUtilities.choiceId = 65500;

                        testLoadedCells = [NSSet set];
                        testCellsToLoad = [self sdl_cellsToLoadWithCount:35];
                    });

                    fit(@"should set the reachedMaxId BOOL and loop back over", ^{
                        [SDLPreloadPresentChoicesOperationUtilities assignIdsToCells:testCellsToLoad loadedCells:testLoadedCells];
                        expect(testCellsToLoad.count).to(equal(35));
                        for (NSUInteger i = 0; i < testCellsToLoad.count; i++) {
                            expect((NSUInteger)testCellsToLoad[i+65500].choiceId).to(equal(i));
                        }
                        expect(SDLPreloadPresentChoicesOperationUtilities.reachedMaxId).to(beTrue());
                    });
                });
            });
        });

        context(@"on subsequent loops of assigning ids", ^{
            context(@"when loadedCells is not full", ^{
                context(@"when those cells are contiguous at the beginning", ^{
                    it(@"should assign ids after those", ^{

                    });
                });

                context(@"when those items are contiguous in the middle so that assigning cells overlap", ^{
                    it(@"should assign the early ids, skip the middle, then assign the end", ^{

                    });
                });

                context(@"when there are items scattered and overlapping setting cells", ^{
                    it(@"should skip the already set ids", ^{

                    });
                });

                context(@"when not enough open ids are available", ^{
                    it(@"should assign what it can and the rest should be UINT16_MAX", ^{

                    });
                });
            });

            context(@"when loadedCells is full", ^{
                it(@"should set all ids to UINT16_MAX", ^{

                });
            });
        });
    });

    QuickSpecEnd
