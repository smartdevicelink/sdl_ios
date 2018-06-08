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

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

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
    
    _choiceId = UINT16_MAX;

    return self;
}


#pragma mark - Object Equality

// Based on preprocessor defines in https://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html It is necessary to rotate each of our properties because a simple bitwise OR will produce equivalent results if, for example:
// Object 1: self.text = "Hi", self.secondaryText = "Hello"
// Object 2: self.text = "Hello", self.secondaryText = "Hi"
// To avoid this, we need to rotate our hashes

NSUInteger const NSUIntBit = (CHAR_BIT * sizeof(NSUInteger));
NSUInteger NSUIntRotate(NSUInteger val, NSUInteger howMuch) {
    return ((((NSUInteger)val) << howMuch) | (((NSUInteger)val) >> (NSUIntBit - howMuch)));
}

- (NSUInteger)hash {
    return NSUIntRotate(self.text.hash, NSUIntBit / 2)
    ^ NSUIntRotate(self.secondaryText.hash, NSUIntBit / 3)
    ^ NSUIntRotate(self.tertiaryText.hash, NSUIntBit / 4)
    ^ NSUIntRotate(self.artwork.name.hash, NSUIntBit / 5)
    ^ NSUIntRotate(self.secondaryArtwork.name.hash, NSUIntBit / 6)
    ^ NSUIntRotate(self.voiceCommands.hash, NSUIntBit / 7);
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

#pragma mark - Etc.

- (NSString *)description {
    return [NSString stringWithFormat:@"SDLChoiceCell: %u-\"%@ - %@ - %@\", artworkNames: %@ - %@, voice commands: %lu", _choiceId, _text, _secondaryText, _tertiaryText, _artwork.name, _secondaryArtwork.name, (unsigned long)_voiceCommands.count];
}

@end

NS_ASSUME_NONNULL_END
