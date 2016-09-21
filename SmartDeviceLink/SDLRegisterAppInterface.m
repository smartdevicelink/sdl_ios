//  SDLRegisterAppInterface.m
//


#import "SDLRegisterAppInterface.h"

#import "SDLAppHMIType.h"
#import "SDLAppInfo.h"
#import "SDLDeviceInfo.h"
#import "SDLLanguage.h"

#import "SDLSyncMsgVersion.h"
#import "SDLTTSChunk.h"


@implementation SDLRegisterAppInterface

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

- (void)setAppName:(NSString *)appName {
    if (appName != nil) {
        [parameters setObject:appName forKey:SDLNameAppName];
    } else {
        [parameters removeObjectForKey:SDLNameAppName];
    }
}

- (NSString *)appName {
    return [parameters objectForKey:SDLNameAppName];
}

- (void)setTtsName:(NSMutableArray *)ttsName {
    if (ttsName != nil) {
        [parameters setObject:ttsName forKey:SDLNameTtsName];
    } else {
        [parameters removeObjectForKey:SDLNameTtsName];
    }
}

- (NSMutableArray *)ttsName {
    NSMutableArray *array = [parameters objectForKey:SDLNameTtsName];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setNgnMediaScreenAppName:(NSString *)ngnMediaScreenAppName {
    if (ngnMediaScreenAppName != nil) {
        [parameters setObject:ngnMediaScreenAppName forKey:SDLNameNgnMediaScreenAppName];
    } else {
        [parameters removeObjectForKey:SDLNameNgnMediaScreenAppName];
    }
}

- (NSString *)ngnMediaScreenAppName {
    return [parameters objectForKey:SDLNameNgnMediaScreenAppName];
}

- (void)setVrSynonyms:(NSMutableArray *)vrSynonyms {
    if (vrSynonyms != nil) {
        [parameters setObject:vrSynonyms forKey:SDLNameVrSynonyms];
    } else {
        [parameters removeObjectForKey:SDLNameVrSynonyms];
    }
}

- (NSMutableArray *)vrSynonyms {
    return [parameters objectForKey:SDLNameVrSynonyms];
}

- (void)setIsMediaApplication:(NSNumber *)isMediaApplication {
    if (isMediaApplication != nil) {
        [parameters setObject:isMediaApplication forKey:SDLNameIsMediaApplication];
    } else {
        [parameters removeObjectForKey:SDLNameIsMediaApplication];
    }
}

- (NSNumber *)isMediaApplication {
    return [parameters objectForKey:SDLNameIsMediaApplication];
}

- (void)setLanguageDesired:(SDLLanguage *)languageDesired {
    if (languageDesired != nil) {
        [parameters setObject:languageDesired forKey:SDLNameLanguageDesired];
    } else {
        [parameters removeObjectForKey:SDLNameLanguageDesired];
    }
}

- (SDLLanguage *)languageDesired {
    NSObject *obj = [parameters objectForKey:SDLNameLanguageDesired];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setHmiDisplayLanguageDesired:(SDLLanguage *)hmiDisplayLanguageDesired {
    if (hmiDisplayLanguageDesired != nil) {
        [parameters setObject:hmiDisplayLanguageDesired forKey:SDLNameHmiDisplayLanguageDesired];
    } else {
        [parameters removeObjectForKey:SDLNameHmiDisplayLanguageDesired];
    }
}

- (SDLLanguage *)hmiDisplayLanguageDesired {
    NSObject *obj = [parameters objectForKey:SDLNameHmiDisplayLanguageDesired];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setAppHMIType:(NSMutableArray *)appHMIType {
    if (appHMIType != nil) {
        [parameters setObject:appHMIType forKey:SDLNameAppHmiType];
    } else {
        [parameters removeObjectForKey:SDLNameAppHmiType];
    }
}

- (NSMutableArray *)appHMIType {
    NSMutableArray *array = [parameters objectForKey:SDLNameAppHmiType];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLAppHMIType.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:[SDLAppHMIType valueOf:enumString]];
        }
        return newList;
    }
}

- (void)setHashID:(NSString *)hashID {
    if (hashID != nil) {
        [parameters setObject:hashID forKey:SDLNameHashId];
    } else {
        [parameters removeObjectForKey:SDLNameHashId];
    }
}

- (NSString *)hashID {
    return [parameters objectForKey:SDLNameHashId];
}

- (void)setDeviceInfo:(SDLDeviceInfo *)deviceInfo {
    if (deviceInfo != nil) {
        [parameters setObject:deviceInfo forKey:SDLNameDeviceInfo];
    } else {
        [parameters removeObjectForKey:SDLNameDeviceInfo];
    }
}

- (SDLDeviceInfo *)deviceInfo {
    NSObject *obj = [parameters objectForKey:SDLNameDeviceInfo];
    if (obj == nil || [obj isKindOfClass:SDLDeviceInfo.class]) {
        return (SDLDeviceInfo *)obj;
    } else {
        return [[SDLDeviceInfo alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setAppID:(NSString *)appID {
    if (appID != nil) {
        [parameters setObject:appID forKey:SDLNameAppId];
    } else {
        [parameters removeObjectForKey:SDLNameAppId];
    }
}

- (NSString *)appID {
    return [parameters objectForKey:SDLNameAppId];
}

- (void)setAppInfo:(SDLAppInfo *)appInfo {
    if (appInfo != nil) {
        [parameters setObject:appInfo forKey:SDLNameAppInfo];
    } else {
        [parameters removeObjectForKey:SDLNameAppInfo];
    }
}

- (SDLAppInfo *)appInfo {
    NSObject *obj = [parameters objectForKey:SDLNameAppInfo];
    if (obj == nil || [obj isKindOfClass:SDLAppInfo.class]) {
        return (SDLAppInfo *)obj;
    } else {
        return [[SDLAppInfo alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
