//  SDLChangeRegistration.m
//


#import "SDLChangeRegistration.h"

#import "SDLLanguage.h"


@implementation SDLChangeRegistration

- (instancetype)init {
    if (self = [super initWithName:SDLNameChangeRegistration]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setLanguage:(SDLLanguage *)language {
    if (language != nil) {
        [parameters setObject:language forKey:SDLNameLanguage];
    } else {
        [parameters removeObjectForKey:SDLNameLanguage];
    }
}

- (SDLLanguage *)language {
    NSObject *obj = [parameters objectForKey:SDLNameLanguage];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
}

- (void)setHmiDisplayLanguage:(SDLLanguage *)hmiDisplayLanguage {
    if (hmiDisplayLanguage != nil) {
        [parameters setObject:hmiDisplayLanguage forKey:SDLNameHmiDisplayLanguage];
    } else {
        [parameters removeObjectForKey:SDLNameHmiDisplayLanguage];
    }
}

- (SDLLanguage *)hmiDisplayLanguage {
    NSObject *obj = [parameters objectForKey:SDLNameHmiDisplayLanguage];
    if (obj == nil || [obj isKindOfClass:SDLLanguage.class]) {
        return (SDLLanguage *)obj;
    } else {
        return [SDLLanguage valueOf:(NSString *)obj];
    }
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

- (void)setTtsName:(NSArray *)ttsName {
    if (ttsName != nil) {
        [parameters setObject:[ttsName copy] forKey:SDLNameTtsName];
    } else {
        [parameters removeObjectForKey:SDLNameTtsName];
    }
}

- (NSArray *)ttsName {
    return [parameters[SDLNameTtsName] copy];
}

- (void)setNgnMediaScreenAppName:(NSString *)ngnMediaScreenAppName {
    if (ngnMediaScreenAppName != nil) {
        parameters[SDLNameNgnMediaScreenAppName] = [ngnMediaScreenAppName copy];
    } else {
        [parameters removeObjectForKey:SDLNameNgnMediaScreenAppName];
    }
}

- (NSString *)ngnMediaScreenAppName {
    return [parameters[SDLNameNgnMediaScreenAppName] copy];
}

- (void)setVrSynonyms:(NSArray *)vrSynonyms {
    if (vrSynonyms != nil) {
        [parameters setObject:[vrSynonyms copy] forKey:SDLNameVrSynonyms];
    } else {
        [parameters removeObjectForKey:SDLNameVrSynonyms];
    }
}

- (NSArray *)vrSynonyms {
    return [parameters[SDLNameVrSynonyms] copy];
}

@end
