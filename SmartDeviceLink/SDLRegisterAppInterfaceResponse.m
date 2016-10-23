//  SDLRegisterAppInterfaceResponse.m
//


#import "SDLRegisterAppInterfaceResponse.h"

#import "SDLAudioPassThruCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"
#import "SDLHMICapabilities.h"
#import "SDLNames.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSyncMsgVersion.h"
#import "SDLVehicleType.h"

@implementation SDLRegisterAppInterfaceResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameRegisterAppInterface]) {
    }
    return self;
}

- (void)setSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion {
    if (syncMsgVersion != nil) {
        [parameters setObject:syncMsgVersion forKey:SDLNameSyncMessageVersion];
    } else {
        [parameters removeObjectForKey:SDLNameSyncMessageVersion];
    }
}

- (SDLSyncMsgVersion *)syncMsgVersion {
    NSObject *obj = [parameters objectForKey:SDLNameSyncMessageVersion];
    if (obj == nil || [obj isKindOfClass:SDLSyncMsgVersion.class]) {
        return (SDLSyncMsgVersion *)obj;
    } else {
        return [[SDLSyncMsgVersion alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setLanguage:(SDLLanguage)language {
    if (language != nil) {
        [parameters setObject:language forKey:SDLNameLanguage];
    } else {
        [parameters removeObjectForKey:SDLNameLanguage];
    }
}

- (SDLLanguage)language {
    NSObject *obj = [parameters objectForKey:SDLNameLanguage];
    return (SDLLanguage)obj;
}

- (void)setHmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage {
    if (hmiDisplayLanguage != nil) {
        [parameters setObject:hmiDisplayLanguage forKey:SDLNameHMIDisplayLanguage];
    } else {
        [parameters removeObjectForKey:SDLNameHMIDisplayLanguage];
    }
}

- (SDLLanguage)hmiDisplayLanguage {
    NSObject *obj = [parameters objectForKey:SDLNameHMIDisplayLanguage];
    return (SDLLanguage)obj;
}

- (void)setDisplayCapabilities:(SDLDisplayCapabilities *)displayCapabilities {
    if (displayCapabilities != nil) {
        [parameters setObject:displayCapabilities forKey:SDLNameDisplayCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameDisplayCapabilities];
    }
}

- (SDLDisplayCapabilities *)displayCapabilities {
    NSObject *obj = [parameters objectForKey:SDLNameDisplayCapabilities];
    if (obj == nil || [obj isKindOfClass:SDLDisplayCapabilities.class]) {
        return (SDLDisplayCapabilities *)obj;
    } else {
        return [[SDLDisplayCapabilities alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setButtonCapabilities:(NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    if (buttonCapabilities != nil) {
        [parameters setObject:buttonCapabilities forKey:SDLNameButtonCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameButtonCapabilities];
    }
}

- (NSMutableArray<SDLButtonCapabilities *> *)buttonCapabilities {
    NSMutableArray<SDLButtonCapabilities *> *array = [parameters objectForKey:SDLNameButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray<SDLButtonCapabilities *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLButtonCapabilities alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setSoftButtonCapabilities:(NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    if (softButtonCapabilities != nil) {
        [parameters setObject:softButtonCapabilities forKey:SDLNameSoftButtonCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtonCapabilities];
    }
}

- (NSMutableArray<SDLSoftButtonCapabilities *> *)softButtonCapabilities {
    NSMutableArray<SDLSoftButtonCapabilities *> *array = [parameters objectForKey:SDLNameSoftButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButtonCapabilities.class]) {
        return array;
    } else {
        NSMutableArray<SDLSoftButtonCapabilities *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLSoftButtonCapabilities alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setPresetBankCapabilities:(SDLPresetBankCapabilities *)presetBankCapabilities {
    if (presetBankCapabilities != nil) {
        [parameters setObject:presetBankCapabilities forKey:SDLNamePresetBankCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNamePresetBankCapabilities];
    }
}

- (SDLPresetBankCapabilities *)presetBankCapabilities {
    NSObject *obj = [parameters objectForKey:SDLNamePresetBankCapabilities];
    if (obj == nil || [obj isKindOfClass:SDLPresetBankCapabilities.class]) {
        return (SDLPresetBankCapabilities *)obj;
    } else {
        return [[SDLPresetBankCapabilities alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setHmiZoneCapabilities:(NSMutableArray<SDLHMIZoneCapabilities> *)hmiZoneCapabilities {
    if (hmiZoneCapabilities != nil) {
        [parameters setObject:hmiZoneCapabilities forKey:SDLNameHMIZoneCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameHMIZoneCapabilities];
    }
}

- (NSMutableArray<SDLHMIZoneCapabilities> *)hmiZoneCapabilities {
    NSMutableArray<SDLHMIZoneCapabilities> *array = [parameters objectForKey:SDLNameHMIZoneCapabilities];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray<SDLHMIZoneCapabilities> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLHMIZoneCapabilities)enumString];
        }
        return newList;
    }
}

- (void)setSpeechCapabilities:(NSMutableArray<SDLSpeechCapabilities> *)speechCapabilities {
    if (speechCapabilities != nil) {
        [parameters setObject:speechCapabilities forKey:SDLNameSpeechCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameSpeechCapabilities];
    }
}

- (NSMutableArray<SDLSpeechCapabilities> *)speechCapabilities {
    NSMutableArray<SDLSpeechCapabilities> *array = [parameters objectForKey:SDLNameSpeechCapabilities];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray<SDLSpeechCapabilities> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLSpeechCapabilities)enumString];
        }
        return newList;
    }
}

- (void)setPrerecordedSpeech:(NSMutableArray<SDLPrerecordedSpeech> *)prerecordedSpeech {
    if (prerecordedSpeech != nil) {
        [parameters setObject:prerecordedSpeech forKey:SDLNamePrerecordedSpeech];
    } else {
        [parameters removeObjectForKey:SDLNamePrerecordedSpeech];
    }
}

- (NSMutableArray<SDLPrerecordedSpeech> *)prerecordedSpeech {
    NSMutableArray<SDLPrerecordedSpeech> *array = [parameters objectForKey:SDLNamePrerecordedSpeech];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray<SDLPrerecordedSpeech> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLPrerecordedSpeech)enumString];
        }
        return newList;
    }
}

- (void)setVrCapabilities:(NSMutableArray<SDLVRCapabilities> *)vrCapabilities {
    if (vrCapabilities != nil) {
        [parameters setObject:vrCapabilities forKey:SDLNameVRCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameVRCapabilities];
    }
}

- (NSMutableArray<SDLVRCapabilities> *)vrCapabilities {
    NSMutableArray<SDLVRCapabilities> *array = [parameters objectForKey:SDLNameVRCapabilities];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray<SDLVRCapabilities> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLVRCapabilities)enumString];
        }
        return newList;
    }
}

