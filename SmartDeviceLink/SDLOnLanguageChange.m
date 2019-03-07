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
    NSError *error;
    return [parameters sdl_enumForName:SDLNameLanguage error:&error];
}

- (void)setHmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage {
    [parameters sdl_setObject:hmiDisplayLanguage forName:SDLNameHMIDisplayLanguage];
}

- (SDLLanguage)hmiDisplayLanguage {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameHMIDisplayLanguage error:&error];
}


@end

NS_ASSUME_NONNULL_END
