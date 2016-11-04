//  SDLChangeRegistration.m
//


#import "SDLChangeRegistration.h"

#import "SDLLanguage.h"
#import "SDLNames.h"

@implementation SDLChangeRegistration

- (instancetype)init {
    if (self = [super initWithName:NAMES_ChangeRegistration]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithLanguage:(SDLLanguage *)language hmiDisplayLanguage:(SDLLanguage *)hmiDisplayLanguage {
    self = [self initWithLanguage:language hmiDisplayLanguage:hmiDisplayLanguage appName:nil ttsName:nil ngnMediaScreenAppName:nil vrSynonyms:nil];
    if (!self) {
        return nil;
    }

    return self;
}

- (instancetype)initWithLanguage:(SDLLanguage *)language hmiDisplayLanguage:(SDLLanguage *)hmiDisplayLanguage appName:(NSString *)appName ttsName:(NSArray *)ttsName ngnMediaScreenAppName:(NSString *)ngnMediaScreenAppName vrSynonyms:(NSArray *)vrSynonyms {
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

- (void)setLanguage:(SDLLanguage *)language {
    if (language != nil) {
        [parameters setObject:language forKey:NAMES_language];
    } else {
        [parameters removeObjectForKey:NAMES_language];
    }
}

- (SDLLanguage *)language {
    NSObject *obj = [parameters objectForKey:NAMES_language];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setHmiDisplayLanguage:(SDLLanguage *)hmiDisplayLanguage {
    if (hmiDisplayLanguage != nil) {
        [parameters setObject:hmiDisplayLanguage forKey:NAMES_hmiDisplayLanguage];
    } else {
        [parameters removeObjectForKey:NAMES_hmiDisplayLanguage];
    }
}

- (SDLLanguage *)hmiDisplayLanguage {
    NSObject *obj = [parameters objectForKey:NAMES_hmiDisplayLanguage];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setAppName:(NSString *)appName {
    if (appName != nil) {
        parameters[NAMES_appName] = [appName copy];
    } else {
        [parameters removeObjectForKey:NAMES_appName];
    }
}

- (NSString *)appName {
    return [parameters[NAMES_appName] copy];
}

- (void)setTtsName:(NSArray *)ttsName {
    if (ttsName != nil) {
        [parameters setObject:[ttsName copy] forKey:NAMES_ttsName];
    } else {
        [parameters removeObjectForKey:NAMES_ttsName];
    }
}

- (NSArray *)ttsName {
    return [parameters[NAMES_ttsName] copy];
}

- (void)setNgnMediaScreenAppName:(NSString *)ngnMediaScreenAppName {
    if (ngnMediaScreenAppName != nil) {
        parameters[NAMES_ngnMediaScreenAppName] = [ngnMediaScreenAppName copy];
    } else {
        [parameters removeObjectForKey:NAMES_ngnMediaScreenAppName];
    }
}

- (NSString *)ngnMediaScreenAppName {
    return [parameters[NAMES_ngnMediaScreenAppName] copy];
}

- (void)setVrSynonyms:(NSArray *)vrSynonyms {
    if (vrSynonyms != nil) {
        [parameters setObject:[vrSynonyms copy] forKey:NAMES_vrSynonyms];
    } else {
        [parameters removeObjectForKey:NAMES_vrSynonyms];
    }
}

- (NSArray *)vrSynonyms {
    return [parameters[NAMES_vrSynonyms] copy];
}

@end
