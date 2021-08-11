//
//  SDLMenuReplaceUtilitiesSpecHelpers.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 1/29/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLMenuReplaceUtilitiesSpecHelpers.h"

#import "SDLArtwork.h"
#import "SDLMenuCell.h"

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;

@end

@implementation SDLMenuReplaceUtilitiesSpecHelpers

+ (NSMutableArray<SDLMenuCell *> *)topLevelOnlyMenu {
    NSData *cellArtData = [@"testart" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cellArtData2 = [@"testart2" dataUsingEncoding:NSUTF8StringEncoding];
    SDLArtwork *artwork1 = [[SDLArtwork alloc] initWithData:cellArtData name:@"Test Art 1" fileExtension:@"png" persistent:NO];
    SDLArtwork *artwork2 = [[SDLArtwork alloc] initWithData:cellArtData2 name:@"Test Art 2" fileExtension:@"png" persistent:NO];

    SDLMenuCell *cell1 = [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:nil tertiaryText:nil icon:artwork1 secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
    cell1.cellId = 1;

    SDLMenuCell *cell2 = [[SDLMenuCell alloc] initWithTitle:@"Item 2" secondaryText:nil tertiaryText:nil icon:artwork1 secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
    cell2.cellId = 2;

    SDLMenuCell *cell3 = [[SDLMenuCell alloc] initWithTitle:@"Item 3" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:artwork2 voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
    cell3.cellId = 3;

    return [@[cell1, cell2, cell3] mutableCopy];
}

+ (NSMutableArray<SDLMenuCell *> *)deepMenu {
    NSData *cellArtData = [@"testart" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cellArtData2 = [@"testart2" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cellArtData3 = [@"testart3" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cellArtData4 = [@"testart4" dataUsingEncoding:NSUTF8StringEncoding];
    SDLArtwork *artwork1 = [[SDLArtwork alloc] initWithData:cellArtData name:@"Test Art 1" fileExtension:@"png" persistent:NO];
    SDLArtwork *artwork2 = [[SDLArtwork alloc] initWithData:cellArtData2 name:@"Test Art 2" fileExtension:@"png" persistent:NO];
    SDLArtwork *artwork3 = [[SDLArtwork alloc] initWithData:cellArtData3 name:@"Test Art 3" fileExtension:@"png" persistent:NO];
    SDLArtwork *artwork4 = [[SDLArtwork alloc] initWithData:cellArtData4 name:@"Test Art 4" fileExtension:@"png" persistent:NO];

    SDLMenuCell *subList1SubList1Cell1 = [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:@"SubItem 1" tertiaryText:@"Sub-SubItem 1" icon:nil secondaryArtwork:artwork3 voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
//    subList1SubList1Cell1.cellId = 1;
    SDLMenuCell *subList1SubList1Cell2 = [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:@"SubItem 1" tertiaryText:@"Sub-SubItem 2" icon:artwork1 secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
//    subList1SubList1Cell2.cellId = 2;
    NSArray<SDLMenuCell *> *subList1SubList1 = @[subList1SubList1Cell1, subList1SubList1Cell2];

    SDLMenuCell *subList1Cell1 = [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:@"SubItem 1" tertiaryText:nil icon:artwork4 secondaryArtwork:nil submenuLayout:nil subCells:subList1SubList1];
//    subList1Cell1.cellId = 3;
    SDLMenuCell *subList1Cell2 = [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:@"SubItem 2" tertiaryText:nil icon:artwork2 secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
//    subList1Cell2.cellId = 4;
    NSArray<SDLMenuCell *> *subList1 = @[subList1Cell1, subList1Cell2];

    SDLMenuCell *subList2Cell1 = [[SDLMenuCell alloc] initWithTitle:@"Item 3" secondaryText:@"SubItem 1" tertiaryText:nil icon:artwork1 secondaryArtwork:artwork4 voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
//    subList2Cell1.cellId = 5;
    SDLMenuCell *subList2Cell2 = [[SDLMenuCell alloc] initWithTitle:@"Item 3" secondaryText:@"SubItem 2" tertiaryText:nil icon:artwork1 secondaryArtwork:artwork2 voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
//    subList2Cell2.cellId = 6;
    NSArray<SDLMenuCell *> *subList2 = @[subList2Cell1, subList2Cell2];

    SDLMenuCell *topListCell1 = [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:nil tertiaryText:nil icon:artwork1 secondaryArtwork:nil submenuLayout:nil subCells:subList1];
//    topListCell1.cellId = 7;
    SDLMenuCell *topListCell2 = [[SDLMenuCell alloc] initWithTitle:@"Item 2" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}];
//    topListCell2.cellId = 8;
    SDLMenuCell *topListCell3 = [[SDLMenuCell alloc] initWithTitle:@"Item 3" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil submenuLayout:nil subCells:subList2];
//    topListCell3.cellId = 9;

    return [@[topListCell1, topListCell2, topListCell3] mutableCopy];
}

@end
