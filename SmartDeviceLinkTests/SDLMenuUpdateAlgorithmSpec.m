//
//  SDLMenuUpdateAlgorithmSpec.m
//  SmartDeviceLinkTests
//
//  Created by Justin Gluck on 5/15/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;
@import OCMock;

#import "SDLMenuCell.h"
#import "SDLDynamicMenuUpdateRunScore.h"
#import "SDLDynamicMenuUpdateAlgorithm.h"

QuickSpecBegin(SDLMenuUpdateAlgorithmSpec)

typedef NS_ENUM(NSUInteger, MenuCellState) {
    MenuCellStateDelete,
    MenuCellStateAdd,
    MenuCellStateKeep
};

describe(@"The menu update algorithm", ^{
    __block SDLDynamicMenuUpdateRunScore *runScore = nil;

    __block SDLMenuCell *oldCell1 = nil;
    __block SDLMenuCell *oldCell2 = nil;
    __block SDLMenuCell *oldCell3 = nil;
    __block SDLMenuCell *oldCell4 = nil;
    __block SDLMenuCell *oldCell5 = nil;
    __block SDLMenuCell *oldCell6 = nil;

    __block SDLMenuCell *newCell1 = nil;
    __block SDLMenuCell *newCell2 = nil;
    __block SDLMenuCell *newCell3 = nil;
    __block SDLMenuCell *newCell4 = nil;
    __block SDLMenuCell *newCell5 = nil;
    __block SDLMenuCell *newCell6 = nil;

    // 0 = Delete, 1 = Add, 2 = Keep
    describe(@"compare old and new menu cells", ^{
        beforeEach(^{
            oldCell1 = [[SDLMenuCell alloc] initWithTitle:@"Cell 1" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            oldCell2 = [[SDLMenuCell alloc] initWithTitle:@"Cell 2" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            oldCell3 = [[SDLMenuCell alloc] initWithTitle:@"Cell 3" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            oldCell4 = [[SDLMenuCell alloc] initWithTitle:@"Cell 4" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            oldCell5 = [[SDLMenuCell alloc] initWithTitle:@"Cell 5" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            oldCell6 = [[SDLMenuCell alloc] initWithTitle:@"Cell 6" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

            newCell1 = [[SDLMenuCell alloc] initWithTitle:@"Cell 1" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            newCell2 = [[SDLMenuCell alloc] initWithTitle:@"Cell 2" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            newCell3 = [[SDLMenuCell alloc] initWithTitle:@"Cell 3" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            newCell4 = [[SDLMenuCell alloc] initWithTitle:@"Cell 4" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            newCell5 = [[SDLMenuCell alloc] initWithTitle:@"Cell 5" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            newCell6 = [[SDLMenuCell alloc] initWithTitle:@"Cell 6" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
        });

        it(@"should have a new menu status of 22221 and an old menu status of 2222 on best run", ^{
            NSArray<SDLMenuCell *> *oldMenuCells = @[oldCell1, oldCell2, oldCell3, oldCell4];
            NSArray<SDLMenuCell *> *updatedMenuCells = @[newCell1, newCell2, newCell3, newCell4, newCell5];

            runScore = [SDLDynamicMenuUpdateAlgorithm dynamicRunScoreOldMenuCells:oldMenuCells updatedMenuCells:updatedMenuCells];

            expect(runScore.updatedStatus.count).to(equal(5));
            expect(runScore.oldStatus.count).to(equal(4));
            expect(runScore.score).to(equal(1));

            expect(runScore.updatedStatus[0].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.updatedStatus[1].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.updatedStatus[2].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.updatedStatus[3].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.updatedStatus[4].integerValue).to(equal(MenuCellStateAdd));

            expect(runScore.oldStatus[0].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.oldStatus[1].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.oldStatus[2].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.oldStatus[3].integerValue).to(equal(MenuCellStateKeep));
        });

        it(@"should have a new menu status of 222 and an old menu status of 2220 on best run", ^{

            NSArray<SDLMenuCell *> *oldMenuCells = @[oldCell1, oldCell2, oldCell3, oldCell4];
            NSArray<SDLMenuCell *> *updatedMenuCells = @[newCell1, newCell2, newCell3];

            runScore = [SDLDynamicMenuUpdateAlgorithm dynamicRunScoreOldMenuCells:oldMenuCells updatedMenuCells:updatedMenuCells];

            expect(runScore.updatedStatus.count).to(equal(3));
            expect(runScore.oldStatus.count).to(equal(4));
            expect(runScore.score).to(equal(0));

            expect(runScore.updatedStatus[0].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.updatedStatus[1].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.updatedStatus[2].integerValue).to(equal(MenuCellStateKeep));

            expect(runScore.oldStatus[0].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.oldStatus[1].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.oldStatus[2].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.oldStatus[3].integerValue).to(equal(MenuCellStateDelete));
        });

        it(@"should have a new menu status of 111 and an old menu status of 000 on best run", ^{
            NSArray<SDLMenuCell *> *oldMenuCells = @[oldCell1, oldCell2, oldCell3];
            NSArray<SDLMenuCell *> *updatedMenuCells = @[newCell4, newCell5, newCell6];

            runScore = [SDLDynamicMenuUpdateAlgorithm dynamicRunScoreOldMenuCells:oldMenuCells updatedMenuCells:updatedMenuCells];

            expect(runScore.updatedStatus.count).to(equal(3));
            expect(runScore.oldStatus.count).to(equal(3));
            expect(runScore.score).to(equal(3));

            expect(runScore.updatedStatus[0].integerValue).to(equal(MenuCellStateAdd));
            expect(runScore.updatedStatus[1].integerValue).to(equal(MenuCellStateAdd));
            expect(runScore.updatedStatus[2].integerValue).to(equal(MenuCellStateAdd));

            expect(runScore.oldStatus[0].integerValue).to(equal(MenuCellStateDelete));
            expect(runScore.oldStatus[1].integerValue).to(equal(MenuCellStateDelete));
            expect(runScore.oldStatus[2].integerValue).to(equal(MenuCellStateDelete));
        });

        it(@"should have a new menu status of 1212 and an old menu status of 2020 on best run", ^{
            NSArray<SDLMenuCell *> *oldMenuCells = @[oldCell1, oldCell2, oldCell3, oldCell4];
            NSArray<SDLMenuCell *> *updatedMenuCells = @[oldCell2, oldCell1, oldCell4, oldCell3 ];

            runScore = [SDLDynamicMenuUpdateAlgorithm dynamicRunScoreOldMenuCells:oldMenuCells updatedMenuCells:updatedMenuCells];

            expect(runScore.updatedStatus.count).to(equal(4));
            expect(runScore.oldStatus.count).to(equal(4));
            expect(runScore.score).to(equal(2));

            expect(runScore.updatedStatus[0].integerValue).to(equal(MenuCellStateAdd));
            expect(runScore.updatedStatus[1].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.updatedStatus[2].integerValue).to(equal(MenuCellStateAdd));
            expect(runScore.updatedStatus[3].integerValue).to(equal(MenuCellStateKeep));

            expect(runScore.oldStatus[0].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.oldStatus[1].integerValue).to(equal(MenuCellStateDelete));
            expect(runScore.oldStatus[2].integerValue).to(equal(MenuCellStateKeep));
            expect(runScore.oldStatus[3].integerValue).to(equal(MenuCellStateDelete));
        });

        it(@"should have no new menu status and an old menu status is 2222", ^{
            NSArray<SDLMenuCell *> *oldMenuCells = @[oldCell1, oldCell2, oldCell3, oldCell4];
            NSArray<SDLMenuCell *> *updatedMenuCells = @[];

            runScore = [SDLDynamicMenuUpdateAlgorithm dynamicRunScoreOldMenuCells:oldMenuCells updatedMenuCells:updatedMenuCells];

            expect(runScore.updatedStatus.count).to(equal(0));
            expect(runScore.oldStatus.count).to(equal(4));
            expect(runScore.score).to(equal(0));

            expect(runScore.oldStatus[0].integerValue).to(equal(MenuCellStateDelete));
            expect(runScore.oldStatus[1].integerValue).to(equal(MenuCellStateDelete));
            expect(runScore.oldStatus[2].integerValue).to(equal(MenuCellStateDelete));
            expect(runScore.oldStatus[3].integerValue).to(equal(MenuCellStateDelete));
        });

        it(@"should have menu status of 1111 and no old menu status", ^{
            NSArray<SDLMenuCell *> *oldMenuCells = @[];
            NSArray<SDLMenuCell *> *updatedMenuCells = @[oldCell1, oldCell2, oldCell3, oldCell4];

            runScore = [SDLDynamicMenuUpdateAlgorithm dynamicRunScoreOldMenuCells:oldMenuCells updatedMenuCells:updatedMenuCells];

            expect(runScore.updatedStatus.count).to(equal(4));
            expect(runScore.oldStatus.count).to(equal(0));
            expect(runScore.score).to(equal(4));

            expect(runScore.updatedStatus[0].integerValue).to(equal(MenuCellStateAdd));
            expect(runScore.updatedStatus[1].integerValue).to(equal(MenuCellStateAdd));
            expect(runScore.updatedStatus[2].integerValue).to(equal(MenuCellStateAdd));
            expect(runScore.updatedStatus[3].integerValue).to(equal(MenuCellStateAdd));
        });


        it(@"should return nil of old and new menu is an empty array", ^{
            NSArray<SDLMenuCell *> *oldMenuCells = @[];
            NSArray<SDLMenuCell *> *updatedMenuCells = @[];

            runScore = [SDLDynamicMenuUpdateAlgorithm dynamicRunScoreOldMenuCells:oldMenuCells updatedMenuCells:updatedMenuCells];

            expect(runScore.isEmpty).to(beTrue());
        });
    });
});

QuickSpecEnd
