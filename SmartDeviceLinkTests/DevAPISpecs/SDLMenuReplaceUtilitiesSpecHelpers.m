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

+ (NSArray<SDLMenuCell *> *)topLevelMenuOnly {
    NSData *cellArtData = [@"testart" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cellArtData2 = [@"testart2" dataUsingEncoding:NSUTF8StringEncoding];
    return @[
        [[SDLMenuCell alloc] initWithTitle:@"Item 1" icon:[[SDLArtwork alloc] initWithData:cellArtData name:@"Test Art 1" fileExtension:@"png" persistent:NO] voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}],
        [[SDLMenuCell alloc] initWithTitle:@"Item 2" icon:[[SDLArtwork alloc] initWithData:cellArtData2 name:@"Test Art 1" fileExtension:@"png" persistent:NO] voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}],
        [[SDLMenuCell alloc] initWithTitle:@"Item 3" icon:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}]
    ];
}

+ (NSArray<SDLMenuCell *> *)deepMenu {
    NSData *cellArtData = [@"testart" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cellArtData2 = [@"testart2" dataUsingEncoding:NSUTF8StringEncoding];

    NSArray<SDLMenuCell *> *subList1SubList1SubList1 = @[
    ];

    NSArray<SDLMenuCell *> *subList1SubList1SubList2 = @[
    ];

    NSArray<SDLMenuCell *> *subList1SubList1 = @[
    ];

    NSArray<SDLMenuCell *> *subList1 = @[
    ];

    NSArray<SDLMenuCell *> *subList2 = @[
    ];

    return @[
        [[SDLMenuCell alloc] initWithTitle:@"Item 1" icon:[[SDLArtwork alloc] initWithData:cellArtData name:@"Test Art 1" fileExtension:@"png" persistent:NO] submenuLayout:nil subCells:subList1],
        [[SDLMenuCell alloc] initWithTitle:@"Item 2" icon:[[SDLArtwork alloc] initWithData:cellArtData2 name:@"Test Art 1" fileExtension:@"png" persistent:NO] voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {}],
        [[SDLMenuCell alloc] initWithTitle:@"Item 3" icon:nil submenuLayout:nil subCells:subList2]
    ];
}

@end
