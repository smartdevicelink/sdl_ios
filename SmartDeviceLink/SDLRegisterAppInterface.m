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
#import "SDLTemplateColorScheme.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

static NSUInteger const AppIdCharacterCount = 10;

@implementation SDLRegisterAppInterface

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super initWithName:SDLNameRegisterAppInterface]) {
    }
    return self;
}

- (instancetype)initWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    NSArray<SDLAppHMIType> *allHMITypes = lifecycleConfiguration.additionalAppTypes ? [lifecycleConfiguration.additionalAppTypes arrayByAddingObject:lifecycleConfiguration.appType] : @[lifecycleConfiguration.appType];

    return [self initWithAppName:lifecycleConfiguration.appName
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

- (instancetype)initWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppId languageDesired:(SDLLanguage)languageDesired {
    self = [self initWithAppName:appName languageDesired:languageDesired];
    if (!self) {
        return nil;
    }

    self.fullAppID = fullAppId;
    self.appID = [self.class sdlex_shortAppIdFromFullAppId:fullAppId];

    return self;
}

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired {
    self = [self initWithAppName:appName languageDesired:languageDesired];
    if (!self) {
        return nil;
    }

    self.fullAppID = @"";
    self.appID = appId;

    return self;
}

- (instancetype)initWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appTypes:(NSArray<SDLAppHMIType> *)appTypes shortAppName:(nullable NSString *)shortAppName {
    self = [self initWithAppName:appName fullAppId:fullAppId languageDesired:languageDesired];
    if (!self) {
        return nil;
    }

    self.isMediaApplication = @(isMediaApp);
    self.appHMIType = appTypes;
    self.ngnMediaScreenAppName = shortAppName;

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

- (instancetype)initWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppID languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appTypes:(NSArray<SDLAppHMIType> *)appTypes shortAppName:(nullable NSString *)shortAppName ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired resumeHash:(nullable NSString *)resumeHash dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    self = [self initWithAppName:appName fullAppId:fullAppID languageDesired:languageDesired isMediaApp:isMediaApp appTypes:appTypes shortAppName:shortAppName];
    if (!self) { return nil; }

    self.ttsName = [ttsName copy];
    self.vrSynonyms = [vrSynonyms copy];
    self.hmiDisplayLanguageDesired = hmiDisplayLanguageDesired;
    self.hashID = resumeHash;
    self.dayColorScheme = dayColorScheme;
    self.nightColorScheme = nightColorScheme;

    return self;
}

#pragma mark Initializer Helpers

- (instancetype)initWithAppName:(NSString *)appName languageDesired:(SDLLanguage)languageDesired {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.appName = appName;
    self.languageDesired = languageDesired;
    self.hmiDisplayLanguageDesired = languageDesired;

    self.syncMsgVersion = [[SDLSyncMsgVersion alloc] initWithMajorVersion:5 minorVersion:0 patchVersion:0];
    self.appInfo = [SDLAppInfo currentAppInfo];
    self.deviceInfo = [SDLDeviceInfo currentDevice];
    self.correlationID = @1;
    self.isMediaApplication = @NO;

    return self;
}

#pragma mark - Getters and Setters

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

- (void)setFullAppID:(NSString *)fullAppID {
    [parameters sdl_setObject:fullAppID forName:SDLNameFullAppID];
}

- (NSString *)fullAppID {
    return [parameters sdl_objectForName:SDLNameFullAppID];
}

- (void)setAppInfo:(nullable SDLAppInfo *)appInfo {
    [parameters sdl_setObject:appInfo forName:SDLNameAppInfo];
}

- (nullable SDLAppInfo *)appInfo {
    return [parameters sdl_objectForName:SDLNameAppInfo ofClass:SDLAppInfo.class];
}

- (void)setDayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme {
    [parameters sdl_setObject:dayColorScheme forName:SDLNameDayColorScheme];
}

- (nullable SDLTemplateColorScheme *)dayColorScheme {
    return [parameters sdl_objectForName:SDLNameDayColorScheme ofClass:[SDLTemplateColorScheme class]];
}

- (void)setNightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    [parameters sdl_setObject:nightColorScheme forName:SDLNameNightColorScheme];
}

- (nullable SDLTemplateColorScheme *)nightColorScheme {
    return [parameters sdl_objectForName:SDLNameNightColorScheme ofClass:[SDLTemplateColorScheme class]];
}

#pragma mark - Helpers

/**
 *  Generates the `appId` from the `fullAppId`
 *
 *  @discussion When an app is registered with an OEM, it is assigned an `appID` and a `fullAppID`. The `fullAppID` is the full UUID appID. The `appID` is the first 10 non-dash (i.e. "-") characters of the  `fullAppID`.
 *
 *  @param fullAppId   A `fullAppId`
 *  @return            An `appID` made of the first 10 non-dash characters of the "fullAppID"
 */
+ (nullable NSString *)sdlex_shortAppIdFromFullAppId:(nullable NSString *)fullAppId {
    if (fullAppId.length <= AppIdCharacterCount) { return fullAppId; }

    NSString *filteredString = [self sdlex_filterDashesFromText:fullAppId];
    NSString *truncatedString = [self sdlex_truncateText:filteredString length:AppIdCharacterCount];

    return truncatedString;
}

/**
 *  Filters the dash characters from a string
 *
 *  @param text    The string
 *  @return        The string with all dash characters removed
 */
+ (NSString *)sdlex_filterDashesFromText:(NSString *)text {
    if (text.length == 0) { return text; }
    NSCharacterSet *supportedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    return [[text componentsSeparatedByCharactersInSet:supportedCharacters] componentsJoinedByString:@""];
}

/**
 *  Truncates a string to the specified length
 *
 *  @param text    The string to truncate
 *  @param length  The length to truncate the string
 *  @return        A truncated string
 */
+ (NSString *)sdlex_truncateText:(NSString *)text length:(UInt8)length {
    if (length >= text.length) { return text; }
    return [text substringToIndex:MIN(length, text.length)];
}

@end

NS_ASSUME_NONNULL_END
