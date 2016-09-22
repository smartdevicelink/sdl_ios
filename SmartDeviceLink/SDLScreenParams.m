//  SDLScreenParams.m
//

#import "SDLScreenParams.h"

#import "SDLImageResolution.h"
#import "SDLNames.h"
#import "SDLTouchEventCapabilities.h"


@implementation SDLScreenParams

- (void)setResolution:(SDLImageResolution *)resolution {
    if (resolution != nil) {
        [store setObject:resolution forKey:NAMES_resolution];
    } else {
        [store removeObjectForKey:NAMES_resolution];
    }
}

- (SDLImageResolution *)resolution {
    NSObject *obj = [store objectForKey:NAMES_resolution];
    if (obj == nil || [obj isKindOfClass:SDLImageResolution.class]) {
        return (SDLImageResolution *)obj;
    } else {
        return [[SDLImageResolution alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setTouchEventAvailable:(SDLTouchEventCapabilities *)touchEventAvailable {
    if (touchEventAvailable != nil) {
        [store setObject:touchEventAvailable forKey:NAMES_touchEventAvailable];
    } else {
        [store removeObjectForKey:NAMES_touchEventAvailable];
    }
}

- (SDLTouchEventCapabilities *)touchEventAvailable {
    NSObject *obj = [store objectForKey:NAMES_touchEventAvailable];
    if (obj == nil || [obj isKindOfClass:SDLTouchEventCapabilities.class]) {
        return (SDLTouchEventCapabilities *)obj;
    } else {
        return [[SDLTouchEventCapabilities alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
