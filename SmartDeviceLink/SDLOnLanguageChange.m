//  SDLOnLanguageChange.m
//

#import "SDLOnLanguageChange.h"

#import "SDLLanguage.h"
#import "SDLNames.h"


@implementation SDLOnLanguageChange

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnLanguageChange]) {
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

@end
