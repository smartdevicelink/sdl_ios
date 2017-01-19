//  SDLPerformInteractionResponse.m
//


#import "SDLPerformInteractionResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPerformInteractionResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNamePerformInteraction]) {
    }
    return self;
}

- (void)setChoiceID:(nullable NSNumber<SDLInt> *)choiceID {
    [parameters sdl_setObject:choiceID forName:SDLNameChoiceId];
}

- (nullable NSNumber<SDLInt> *)choiceID {
    return [parameters sdl_objectForName:SDLNameChoiceId];
}

- (void)setManualTextEntry:(nullable NSString *)manualTextEntry {
    [parameters sdl_setObject:manualTextEntry forName:SDLNameManualTextEntry];
}

- (nullable NSString *)manualTextEntry {
    return [parameters sdl_objectForName:SDLNameManualTextEntry];
}

- (void)setTriggerSource:(nullable SDLTriggerSource)triggerSource {
    [parameters sdl_setObject:triggerSource forName:SDLNameTriggerSource];
}

- (nullable SDLTriggerSource)triggerSource {
    return [parameters sdl_objectForName:SDLNameTriggerSource];
}

@end
    
NS_ASSUME_NONNULL_END
