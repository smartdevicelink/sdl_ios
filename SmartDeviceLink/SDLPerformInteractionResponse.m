//  SDLPerformInteractionResponse.m
//


#import "SDLPerformInteractionResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

@implementation SDLPerformInteractionResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNamePerformInteraction]) {
    }
    return self;
}

- (void)setChoiceID:(NSNumber<SDLInt> *)choiceID {
    [parameters sdl_setObject:choiceID forName:SDLNameChoiceId];
}

- (NSNumber<SDLInt> *)choiceID {
    return [parameters sdl_objectForName:SDLNameChoiceId];
}

- (void)setManualTextEntry:(NSString *)manualTextEntry {
    [parameters sdl_setObject:manualTextEntry forName:SDLNameManualTextEntry];
}

- (NSString *)manualTextEntry {
    return [parameters sdl_objectForName:SDLNameManualTextEntry];
}

- (void)setTriggerSource:(SDLTriggerSource)triggerSource {
    [parameters sdl_setObject:triggerSource forName:SDLNameTriggerSource];
}

- (SDLTriggerSource)triggerSource {
    return [parameters sdl_objectForName:SDLNameTriggerSource];
}

@end
