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
    if (self = [super initWithName:NAMES_SetGlobalProperties]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setHelpPrompt:(NSMutableArray *)helpPrompt {
    if (helpPrompt != nil) {
        [parameters setObject:helpPrompt forKey:NAMES_helpPrompt];
    } else {
        [parameters removeObjectForKey:NAMES_helpPrompt];
    }
}

- (NSMutableArray *)helpPrompt {
    NSMutableArray *array = [parameters objectForKey:NAMES_helpPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setTimeoutPrompt:(NSMutableArray *)timeoutPrompt {
    if (timeoutPrompt != nil) {
        [parameters setObject:timeoutPrompt forKey:NAMES_timeoutPrompt];
    } else {
        [parameters removeObjectForKey:NAMES_timeoutPrompt];
    }
}

- (NSMutableArray *)timeoutPrompt {
    NSMutableArray *array = [parameters objectForKey:NAMES_timeoutPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setVrHelpTitle:(NSString *)vrHelpTitle {
    if (vrHelpTitle != nil) {
        [parameters setObject:vrHelpTitle forKey:NAMES_vrHelpTitle];
    } else {
        [parameters removeObjectForKey:NAMES_vrHelpTitle];
    }
}

- (NSString *)vrHelpTitle {
    return [parameters objectForKey:NAMES_vrHelpTitle];
}

- (void)setVrHelp:(NSMutableArray *)vrHelp {
    if (vrHelp != nil) {
        [parameters setObject:vrHelp forKey:NAMES_vrHelp];
    } else {
        [parameters removeObjectForKey:NAMES_vrHelp];
    }
}

- (NSMutableArray *)vrHelp {
    NSMutableArray *array = [parameters objectForKey:NAMES_vrHelp];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLVRHelpItem.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLVRHelpItem alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setMenuTitle:(NSString *)menuTitle {
    if (menuTitle != nil) {
        [parameters setObject:menuTitle forKey:NAMES_menuTitle];
    } else {
        [parameters removeObjectForKey:NAMES_menuTitle];
    }
}

- (NSString *)menuTitle {
    return [parameters objectForKey:NAMES_menuTitle];
}

- (void)setMenuIcon:(SDLImage *)menuIcon {
    if (menuIcon != nil) {
        [parameters setObject:menuIcon forKey:NAMES_menuIcon];
    } else {
        [parameters removeObjectForKey:NAMES_menuIcon];
    }
}

- (SDLImage *)menuIcon {
    NSObject *obj = [parameters objectForKey:NAMES_menuIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setKeyboardProperties:(SDLKeyboardProperties *)keyboardProperties {
    if (keyboardProperties != nil) {
        [parameters setObject:keyboardProperties forKey:NAMES_keyboardProperties];
    } else {
        [parameters removeObjectForKey:NAMES_keyboardProperties];
    }
}

- (SDLKeyboardProperties *)keyboardProperties {
    NSObject *obj = [parameters objectForKey:NAMES_keyboardProperties];
    if (obj == nil || [obj isKindOfClass:SDLKeyboardProperties.class]) {
        return (SDLKeyboardProperties *)obj;
    } else {
        return [[SDLKeyboardProperties alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
