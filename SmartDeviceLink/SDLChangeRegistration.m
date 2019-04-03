//  SDLChangeRegistration.m
//


#import "SDLChangeRegistration.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTTSChunk.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLChangeRegistration

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameChangeRegistration]) {
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
    [parameters sdl_setObject:language forName:SDLRPCParameterNameLanguage];
}

- (SDLLanguage)language {
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameLanguage error:&error];
}

- (void)setHmiDisplayLanguage:(SDLLanguage )hmiDisplayLanguage {
    [parameters sdl_setObject:hmiDisplayLanguage forName:SDLRPCParameterNameHMIDisplayLanguage];
}

- (SDLLanguage)hmiDisplayLanguage {
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameHMIDisplayLanguage error:&error];
}

- (void)setAppName:(nullable NSString *)appName {
    [parameters sdl_setObject:appName forName:SDLRPCParameterNameAppName];
}

- (nullable NSString *)appName {
    return [[parameters sdl_objectForName:SDLRPCParameterNameAppName ofClass:NSString.class error:nil] copy];
}

- (void)setTtsName:(nullable NSArray<SDLTTSChunk *> *)ttsName {
    [parameters sdl_setObject:ttsName forName:SDLRPCParameterNameTTSName];
}

- (nullable NSArray<SDLTTSChunk *> *)ttsName {
    return [parameters sdl_objectsForName:SDLRPCParameterNameTTSName ofClass:SDLTTSChunk.class error:nil];
}

- (void)setNgnMediaScreenAppName:(nullable NSString *)ngnMediaScreenAppName {
    [parameters sdl_setObject:ngnMediaScreenAppName forName:SDLRPCParameterNameNGNMediaScreenAppName];
}

- (nullable NSString *)ngnMediaScreenAppName {
    return [parameters sdl_objectForName:SDLRPCParameterNameNGNMediaScreenAppName ofClass:NSString.class error:nil];
}

- (void)setVrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms {
    [parameters sdl_setObject:vrSynonyms forName:SDLRPCParameterNameVRSynonyms];
}

- (nullable NSArray<NSString *> *)vrSynonyms {
    return [parameters sdl_objectsForName:SDLRPCParameterNameVRSynonyms ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
