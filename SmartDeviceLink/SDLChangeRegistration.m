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

- (void)setAppName:(NSString *)appName {
    if (appName != nil) {
        parameters[SDLNameAppName] = [appName copy];
    } else {
        [parameters removeObjectForKey:SDLNameAppName];
    }
}

- (NSString *)appName {
    return [parameters[SDLNameAppName] copy];
}

- (void)setTtsName:(NSArray<SDLTTSChunk *> *)ttsName {
    if (ttsName != nil) {
        [parameters setObject:[ttsName copy] forKey:SDLNameTTSName];
    } else {
        [parameters removeObjectForKey:SDLNameTTSName];
    }
}

- (NSArray<SDLTTSChunk *> *)ttsName {
    return [parameters[SDLNameTTSName] copy];
}

- (void)setNgnMediaScreenAppName:(NSString *)ngnMediaScreenAppName {
    if (ngnMediaScreenAppName != nil) {
        parameters[SDLNameNGNMediaScreenAppName] = [ngnMediaScreenAppName copy];
    } else {
        [parameters removeObjectForKey:SDLNameNGNMediaScreenAppName];
    }
}

- (NSString *)ngnMediaScreenAppName {
    return [parameters[SDLNameNGNMediaScreenAppName] copy];
}

- (void)setVrSynonyms:(NSArray<NSString *> *)vrSynonyms {
    if (vrSynonyms != nil) {
        [parameters setObject:[vrSynonyms copy] forKey:SDLNameVRSynonyms];
    } else {
        [parameters removeObjectForKey:SDLNameVRSynonyms];
    }
}

- (NSArray<NSString *> *)vrSynonyms {
    return [parameters[SDLNameVRSynonyms] copy];
}

@end
