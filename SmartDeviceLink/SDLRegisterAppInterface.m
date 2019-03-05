//  SDLRegisterAppInterface.m
//


#import "SDLRegisterAppInterface.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAppHMIType.h"
#import "SDLAppInfo.h"
#import "SDLDeviceInfo.h"
#import "SDLGlobals.h"
#import "SDLLanguage.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSyncMsgVersion.h"
#import "SDLTemplateColorScheme.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRegisterAppInterface

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameRegisterAppInterface]) {
    }
    return self;
}

- (instancetype)initWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    NSArray<SDLAppHMIType> *allHMITypes = lifecycleConfiguration.additionalAppTypes ? [lifecycleConfiguration.additionalAppTypes arrayByAddingObject:lifecycleConfiguration.appType] : @[lifecycleConfiguration.appType];

    return [self initWithAppName:lifecycleConfiguration.appName
                           appId:lifecycleConfiguration.appId
                       fullAppId:lifecycleConfiguration.fullAppId
                 languageDesired:lifecycleConfiguration.language
                      isMediaApp:lifecycleConfiguration.isMedia
                        appTypes:allHMITypes
                    shortAppName:lifecycleConfiguration.shortAppName
                         ttsName:lifecycleConfiguration.ttsName
                      vrSynonyms:lifecycleConfiguration.voiceRecognitionCommandNames
       hmiDisplayLanguageDesired:lifecycleConfiguration.language
                      resumeHash:lifecycleConfiguration.resumeHash
                  dayColorScheme:lifecycleConfiguration.dayColorScheme
                nightColorScheme:lifecycleConfiguration.nightColorScheme];
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.appName = appName;
    self.appID = appId;
    self.fullAppID = nil;
    self.languageDesired = languageDesired;

    self.hmiDisplayLanguageDesired = languageDesired;

    UInt8 majorVersion = (UInt8)[SDLMaxProxyRPCVersion substringWithRange:NSMakeRange(0, 1)].intValue;
    UInt8 minorVersion = (UInt8)[SDLMaxProxyRPCVersion substringWithRange:NSMakeRange(2, 1)].intValue;
    UInt8 patchVersion = (UInt8)[SDLMaxProxyRPCVersion substringWithRange:NSMakeRange(4, 1)].intValue;
    self.syncMsgVersion = [[SDLSyncMsgVersion alloc] initWithMajorVersion:majorVersion minorVersion:minorVersion patchVersion:patchVersion];
    self.appInfo = [SDLAppInfo currentAppInfo];
    self.deviceInfo = [SDLDeviceInfo currentDevice];
    self.correlationID = @1;
    self.isMediaApplication = @NO;

    return self;
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

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId fullAppId:(nullable NSString *)fullAppId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appTypes:(NSArray<SDLAppHMIType> *)appTypes shortAppName:(nullable NSString *)shortAppName ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired resumeHash:(nullable NSString *)resumeHash dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self = [self initWithAppName:appName appId:appId languageDesired:languageDesired isMediaApp:isMediaApp appTypes:appTypes shortAppName:shortAppName ttsName:ttsName vrSynonyms:vrSynonyms hmiDisplayLanguageDesired:hmiDisplayLanguageDesired resumeHash:resumeHash];
#pragma clang diagnostic pop

    if (!self) { return nil; }

    self.fullAppID = fullAppId;
    self.dayColorScheme = dayColorScheme;
    self.nightColorScheme = nightColorScheme;

    return self;
}

#pragma mark - Getters and Setters

- (void)setSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion {
    [parameters sdl_setObject:syncMsgVersion forName:SDLRPCParameterNameSyncMessageVersion];
}

- (SDLSyncMsgVersion *)syncMsgVersion {
    return [parameters sdl_objectForName:SDLRPCParameterNameSyncMessageVersion ofClass:SDLSyncMsgVersion.class];
}

- (void)setAppName:(NSString *)appName {
    [parameters sdl_setObject:appName forName:SDLRPCParameterNameAppName];
}

- (NSString *)appName {
    return [parameters sdl_objectForName:SDLRPCParameterNameAppName];
}

- (void)setTtsName:(nullable NSArray<SDLTTSChunk *> *)ttsName {
    [parameters sdl_setObject:ttsName forName:SDLRPCParameterNameTTSName];
}

- (nullable NSArray<SDLTTSChunk *> *)ttsName {
    return [parameters sdl_objectsForName:SDLRPCParameterNameTTSName ofClass:SDLTTSChunk.class];
}

