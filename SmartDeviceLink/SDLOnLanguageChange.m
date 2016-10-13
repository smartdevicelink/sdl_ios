//  SDLOnLanguageChange.m
//

#import "SDLOnLanguageChange.h"

#import "SDLLanguage.h"
#import "SDLNames.h"

@implementation SDLOnLanguageChange

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnLanguageChange]) {
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
    return (SDLLanguage)obj;
}

- (void)setHmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage {
    if (hmiDisplayLanguage != nil) {
        [parameters setObject:hmiDisplayLanguage forKey:SDLNameHMIDisplayLanguage];
    } else {
        [parameters removeObjectForKey:SDLNameHMIDisplayLanguage];
    }
}

- (SDLLanguage)hmiDisplayLanguage {
    NSObject *obj = [parameters objectForKey:SDLNameHMIDisplayLanguage];
    return (SDLLanguage)obj;
}


@end
