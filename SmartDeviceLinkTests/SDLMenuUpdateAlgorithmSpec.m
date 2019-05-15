//
//  SDLMenuUpdateAlgorithmSpec.m
//  SmartDeviceLinkTests
//
//  Created by Justin Gluck on 5/15/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLMenuCell.h"
#import "SDLMenuRunScore.h"
#import "SDLMenuUpdateAlgorithm.h"

QuickSpecBegin(SDLMenuUpdateAlgorithmSpec)

typedef NS_ENUM(NSUInteger, MenuCellState) {
    MenuCellStateDelete,
    MenuCellStateAdd,
    MenuCellStateKeep
};

describe(@"menuUpdateAlgorithm", ^{
    __block SDLMenuRunScore *runScore = nil;
    //__block SDLMenuUpdateAlgorithm *updatelgorithm = nil;

    __block SDLMenuCell *oldCell1 = nil;
    __block SDLMenuCell *oldCell2 = nil;
    __block SDLMenuCell *oldCell3 = nil;
    __block SDLMenuCell *oldCell4 = nil;

    __block SDLMenuCell *newCell1 = nil;
    __block SDLMenuCell *newCell2 = nil;
    __block SDLMenuCell *newCell3 = nil;
    __block SDLMenuCell *newCell4 = nil;
    __block SDLMenuCell *newCell5 = nil;

    // 0 = Delete   1 = Add    2 = Keep
    describe(@"compare old and new menu cells", ^{

        it(@"new menu status should best run of 22221", ^{
            oldCell1 = [[SDLMenuCell alloc] initWithTitle:@"Cell 1" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            oldCell2 = [[SDLMenuCell alloc] initWithTitle:@"Cell 2" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            oldCell3 = [[SDLMenuCell alloc] initWithTitle:@"Cell 3" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            oldCell4 = [[SDLMenuCell alloc] initWithTitle:@"Cell 4" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

            newCell1 = [[SDLMenuCell alloc] initWithTitle:@"Cell 1" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            newCell2 = [[SDLMenuCell alloc] initWithTitle:@"Cell 2" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            newCell3 = [[SDLMenuCell alloc] initWithTitle:@"Cell 3" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            newCell4 = [[SDLMenuCell alloc] initWithTitle:@"Cell 4" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
            newCell5 = [[SDLMenuCell alloc] initWithTitle:@"Cell 5" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];

            NSArray<SDLMenuCell *> *oldMenuCells = @[oldCell1, oldCell2, oldCell3, oldCell4];
            NSArray<SDLMenuCell *> *newMenuCells = @[newCell1, newCell2, newCell3, newCell4, newCell5];

            runScore = [SDLMenuUpdateAlgorithm compareOldMenuCells:oldMenuCells updatedMenuCells:newMenuCells];
            expect(runScore.updatedStatus[0].integerValue).to(equal(@(MenuCellStateKeep)));
            expect(runScore.updatedStatus[1].integerValue).to(equal(@(MenuCellStateKeep)));
            expect(runScore.updatedStatus[2].integerValue).to(equal(@(MenuCellStateKeep)));
            expect(runScore.updatedStatus[3].integerValue).to(equal(@(MenuCellStateKeep)));
            expect(runScore.updatedStatus[4].integerValue).to(equal(@(MenuCellStateAdd)));
        });
    });
});

QuickSpecEnd
