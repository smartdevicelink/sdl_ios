//  SDLScreenParams.m
//

#import "SDLScreenParams.h"

#import "SDLImageResolution.h"
#import "SDLNames.h"
#import "SDLTouchEventCapabilities.h"

@implementation SDLScreenParams

- (void)setResolution:(SDLImageResolution *)resolution {
    if (resolution != nil) {
        [store setObject:resolution forKey:SDLNameResolution];
    } else {
        [store removeObjectForKey:SDLNameResolution];
    }
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
    if (touchEventAvailable != nil) {
        [store setObject:touchEventAvailable forKey:SDLNameTouchEventAvailable];
    } else {
        [store removeObjectForKey:SDLNameTouchEventAvailable];
    }
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