- (void)setNgnMediaScreenAppName:(nullable NSString *)ngnMediaScreenAppName {
    [parameters sdl_setObject:ngnMediaScreenAppName forName:SDLRPCParameterNameNGNMediaScreenAppName];
}

- (nullable NSString *)ngnMediaScreenAppName {
    return [parameters sdl_objectForName:SDLRPCParameterNameNGNMediaScreenAppName];
}

- (void)setVrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms {
    [parameters sdl_setObject:vrSynonyms forName:SDLRPCParameterNameVRSynonyms];
}

- (nullable NSArray<NSString *> *)vrSynonyms {
    return [parameters sdl_objectForName:SDLRPCParameterNameVRSynonyms];
}

- (void)setIsMediaApplication:(NSNumber<SDLBool> *)isMediaApplication {
    [parameters sdl_setObject:isMediaApplication forName:SDLRPCParameterNameIsMediaApplication];
}

- (NSNumber<SDLBool> *)isMediaApplication {
    return [parameters sdl_objectForName:SDLRPCParameterNameIsMediaApplication];
}

- (void)setLanguageDesired:(SDLLanguage)languageDesired {
    [parameters sdl_setObject:languageDesired forName:SDLRPCParameterNameLanguageDesired];
}

- (SDLLanguage)languageDesired {
    return [parameters sdl_objectForName:SDLRPCParameterNameLanguageDesired];
}

- (void)setHmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired {
    [parameters sdl_setObject:hmiDisplayLanguageDesired forName:SDLRPCParameterNameHMIDisplayLanguageDesired];
}

- (SDLLanguage)hmiDisplayLanguageDesired {
    return [parameters sdl_objectForName:SDLRPCParameterNameHMIDisplayLanguageDesired];
}

- (void)setAppHMIType:(nullable NSArray<SDLAppHMIType> *)appHMIType {
    [parameters sdl_setObject:appHMIType forName:SDLRPCParameterNameAppHMIType];
}

- (nullable NSArray<SDLAppHMIType> *)appHMIType {
    return [parameters sdl_objectForName:SDLRPCParameterNameAppHMIType];
}

- (void)setHashID:(nullable NSString *)hashID {
    [parameters sdl_setObject:hashID forName:SDLRPCParameterNameHashId];
}

- (nullable NSString *)hashID {
    return [parameters sdl_objectForName:SDLRPCParameterNameHashId];
}

- (void)setDeviceInfo:(nullable SDLDeviceInfo *)deviceInfo {
    [parameters sdl_setObject:deviceInfo forName:SDLRPCParameterNameDeviceInfo];
}

- (nullable SDLDeviceInfo *)deviceInfo {
    return [parameters sdl_objectForName:SDLRPCParameterNameDeviceInfo ofClass:SDLDeviceInfo.class];
}

- (void)setAppID:(NSString *)appID {
    [parameters sdl_setObject:appID forName:SDLRPCParameterNameAppId];
}

- (NSString *)appID {
    return [parameters sdl_objectForName:SDLRPCParameterNameAppId];
}

- (void)setFullAppID:(nullable NSString *)fullAppID {
    [parameters sdl_setObject:fullAppID forName:SDLRPCParameterNameFullAppID];
}

- (nullable NSString *)fullAppID {
    return [parameters sdl_objectForName:SDLRPCParameterNameFullAppID];
}

- (void)setAppInfo:(nullable SDLAppInfo *)appInfo {
    [parameters sdl_setObject:appInfo forName:SDLRPCParameterNameAppInfo];
}

- (nullable SDLAppInfo *)appInfo {
    return [parameters sdl_objectForName:SDLRPCParameterNameAppInfo ofClass:SDLAppInfo.class];
}

- (void)setDayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme {
    [parameters sdl_setObject:dayColorScheme forName:SDLRPCParameterNameDayColorScheme];
}

- (nullable SDLTemplateColorScheme *)dayColorScheme {
    return [parameters sdl_objectForName:SDLRPCParameterNameDayColorScheme ofClass:[SDLTemplateColorScheme class]];
}

- (void)setNightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    [parameters sdl_setObject:nightColorScheme forName:SDLRPCParameterNameNightColorScheme];
}

- (nullable SDLTemplateColorScheme *)nightColorScheme {
    return [parameters sdl_objectForName:SDLRPCParameterNameNightColorScheme ofClass:[SDLTemplateColorScheme class]];
}

@end

NS_ASSUME_NONNULL_END
