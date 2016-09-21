//  SDLDeleteInteractionChoiceSet.m
//


#import "SDLDeleteInteractionChoiceSet.h"



@implementation SDLDeleteInteractionChoiceSet

- (instancetype)init {
    if (self = [super initWithName:SDLNameDeleteInteractionChoiceSet]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
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

@end
