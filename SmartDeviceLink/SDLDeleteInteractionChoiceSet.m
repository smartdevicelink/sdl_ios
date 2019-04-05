//  SDLDeleteInteractionChoiceSet.m
//


#import "SDLDeleteInteractionChoiceSet.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeleteInteractionChoiceSet

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDeleteInteractionChoiceSet]) {
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
    [parameters sdl_setObject:interactionChoiceSetID forName:SDLRPCParameterNameInteractionChoiceSetId];
}

- (NSNumber<SDLInt> *)interactionChoiceSetID {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameInteractionChoiceSetId ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
