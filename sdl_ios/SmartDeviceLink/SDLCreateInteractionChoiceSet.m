//  SDLCreateInteractionChoiceSet.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLCreateInteractionChoiceSet.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLChoice.h>

@implementation SDLCreateInteractionChoiceSet

-(id) init {
    if (self = [super initWithName:NAMES_CreateInteractionChoiceSet]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setInteractionChoiceSetID:(NSNumber *)interactionChoiceSetID {
    [parameters setOrRemoveObject:interactionChoiceSetID forKey:NAMES_interactionChoiceSetID];
}

-(NSNumber*) interactionChoiceSetID {
    return [parameters objectForKey:NAMES_interactionChoiceSetID];
}

- (void)setChoiceSet:(NSMutableArray *)choiceSet {
    [parameters setOrRemoveObject:choiceSet forKey:NAMES_choiceSet];
}

-(NSMutableArray*) choiceSet {
    NSMutableArray* array = [parameters objectForKey:NAMES_choiceSet];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLChoice.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLChoice alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

@end
