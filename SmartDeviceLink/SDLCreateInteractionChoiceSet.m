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

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithId:(UInt32)choiceId choiceSet:(NSArray *)choiceSet {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.interactionChoiceSetID = @(choiceId);
    self.choiceSet = [choiceSet mutableCopy];
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

- (void)setChoiceSet:(NSMutableArray *)choiceSet {
    if (choiceSet != nil) {
        [parameters setObject:choiceSet forKey:NAMES_choiceSet];
    } else {
        [parameters removeObjectForKey:NAMES_choiceSet];
    }
}

- (NSMutableArray *)choiceSet {
    NSMutableArray *array = [parameters objectForKey:NAMES_choiceSet];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLChoice.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLChoice alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

@end
