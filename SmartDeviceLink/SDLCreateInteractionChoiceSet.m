//  SDLCreateInteractionChoiceSet.m
//


#import "SDLCreateInteractionChoiceSet.h"

#import "SDLChoice.h"
#import "SDLNames.h"

@implementation SDLCreateInteractionChoiceSet

- (instancetype)init {
    if (self = [super initWithName:SDLNameCreateInteractionChoiceSet]) {
    }
    return self;
}

- (void)setInteractionChoiceSetID:(NSNumber *)interactionChoiceSetID {
    if (interactionChoiceSetID != nil) {
        [parameters setObject:interactionChoiceSetID forKey:SDLNameInteractionChoiceSetId];
    } else {
        [parameters removeObjectForKey:SDLNameInteractionChoiceSetId];
    }
}

- (NSNumber *)interactionChoiceSetID {
    return [parameters objectForKey:SDLNameInteractionChoiceSetId];
}

- (void)setChoiceSet:(NSMutableArray<SDLChoice *> *)choiceSet {
    if (choiceSet != nil) {
        [parameters setObject:choiceSet forKey:SDLNameChoiceSet];
    } else {
        [parameters removeObjectForKey:SDLNameChoiceSet];
    }
}

- (NSMutableArray<SDLChoice *> *)choiceSet {
    NSMutableArray<SDLChoice *> *array = [parameters objectForKey:SDLNameChoiceSet];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLChoice.class]) {
        return array;
    } else {
        NSMutableArray<SDLChoice *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLChoice alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
