//
//  SDLChoiceCell.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 Livio. All rights reserved.
//

#import "SDLChoiceCell.h"

#import "SDLArtwork.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLChoiceCell

#pragma mark - Object Lifecycle

- (instancetype)initWithText:(NSString *)text {
    return [self initWithText:text secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:nil];
}

- (instancetype)initWithText:(NSString *)text artwork:(nullable SDLArtwork *)artwork voiceCommands:(nullable NSArray<NSString *> *)voiceCommands {
    return [self initWithText:text secondaryText:nil tertiaryText:nil voiceCommands:voiceCommands artwork:artwork secondaryArtwork:nil];
}

- (instancetype)initWithText:(NSString *)text secondaryText:(nullable NSString *)secondaryText tertiaryText:(nullable NSString *)tertiaryText voiceCommands:(nullable NSArray<NSString *> *)voiceCommands artwork:(nullable SDLArtwork *)artwork secondaryArtwork:(nullable SDLArtwork *)secondaryArtwork {
    self = [super init];
    if (!self) { return nil; }

    _text = text;
    _secondaryText = secondaryText;
    _tertiaryText = tertiaryText;
    _voiceCommands = voiceCommands;
    _artwork = artwork;
    _secondaryArtwork = secondaryArtwork;

    return self;
}


#pragma mark - Object Equality

- (NSUInteger)hash {
    return self.text.hash ^ self.secondaryText.hash ^ self.tertiaryText.hash ^ self.artwork.name.hash ^ self.secondaryArtwork.name.hash ^ self.voiceCommands.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) { return YES; }
    if (![object isMemberOfClass:[self class]]) { return NO; }

    return [self isEqualToChoice:(SDLChoiceCell *)object];
}

- (BOOL)isEqualToChoice:(SDLChoiceCell *)choice {
    if (choice == nil) { return NO; }

    return (self.hash == choice.hash);
}

@end

NS_ASSUME_NONNULL_END
