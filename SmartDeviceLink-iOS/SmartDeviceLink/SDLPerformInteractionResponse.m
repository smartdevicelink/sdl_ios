//  SDLPerformInteractionResponse.m
//


#import "SDLPerformInteractionResponse.h"

#import "SDLNames.h"
#import "SDLTriggerSource.h"


@implementation SDLPerformInteractionResponse

- (instancetype)init {
    if (self = [super initWithName:NAMES_PerformInteraction]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setChoiceID:(NSNumber *)choiceID {
    if (choiceID != nil) {
        [parameters setObject:choiceID forKey:NAMES_choiceID];
    } else {
        [parameters removeObjectForKey:NAMES_choiceID];
    }
}

- (NSNumber *)choiceID {
    return [parameters objectForKey:NAMES_choiceID];
}

- (void)setManualTextEntry:(NSString *)manualTextEntry {
    if (manualTextEntry != nil) {
        [parameters setObject:manualTextEntry forKey:NAMES_manualTextEntry];
    } else {
        [parameters removeObjectForKey:NAMES_manualTextEntry];
    }
}

- (NSString *)manualTextEntry {
    return [parameters objectForKey:NAMES_manualTextEntry];
}

- (void)setTriggerSource:(SDLTriggerSource *)triggerSource {
    if (triggerSource != nil) {
        [parameters setObject:triggerSource forKey:NAMES_triggerSource];
    } else {
        [parameters removeObjectForKey:NAMES_triggerSource];
    }
}

- (SDLTriggerSource *)triggerSource {
    NSObject *obj = [parameters objectForKey:NAMES_triggerSource];
    if (obj == nil || [obj isKindOfClass:SDLTriggerSource.class]) {
        return (SDLTriggerSource *)obj;
    } else {
        return [SDLTriggerSource valueOf:(NSString *)obj];
    }
}

@end
