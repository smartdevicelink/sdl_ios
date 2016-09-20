//  SDLCreateInteractionChoiceSet.m
//


#import "SDLCreateInteractionChoiceSet.h"

#import "SDLChoice.h"
#import "SDLNames.h"

@implementation SDLCreateInteractionChoiceSet

- (instancetype)init {
    if (self = [super initWithName:NAMES_CreateInteractionChoiceSet]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setInteractionChoiceSetID:(NSNumber *)interactionChoiceSetID {
    if (interactionChoiceSetID != nil) {
        [parameters setObject:interactionChoiceSetID forKey:NAMES_interactionChoiceSetID];
    } else {
        [parameters removeObjectForKey:NAMES_interactionChoiceSetID];
    }
}

- (NSNumber *)interactionChoiceSetID {
    return [parameters objectForKey:NAMES_interactionChoiceSetID];
}

- (void)setChoiceSet:(NSMutableArray<SDLChoice *> *)choiceSet {
    if (choiceSet != nil) {
        [parameters setObject:choiceSet forKey:NAMES_choiceSet];
    } else {
        [parameters removeObjectForKey:NAMES_choiceSet];
    }
}

- (NSMutableArray<SDLChoice *> *)choiceSet {
    NSMutableArray<SDLChoice *> *array = [parameters objectForKey:NAMES_choiceSet];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLChoice.class]) {
        return array;
    } else {
        NSMutableArray<SDLChoice *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLChoice alloc] initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict]];
        }
        return newList;
    }
}

@end
