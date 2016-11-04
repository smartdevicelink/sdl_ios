//  SDLRegisterAppInterface.m
//


#import "SDLRegisterAppInterface.h"

#import "SDLAppHMIType.h"
#import "SDLAppInfo.h"
#import "SDLDeviceInfo.h"
#import "SDLLanguage.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLNames.h"
#import "SDLSyncMsgVersion.h"
#import "SDLTTSChunk.h"


@implementation SDLRegisterAppInterface

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

- (instancetype)initWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    return [self initWithAppName:lifecycleConfiguration.appName appId:lifecycleConfiguration.appId languageDesired:lifecycleConfiguration.language isMediaApp:lifecycleConfiguration.isMedia appType:lifecycleConfiguration.appType shortAppName:lifecycleConfiguration.shortAppName ttsName:lifecycleConfiguration.ttsName vrSynonyms:lifecycleConfiguration.voiceRecognitionCommandNames hmiDisplayLanguageDesired:lifecycleConfiguration.language resumeHash:lifecycleConfiguration.resumeHash];
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage *)languageDesired {
    return [self initWithAppName:appName appId:appId languageDesired:languageDesired isMediaApp:NO appType:nil shortAppName:nil];
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage *)languageDesired isMediaApp:(BOOL)isMediaApp appType:(SDLAppHMIType *)appType shortAppName:(NSString *)shortAppName {
    return [self initWithAppName:appName appId:appId languageDesired:languageDesired isMediaApp:isMediaApp appType:appType shortAppName:shortAppName ttsName:nil vrSynonyms:nil hmiDisplayLanguageDesired:languageDesired resumeHash:nil];
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage *)languageDesired isMediaApp:(BOOL)isMediaApp appType:(SDLAppHMIType *)appType shortAppName:(NSString *)shortAppName ttsName:(NSArray<SDLTTSChunk *> *)ttsName vrSynonyms:(NSArray<NSString *> *)vrSynonyms hmiDisplayLanguageDesired:(SDLLanguage *)hmiDisplayLanguageDesired resumeHash:(NSString *)resumeHash {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.appID = appId;
    self.appName = appName;
    self.ngnMediaScreenAppName = shortAppName;

    if (appType != nil) {
        self.appHMIType = [NSMutableArray arrayWithObject:appType];
    }

    self.languageDesired = languageDesired;
    self.hmiDisplayLanguageDesired = hmiDisplayLanguageDesired;
    self.isMediaApplication = @(isMediaApp);
    self.ttsName = [ttsName copy];
    self.vrSynonyms = [vrSynonyms copy];
    self.syncMsgVersion = [[SDLSyncMsgVersion alloc] initWithMajorVersion:1 minorVersion:0];
    self.appInfo = [SDLAppInfo currentAppInfo];
    self.deviceInfo = [SDLDeviceInfo currentDevice];
    self.hashID = resumeHash;
    self.correlationID = @1;

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

- (void)setAppName:(NSString *)appName {
    if (appName != nil) {
        [parameters setObject:appName forKey:NAMES_appName];
    } else {
        [parameters removeObjectForKey:NAMES_appName];
    }
}

- (NSString *)appName {
    return [parameters objectForKey:NAMES_appName];
}

- (void)setTtsName:(NSMutableArray *)ttsName {
    if (ttsName != nil) {
        [parameters setObject:ttsName forKey:NAMES_ttsName];
    } else {
        [parameters removeObjectForKey:NAMES_ttsName];
    }
}

- (NSMutableArray *)ttsName {
    NSMutableArray *array = [parameters objectForKey:NAMES_ttsName];
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
        [parameters setObject:ngnMediaScreenAppName forKey:NAMES_ngnMediaScreenAppName];
    } else {
        [parameters removeObjectForKey:NAMES_ngnMediaScreenAppName];
    }
}

- (NSString *)ngnMediaScreenAppName {
    return [parameters objectForKey:NAMES_ngnMediaScreenAppName];
}

