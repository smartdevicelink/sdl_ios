//  SDLRegisterAppInterfaceResponse.m
//


#import "SDLRegisterAppInterfaceResponse.h"

#import "SDLAudioPassThruCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"
#import "SDLHMICapabilities.h"
#import "SDLHMIZoneCapabilities.h"
#import "SDLLanguage.h"

#import "SDLPrerecordedSpeech.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSpeechCapabilities.h"
#import "SDLSyncMsgVersion.h"
#import "SDLVRCapabilities.h"
#import "SDLVehicleType.h"


@implementation SDLRegisterAppInterfaceResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameRegisterAppInterface]) {
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
        [parameters setObject:syncMsgVersion forKey:SDLNameSyncMsgVersion];
    } else {
        [parameters removeObjectForKey:SDLNameSyncMsgVersion];
    }
}

- (SDLSyncMsgVersion *)syncMsgVersion {
    NSObject *obj = [parameters objectForKey:SDLNameSyncMsgVersion];
    if (obj == nil || [obj isKindOfClass:SDLSyncMsgVersion.class]) {
        return (SDLSyncMsgVersion *)obj;
    } else {
        return [[SDLSyncMsgVersion alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setLanguage:(SDLLanguage *)language {
    if (language != nil) {
        [parameters setObject:language forKey:SDLNameLanguage];
    } else {
        [parameters removeObjectForKey:SDLNameLanguage];
    }
}

- (SDLLanguage *)language {
    NSObject *obj = [parameters objectForKey:SDLNameLanguage];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setHmiDisplayLanguage:(SDLLanguage *)hmiDisplayLanguage {
    if (hmiDisplayLanguage != nil) {
        [parameters setObject:hmiDisplayLanguage forKey:SDLNameHmiDisplayLanguage];
    } else {
        [parameters removeObjectForKey:SDLNameHmiDisplayLanguage];
    }
}

- (SDLLanguage *)hmiDisplayLanguage {
    NSObject *obj = [parameters objectForKey:SDLNameHmiDisplayLanguage];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
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
        return [[SDLDisplayCapabilities alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setButtonCapabilities:(NSMutableArray *)buttonCapabilities {
    if (buttonCapabilities != nil) {
        [parameters setObject:buttonCapabilities forKey:SDLNameButtonCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameButtonCapabilities];
    }
}

- (NSMutableArray *)buttonCapabilities {
    NSMutableArray *array = [parameters objectForKey:SDLNameButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLButtonCapabilities.class]) {
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
        [parameters setObject:softButtonCapabilities forKey:SDLNameSoftButtonCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtonCapabilities];
    }
}

- (NSMutableArray *)softButtonCapabilities {
    NSMutableArray *array = [parameters objectForKey:SDLNameSoftButtonCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButtonCapabilities.class]) {
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
        return [[SDLPresetBankCapabilities alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setHmiZoneCapabilities:(NSMutableArray *)hmiZoneCapabilities {
    if (hmiZoneCapabilities != nil) {
        [parameters setObject:hmiZoneCapabilities forKey:SDLNameHmiZoneCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameHmiZoneCapabilities];
    }
}

- (NSMutableArray *)hmiZoneCapabilities {
    NSMutableArray *array = [parameters objectForKey:SDLNameHmiZoneCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLHMIZoneCapabilities.class]) {
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
        [parameters setObject:speechCapabilities forKey:SDLNameSpeechCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameSpeechCapabilities];
    }
}

- (NSMutableArray *)speechCapabilities {
    NSMutableArray *array = [parameters objectForKey:SDLNameSpeechCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSpeechCapabilities.class]) {
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
        [parameters setObject:prerecordedSpeech forKey:SDLNamePrerecordedSpeech];
    } else {
        [parameters removeObjectForKey:SDLNamePrerecordedSpeech];
    }
}

- (NSMutableArray *)prerecordedSpeech {
    NSMutableArray *array = [parameters objectForKey:SDLNamePrerecordedSpeech];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLPrerecordedSpeech.class]) {
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
        [parameters setObject:vrCapabilities forKey:SDLNameVrCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameVrCapabilities];
    }
}

- (NSMutableArray *)vrCapabilities {
    NSMutableArray *array = [parameters objectForKey:SDLNameVrCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLVRCapabilities.class]) {
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
        [parameters setObject:audioPassThruCapabilities forKey:SDLNameAudioPassThruCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameAudioPassThruCapabilities];
    }
}

- (NSMutableArray *)audioPassThruCapabilities {
    NSMutableArray *array = [parameters objectForKey:SDLNameAudioPassThruCapabilities];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLAudioPassThruCapabilities.class]) {
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
        return [[SDLVehicleType alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setSupportedDiagModes:(NSMutableArray *)supportedDiagModes {
    if (supportedDiagModes != nil) {
        [parameters setObject:supportedDiagModes forKey:SDLNameSupportedDiagModes];
    } else {
        [parameters removeObjectForKey:SDLNameSupportedDiagModes];
    }
}

- (NSMutableArray *)supportedDiagModes {
    return [parameters objectForKey:SDLNameSupportedDiagModes];
}

- (void)setHmiCapabilities:(SDLHMICapabilities *)hmiCapabilities {
    if (hmiCapabilities != nil) {
        [parameters setObject:hmiCapabilities forKey:SDLNameHmiCapabilities];
    } else {
        [parameters removeObjectForKey:SDLNameHmiCapabilities];
    }
}

- (SDLHMICapabilities *)hmiCapabilities {
    NSObject *obj = [parameters objectForKey:SDLNameHmiCapabilities];
    if (obj == nil || [obj isKindOfClass:[SDLHMICapabilities class]]) {
        return (SDLHMICapabilities *)obj;
    } else {
        return [[SDLHMICapabilities alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setSdlVersion:(NSString *)sdlVersion {
    if (sdlVersion != nil) {
        parameters[SDLNameSdlVersion] = sdlVersion;
    } else {
        [parameters removeObjectForKey:SDLNameSdlVersion];
    }
}

- (NSString *)sdlVersion {
    return parameters[SDLNameSdlVersion];
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
