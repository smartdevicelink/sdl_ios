//  SDLChangeRegistration.m
//


#import "SDLChangeRegistration.h"

#import "SDLNames.h"

@implementation SDLChangeRegistration

- (instancetype)init {
    if (self = [super initWithName:SDLNameChangeRegistration]) {
    }
    return self;
}

- (instancetype)initWithLanguage:(SDLLanguage)language hmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage {
    self = [self initWithLanguage:language hmiDisplayLanguage:hmiDisplayLanguage appName:nil ttsName:nil ngnMediaScreenAppName:nil vrSynonyms:nil];
    if (!self) {
        return nil;
    }

    return self;
}

- (instancetype)initWithLanguage:(SDLLanguage)language hmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage appName:(nullable NSString *)appName ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName ngnMediaScreenAppName:(nullable NSString *)ngnMediaScreenAppName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.language = language;
    self.hmiDisplayLanguage = hmiDisplayLanguage;
    self.appName = appName;
    self.ttsName = ttsName;
    self.ngnMediaScreenAppName = ngnMediaScreenAppName;
    self.vrSynonyms = vrSynonyms;

    return self;
}

- (void)setLanguage:(SDLLanguage)language {
    if (language != nil) {
        [parameters setObject:language forKey:SDLNameLanguage];
    } else {
        [parameters removeObjectForKey:SDLNameLanguage];
    }
}

- (SDLLanguage)language {
    NSObject *obj = [parameters objectForKey:SDLNameLanguage];
    return (SDLLanguage )obj;
}

- (void)setHmiDisplayLanguage:(SDLLanguage )hmiDisplayLanguage {
    if (hmiDisplayLanguage != nil) {
        [parameters setObject:hmiDisplayLanguage forKey:SDLNameHMIDisplayLanguage];
    } else {
        [parameters removeObjectForKey:SDLNameHMIDisplayLanguage];
    }
}

- (SDLLanguage )hmiDisplayLanguage {
    NSObject *obj = [parameters objectForKey:SDLNameHMIDisplayLanguage];
    return (SDLLanguage )obj;
}

- (void)setAppName:(nullable NSString *)appName {
    if (appName != nil) {
        parameters[SDLNameAppName] = [appName copy];
    } else {
        [parameters removeObjectForKey:SDLNameAppName];
    }
}

- (nullable NSString *)appName {
    return [parameters[SDLNameAppName] copy];
}

- (void)setTtsName:(nullable NSArray<SDLTTSChunk *> *)ttsName {
    if (ttsName != nil) {
        [parameters setObject:[ttsName copy] forKey:SDLNameTTSName];
    } else {
        [parameters removeObjectForKey:SDLNameTTSName];
    }
}

- (nullable NSArray<SDLTTSChunk *> *)ttsName {
    return [parameters[SDLNameTTSName] copy];
}

- (void)setNgnMediaScreenAppName:(nullable NSString *)ngnMediaScreenAppName {
    if (ngnMediaScreenAppName != nil) {
        parameters[SDLNameNGNMediaScreenAppName] = [ngnMediaScreenAppName copy];
    } else {
        [parameters removeObjectForKey:SDLNameNGNMediaScreenAppName];
    }
}

- (nullable NSString *)ngnMediaScreenAppName {
    return [parameters[SDLNameNGNMediaScreenAppName] copy];
}

- (void)setVrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms {
    if (vrSynonyms != nil) {
        [parameters setObject:[vrSynonyms copy] forKey:SDLNameVRSynonyms];
    } else {
        [parameters removeObjectForKey:SDLNameVRSynonyms];
    }
}

- (nullable NSArray<NSString *> *)vrSynonyms {
    return [parameters[SDLNameVRSynonyms] copy];
}

@end
