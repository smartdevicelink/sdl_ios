//  SDLCreateInteractionChoiceSet.m
//


#import "SDLCreateInteractionChoiceSet.h"

#import "NSMutableDictionary+Store.h"
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
    [parameters sdl_setObject:interactionChoiceSetID forName:SDLNameInteractionChoiceSetId];
}

- (NSNumber<SDLInt> *)interactionChoiceSetID {
    NSError *error;
    return [parameters sdl_objectForName:SDLNameInteractionChoiceSetId ofClass:NSNumber.class error:&error];
}

- (void)setChoiceSet:(NSArray<SDLChoice *> *)choiceSet {
    [parameters sdl_setObject:choiceSet forName:SDLNameChoiceSet];
}

- (NSArray<SDLChoice *> *)choiceSet {
    NSError *error;
    return [parameters sdl_objectsForName:SDLNameChoiceSet ofClass:SDLChoice.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
