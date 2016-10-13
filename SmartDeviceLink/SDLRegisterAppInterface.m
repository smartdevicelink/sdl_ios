//  SDLRegisterAppInterface.m
//


#import "SDLRegisterAppInterface.h"

#import "SDLAppHMIType.h"
#import "SDLAppInfo.h"
#import "SDLDeviceInfo.h"
#import "SDLNames.h"
#import "SDLSyncMsgVersion.h"
#import "SDLTTSChunk.h"


@implementation SDLRegisterAppInterface

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
        [parameters setObject:ttsName forKey:SDLNameTTSName];
    } else {
        [parameters removeObjectForKey:SDLNameTTSName];
    }
}

- (NSMutableArray *)ttsName {
    NSMutableArray *array = [parameters objectForKey:SDLNameTTSName];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setNgnMediaScreenAppName:(NSString *)ngnMediaScreenAppName {
    if (ngnMediaScreenAppName != nil) {
        [parameters setObject:ngnMediaScreenAppName forKey:SDLNameNGNMediaScreenAppName];
    } else {
        [parameters removeObjectForKey:SDLNameNGNMediaScreenAppName];
    }
}

- (NSString *)ngnMediaScreenAppName {
    return [parameters objectForKey:SDLNameNGNMediaScreenAppName];
}

- (void)setVrSynonyms:(NSMutableArray *)vrSynonyms {
    if (vrSynonyms != nil) {
        [parameters setObject:vrSynonyms forKey:SDLNameVRSynonyms];
    } else {
        [parameters removeObjectForKey:SDLNameVRSynonyms];
    }
}

- (NSMutableArray *)vrSynonyms {
    return [parameters objectForKey:SDLNameVRSynonyms];
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

- (void)setLanguageDesired:(SDLLanguage)languageDesired {
    if (languageDesired != nil) {
        [parameters setObject:languageDesired forKey:SDLNameLanguageDesired];
    } else {
        [parameters removeObjectForKey:SDLNameLanguageDesired];
    }
}

- (SDLLanguage)languageDesired {
    NSObject *obj = [parameters objectForKey:SDLNameLanguageDesired];
    return (SDLLanguage)obj;
}

- (void)setHmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired {
    if (hmiDisplayLanguageDesired != nil) {
        [parameters setObject:hmiDisplayLanguageDesired forKey:SDLNameHMIDisplayLanguageDesired];
    } else {
        [parameters removeObjectForKey:SDLNameHMIDisplayLanguageDesired];
    }
}

- (SDLLanguage)hmiDisplayLanguageDesired {
    NSObject *obj = [parameters objectForKey:SDLNameHMIDisplayLanguageDesired];
    return (SDLLanguage)obj;
}

- (void)setAppHMIType:(NSMutableArray *)appHMIType {
    if (appHMIType != nil) {
        [parameters setObject:appHMIType forKey:SDLNameAppHMIType];
    } else {
        [parameters removeObjectForKey:SDLNameAppHMIType];
    }
}

- (NSMutableArray *)appHMIType {
    NSMutableArray *array = [parameters objectForKey:SDLNameAppHMIType];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLAppHMIType)enumString];
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
        return [[SDLDeviceInfo alloc] initWithDictionary:(NSDictionary *)obj];
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
        return [[SDLAppInfo alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
