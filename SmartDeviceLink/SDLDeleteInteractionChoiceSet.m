//  SDLDeleteInteractionChoiceSet.m
//


#import "SDLDeleteInteractionChoiceSet.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeleteInteractionChoiceSet

- (instancetype)init {
    if (self = [super initWithName:SDLNameDeleteInteractionChoiceSet]) {
    }
    return self;
}

- (instancetype)initWithId:(UInt32)choiceId {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.interactionChoiceSetID = @(choiceId);

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

@end

NS_ASSUME_NONNULL_END
