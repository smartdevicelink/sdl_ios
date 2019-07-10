//  SDLScreenParams.m
//

#import "SDLScreenParams.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImageResolution.h"
#import "SDLRPCParameterNames.h"
#import "SDLTouchEventCapabilities.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLScreenParams

- (void)setResolution:(SDLImageResolution *)resolution {
    [self.store sdl_setObject:resolution forName:SDLRPCParameterNameResolution];
}

- (SDLImageResolution *)resolution {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameResolution ofClass:SDLImageResolution.class error:&error];
}

- (void)setTouchEventAvailable:(nullable SDLTouchEventCapabilities *)touchEventAvailable {
    [self.store sdl_setObject:touchEventAvailable forName:SDLRPCParameterNameTouchEventAvailable];
}

- (nullable SDLTouchEventCapabilities *)touchEventAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameTouchEventAvailable ofClass:SDLTouchEventCapabilities.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
