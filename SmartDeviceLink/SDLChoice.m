//  SDLChoice.m
//

#import "SDLChoice.h"

#import "SDLImage.h"
#import "SDLNames.h"

@implementation SDLChoice

- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(NSArray<NSString *> *)vrCommands image:(SDLImage *)image secondaryText:(NSString *)secondaryText secondaryImage:(SDLImage *)secondaryImage tertiaryText:(NSString *)tertiaryText {
    self = [self initWithId:choiceId menuName:menuName vrCommands:vrCommands];
    if (!self) {
        return nil;
    }

    self.image = image;
    self.secondaryText = secondaryText;
    self.secondaryImage = secondaryImage;
    self.tertiaryText = tertiaryText;

    return self;
}

- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(NSArray<NSString *> *)vrCommands {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.choiceID = @(choiceId);
    self.menuName = menuName;
    self.vrCommands = [vrCommands mutableCopy];

    return self;
}

- (void)setChoiceID:(NSNumber<SDLInt> *)choiceID {
    [self setObject:choiceID forName:SDLNameChoiceId];
}

- (NSNumber<SDLInt> *)choiceID {
    return [self objectForName:SDLNameChoiceId];
}

- (void)setMenuName:(NSString *)menuName {
    [self setObject:menuName forName:SDLNameMenuName];
}

- (NSString *)menuName {
    return [self objectForName:SDLNameMenuName];
}

- (void)setVrCommands:(NSMutableArray<NSString *> *)vrCommands {
    [self setObject:vrCommands forName:SDLNameVRCommands];
}

- (NSMutableArray<NSString *> *)vrCommands {
    return [self objectForName:SDLNameVRCommands];
}

- (void)setImage:(SDLImage *)image {
    [self setObject:image forName:SDLNameImage];
}

- (SDLImage *)image {
    return [self objectForName:SDLNameImage ofClass:SDLImage.class];
}

- (void)setSecondaryText:(NSString *)secondaryText {
    [self setObject:secondaryText forName:SDLNameSecondaryText];
}

- (NSString *)secondaryText {
    return [self objectForName:SDLNameSecondaryText];
}

- (void)setTertiaryText:(NSString *)tertiaryText {
    [self setObject:tertiaryText forName:SDLNameTertiaryText];
}

- (NSString *)tertiaryText {
    return [self objectForName:SDLNameTertiaryText];
}

- (void)setSecondaryImage:(SDLImage *)secondaryImage {
    [self setObject:secondaryImage forName:SDLNameSecondaryImage];
}

- (SDLImage *)secondaryImage {
    return [self objectForName:SDLNameSecondaryImage ofClass:SDLImage.class];
}

@end
