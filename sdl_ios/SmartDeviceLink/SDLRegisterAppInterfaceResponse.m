//  SDLRegisterAppInterfaceResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLRegisterAppInterfaceResponse.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLButtonCapabilities.h>
#import <SmartDeviceLink/SDLSoftButtonCapabilities.h>
#import <SmartDeviceLink/SDLHmiZoneCapabilities.h>
#import <SmartDeviceLink/SDLSpeechCapabilities.h>
#import <SmartDeviceLink/SDLPrerecordedSpeech.h>
#import <SmartDeviceLink/SDLVrCapabilities.h>
#import <SmartDeviceLink/SDLAudioPassThruCapabilities.h>

@implementation SDLRegisterAppInterfaceResponse

-(id) init {
    if (self = [super initWithName:NAMES_RegisterAppInterface]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion {
    [parameters setOrRemoveObject:syncMsgVersion forKey:NAMES_syncMsgVersion];
}

-(SDLSyncMsgVersion*) syncMsgVersion {
    NSObject* obj = [parameters objectForKey:NAMES_syncMsgVersion];
    if ([obj isKindOfClass:SDLSyncMsgVersion.class]) {
        return (SDLSyncMsgVersion*)obj;
    } else {
        return [[SDLSyncMsgVersion alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setLanguage:(SDLLanguage *)language {
    [parameters setOrRemoveObject:language forKey:NAMES_language];
}

-(SDLLanguage*) language {
    NSObject* obj = [parameters objectForKey:NAMES_language];
    if ([obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage*)obj;
    } else {
        return [SDLLanguage valueOf:(NSString*)obj];
    }
}

- (void)setHmiDisplayLanguage:(SDLLanguage *)hmiDisplayLanguage {
    [parameters setOrRemoveObject:hmiDisplayLanguage forKey:NAMES_hmiDisplayLanguage];
}

-(SDLLanguage*) hmiDisplayLanguage {
    NSObject* obj = [parameters objectForKey:NAMES_hmiDisplayLanguage];
    if ([obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage*)obj;
    } else {
        return [SDLLanguage valueOf:(NSString*)obj];
    }
}

- (void)setDisplayCapabilities:(SDLDisplayCapabilities *)displayCapabilities {
    [parameters setOrRemoveObject:displayCapabilities forKey:NAMES_displayCapabilities];
}

-(SDLDisplayCapabilities*) displayCapabilities {
    NSObject* obj = [parameters objectForKey:NAMES_displayCapabilities];
    if ([obj isKindOfClass:SDLDisplayCapabilities.class]) {
        return (SDLDisplayCapabilities*)obj;
    } else {
        return [[SDLDisplayCapabilities alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setButtonCapabilities:(NSMutableArray *)buttonCapabilities {
    [parameters setOrRemoveObject:buttonCapabilities forKey:NAMES_buttonCapabilities];
}

-(NSMutableArray*) buttonCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_buttonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

- (void)setSoftButtonCapabilities:(NSMutableArray *)softButtonCapabilities {
    [parameters setOrRemoveObject:softButtonCapabilities forKey:NAMES_softButtonCapabilities];
}

-(NSMutableArray*) softButtonCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_softButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLSoftButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

- (void)setPresetBankCapabilities:(SDLPresetBankCapabilities *)presetBankCapabilities {
    [parameters setOrRemoveObject:presetBankCapabilities forKey:NAMES_presetBankCapabilities];
}

-(SDLPresetBankCapabilities*) presetBankCapabilities {
    NSObject* obj = [parameters objectForKey:NAMES_presetBankCapabilities];
    if ([obj isKindOfClass:SDLPresetBankCapabilities.class]) {
        return (SDLPresetBankCapabilities*)obj;
    } else {
        return [[SDLPresetBankCapabilities alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setHmiZoneCapabilities:(NSMutableArray *)hmiZoneCapabilities {
    [parameters setOrRemoveObject:hmiZoneCapabilities forKey:NAMES_hmiZoneCapabilities];
}

-(NSMutableArray*) hmiZoneCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_hmiZoneCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLHmiZoneCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString* enumString in array) {
            [newList addObject:[SDLHmiZoneCapabilities valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setSpeechCapabilities:(NSMutableArray *)speechCapabilities {
    [parameters setOrRemoveObject:speechCapabilities forKey:NAMES_speechCapabilities];
}

-(NSMutableArray*) speechCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_speechCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSpeechCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString* enumString in array) {
            [newList addObject:[SDLSpeechCapabilities valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setPrerecordedSpeech:(NSMutableArray *)prerecordedSpeech {
    [parameters setOrRemoveObject:prerecordedSpeech forKey:NAMES_prerecordedSpeech];
}

-(NSMutableArray*) prerecordedSpeech {
    NSMutableArray* array = [parameters objectForKey:NAMES_prerecordedSpeech];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLPrerecordedSpeech.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString* enumString in array) {
            [newList addObject:[SDLPrerecordedSpeech valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setVrCapabilities:(NSMutableArray *)vrCapabilities {
    [parameters setOrRemoveObject:vrCapabilities forKey:NAMES_vrCapabilities];
}

-(NSMutableArray*) vrCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_vrCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLVrCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString* enumString in array) {
            [newList addObject:[SDLVrCapabilities valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setAudioPassThruCapabilities:(NSMutableArray *)audioPassThruCapabilities {
    [parameters setOrRemoveObject:audioPassThruCapabilities forKey:NAMES_audioPassThruCapabilities];
}

-(NSMutableArray*) audioPassThruCapabilities {
    NSMutableArray* array = [parameters objectForKey:NAMES_audioPassThruCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLAudioPassThruCapabilities.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLAudioPassThruCapabilities alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

- (void)setVehicleType:(SDLVehicleType *)vehicleType {
    [parameters setOrRemoveObject:vehicleType forKey:NAMES_vehicleType];
}

-(SDLVehicleType*) vehicleType {
    NSObject* obj = [parameters objectForKey:NAMES_vehicleType];
    if ([obj isKindOfClass:SDLVehicleType.class]) {
        return (SDLVehicleType*)obj;
    } else {
        return [[SDLVehicleType alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setSupportedDiagModes:(NSMutableArray *)supportedDiagModes {
    [parameters setOrRemoveObject:supportedDiagModes forKey:NAMES_supportedDiagModes];
}

-(NSMutableArray*) supportedDiagModes {
    return [parameters objectForKey:NAMES_supportedDiagModes];
}

@end
