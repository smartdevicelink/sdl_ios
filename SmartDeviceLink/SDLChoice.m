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
    if (choiceID != nil) {
        [store setObject:choiceID forKey:SDLNameChoiceId];
    } else {
        [store removeObjectForKey:SDLNameChoiceId];
    }
}

- (NSNumber<SDLInt> *)choiceID {
    return [store objectForKey:SDLNameChoiceId];
}

- (void)setMenuName:(NSString *)menuName {
    if (menuName != nil) {
        [store setObject:menuName forKey:SDLNameMenuName];
    } else {
        [store removeObjectForKey:SDLNameMenuName];
    }
}

- (NSString *)menuName {
    return [store objectForKey:SDLNameMenuName];
}

- (void)setVrCommands:(NSMutableArray<NSString *> *)vrCommands {
    if (vrCommands != nil) {
        [store setObject:vrCommands forKey:SDLNameVRCommands];
    } else {
        [store removeObjectForKey:SDLNameVRCommands];
    }
}

- (NSMutableArray<NSString *> *)vrCommands {
    return [store objectForKey:SDLNameVRCommands];
}

- (void)setImage:(SDLImage *)image {
    if (image != nil) {
        [store setObject:image forKey:SDLNameImage];
    } else {
        [store removeObjectForKey:SDLNameImage];
    }
}

- (SDLImage *)image {
    NSObject *obj = [store objectForKey:SDLNameImage];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setSecondaryText:(NSString *)secondaryText {
    if (secondaryText != nil) {
        [store setObject:secondaryText forKey:SDLNameSecondaryText];
    } else {
        [store removeObjectForKey:SDLNameSecondaryText];
    }
}

- (NSString *)secondaryText {
    return [store objectForKey:SDLNameSecondaryText];
}

- (void)setTertiaryText:(NSString *)tertiaryText {
    if (tertiaryText != nil) {
        [store setObject:tertiaryText forKey:SDLNameTertiaryText];
    } else {
        [store removeObjectForKey:SDLNameTertiaryText];
    }
}

- (NSString *)tertiaryText {
    return [store objectForKey:SDLNameTertiaryText];
}

- (void)setSecondaryImage:(SDLImage *)secondaryImage {
    if (secondaryImage != nil) {
        [store setObject:secondaryImage forKey:SDLNameSecondaryImage];
    } else {
        [store removeObjectForKey:SDLNameSecondaryImage];
    }
}

- (SDLImage *)secondaryImage {
    NSObject *obj = [store objectForKey:SDLNameSecondaryImage];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
