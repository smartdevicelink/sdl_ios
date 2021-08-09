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

@implementation SDLMenuReplaceUtilitiesSpecHelpers

+ (NSArray<SDLMenuCell *> *)topLevelOnlyMenu {
    NSData *cellArtData = [@"testart" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cellArtData2 = [@"testart2" dataUsingEncoding:NSUTF8StringEncoding];
    SDLArtwork *artwork1 = [[SDLArtwork alloc] initWithData:cellArtData name:@"Test Art 1" fileExtension:@"png" persistent:NO];
    SDLArtwork *artwork2 = [[SDLArtwork alloc] initWithData:cellArtData2 name:@"Test Art 2" fileExtension:@"png" persistent:NO];

    return @[
        [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:nil tertiaryText:nil icon:artwork1 secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}],
        [[SDLMenuCell alloc] initWithTitle:@"Item 2" secondaryText:nil tertiaryText:nil icon:artwork1 secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}],
        [[SDLMenuCell alloc] initWithTitle:@"Item 3" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:artwork2 voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}]
    ];
}

+ (NSArray<SDLMenuCell *> *)deepMenu {
    NSData *cellArtData = [@"testart" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cellArtData2 = [@"testart2" dataUsingEncoding:NSUTF8StringEncoding];
    SDLArtwork *artwork1 = [[SDLArtwork alloc] initWithData:cellArtData name:@"Test Art 1" fileExtension:@"png" persistent:NO];
    SDLArtwork *artwork2 = [[SDLArtwork alloc] initWithData:cellArtData2 name:@"Test Art 2" fileExtension:@"png" persistent:NO];

    NSArray<SDLMenuCell *> *subList1SubList1 = @[
        [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:@"SubItem 1" tertiaryText:@"Sub-SubItem 1" icon:artwork1 secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}],
        [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:@"SubItem 1" tertiaryText:@"Sub-SubItem 2" icon:artwork1 secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}]
    ];

    NSArray<SDLMenuCell *> *subList1 = @[
        [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:@"SubItem 1" tertiaryText:nil icon:artwork1 secondaryArtwork:nil submenuLayout:nil subCells:subList1SubList1],
        [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:@"SubItem 2" tertiaryText:nil icon:artwork1 secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}]
    ];

    NSArray<SDLMenuCell *> *subList2 = @[
        [[SDLMenuCell alloc] initWithTitle:@"Item 2" secondaryText:@"SubItem 1" tertiaryText:nil icon:artwork1 secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}],
        [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:@"SubItem 2" tertiaryText:nil icon:artwork1 secondaryArtwork:artwork2 voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}]
    ];

    return @[
        [[SDLMenuCell alloc] initWithTitle:@"Item 1" secondaryText:nil tertiaryText:nil icon:artwork1 secondaryArtwork:nil submenuLayout:nil subCells:subList1],
        [[SDLMenuCell alloc] initWithTitle:@"Item 2" secondaryText:nil tertiaryText:nil icon:artwork1 secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}],
        [[SDLMenuCell alloc] initWithTitle:@"Item 3" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil submenuLayout:nil subCells:subList2]
    ];
}

@end
