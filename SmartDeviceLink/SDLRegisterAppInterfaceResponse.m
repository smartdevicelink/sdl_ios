//  SDLRegisterAppInterfaceResponse.m
//


#import "SDLRegisterAppInterfaceResponse.h"

#import "SDLAudioPassThruCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"
#import "SDLHMICapabilities.h"
#import "SDLHMIZoneCapabilities.h"
#import "SDLLanguage.h"
#import "SDLNames.h"
#import "SDLPrerecordedSpeech.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSpeechCapabilities.h"
#import "SDLSyncMsgVersion.h"
#import "SDLVehicleType.h"
#import "SDLVrCapabilities.h"


@implementation SDLRegisterAppInterfaceResponse

- (instancetype)init {
    if (self = [super initWithName:NAMES_RegisterAppInterface]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion {
    if (syncMsgVersion != nil) {
        [parameters setObject:syncMsgVersion forKey:NAMES_syncMsgVersion];
    } else {
        [parameters removeObjectForKey:NAMES_syncMsgVersion];
    }
}

- (SDLSyncMsgVersion *)syncMsgVersion {
    NSObject *obj = [parameters objectForKey:NAMES_syncMsgVersion];
    if (obj == nil || [obj isKindOfClass:SDLSyncMsgVersion.class]) {
        return (SDLSyncMsgVersion *)obj;
    } else {
        return [[SDLSyncMsgVersion alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setLanguage:(SDLLanguage *)language {
    if (language != nil) {
        [parameters setObject:language forKey:NAMES_language];
    } else {
        [parameters removeObjectForKey:NAMES_language];
    }
}

- (SDLLanguage *)language {
    NSObject *obj = [parameters objectForKey:NAMES_language];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setHmiDisplayLanguage:(SDLLanguage *)hmiDisplayLanguage {
    if (hmiDisplayLanguage != nil) {
        [parameters setObject:hmiDisplayLanguage forKey:NAMES_hmiDisplayLanguage];
    } else {
        [parameters removeObjectForKey:NAMES_hmiDisplayLanguage];
    }
}

- (SDLLanguage *)hmiDisplayLanguage {
    NSObject *obj = [parameters objectForKey:NAMES_hmiDisplayLanguage];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setDisplayCapabilities:(SDLDisplayCapabilities *)displayCapabilities {
    if (displayCapabilities != nil) {
        [parameters setObject:displayCapabilities forKey:NAMES_displayCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_displayCapabilities];
    }
}

- (SDLDisplayCapabilities *)displayCapabilities {
    NSObject *obj = [parameters objectForKey:NAMES_displayCapabilities];
    if (obj == nil || [obj isKindOfClass:SDLDisplayCapabilities.class]) {
        return (SDLDisplayCapabilities *)obj;
    } else {
        return [[SDLDisplayCapabilities alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setButtonCapabilities:(NSMutableArray *)buttonCapabilities {
    if (buttonCapabilities != nil) {
        [parameters setObject:buttonCapabilities forKey:NAMES_buttonCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_buttonCapabilities];
    }
}

- (NSMutableArray *)buttonCapabilities {
    NSMutableArray *array = [parameters objectForKey:NAMES_buttonCapabilities];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setSoftButtonCapabilities:(NSMutableArray *)softButtonCapabilities {
    if (softButtonCapabilities != nil) {
        [parameters setObject:softButtonCapabilities forKey:NAMES_softButtonCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_softButtonCapabilities];
    }
}

- (NSMutableArray *)softButtonCapabilities {
    NSMutableArray *array = [parameters objectForKey:NAMES_softButtonCapabilities];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLSoftButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLSoftButtonCapabilities alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setPresetBankCapabilities:(SDLPresetBankCapabilities *)presetBankCapabilities {
    if (presetBankCapabilities != nil) {
        [parameters setObject:presetBankCapabilities forKey:NAMES_presetBankCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_presetBankCapabilities];
    }
}

- (SDLPresetBankCapabilities *)presetBankCapabilities {
    NSObject *obj = [parameters objectForKey:NAMES_presetBankCapabilities];
    if (obj == nil || [obj isKindOfClass:SDLPresetBankCapabilities.class]) {
        return (SDLPresetBankCapabilities *)obj;
    } else {
        return [[SDLPresetBankCapabilities alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setHmiZoneCapabilities:(NSMutableArray *)hmiZoneCapabilities {
    if (hmiZoneCapabilities != nil) {
        [parameters setObject:hmiZoneCapabilities forKey:NAMES_hmiZoneCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_hmiZoneCapabilities];
    }
}

- (NSMutableArray *)hmiZoneCapabilities {
    NSMutableArray *array = [parameters objectForKey:NAMES_hmiZoneCapabilities];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLHMIZoneCapabilities.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLHMIZoneCapabilities valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setSpeechCapabilities:(NSMutableArray *)speechCapabilities {
    if (speechCapabilities != nil) {
        [parameters setObject:speechCapabilities forKey:NAMES_speechCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_speechCapabilities];
    }
}

- (NSMutableArray *)speechCapabilities {
    NSMutableArray *array = [parameters objectForKey:NAMES_speechCapabilities];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLSpeechCapabilities.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLSpeechCapabilities valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setPrerecordedSpeech:(NSMutableArray *)prerecordedSpeech {
    if (prerecordedSpeech != nil) {
        [parameters setObject:prerecordedSpeech forKey:NAMES_prerecordedSpeech];
    } else {
        [parameters removeObjectForKey:NAMES_prerecordedSpeech];
    }
}

- (NSMutableArray *)prerecordedSpeech {
    NSMutableArray *array = [parameters objectForKey:NAMES_prerecordedSpeech];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLPrerecordedSpeech.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLPrerecordedSpeech valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setVrCapabilities:(NSMutableArray *)vrCapabilities {
    if (vrCapabilities != nil) {
        [parameters setObject:vrCapabilities forKey:NAMES_vrCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_vrCapabilities];
    }
}

- (NSMutableArray *)vrCapabilities {
    NSMutableArray *array = [parameters objectForKey:NAMES_vrCapabilities];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLVRCapabilities.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLVRCapabilities valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setAudioPassThruCapabilities:(NSMutableArray *)audioPassThruCapabilities {
    if (audioPassThruCapabilities != nil) {
        [parameters setObject:audioPassThruCapabilities forKey:NAMES_audioPassThruCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_audioPassThruCapabilities];
    }
}

- (NSMutableArray *)audioPassThruCapabilities {
    NSMutableArray *array = [parameters objectForKey:NAMES_audioPassThruCapabilities];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLAudioPassThruCapabilities.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLAudioPassThruCapabilities alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setVehicleType:(SDLVehicleType *)vehicleType {
    if (vehicleType != nil) {
        [parameters setObject:vehicleType forKey:NAMES_vehicleType];
    } else {
        [parameters removeObjectForKey:NAMES_vehicleType];
    }
}

- (SDLVehicleType *)vehicleType {
    NSObject *obj = [parameters objectForKey:NAMES_vehicleType];
    if (obj == nil || [obj isKindOfClass:SDLVehicleType.class]) {
        return (SDLVehicleType *)obj;
    } else {
        return [[SDLVehicleType alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setSupportedDiagModes:(NSMutableArray *)supportedDiagModes {
    if (supportedDiagModes != nil) {
        [parameters setObject:supportedDiagModes forKey:NAMES_supportedDiagModes];
    } else {
        [parameters removeObjectForKey:NAMES_supportedDiagModes];
    }
}

- (NSMutableArray *)supportedDiagModes {
    return [parameters objectForKey:NAMES_supportedDiagModes];
}

- (void)setHmiCapabilities:(SDLHMICapabilities *)hmiCapabilities {
    if (hmiCapabilities != nil) {
        [parameters setObject:hmiCapabilities forKey:NAMES_hmiCapabilities];
    } else {
        [parameters removeObjectForKey:NAMES_hmiCapabilities];
    }
}

- (SDLHMICapabilities *)hmiCapabilities {
    NSObject *obj = [parameters objectForKey:NAMES_hmiCapabilities];
    if (obj == nil || [obj isKindOfClass:[SDLHMICapabilities class]]) {
        return (SDLHMICapabilities *)obj;
    } else {
        return [[SDLHMICapabilities alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setSdlVersion:(NSString *)sdlVersion {
    if (sdlVersion != nil) {
        parameters[NAMES_sdlVersion] = sdlVersion;
    } else {
        [parameters removeObjectForKey:NAMES_sdlVersion];
    }
}

- (NSString *)sdlVersion {
    return parameters[NAMES_sdlVersion];
}

- (void)setSystemSoftwareVersion:(NSString *)systemSoftwareVersion {
    if (systemSoftwareVersion != nil) {
        parameters[NAMES_systemSoftwareVersion] = systemSoftwareVersion;
    } else {
        [parameters removeObjectForKey:NAMES_systemSoftwareVersion];
    }
}

- (NSString *)systemSoftwareVersion {
    return parameters[NAMES_systemSoftwareVersion];
}

@end
