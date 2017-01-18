//  SDLScreenParams.m
//

#import "SDLScreenParams.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImageResolution.h"
#import "SDLNames.h"
#import "SDLTouchEventCapabilities.h"

@implementation SDLScreenParams

- (void)setResolution:(SDLImageResolution *)resolution {
    [store sdl_setObject:resolution forName:SDLNameResolution];
}

- (SDLImageResolution *)resolution {
    return [store sdl_objectForName:SDLNameResolution ofClass:SDLImageResolution.class];
}

- (void)setTouchEventAvailable:(SDLTouchEventCapabilities *)touchEventAvailable {
    [store sdl_setObject:touchEventAvailable forName:SDLNameTouchEventAvailable];
}

- (SDLTouchEventCapabilities *)touchEventAvailable {
    return [store sdl_objectForName:SDLNameTouchEventAvailable ofClass:SDLTouchEventCapabilities.class];
}

@end
