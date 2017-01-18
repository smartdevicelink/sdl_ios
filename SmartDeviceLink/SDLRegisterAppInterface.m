//  SDLRegisterAppInterface.m
//


#import "SDLRegisterAppInterface.h"

#import "NSMutableDictionary+Store.h"
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
    if (self = [super initWithName:SDLNameRegisterAppInterface]) {
    }
    return self;
}

- (instancetype)initWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    return [self initWithAppName:lifecycleConfiguration.appName appId:lifecycleConfiguration.appId languageDesired:lifecycleConfiguration.language isMediaApp:lifecycleConfiguration.isMedia appType:lifecycleConfiguration.appType shortAppName:lifecycleConfiguration.shortAppName ttsName:lifecycleConfiguration.ttsName vrSynonyms:lifecycleConfiguration.voiceRecognitionCommandNames hmiDisplayLanguageDesired:lifecycleConfiguration.language resumeHash:lifecycleConfiguration.resumeHash];
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired {
    return [self initWithAppName:appName appId:appId languageDesired:languageDesired isMediaApp:NO appType:nil shortAppName:nil];
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appType:(SDLAppHMIType)appType shortAppName:(NSString *)shortAppName {
    return [self initWithAppName:appName appId:appId languageDesired:languageDesired isMediaApp:isMediaApp appType:appType shortAppName:shortAppName ttsName:nil vrSynonyms:nil hmiDisplayLanguageDesired:languageDesired resumeHash:nil];
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appType:(SDLAppHMIType)appType shortAppName:(NSString *)shortAppName ttsName:(NSArray<SDLTTSChunk *> *)ttsName vrSynonyms:(NSArray<NSString *> *)vrSynonyms hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired resumeHash:(NSString *)resumeHash {
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
    [parameters sdl_setObject:syncMsgVersion forName:SDLNameSyncMessageVersion];
}

- (SDLSyncMsgVersion *)syncMsgVersion {
    NSObject *obj = [parameters sdl_objectForName:SDLNameSyncMessageVersion];
    if (obj == nil || [obj isKindOfClass:SDLSyncMsgVersion.class]) {
        return (SDLSyncMsgVersion *)obj;
    } else {
        return [[SDLSyncMsgVersion alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setAppName:(NSString *)appName {
    [parameters sdl_setObject:appName forName:SDLNameAppName];
}

- (NSString *)appName {
    return [parameters sdl_objectForName:SDLNameAppName];
}

- (void)setTtsName:(NSMutableArray<SDLTTSChunk *> *)ttsName {
    [parameters sdl_setObject:ttsName forName:SDLNameTTSName];
}

- (NSMutableArray<SDLTTSChunk *> *)ttsName {
    NSMutableArray<SDLTTSChunk *> *array = [parameters sdl_objectForName:SDLNameTTSName];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTTSChunk.class]) {
        return array;
    } else {
        NSMutableArray<SDLTTSChunk *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLTTSChunk alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

- (void)setNgnMediaScreenAppName:(NSString *)ngnMediaScreenAppName {
    [parameters sdl_setObject:ngnMediaScreenAppName forName:SDLNameNGNMediaScreenAppName];
}

- (NSString *)ngnMediaScreenAppName {
    return [parameters sdl_objectForName:SDLNameNGNMediaScreenAppName];
}

- (void)setVrSynonyms:(NSMutableArray<NSString *> *)vrSynonyms {
    [parameters sdl_setObject:vrSynonyms forName:SDLNameVRSynonyms];
}

- (NSMutableArray<NSString *> *)vrSynonyms {
    return [parameters sdl_objectForName:SDLNameVRSynonyms];
}

- (void)setIsMediaApplication:(NSNumber<SDLBool> *)isMediaApplication {
    [parameters sdl_setObject:isMediaApplication forName:SDLNameIsMediaApplication];
}

- (NSNumber<SDLBool> *)isMediaApplication {
    return [parameters sdl_objectForName:SDLNameIsMediaApplication];
}

- (void)setLanguageDesired:(SDLLanguage)languageDesired {
    [parameters sdl_setObject:languageDesired forName:SDLNameLanguageDesired];
}

- (SDLLanguage)languageDesired {
    NSObject *obj = [parameters sdl_objectForName:SDLNameLanguageDesired];
    return (SDLLanguage)obj;
}

- (void)setHmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired {
    [parameters sdl_setObject:hmiDisplayLanguageDesired forName:SDLNameHMIDisplayLanguageDesired];
}

- (SDLLanguage)hmiDisplayLanguageDesired {
    NSObject *obj = [parameters sdl_objectForName:SDLNameHMIDisplayLanguageDesired];
    return (SDLLanguage)obj;
}

- (void)setAppHMIType:(NSMutableArray<SDLAppHMIType> *)appHMIType {
    [parameters sdl_setObject:appHMIType forName:SDLNameAppHMIType];
}

- (NSMutableArray<SDLAppHMIType> *)appHMIType {
    NSMutableArray<SDLAppHMIType> *array = [parameters sdl_objectForName:SDLNameAppHMIType];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray<SDLAppHMIType> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLAppHMIType)enumString];
        }
        return newList;
    }
}

- (void)setHashID:(NSString *)hashID {
    [parameters sdl_setObject:hashID forName:SDLNameHashId];
}

- (NSString *)hashID {
    return [parameters sdl_objectForName:SDLNameHashId];
}

- (void)setDeviceInfo:(SDLDeviceInfo *)deviceInfo {
    [parameters sdl_setObject:deviceInfo forName:SDLNameDeviceInfo];
}

- (SDLDeviceInfo *)deviceInfo {
    NSObject *obj = [parameters sdl_objectForName:SDLNameDeviceInfo];
    if (obj == nil || [obj isKindOfClass:SDLDeviceInfo.class]) {
        return (SDLDeviceInfo *)obj;
    } else {
        return [[SDLDeviceInfo alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setAppID:(NSString *)appID {
    [parameters sdl_setObject:appID forName:SDLNameAppId];
}

- (NSString *)appID {
    return [parameters sdl_objectForName:SDLNameAppId];
}

- (void)setAppInfo:(SDLAppInfo *)appInfo {
    [parameters sdl_setObject:appInfo forName:SDLNameAppInfo];
}

- (SDLAppInfo *)appInfo {
    NSObject *obj = [parameters sdl_objectForName:SDLNameAppInfo];
    if (obj == nil || [obj isKindOfClass:SDLAppInfo.class]) {
        return (SDLAppInfo *)obj;
    } else {
        return [[SDLAppInfo alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
