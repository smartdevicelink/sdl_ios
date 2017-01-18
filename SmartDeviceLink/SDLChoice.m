//  SDLChoice.m
//

#import "SDLChoice.h"

#import "NSMutableDictionary+Store.h"
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
    [store sdl_setObject:choiceID forName:SDLNameChoiceId];
}

- (NSNumber<SDLInt> *)choiceID {
    return [store sdl_objectForName:SDLNameChoiceId];
}

- (void)setMenuName:(NSString *)menuName {
    [store sdl_setObject:menuName forName:SDLNameMenuName];
}

- (NSString *)menuName {
    return [store sdl_objectForName:SDLNameMenuName];
}

- (void)setVrCommands:(NSMutableArray<NSString *> *)vrCommands {
    [store sdl_setObject:vrCommands forName:SDLNameVRCommands];
}

- (NSMutableArray<NSString *> *)vrCommands {
    return [store sdl_objectForName:SDLNameVRCommands];
}

- (void)setImage:(SDLImage *)image {
    [store sdl_setObject:image forName:SDLNameImage];
}

- (SDLImage *)image {
    return [store sdl_objectForName:SDLNameImage ofClass:SDLImage.class];
}

- (void)setSecondaryText:(NSString *)secondaryText {
    [store sdl_setObject:secondaryText forName:SDLNameSecondaryText];
}

- (NSString *)secondaryText {
    return [store sdl_objectForName:SDLNameSecondaryText];
}

- (void)setTertiaryText:(NSString *)tertiaryText {
    [store sdl_setObject:tertiaryText forName:SDLNameTertiaryText];
}

- (NSString *)tertiaryText {
    return [store sdl_objectForName:SDLNameTertiaryText];
}

- (void)setSecondaryImage:(SDLImage *)secondaryImage {
    [store sdl_setObject:secondaryImage forName:SDLNameSecondaryImage];
}

- (SDLImage *)secondaryImage {
    return [store sdl_objectForName:SDLNameSecondaryImage ofClass:SDLImage.class];
}

@end
