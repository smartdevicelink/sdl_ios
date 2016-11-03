//  SDLChoice.m
//

#import "SDLChoice.h"

#import "SDLImage.h"
#import "SDLNames.h"


@implementation SDLChoice

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(NSArray *)vrCommands image:(SDLImage *)image secondaryText:(NSString *)secondaryText secondaryImage:(SDLImage *)secondaryImage tertiaryText:(NSString *)tertiaryText {
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

- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(NSArray *)vrCommands {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.choiceID = @(choiceId);
    self.menuName = menuName;
    self.vrCommands = [vrCommands mutableCopy];

    return self;
}

- (void)setChoiceID:(NSNumber *)choiceID {
    if (choiceID != nil) {
        [store setObject:choiceID forKey:NAMES_choiceID];
    } else {
        [store removeObjectForKey:NAMES_choiceID];
    }
}

- (NSNumber *)choiceID {
    return [store objectForKey:NAMES_choiceID];
}

- (void)setMenuName:(NSString *)menuName {
    if (menuName != nil) {
        [store setObject:menuName forKey:NAMES_menuName];
    } else {
        [store removeObjectForKey:NAMES_menuName];
    }
}

- (NSString *)menuName {
    return [store objectForKey:NAMES_menuName];
}

- (void)setVrCommands:(NSMutableArray *)vrCommands {
    if (vrCommands != nil) {
        [store setObject:vrCommands forKey:NAMES_vrCommands];
    } else {
        [store removeObjectForKey:NAMES_vrCommands];
    }
}

- (NSMutableArray *)vrCommands {
    return [store objectForKey:NAMES_vrCommands];
}

- (void)setImage:(SDLImage *)image {
    if (image != nil) {
        [store setObject:image forKey:NAMES_image];
    } else {
        [store removeObjectForKey:NAMES_image];
    }
}

- (SDLImage *)image {
    NSObject *obj = [store objectForKey:NAMES_image];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setSecondaryText:(NSString *)secondaryText {
    if (secondaryText != nil) {
        [store setObject:secondaryText forKey:NAMES_secondaryText];
    } else {
        [store removeObjectForKey:NAMES_secondaryText];
    }
}

- (NSString *)secondaryText {
    return [store objectForKey:NAMES_secondaryText];
}

- (void)setTertiaryText:(NSString *)tertiaryText {
    if (tertiaryText != nil) {
        [store setObject:tertiaryText forKey:NAMES_tertiaryText];
    } else {
        [store removeObjectForKey:NAMES_tertiaryText];
    }
}

- (NSString *)tertiaryText {
    return [store objectForKey:NAMES_tertiaryText];
}

- (void)setSecondaryImage:(SDLImage *)secondaryImage {
    if (secondaryImage != nil) {
        [store setObject:secondaryImage forKey:NAMES_secondaryImage];
    } else {
        [store removeObjectForKey:NAMES_secondaryImage];
    }
}

- (SDLImage *)secondaryImage {
    NSObject *obj = [store objectForKey:NAMES_secondaryImage];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
