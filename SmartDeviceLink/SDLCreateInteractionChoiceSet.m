//  SDLCreateInteractionChoiceSet.m
//


#import "SDLCreateInteractionChoiceSet.h"

#import "SDLChoice.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLCreateInteractionChoiceSet

- (instancetype)init {
    if (self = [super initWithName:SDLNameCreateInteractionChoiceSet]) {
    }
    return self;
}

- (instancetype)initWithId:(UInt32)choiceId choiceSet:(NSArray<SDLChoice *> *)choiceSet {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.interactionChoiceSetID = @(choiceId);
    self.choiceSet = [choiceSet mutableCopy];
    return self;
}

- (void)setInteractionChoiceSetID:(NSNumber<SDLInt> *)interactionChoiceSetID {
    if (interactionChoiceSetID != nil) {
        [parameters setObject:interactionChoiceSetID forKey:SDLNameInteractionChoiceSetId];
    } else {
        [parameters removeObjectForKey:SDLNameInteractionChoiceSetId];
    }
}

- (NSNumber<SDLInt> *)interactionChoiceSetID {
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

NS_ASSUME_NONNULL_END
