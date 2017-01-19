//  SDLPerformInteractionResponse.m
//


#import "SDLPerformInteractionResponse.h"

#import "SDLNames.h"

@implementation SDLPerformInteractionResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNamePerformInteraction]) {
    }
    return self;
}

- (void)setChoiceID:(nullable NSNumber<SDLInt> *)choiceID {
    if (choiceID != nil) {
        [parameters setObject:choiceID forKey:SDLNameChoiceId];
    } else {
        [parameters removeObjectForKey:SDLNameChoiceId];
    }
}

- (nullable NSNumber<SDLInt> *)choiceID {
    return [parameters objectForKey:SDLNameChoiceId];
}

- (void)setManualTextEntry:(nullable NSString *)manualTextEntry {
    if (manualTextEntry != nil) {
        [parameters setObject:manualTextEntry forKey:SDLNameManualTextEntry];
    } else {
        [parameters removeObjectForKey:SDLNameManualTextEntry];
    }
}

- (nullable NSString *)manualTextEntry {
    return [parameters objectForKey:SDLNameManualTextEntry];
}

- (void)setTriggerSource:(nullable SDLTriggerSource)triggerSource {
    if (triggerSource != nil) {
        [parameters setObject:triggerSource forKey:SDLNameTriggerSource];
    } else {
        [parameters removeObjectForKey:SDLNameTriggerSource];
    }
}

- (nullable SDLTriggerSource)triggerSource {
    NSObject *obj = [parameters objectForKey:SDLNameTriggerSource];
    return (SDLTriggerSource)obj;
}

@end
