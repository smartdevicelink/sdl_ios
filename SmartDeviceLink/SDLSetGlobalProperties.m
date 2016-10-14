//  SDLSetGlobalProperties.m
//


#import "SDLSetGlobalProperties.h"

#import "SDLImage.h"
#import "SDLKeyboardProperties.h"
#import "SDLNames.h"
#import "SDLTTSChunk.h"
#import "SDLVRHelpItem.h"


@implementation SDLSetGlobalProperties

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetGlobalProperties]) {
    }
    return self;
}

- (void)setHelpPrompt:(NSMutableArray *)helpPrompt {
    if (helpPrompt != nil) {
        [parameters setObject:helpPrompt forKey:SDLNameHelpPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameHelpPrompt];
    }
}

- (NSMutableArray *)helpPrompt {
    NSMutableArray *array = [parameters objectForKey:SDLNameHelpPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setTimeoutPrompt:(NSMutableArray *)timeoutPrompt {
    if (timeoutPrompt != nil) {
        [parameters setObject:timeoutPrompt forKey:SDLNameTimeoutPrompt];
    } else {
        [parameters removeObjectForKey:SDLNameTimeoutPrompt];
    }
}

- (NSMutableArray *)timeoutPrompt {
    NSMutableArray *array = [parameters objectForKey:SDLNameTimeoutPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setVrHelpTitle:(NSString *)vrHelpTitle {
    if (vrHelpTitle != nil) {
        [parameters setObject:vrHelpTitle forKey:SDLNameVRHelpTitle];
    } else {
        [parameters removeObjectForKey:SDLNameVRHelpTitle];
    }
}

- (NSString *)vrHelpTitle {
    return [parameters objectForKey:SDLNameVRHelpTitle];
}

- (void)setVrHelp:(NSMutableArray *)vrHelp {
    if (vrHelp != nil) {
        [parameters setObject:vrHelp forKey:SDLNameVRHelp];
    } else {
        [parameters removeObjectForKey:SDLNameVRHelp];
    }
}

- (NSMutableArray *)vrHelp {
    NSMutableArray *array = [parameters objectForKey:SDLNameVRHelp];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLVRHelpItem.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLVRHelpItem alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setMenuTitle:(NSString *)menuTitle {
    if (menuTitle != nil) {
        [parameters setObject:menuTitle forKey:SDLNameMenuTitle];
    } else {
        [parameters removeObjectForKey:SDLNameMenuTitle];
    }
}

- (NSString *)menuTitle {
    return [parameters objectForKey:SDLNameMenuTitle];
}

- (void)setMenuIcon:(SDLImage *)menuIcon {
    if (menuIcon != nil) {
        [parameters setObject:menuIcon forKey:SDLNameMenuIcon];
    } else {
        [parameters removeObjectForKey:SDLNameMenuIcon];
    }
}

- (SDLImage *)menuIcon {
    NSObject *obj = [parameters objectForKey:SDLNameMenuIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setKeyboardProperties:(SDLKeyboardProperties *)keyboardProperties {
    if (keyboardProperties != nil) {
        [parameters setObject:keyboardProperties forKey:SDLNameKeyboardProperties];
    } else {
        [parameters removeObjectForKey:SDLNameKeyboardProperties];
    }
}

- (SDLKeyboardProperties *)keyboardProperties {
    NSObject *obj = [parameters objectForKey:SDLNameKeyboardProperties];
    if (obj == nil || [obj isKindOfClass:SDLKeyboardProperties.class]) {
        return (SDLKeyboardProperties *)obj;
    } else {
        return [[SDLKeyboardProperties alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
