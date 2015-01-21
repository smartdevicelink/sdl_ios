//  SDLPerformInteractionResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLPerformInteractionResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLPerformInteractionResponse

-(id) init {
    if (self = [super initWithName:NAMES_PerformInteraction]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setChoiceID:(NSNumber *)choiceID {
    [parameters setOrRemoveObject:choiceID forKey:NAMES_choiceID];
}

-(NSNumber*) choiceID {
    return [parameters objectForKey:NAMES_choiceID];
}

- (void)setManualTextEntry:(NSString *)manualTextEntry {
    [parameters setOrRemoveObject:manualTextEntry forKey:NAMES_manualTextEntry];
}

-(NSString*) manualTextEntry {
    return [parameters objectForKey:NAMES_manualTextEntry];
}

- (void)setTriggerSource:(SDLTriggerSource *)triggerSource {
    [parameters setOrRemoveObject:triggerSource forKey:NAMES_triggerSource];
}

-(SDLTriggerSource*) triggerSource {
    NSObject* obj = [parameters objectForKey:NAMES_triggerSource];
    if ([obj isKindOfClass:SDLTriggerSource.class]) {
        return (SDLTriggerSource*)obj;
    } else {
        return [SDLTriggerSource valueOf:(NSString*)obj];
    }
}

@end
