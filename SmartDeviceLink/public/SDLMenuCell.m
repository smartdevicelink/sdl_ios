//
//  SDLMenuCell.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLMenuCell.h"

#import "SDLArtwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;

@end

@implementation SDLMenuCell

- (instancetype)initWithTitle:(NSString *)title icon:(nullable SDLArtwork *)icon voiceCommands:(nullable NSArray<NSString *> *)voiceCommands handler:(SDLMenuCellSelectionHandler)handler {
    self = [super init];
    if (!self) { return nil; }

    _title = title;
    _icon = icon;
    _voiceCommands = voiceCommands;
    _handler = handler;

    _cellId = UINT32_MAX;
    _parentCellId = UINT32_MAX;

    return self;
}

- (instancetype)initWithTitle:(NSString *)title icon:(nullable SDLArtwork *)icon submenuLayout:(nullable SDLMenuLayout)layout subCells:(NSArray<SDLMenuCell *> *)subCells {
    self = [super init];
    if (!self) { return nil; }

    _title = title;
    _submenuLayout = layout;
    _icon = icon;
    _subCells = subCells;

    _cellId = UINT32_MAX;
    _parentCellId = UINT32_MAX;

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SDLMenuCell: %u-\"%@\", artworkName: %@, voice commands: %lu, isSubcell: %@, hasSubcells: %@, submenuLayout: %@", (unsigned int)_cellId, _title, _icon.name, (unsigned long)_voiceCommands.count, (_parentCellId != UINT32_MAX ? @"YES" : @"NO"), (_subCells.count > 0 ? @"YES" : @"NO"), _submenuLayout];
}

#pragma mark - Object Equality

NSUInteger const NSUIntBitCell = (CHAR_BIT * sizeof(NSUInteger));
NSUInteger NSUIntRotateCell(NSUInteger val, NSUInteger howMuch) {
    return ((((NSUInteger)val) << howMuch) | (((NSUInteger)val) >> (NSUIntBitCell - howMuch)));
}

- (NSUInteger)hash {
    return NSUIntRotateCell(self.title.hash, NSUIntBitCell / 2)
    ^ NSUIntRotateCell(self.icon.name.hash, NSUIntBitCell / 3)
    ^ NSUIntRotateCell(self.voiceCommands.hash, NSUIntBitCell / 4)
    ^ NSUIntRotateCell(self.subCells.count !=0, NSUIntBitCell  / 5)
    ^ NSUIntRotateCell(self.submenuLayout.hash, NSUIntBitCell / 6);
}

- (BOOL)isEqual:(id)object {
    if (self == object) { return YES; }
    if (![object isMemberOfClass:[self class]]) { return NO; }

    return [self isEqualToChoice:(SDLMenuCell *)object];
}

- (BOOL)isEqualToChoice:(SDLMenuCell *)choice {
    if (choice == nil) { return NO; }

    return (self.hash == choice.hash);
}

@end

NS_ASSUME_NONNULL_END
