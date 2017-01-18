//  SDLChoice.m
//

#import "SDLChoice.h"

#import "SDLImage.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLChoice

- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(NSArray<NSString *> *)vrCommands image:(nullable SDLImage *)image secondaryText:(nullable NSString *)secondaryText secondaryImage:(nullable SDLImage *)secondaryImage tertiaryText:(nullable NSString *)tertiaryText {
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

- (void)setImage:(nullable SDLImage *)image {
    if (image != nil) {
        [store setObject:image forKey:SDLNameImage];
    } else {
        [store removeObjectForKey:SDLNameImage];
    }
}

- (nullable SDLImage *)image {
    NSObject *obj = [store objectForKey:SDLNameImage];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLImage*)obj;
    
}

- (void)setSecondaryText:(nullable NSString *)secondaryText {
    if (secondaryText != nil) {
        [store setObject:secondaryText forKey:SDLNameSecondaryText];
    } else {
        [store removeObjectForKey:SDLNameSecondaryText];
    }
}

- (nullable NSString *)secondaryText {
    return [store objectForKey:SDLNameSecondaryText];
}

- (void)setTertiaryText:(nullable NSString *)tertiaryText {
    if (tertiaryText != nil) {
        [store setObject:tertiaryText forKey:SDLNameTertiaryText];
    } else {
        [store removeObjectForKey:SDLNameTertiaryText];
    }
}

- (nullable NSString *)tertiaryText {
    return [store objectForKey:SDLNameTertiaryText];
}

- (void)setSecondaryImage:(nullable SDLImage *)secondaryImage {
    if (secondaryImage != nil) {
        [store setObject:secondaryImage forKey:SDLNameSecondaryImage];
    } else {
        [store removeObjectForKey:SDLNameSecondaryImage];
    }
}

- (nullable SDLImage *)secondaryImage {
    NSObject *obj = [store objectForKey:SDLNameSecondaryImage];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLImage*)obj;
}

@end

NS_ASSUME_NONNULL_END
