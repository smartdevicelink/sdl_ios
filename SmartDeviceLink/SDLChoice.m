//  SDLChoice.m
//

#import "SDLChoice.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLChoice

- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(nullable NSArray<NSString *> *)vrCommands image:(nullable SDLImage *)image secondaryText:(nullable NSString *)secondaryText secondaryImage:(nullable SDLImage *)secondaryImage tertiaryText:(nullable NSString *)tertiaryText {
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

- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(nullable NSArray<NSString *> *)vrCommands {
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

- (void)setVrCommands:(nullable NSArray<NSString *> *)vrCommands {
    [store sdl_setObject:vrCommands forName:SDLNameVRCommands];
}

- (nullable NSArray<NSString *> *)vrCommands {
    return [store sdl_objectForName:SDLNameVRCommands];
}

- (void)setImage:(nullable SDLImage *)image {
    [store sdl_setObject:image forName:SDLNameImage];
}

- (nullable SDLImage *)image {
    return [store sdl_objectForName:SDLNameImage ofClass:SDLImage.class];
}

- (void)setSecondaryText:(nullable NSString *)secondaryText {
    [store sdl_setObject:secondaryText forName:SDLNameSecondaryText];
}

- (nullable NSString *)secondaryText {
    return [store sdl_objectForName:SDLNameSecondaryText];
}

- (void)setTertiaryText:(nullable NSString *)tertiaryText {
    [store sdl_setObject:tertiaryText forName:SDLNameTertiaryText];
}

- (nullable NSString *)tertiaryText {
    return [store sdl_objectForName:SDLNameTertiaryText];
}

- (void)setSecondaryImage:(nullable SDLImage *)secondaryImage {
    [store sdl_setObject:secondaryImage forName:SDLNameSecondaryImage];
}

- (nullable SDLImage *)secondaryImage {
    return [store sdl_objectForName:SDLNameSecondaryImage ofClass:SDLImage.class];
}

@end

NS_ASSUME_NONNULL_END
