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
    [self setObject:choiceID forName:SDLNameChoiceId];
}

- (NSNumber<SDLInt> *)choiceID {
    return [parameters objectForKey:SDLNameChoiceId];
}

- (void)setManualTextEntry:(NSString *)manualTextEntry {
    [self setObject:manualTextEntry forName:SDLNameManualTextEntry];
}

- (NSString *)manualTextEntry {
    return [parameters objectForKey:SDLNameManualTextEntry];
}

- (void)setTriggerSource:(SDLTriggerSource)triggerSource {
    [self setObject:triggerSource forName:SDLNameTriggerSource];
}

- (SDLTriggerSource)triggerSource {
    NSObject *obj = [parameters objectForKey:SDLNameTriggerSource];
    return (SDLTriggerSource)obj;
}

@end
