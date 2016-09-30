//  SDLChoice.m
//

#import "SDLChoice.h"

#import "SDLImage.h"
#import "SDLNames.h"

@implementation SDLChoice

- (void)setChoiceID:(NSNumber *)choiceID {
    if (choiceID != nil) {
        [store setObject:choiceID forKey:SDLNameChoiceId];
    } else {
        [store removeObjectForKey:SDLNameChoiceId];
    }
}

- (NSNumber *)choiceID {
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

- (void)setVrCommands:(NSMutableArray *)vrCommands {
    if (vrCommands != nil) {
        [store setObject:vrCommands forKey:SDLNameVRCommands];
    } else {
        [store removeObjectForKey:SDLNameVRCommands];
    }
}

- (NSMutableArray *)vrCommands {
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
