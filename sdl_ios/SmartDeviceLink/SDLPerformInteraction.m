//  SDLPerformInteraction.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLPerformInteraction.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLTTSChunk.h>
#import <SmartDeviceLink/SDLVrHelpItem.h>

@implementation SDLPerformInteraction

-(id) init {
    if (self = [super initWithName:NAMES_PerformInteraction]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setInitialText:(NSString *)initialText {
    [parameters setOrRemoveObject:initialText forKey:NAMES_initialText];
}

-(NSString*) initialText {
    return [parameters objectForKey:NAMES_initialText];
}

- (void)setInitialPrompt:(NSMutableArray *)initialPrompt {
    [parameters setOrRemoveObject:initialPrompt forKey:NAMES_initialPrompt];
}

-(NSMutableArray*) initialPrompt {
    NSMutableArray* array = [parameters objectForKey:NAMES_initialPrompt];
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

- (void)setInteractionMode:(SDLInteractionMode *)interactionMode {
    [parameters setOrRemoveObject:interactionMode forKey:NAMES_interactionMode];
}

-(SDLInteractionMode*) interactionMode {
    NSObject* obj = [parameters objectForKey:NAMES_interactionMode];
    if ([obj isKindOfClass:SDLInteractionMode.class]) {
        return (SDLInteractionMode*)obj;
    } else {
        return [SDLInteractionMode valueOf:(NSString*)obj];
    }
}

- (void)setInteractionChoiceSetIDList:(NSMutableArray *)interactionChoiceSetIDList {
    [parameters setObject:interactionChoiceSetIDList forKey:NAMES_interactionChoiceSetIDList];
}

-(NSMutableArray*) interactionChoiceSetIDList {
    return [parameters objectForKey:NAMES_interactionChoiceSetIDList];
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

- (void)setTimeout:(NSNumber *)timeout {
    [parameters setOrRemoveObject:timeout forKey:NAMES_timeout];
}

-(NSNumber*) timeout {
    return [parameters objectForKey:NAMES_timeout];
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

- (void)setInteractionLayout:(SDLLayoutMode *)interactionLayout {
    [parameters setOrRemoveObject:interactionLayout forKey:NAMES_interactionLayout];
}

-(SDLLayoutMode*) interactionLayout {
    NSObject* obj = [parameters objectForKey:NAMES_interactionLayout];
    if ([obj isKindOfClass:SDLLayoutMode.class]) {
        return (SDLLayoutMode*)obj;
    } else {
        return [SDLLayoutMode valueOf:(NSString*)obj];
    }
}

@end