- (void)setAudioPassThruCapabilities:(NSMutableArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities {
    if (audioPassThruCapabilities != nil) {
        [parameters setObject:audioPassThruCapabilities forKey:SDLNameAudioPassThruCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameAudioPassThruCapabilities];
    }
}

- (NSMutableArray<SDLAudioPassThruCapabilities *> *)audioPassThruCapabilities {
    NSMutableArray<SDLAudioPassThruCapabilities *> *array = [parameters objectForKey:SDLNameAudioPassThruCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLAudioPassThruCapabilities.class]) {
        return array;
    } else {
        NSMutableArray<SDLAudioPassThruCapabilities *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLAudioPassThruCapabilities alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setVehicleType:(SDLVehicleType *)vehicleType {
    if (vehicleType != nil) {
        [parameters setObject:vehicleType forKey:SDLNameVehicleType];
    } else {
        [parameters removeObjectForKey:SDLNameVehicleType];
    }
}

- (SDLVehicleType *)vehicleType {
    NSObject *obj = [parameters objectForKey:SDLNameVehicleType];
    if (obj == nil || [obj isKindOfClass:SDLVehicleType.class]) {
        return (SDLVehicleType *)obj;
    } else {
        return [[SDLVehicleType alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setSupportedDiagModes:(NSMutableArray<NSNumber<SDLInt> *> *)supportedDiagModes {
    if (supportedDiagModes != nil) {
        [parameters setObject:supportedDiagModes forKey:SDLNameSupportedDiagnosticModes];
    } else {
        [parameters removeObjectForKey:SDLNameSupportedDiagnosticModes];
    }
}

- (NSMutableArray<NSNumber<SDLInt> *> *)supportedDiagModes {
    return [parameters objectForKey:SDLNameSupportedDiagnosticModes];
}

- (void)setHmiCapabilities:(SDLHMICapabilities *)hmiCapabilities {
    if (hmiCapabilities != nil) {
        [parameters setObject:hmiCapabilities forKey:SDLNameHMICapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameHMICapabilities];
    }
}

- (SDLHMICapabilities *)hmiCapabilities {
    NSObject *obj = [parameters objectForKey:SDLNameHMICapabilities];
    if (obj == nil || [obj isKindOfClass:[SDLHMICapabilities class]]) {
        return (SDLHMICapabilities *)obj;
    } else {
        return [[SDLHMICapabilities alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setSdlVersion:(NSString *)sdlVersion {
    if (sdlVersion != nil) {
        parameters[SDLNameSDLVersion] = sdlVersion;
    } else {
        [parameters removeObjectForKey:SDLNameSDLVersion];
    }
}

- (NSString *)sdlVersion {
    return parameters[SDLNameSDLVersion];
}

- (void)setSystemSoftwareVersion:(NSString *)systemSoftwareVersion {
    if (systemSoftwareVersion != nil) {
        parameters[SDLNameSystemSoftwareVersion] = systemSoftwareVersion;
    } else {
        [parameters removeObjectForKey:SDLNameSystemSoftwareVersion];
    }
}

- (NSString *)systemSoftwareVersion {
    return parameters[SDLNameSystemSoftwareVersion];
}

@end
