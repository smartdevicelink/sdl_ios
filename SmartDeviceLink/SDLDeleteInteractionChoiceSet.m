//  SDLDeleteInteractionChoiceSet.m
//


#import "SDLDeleteInteractionChoiceSet.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeleteInteractionChoiceSet

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDeleteInteractionChoiceSet]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithId:(UInt32)choiceId {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.interactionChoiceSetID = @(choiceId);

    return self;
}

- (void)setInteractionChoiceSetID:(NSNumber<SDLInt> *)interactionChoiceSetID {
    [self.parameters sdl_setObject:interactionChoiceSetID forName:SDLRPCParameterNameInteractionChoiceSetId];
}

- (NSNumber<SDLInt> *)interactionChoiceSetID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameInteractionChoiceSetId ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
