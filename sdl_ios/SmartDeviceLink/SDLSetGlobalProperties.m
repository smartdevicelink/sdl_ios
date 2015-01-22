//  SDLSetGlobalProperties.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSetGlobalProperties.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLTTSChunk.h>
#import <SmartDeviceLink/SDLVrHelpItem.h>

@implementation SDLSetGlobalProperties

-(id) init {
    if (self = [super initWithName:NAMES_SetGlobalProperties]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setHelpPrompt:(NSMutableArray *)helpPrompt {
    [parameters setOrRemoveObject:helpPrompt forKey:NAMES_helpPrompt];
}

-(NSMutableArray*) helpPrompt {
    NSMutableArray* array = [parameters objectForKey:NAMES_helpPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

- (void)setTimeoutPrompt:(NSMutableArray *)timeoutPrompt {
    [parameters setOrRemoveObject:timeoutPrompt forKey:NAMES_timeoutPrompt];
}

-(NSMutableArray*) timeoutPrompt {
    NSMutableArray* array = [parameters objectForKey:NAMES_timeoutPrompt];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

- (void)setVrHelpTitle:(NSString *)vrHelpTitle {
    [parameters setOrRemoveObject:vrHelpTitle forKey:NAMES_vrHelpTitle];
}

-(NSString*) vrHelpTitle {
    return [parameters objectForKey:NAMES_vrHelpTitle];
}

- (void)setVrHelp:(NSMutableArray *)vrHelp {
    [parameters setOrRemoveObject:vrHelp forKey:NAMES_vrHelp];
}

-(NSMutableArray*) vrHelp {
    NSMutableArray* array = [parameters objectForKey:NAMES_vrHelp];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLVrHelpItem.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLVrHelpItem alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

- (void)setMenuTitle:(NSString *)menuTitle {
    [parameters setOrRemoveObject:menuTitle forKey:NAMES_menuTitle];
}

-(NSString*) menuTitle {
    return [parameters objectForKey:NAMES_menuTitle];
}

- (void)setMenuIcon:(SDLImage *)menuIcon {
    [parameters setOrRemoveObject:menuIcon forKey:NAMES_menuIcon];
}

-(SDLImage*) menuIcon {
    NSObject* obj = [parameters objectForKey:NAMES_menuIcon];
    if ([obj isKindOfClass:SDLImage.class]) {
        return (SDLImage*)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setKeyboardProperties:(SDLKeyboardProperties *)keyboardProperties {
    [parameters setOrRemoveObject:keyboardProperties forKey:NAMES_keyboardProperties];
}

-(SDLKeyboardProperties*) keyboardProperties {
    NSObject* obj = [parameters objectForKey:NAMES_keyboardProperties];
    if ([obj isKindOfClass:SDLKeyboardProperties.class]) {
        return (SDLKeyboardProperties*)obj;
    } else {
        return [[SDLKeyboardProperties alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

@end
