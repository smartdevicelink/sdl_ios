//  SDLScreenParams.m
//

#import "SDLScreenParams.h"

#import "SDLImageResolution.h"
#import "SDLNames.h"
#import "SDLTouchEventCapabilities.h"

NS_ASSUME_NONNULL_BEGIN

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
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLImageResolution alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLImageResolution*)obj;
}

- (void)setTouchEventAvailable:(nullable SDLTouchEventCapabilities *)touchEventAvailable {
    if (touchEventAvailable != nil) {
        [store setObject:touchEventAvailable forKey:SDLNameTouchEventAvailable];
    } else {
        [store removeObjectForKey:SDLNameTouchEventAvailable];
    }
}

- (nullable SDLTouchEventCapabilities *)touchEventAvailable {
    NSObject *obj = [store objectForKey:SDLNameTouchEventAvailable];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLTouchEventCapabilities alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLTouchEventCapabilities*)obj;
}

@end

NS_ASSUME_NONNULL_END
