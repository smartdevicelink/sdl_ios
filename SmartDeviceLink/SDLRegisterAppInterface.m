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

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRegisterAppInterface

- (instancetype)init {
    if (self = [super initWithName:SDLNameRegisterAppInterface]) {
    }
    return self;
}

- (instancetype)initWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    NSArray<SDLAppHMIType> *allHMITypes = lifecycleConfiguration.additionalAppTypes ? [lifecycleConfiguration.additionalAppTypes arrayByAddingObject:lifecycleConfiguration.appType] : @[lifecycleConfiguration.appType];

    return [self initWithAppName:lifecycleConfiguration.appName
                           appId:lifecycleConfiguration.appId
                 languageDesired:lifecycleConfiguration.language
                      isMediaApp:lifecycleConfiguration.isMedia
                        appTypes:allHMITypes
                    shortAppName:lifecycleConfiguration.shortAppName
                         ttsName:lifecycleConfiguration.ttsName
                      vrSynonyms:lifecycleConfiguration.voiceRecognitionCommandNames
       hmiDisplayLanguageDesired:lifecycleConfiguration.language
                      resumeHash:lifecycleConfiguration.resumeHash];
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.appName = appName;
    self.appID = appId;
    self.languageDesired = languageDesired;
    
    self.syncMsgVersion = [[SDLSyncMsgVersion alloc] initWithMajorVersion:1 minorVersion:0 patchVersion:0];
    self.appInfo = [SDLAppInfo currentAppInfo];
    self.deviceInfo = [SDLDeviceInfo currentDevice];
    self.correlationID = @1;
    
    return self;
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appType:(SDLAppHMIType)appType shortAppName:(nullable NSString *)shortAppName {
    return [self initWithAppName:appName appId:appId languageDesired:languageDesired isMediaApp:isMediaApp appTypes:@[appType] shortAppName:shortAppName];
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appTypes:(NSArray<SDLAppHMIType> *)appTypes shortAppName:(nullable NSString *)shortAppName {
    self = [self initWithAppName:appName appId:appId languageDesired:languageDesired];
    if (!self) {
        return nil;
    }

    self.isMediaApplication = @(isMediaApp);
    self.appHMIType = appTypes;
    self.ngnMediaScreenAppName = shortAppName;

    return self;
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appType:(SDLAppHMIType)appType shortAppName:(nullable NSString *)shortAppName ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired resumeHash:(nullable NSString *)resumeHash {
    return [self initWithAppName:appName appId:appId languageDesired:languageDesired isMediaApp:isMediaApp appTypes:@[appType] shortAppName:shortAppName ttsName:ttsName vrSynonyms:vrSynonyms hmiDisplayLanguageDesired:hmiDisplayLanguageDesired resumeHash:resumeHash];
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appTypes:(NSArray<SDLAppHMIType> *)appTypes shortAppName:(nullable NSString *)shortAppName ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired resumeHash:(nullable NSString *)resumeHash {
    self = [self initWithAppName:appName appId:appId languageDesired:languageDesired isMediaApp:isMediaApp appTypes:appTypes shortAppName:shortAppName];
    if (!self) {
        return nil;
    }

    self.ttsName = [ttsName copy];
    self.vrSynonyms = [vrSynonyms copy];
    self.hmiDisplayLanguageDesired = hmiDisplayLanguageDesired;
    self.hashID = resumeHash;

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

- (void)setTtsName:(nullable NSArray<SDLTTSChunk *> *)ttsName {
    [parameters sdl_setObject:ttsName forName:SDLNameTTSName];
}

- (nullable NSArray<SDLTTSChunk *> *)ttsName {
    return [parameters sdl_objectsForName:SDLNameTTSName ofClass:SDLTTSChunk.class];
}

- (void)setNgnMediaScreenAppName:(nullable NSString *)ngnMediaScreenAppName {
    [parameters sdl_setObject:ngnMediaScreenAppName forName:SDLNameNGNMediaScreenAppName];
}

- (nullable NSString *)ngnMediaScreenAppName {
    return [parameters sdl_objectForName:SDLNameNGNMediaScreenAppName];
}

- (void)setVrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms {
    [parameters sdl_setObject:vrSynonyms forName:SDLNameVRSynonyms];
}

- (nullable NSArray<NSString *> *)vrSynonyms {
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

- (void)setAppHMIType:(nullable NSArray<SDLAppHMIType> *)appHMIType {
    [parameters sdl_setObject:appHMIType forName:SDLNameAppHMIType];
}

- (nullable NSArray<SDLAppHMIType> *)appHMIType {
    return [parameters sdl_objectForName:SDLNameAppHMIType];
}

- (void)setHashID:(nullable NSString *)hashID {
    [parameters sdl_setObject:hashID forName:SDLNameHashId];
}

- (nullable NSString *)hashID {
    return [parameters sdl_objectForName:SDLNameHashId];
}

- (void)setDeviceInfo:(nullable SDLDeviceInfo *)deviceInfo {
    [parameters sdl_setObject:deviceInfo forName:SDLNameDeviceInfo];
}

- (nullable SDLDeviceInfo *)deviceInfo {
    return [parameters sdl_objectForName:SDLNameDeviceInfo ofClass:SDLDeviceInfo.class];
}

- (void)setAppID:(NSString *)appID {
    [parameters sdl_setObject:appID forName:SDLNameAppId];
}

- (NSString *)appID {
    return [parameters sdl_objectForName:SDLNameAppId];
}

- (void)setAppInfo:(nullable SDLAppInfo *)appInfo {
    [parameters sdl_setObject:appInfo forName:SDLNameAppInfo];
}

- (nullable SDLAppInfo *)appInfo {
    return [parameters sdl_objectForName:SDLNameAppInfo ofClass:SDLAppInfo.class];
}

@end

NS_ASSUME_NONNULL_END
