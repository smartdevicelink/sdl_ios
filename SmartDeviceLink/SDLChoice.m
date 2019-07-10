//  SDLChoice.m
//

#import "SDLChoice.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"

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
    [self.store sdl_setObject:choiceID forName:SDLRPCParameterNameChoiceId];
}

- (NSNumber<SDLInt> *)choiceID {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameChoiceId ofClass:NSNumber.class error:&error];
}

- (void)setMenuName:(NSString *)menuName {
    [self.store sdl_setObject:menuName forName:SDLRPCParameterNameMenuName];
}

- (NSString *)menuName {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameMenuName ofClass:NSString.class error:&error];
}

- (void)setVrCommands:(nullable NSArray<NSString *> *)vrCommands {
    [self.store sdl_setObject:vrCommands forName:SDLRPCParameterNameVRCommands];
}

- (nullable NSArray<NSString *> *)vrCommands {
    return [self.store sdl_objectsForName:SDLRPCParameterNameVRCommands ofClass:NSString.class error:nil];
}

- (void)setImage:(nullable SDLImage *)image {
    [self.store sdl_setObject:image forName:SDLRPCParameterNameImage];
}

- (nullable SDLImage *)image {
    return [self.store sdl_objectForName:SDLRPCParameterNameImage ofClass:SDLImage.class error:nil];
}

- (void)setSecondaryText:(nullable NSString *)secondaryText {
    [self.store sdl_setObject:secondaryText forName:SDLRPCParameterNameSecondaryText];
}

- (nullable NSString *)secondaryText {
    return [self.store sdl_objectForName:SDLRPCParameterNameSecondaryText ofClass:NSString.class error:nil];
}

- (void)setTertiaryText:(nullable NSString *)tertiaryText {
    [self.store sdl_setObject:tertiaryText forName:SDLRPCParameterNameTertiaryText];
}

- (nullable NSString *)tertiaryText {
    return [self.store sdl_objectForName:SDLRPCParameterNameTertiaryText ofClass:NSString.class error:nil];
}

- (void)setSecondaryImage:(nullable SDLImage *)secondaryImage {
    [self.store sdl_setObject:secondaryImage forName:SDLRPCParameterNameSecondaryImage];
}

- (nullable SDLImage *)secondaryImage {
    return [self.store sdl_objectForName:SDLRPCParameterNameSecondaryImage ofClass:SDLImage.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
