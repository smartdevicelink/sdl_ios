//  SDLPerformInteractionResponse.m
//


#import "SDLPerformInteractionResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPerformInteractionResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNamePerformInteraction]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setChoiceID:(nullable NSNumber<SDLInt> *)choiceID {
    [self.parameters sdl_setObject:choiceID forName:SDLRPCParameterNameChoiceId];
}

- (nullable NSNumber<SDLInt> *)choiceID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameChoiceId ofClass:NSNumber.class error:nil];
}

- (void)setManualTextEntry:(nullable NSString *)manualTextEntry {
    [self.parameters sdl_setObject:manualTextEntry forName:SDLRPCParameterNameManualTextEntry];
}

- (nullable NSString *)manualTextEntry {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameManualTextEntry ofClass:NSString.class error:nil];
}

- (void)setTriggerSource:(nullable SDLTriggerSource)triggerSource {
    [self.parameters sdl_setObject:triggerSource forName:SDLRPCParameterNameTriggerSource];
}

- (nullable SDLTriggerSource)triggerSource {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameTriggerSource error:nil];
}

@end
    
NS_ASSUME_NONNULL_END
