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

- (void)setChoiceID:(NSNumber<SDLInt> *)choiceID {
    if (choiceID != nil) {
        [parameters setObject:choiceID forKey:SDLNameChoiceId];
    } else {
        [parameters removeObjectForKey:SDLNameChoiceId];
    }
}

- (NSNumber<SDLInt> *)choiceID {
    return [parameters objectForKey:SDLNameChoiceId];
}

- (void)setManualTextEntry:(NSString *)manualTextEntry {
    if (manualTextEntry != nil) {
        [parameters setObject:manualTextEntry forKey:SDLNameManualTextEntry];
    } else {
        [parameters removeObjectForKey:SDLNameManualTextEntry];
    }
}

- (NSString *)manualTextEntry {
    return [parameters objectForKey:SDLNameManualTextEntry];
}

- (void)setTriggerSource:(SDLTriggerSource)triggerSource {
    if (triggerSource != nil) {
        [parameters setObject:triggerSource forKey:SDLNameTriggerSource];
    } else {
        [parameters removeObjectForKey:SDLNameTriggerSource];
    }
}

- (SDLTriggerSource)triggerSource {
    NSObject *obj = [parameters objectForKey:SDLNameTriggerSource];
    return (SDLTriggerSource)obj;
}

@end
