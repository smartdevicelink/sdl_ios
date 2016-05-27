//  SDLDeleteInteractionChoiceSet.m
//


#import "SDLDeleteInteractionChoiceSet.h"

#import "SDLNames.h"

@implementation SDLDeleteInteractionChoiceSet

- (instancetype)init {
    if (self = [super initWithName:NAMES_DeleteInteractionChoiceSet]) {
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
        [parameters setObject:interactionChoiceSetID forKey:NAMES_interactionChoiceSetID];
    } else {
        [parameters removeObjectForKey:NAMES_interactionChoiceSetID];
    }
}

- (NSNumber *)interactionChoiceSetID {
    return [parameters objectForKey:NAMES_interactionChoiceSetID];
}

@end
