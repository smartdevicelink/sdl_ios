//  SDLOnLanguageChange.m
//

#import "SDLOnLanguageChange.h"

#import "NSMutableDictionary+Store.h"
#import "SDLLanguage.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnLanguageChange

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnLanguageChange]) {
    }
    return self;
}

- (void)setLanguage:(SDLLanguage)language {
    [parameters sdl_setObject:language forName:SDLRPCParameterNameLanguage];
}

- (SDLLanguage)language {
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameLanguage];
    return (SDLLanguage)obj;
}

- (void)setHmiDisplayLanguage:(SDLLanguage)hmiDisplayLanguage {
    [parameters sdl_setObject:hmiDisplayLanguage forName:SDLRPCParameterNameHMIDisplayLanguage];
}

- (SDLLanguage)hmiDisplayLanguage {
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameHMIDisplayLanguage];
    return (SDLLanguage)obj;
}


@end

NS_ASSUME_NONNULL_END
