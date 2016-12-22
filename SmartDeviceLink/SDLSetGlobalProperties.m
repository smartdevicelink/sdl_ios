//  SDLSetGlobalProperties.m
//


#import "SDLSetGlobalProperties.h"

#import "SDLImage.h"
#import "SDLKeyboardProperties.h"
#import "SDLNames.h"
#import "SDLTTSChunk.h"
#import "SDLVRHelpItem.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetGlobalProperties

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetGlobalProperties]) {
    }
    return self;
}

- (instancetype)initWithHelpText:(nullable NSString *)helpText timeoutText:(nullable NSString *)timeoutText {
    return [self initWithHelpText:helpText timeoutText:timeoutText vrHelpTitle:nil vrHelp:nil];
}

- (instancetype)initWithHelpText:(nullable NSString *)helpText timeoutText:(nullable NSString *)timeoutText vrHelpTitle:(nullable NSString *)vrHelpTitle vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp {
    return [self initWithHelpText:helpText timeoutText:timeoutText vrHelpTitle:vrHelpTitle vrHelp:vrHelp menuTitle:nil menuIcon:nil keyboardProperties:nil];
}

- (instancetype)initWithHelpText:(nullable NSString *)helpText timeoutText:(nullable NSString *)timeoutText vrHelpTitle:(nullable NSString *)vrHelpTitle vrHelp:(nullable NSArray<SDLVRHelpItem *> *)vrHelp menuTitle:(nullable NSString *)menuTitle menuIcon:(nullable SDLImage *)menuIcon keyboardProperties:(nullable SDLKeyboardProperties *)keyboardProperties {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.helpPrompt = [SDLTTSChunk textChunksFromString:helpText];
    self.timeoutPrompt = [SDLTTSChunk textChunksFromString:timeoutText];
    self.vrHelpTitle = vrHelpTitle;
    self.vrHelp = [vrHelp mutableCopy];
    self.menuTitle = menuTitle;
    self.menuIcon = menuIcon;
    self.keyboardProperties = keyboardProperties;

    return self;
}


- (void)setHelpPrompt:(nullable NSMutableArray<SDLTTSChunk *> *)helpPrompt {
    if (helpPrompt != nil) {
        [parameters setObject:helpPrompt forKey:SDLNameHelpPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameHelpPrompt];
    }
}

- (nullable NSMutableArray<SDLTTSChunk *> *)helpPrompt {
    NSMutableArray<SDLTTSChunk *> *array = [parameters objectForKey:SDLNameHelpPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray<SDLTTSChunk *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setTimeoutPrompt:(nullable NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
    if (timeoutPrompt != nil) {
        [parameters setObject:timeoutPrompt forKey:SDLNameTimeoutPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameTimeoutPrompt];
    }
}

- (nullable NSMutableArray<SDLTTSChunk *> *)timeoutPrompt {
    NSMutableArray<SDLTTSChunk *> *array = [parameters objectForKey:SDLNameTimeoutPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray<SDLTTSChunk *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setVrHelpTitle:(nullable NSString *)vrHelpTitle {
    if (vrHelpTitle != nil) {
        [parameters setObject:vrHelpTitle forKey:SDLNameVRHelpTitle];
    } else {
        [parameters removeObjectForKey:SDLNameVRHelpTitle];
    }
}

- (nullable NSString *)vrHelpTitle {
    return [parameters objectForKey:SDLNameVRHelpTitle];
}

- (void)setVrHelp:(nullable NSMutableArray<SDLVRHelpItem *> *)vrHelp {
    if (vrHelp != nil) {
        [parameters setObject:vrHelp forKey:SDLNameVRHelp];
    } else {
        [parameters removeObjectForKey:SDLNameVRHelp];
    }
}

- (nullable NSMutableArray<SDLVRHelpItem *> *)vrHelp {
    NSMutableArray<SDLVRHelpItem *> *array = [parameters objectForKey:SDLNameVRHelp];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLVRHelpItem.class]) {
        return array;
    } else {
        NSMutableArray<SDLVRHelpItem *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLVRHelpItem alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setMenuTitle:(nullable NSString *)menuTitle {
    if (menuTitle != nil) {
        [parameters setObject:menuTitle forKey:SDLNameMenuTitle];
    } else {
        [parameters removeObjectForKey:SDLNameMenuTitle];
    }
}

- (nullable NSString *)menuTitle {
    return [parameters objectForKey:SDLNameMenuTitle];
}

- (void)setMenuIcon:(nullable SDLImage *)menuIcon {
    if (menuIcon != nil) {
        [parameters setObject:menuIcon forKey:SDLNameMenuIcon];
    } else {
        [parameters removeObjectForKey:SDLNameMenuIcon];
    }
}

- (nullable SDLImage *)menuIcon {
    NSObject *obj = [parameters objectForKey:SDLNameMenuIcon];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLImage*)obj;
}

- (void)setKeyboardProperties:(nullable SDLKeyboardProperties *)keyboardProperties {
    if (keyboardProperties != nil) {
        [parameters setObject:keyboardProperties forKey:SDLNameKeyboardProperties];
    } else {
        [parameters removeObjectForKey:SDLNameKeyboardProperties];
    }
}

- (nullable SDLKeyboardProperties *)keyboardProperties {
    NSObject *obj = [parameters objectForKey:SDLNameKeyboardProperties];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLKeyboardProperties alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLKeyboardProperties*)obj;
}

@end

NS_ASSUME_NONNULL_END
