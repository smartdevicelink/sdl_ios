//
//  SDLMenuCell.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLMenuCell.h"

#import "SDLArtwork.h"
#import "NSArray+Extensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;
@property (strong, nonatomic, readwrite) NSString *uniqueTitle;

@property (copy, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *icon;
@property (copy, nonatomic, readwrite, nullable) NSArray<NSString *> *voiceCommands;
@property (copy, nonatomic, readwrite, nullable) NSString *secondaryText;
@property (copy, nonatomic, readwrite, nullable) NSString *tertiaryText;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *secondaryArtwork;
@property (copy, nonatomic, readwrite, nullable) NSArray<SDLMenuCell *> *subCells;
@property (copy, nonatomic, readwrite, nullable) SDLMenuCellSelectionHandler handler;

@end

@implementation SDLMenuCell

- (instancetype)initWithTitle:(NSString *)title icon:(nullable SDLArtwork *)icon voiceCommands:(nullable NSArray<NSString *> *)voiceCommands handler:(SDLMenuCellSelectionHandler)handler {
    return [self initWithTitle:title secondaryText:nil tertiaryText:nil icon:icon secondaryArtwork:nil voiceCommands:voiceCommands handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title icon:(nullable SDLArtwork *)icon submenuLayout:(nullable SDLMenuLayout)layout subCells:(NSArray<SDLMenuCell *> *)subCells {
    return [self initWithTitle:title secondaryText:nil tertiaryText:nil icon:icon secondaryArtwork:nil submenuLayout:layout subCells:subCells];
}

- (instancetype)initWithTitle:(NSString *)title secondaryText:(nullable NSString *)secondaryText tertiaryText:(nullable NSString *)tertiaryText icon:(nullable SDLArtwork *)icon secondaryArtwork:(nullable SDLArtwork *)secondaryArtwork voiceCommands:(nullable NSArray<NSString *> *)voiceCommands handler:(SDLMenuCellSelectionHandler)handler {
    self = [super init];
    if (!self) { return nil; }

    _title = title;
    _icon = icon;
    _voiceCommands = voiceCommands;
    _handler = handler;
    _uniqueTitle = title;

    _cellId = UINT32_MAX;
    _parentCellId = UINT32_MAX;

    _secondaryText = secondaryText;
    _tertiaryText = tertiaryText;
    _secondaryArtwork = secondaryArtwork;

    return self;
}

- (instancetype)initWithTitle:(NSString *)title secondaryText:(nullable NSString *)secondaryText tertiaryText:(nullable NSString *)tertiaryText icon:(nullable SDLArtwork *)icon secondaryArtwork:(nullable SDLArtwork *)secondaryArtwork submenuLayout:(nullable SDLMenuLayout)layout subCells:(NSArray<SDLMenuCell *> *)subCells {

    self = [super init];
    if (!self) { return nil; }

    _title = title;
    _submenuLayout = layout;
    _icon = icon;
    _subCells = subCells;
    _uniqueTitle = title;

    _cellId = UINT32_MAX;
    _parentCellId = UINT32_MAX;

    _secondaryText = secondaryText;
    _tertiaryText = tertiaryText;
    _secondaryArtwork = secondaryArtwork;

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SDLMenuCell: %u-\"%@\" | \"%@\" | \"%@\", unique title: %@, artworkNames: %@ | %@, voice commands: %lu, isSubcell: %@, hasSubcells: %@, submenuLayout: %@", (unsigned int)_cellId, _title, _secondaryText, _tertiaryText, ([_title isEqualToString:_uniqueTitle] ? @"NO" : _uniqueTitle), _icon.name, _secondaryArtwork.name, (unsigned long)_voiceCommands.count, (_parentCellId != UINT32_MAX ? @"YES" : @"NO"), (_subCells.count > 0 ? @"YES" : @"NO"), _submenuLayout];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"SDLMenuCell: %u-\"%@\" | \"%@\" | \"%@\", unique title: %@, artworkNames: %@ | %@, voice commands: %@, parentCellId: %@, subcells: %@, submenuLayout: %@", (unsigned int)_cellId, _title, _secondaryText, _tertiaryText, ([_title isEqualToString:_uniqueTitle] ? @"NO" : _uniqueTitle), _icon.name, _secondaryArtwork.name, _voiceCommands, (_parentCellId != UINT32_MAX ? @(_parentCellId) : @"NO"), _subCells, _submenuLayout];
}

#pragma mark - Object Equality

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLMenuCell *newCell = [[SDLMenuCell allocWithZone:zone] initWithTitle:_title secondaryText:_secondaryText tertiaryText:_tertiaryText icon:_icon secondaryArtwork:_secondaryArtwork voiceCommands:_voiceCommands handler:_handler];

    if (_subCells.count > 0) {
        newCell.subCells = [[NSArray alloc] initWithArray:_subCells copyItems:YES];
    }

    return newCell;
}

- (NSUInteger)hash {
    return NSUIntRotateCell(self.title.hash, NSUIntBitCell / 2)
    ^ NSUIntRotateCell(self.icon.name.hash, NSUIntBitCell / 3)
    ^ NSUIntRotateCell(self.voiceCommands.dynamicHash, NSUIntBitCell / 4)
    ^ NSUIntRotateCell((self.subCells.count != 0), NSUIntBitCell  / 5)
    ^ NSUIntRotateCell(self.secondaryText.hash, NSUIntBitCell  / 6)
    ^ NSUIntRotateCell(self.tertiaryText.hash, NSUIntBitCell  / 7)
    ^ NSUIntRotateCell(self.secondaryArtwork.name.hash, NSUIntBitCell  / 8)
    ^ NSUIntRotateCell(self.submenuLayout.hash, NSUIntBitCell / 9);
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
