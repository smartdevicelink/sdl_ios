//  SDLOnLanguageChange.m
//

#import "SDLOnLanguageChange.h"

#import "NSMutableDictionary+Store.h"
#import "SDLLanguage.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnLanguageChange

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnLanguageChange]) {
    }
    return self;
}

- (void)setLanguage:(SDLLanguage)language {
    [parameters sdl_setObject:language forName:SDLNameLanguage];
}

- (SDLLanguage)language {
    NSObject *obj = [parameters sdl_objectForName:SDLNameLanguage];
    return (SDLLanguage)obj;
}

- (void)setHmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage {
    [parameters sdl_setObject:hmiDisplayLanguage forName:SDLNameHMIDisplayLanguage];
}

- (SDLLanguage)hmiDisplayLanguage {
    NSObject *obj = [parameters sdl_objectForName:SDLNameHMIDisplayLanguage];
    return (SDLLanguage)obj;
}


@end

NS_ASSUME_NONNULL_END
