//  SDLScreenParams.m
//

#import "SDLScreenParams.h"

#import "SDLImageResolution.h"
#import "SDLNames.h"
#import "SDLTouchEventCapabilities.h"

@implementation SDLScreenParams

- (void)setResolution:(SDLImageResolution *)resolution {
    [self setObject:resolution forName:SDLNameResolution];
}

- (SDLImageResolution *)resolution {
    NSObject *obj = [store objectForKey:SDLNameResolution];
    if (obj == nil || [obj isKindOfClass:SDLImageResolution.class]) {
        return (SDLImageResolution *)obj;
    } else {
        return [[SDLImageResolution alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setTouchEventAvailable:(SDLTouchEventCapabilities *)touchEventAvailable {
    [self setObject:touchEventAvailable forName:SDLNameTouchEventAvailable];
}

- (SDLTouchEventCapabilities *)touchEventAvailable {
    NSObject *obj = [store objectForKey:SDLNameTouchEventAvailable];
    if (obj == nil || [obj isKindOfClass:SDLTouchEventCapabilities.class]) {
        return (SDLTouchEventCapabilities *)obj;
    } else {
        return [[SDLTouchEventCapabilities alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
