//  SDLChangeRegistration.m
//


#import "SDLChangeRegistration.h"

#import "NSMutableDictionary+Store.h"
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

- (instancetype)initWithLanguage:(SDLLanguage)language hmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage appName:(NSString *)appName ttsName:(NSArray<SDLTTSChunk *> *)ttsName ngnMediaScreenAppName:(NSString *)ngnMediaScreenAppName vrSynonyms:(NSArray<NSString *> *)vrSynonyms {
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
    [parameters sdl_setObject:language forName:SDLNameLanguage];
}

- (SDLLanguage)language {
    return [parameters sdl_objectForName:SDLNameLanguage];
}

- (void)setHmiDisplayLanguage:(SDLLanguage )hmiDisplayLanguage {
    [parameters sdl_setObject:hmiDisplayLanguage forName:SDLNameHMIDisplayLanguage];
}

- (SDLLanguage )hmiDisplayLanguage {
    return [parameters sdl_objectForName:SDLNameHMIDisplayLanguage];
}

- (void)setAppName:(NSString *)appName {
    [parameters sdl_setObject:appName forName:SDLNameAppName];
}

- (NSString *)appName {
    return [[parameters sdl_objectForName:SDLNameAppName] copy];
}

- (void)setTtsName:(NSArray<SDLTTSChunk *> *)ttsName {
    [parameters sdl_setObject:ttsName forName:SDLNameTTSName];
}

- (NSArray<SDLTTSChunk *> *)ttsName {
    return [[parameters sdl_objectForName:SDLNameTTSName] copy];
}

- (void)setNgnMediaScreenAppName:(NSString *)ngnMediaScreenAppName {
    [parameters sdl_setObject:ngnMediaScreenAppName forName:SDLNameNGNMediaScreenAppName];
}

- (NSString *)ngnMediaScreenAppName {
    return [[parameters sdl_objectForName:SDLNameNGNMediaScreenAppName] copy];
}

- (void)setVrSynonyms:(NSArray<NSString *> *)vrSynonyms {
    [parameters sdl_setObject:vrSynonyms forName:SDLNameVRSynonyms];
}

- (NSArray<NSString *> *)vrSynonyms {
    return [[parameters sdl_objectForName:SDLNameVRSynonyms] copy];
}

@end
