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
#import "SDLMsgVersion.h"
#import "SDLTemplateColorScheme.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRegisterAppInterface

#pragma mark - Lifecycle

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameRegisterAppInterface]) {
    }
    return self;
}
#pragma clang diagnostic pop

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

    self.sdlMsgVersion = [SDLMsgVersion versionWithString:SDLMaxProxyRPCVersion];
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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)setSyncMsgVersion:(SDLSyncMsgVersion *)syncMsgVersion {
    SDLMsgVersion * sdlMsgVersion = [[SDLMsgVersion alloc] initWithMajorVersion:(uint8_t)syncMsgVersion.majorVersion.unsignedIntValue minorVersion:(uint8_t)syncMsgVersion.minorVersion.unsignedIntValue patchVersion:(uint8_t)syncMsgVersion.patchVersion.unsignedIntValue];
    [self.parameters sdl_setObject:sdlMsgVersion forName:SDLRPCParameterNameSyncMessageVersion];
}

- (SDLSyncMsgVersion *)syncMsgVersion {
    SDLMsgVersion * sdlMsgVersion = [self.parameters sdl_objectForName:SDLRPCParameterNameSyncMessageVersion ofClass:SDLMsgVersion.class error:nil];
    return [[SDLSyncMsgVersion alloc] initWithMajorVersion:(uint8_t)sdlMsgVersion.majorVersion.unsignedIntValue minorVersion:(uint8_t)sdlMsgVersion.minorVersion.unsignedIntValue patchVersion:(uint8_t)sdlMsgVersion.patchVersion.unsignedIntValue];
}
#pragma clang diagnostic pop

- (void)setSdlMsgVersion:(SDLMsgVersion *)sdlMsgVersion {
    [self.parameters sdl_setObject:sdlMsgVersion forName:SDLRPCParameterNameSyncMessageVersion];
}

- (SDLMsgVersion *)sdlMsgVersion {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSyncMessageVersion ofClass:SDLMsgVersion.class error:nil];
}

- (void)setAppName:(NSString *)appName {
    [self.parameters sdl_setObject:appName forName:SDLRPCParameterNameAppName];
}

- (NSString *)appName {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAppName ofClass:NSString.class error:&error];
}

- (void)setTtsName:(nullable NSArray<SDLTTSChunk *> *)ttsName {
    [self.parameters sdl_setObject:ttsName forName:SDLRPCParameterNameTTSName];
}

- (nullable NSArray<SDLTTSChunk *> *)ttsName {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameTTSName ofClass:SDLTTSChunk.class error:nil];
}

- (void)setNgnMediaScreenAppName:(nullable NSString *)ngnMediaScreenAppName {
    [self.parameters sdl_setObject:ngnMediaScreenAppName forName:SDLRPCParameterNameNGNMediaScreenAppName];
}

- (nullable NSString *)ngnMediaScreenAppName {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameNGNMediaScreenAppName ofClass:NSString.class error:nil];
}

- (void)setVrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms {
    [self.parameters sdl_setObject:vrSynonyms forName:SDLRPCParameterNameVRSynonyms];
}

- (nullable NSArray<NSString *> *)vrSynonyms {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameVRSynonyms ofClass:NSString.class error:nil];
}

- (void)setIsMediaApplication:(NSNumber<SDLBool> *)isMediaApplication {
    [self.parameters sdl_setObject:isMediaApplication forName:SDLRPCParameterNameIsMediaApplication];
}

- (NSNumber<SDLBool> *)isMediaApplication {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameIsMediaApplication ofClass:NSNumber.class error:&error];
}

- (void)setLanguageDesired:(SDLLanguage)languageDesired {
    [self.parameters sdl_setObject:languageDesired forName:SDLRPCParameterNameLanguageDesired];
}

- (SDLLanguage)languageDesired {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameLanguageDesired error:&error];
}

- (void)setHmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired {
    [self.parameters sdl_setObject:hmiDisplayLanguageDesired forName:SDLRPCParameterNameHMIDisplayLanguageDesired];
}

- (SDLLanguage)hmiDisplayLanguageDesired {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameHMIDisplayLanguageDesired error:&error];
}

- (void)setAppHMIType:(nullable NSArray<SDLAppHMIType> *)appHMIType {
    [self.parameters sdl_setObject:appHMIType forName:SDLRPCParameterNameAppHMIType];
}

- (nullable NSArray<SDLAppHMIType> *)appHMIType {
    return [self.parameters sdl_enumsForName:SDLRPCParameterNameAppHMIType error:nil];
}

- (void)setHashID:(nullable NSString *)hashID {
    [self.parameters sdl_setObject:hashID forName:SDLRPCParameterNameHashId];
}

- (nullable NSString *)hashID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameHashId ofClass:NSString.class error:nil];
}

- (void)setDeviceInfo:(nullable SDLDeviceInfo *)deviceInfo {
    [self.parameters sdl_setObject:deviceInfo forName:SDLRPCParameterNameDeviceInfo];
}

- (nullable SDLDeviceInfo *)deviceInfo {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDeviceInfo ofClass:SDLDeviceInfo.class error:nil];
}

- (void)setAppID:(NSString *)appID {
    [self.parameters sdl_setObject:appID forName:SDLRPCParameterNameAppId];
}

- (NSString *)appID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAppId ofClass:NSString.class error:&error];
}

- (void)setFullAppID:(nullable NSString *)fullAppID {
    [self.parameters sdl_setObject:fullAppID forName:SDLRPCParameterNameFullAppID];
}

- (nullable NSString *)fullAppID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameFullAppID ofClass:NSString.class error:nil];
}

- (void)setAppInfo:(nullable SDLAppInfo *)appInfo {
    [self.parameters sdl_setObject:appInfo forName:SDLRPCParameterNameAppInfo];
}

- (nullable SDLAppInfo *)appInfo {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAppInfo ofClass:SDLAppInfo.class error:nil];
}

- (void)setDayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme {
    [self.parameters sdl_setObject:dayColorScheme forName:SDLRPCParameterNameDayColorScheme];
}

- (nullable SDLTemplateColorScheme *)dayColorScheme {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameDayColorScheme ofClass:SDLTemplateColorScheme.class error:nil];
}

- (void)setNightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    [self.parameters sdl_setObject:nightColorScheme forName:SDLRPCParameterNameNightColorScheme];
}

- (nullable SDLTemplateColorScheme *)nightColorScheme {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameNightColorScheme ofClass:SDLTemplateColorScheme.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
