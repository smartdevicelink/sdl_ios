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
    return [parameters sdl_objectForName:SDLNameSyncMessageVersion ofClass:SDLSyncMsgVersion.class];
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
    return [parameters sdl_objectsForName:SDLNameTTSName ofClass:SDLTTSChunk.class];
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
    return [parameters sdl_objectForName:SDLNameLanguageDesired];
}

- (void)setHmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired {
    [parameters sdl_setObject:hmiDisplayLanguageDesired forName:SDLNameHMIDisplayLanguageDesired];
}

- (SDLLanguage)hmiDisplayLanguageDesired {
    return [parameters sdl_objectForName:SDLNameHMIDisplayLanguageDesired];
}

- (void)setAppHMIType:(NSMutableArray<SDLAppHMIType> *)appHMIType {
    [parameters sdl_setObject:appHMIType forName:SDLNameAppHMIType];
}

- (NSMutableArray<SDLAppHMIType> *)appHMIType {
    return [parameters sdl_enumsForName:SDLNameAppHMIType];
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
    return [parameters sdl_objectForName:SDLNameDeviceInfo ofClass:SDLDeviceInfo.class];
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
    return [parameters sdl_objectForName:SDLNameAppInfo ofClass:SDLAppInfo.class];
}

@end
