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
    [self setObject:language forName:SDLNameLanguage];
}

- (SDLLanguage)language {
    return [self objectForName:SDLNameLanguage];
}

- (void)setHmiDisplayLanguage:(SDLLanguage )hmiDisplayLanguage {
    [self setObject:hmiDisplayLanguage forName:SDLNameHMIDisplayLanguage];
}

- (SDLLanguage )hmiDisplayLanguage {
    return [self objectForName:SDLNameHMIDisplayLanguage];
}

- (void)setAppName:(NSString *)appName {
    [self setObject:appName forName:SDLNameAppName];
}

- (NSString *)appName {
    return [[self objectForName:SDLNameAppName] copy];
}

- (void)setTtsName:(NSArray<SDLTTSChunk *> *)ttsName {
    [self setObject:ttsName forName:SDLNameTTSName];
}

- (NSArray<SDLTTSChunk *> *)ttsName {
    return [[self objectForName:SDLNameTTSName] copy];
}

- (void)setNgnMediaScreenAppName:(NSString *)ngnMediaScreenAppName {
    [self setObject:ngnMediaScreenAppName forName:SDLNameNGNMediaScreenAppName];
}

- (NSString *)ngnMediaScreenAppName {
    return [[self objectForName:SDLNameNGNMediaScreenAppName] copy];
}

- (void)setVrSynonyms:(NSArray<NSString *> *)vrSynonyms {
    [self setObject:vrSynonyms forName:SDLNameVRSynonyms];
}

- (NSArray<NSString *> *)vrSynonyms {
    return [[self objectForName:SDLNameVRSynonyms] copy];
}

@end