- (void)setVrSynonyms:(NSMutableArray *)vrSynonyms {
    if (vrSynonyms != nil) {
        [parameters setObject:vrSynonyms forKey:NAMES_vrSynonyms];
    } else {
        [parameters removeObjectForKey:NAMES_vrSynonyms];
    }
}

- (NSMutableArray *)vrSynonyms {
    return [parameters objectForKey:NAMES_vrSynonyms];
}

- (void)setIsMediaApplication:(NSNumber *)isMediaApplication {
    if (isMediaApplication != nil) {
        [parameters setObject:isMediaApplication forKey:NAMES_isMediaApplication];
    } else {
        [parameters removeObjectForKey:NAMES_isMediaApplication];
    }
}

- (NSNumber *)isMediaApplication {
    return [parameters objectForKey:NAMES_isMediaApplication];
}

- (void)setLanguageDesired:(SDLLanguage *)languageDesired {
    if (languageDesired != nil) {
        [parameters setObject:languageDesired forKey:NAMES_languageDesired];
    } else {
        [parameters removeObjectForKey:NAMES_languageDesired];
    }
}

- (SDLLanguage *)languageDesired {
    NSObject *obj = [parameters objectForKey:NAMES_languageDesired];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setHmiDisplayLanguageDesired:(SDLLanguage *)hmiDisplayLanguageDesired {
    if (hmiDisplayLanguageDesired != nil) {
        [parameters setObject:hmiDisplayLanguageDesired forKey:NAMES_hmiDisplayLanguageDesired];
    } else {
        [parameters removeObjectForKey:NAMES_hmiDisplayLanguageDesired];
    }
}

- (SDLLanguage *)hmiDisplayLanguageDesired {
    NSObject *obj = [parameters objectForKey:NAMES_hmiDisplayLanguageDesired];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setAppHMIType:(NSMutableArray *)appHMIType {
    if (appHMIType != nil) {
        [parameters setObject:appHMIType forKey:NAMES_appHMIType];
    } else {
        [parameters removeObjectForKey:NAMES_appHMIType];
    }
}

- (NSMutableArray *)appHMIType {
    NSMutableArray *array = [parameters objectForKey:NAMES_appHMIType];
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
        [parameters setObject:hashID forKey:NAMES_hashID];
    } else {
        [parameters removeObjectForKey:NAMES_hashID];
    }
}

- (NSString *)hashID {
    return [parameters objectForKey:NAMES_hashID];
}

- (void)setDeviceInfo:(SDLDeviceInfo *)deviceInfo {
    if (deviceInfo != nil) {
        [parameters setObject:deviceInfo forKey:NAMES_deviceInfo];
    } else {
        [parameters removeObjectForKey:NAMES_deviceInfo];
    }
}

- (SDLDeviceInfo *)deviceInfo {
    NSObject *obj = [parameters objectForKey:NAMES_deviceInfo];
    if (obj == nil || [obj isKindOfClass:SDLDeviceInfo.class]) {
        return (SDLDeviceInfo *)obj;
    } else {
        return [[SDLDeviceInfo alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setAppID:(NSString *)appID {
    if (appID != nil) {
        [parameters setObject:appID forKey:NAMES_appID];
    } else {
        [parameters removeObjectForKey:NAMES_appID];
    }
}

- (NSString *)appID {
    return [parameters objectForKey:NAMES_appID];
}

- (void)setAppInfo:(SDLAppInfo *)appInfo {
    if (appInfo != nil) {
        [parameters setObject:appInfo forKey:NAMES_appInfo];
    } else {
        [parameters removeObjectForKey:NAMES_appInfo];
    }
}

- (SDLAppInfo *)appInfo {
    NSObject *obj = [parameters objectForKey:NAMES_appInfo];
    if (obj == nil || [obj isKindOfClass:SDLAppInfo.class]) {
        return (SDLAppInfo *)obj;
    } else {
        return [[SDLAppInfo alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
