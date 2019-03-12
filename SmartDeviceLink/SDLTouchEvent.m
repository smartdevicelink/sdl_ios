//  SDLTouchEvent.m
//


#import "SDLTouchEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLTouchCoord.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTouchEvent

- (void)setTouchEventId:(NSNumber<SDLInt> *)touchEventId {
    [store sdl_setObject:touchEventId forName:SDLRPCParameterNameId];
}

- (NSNumber<SDLInt> *)touchEventId {
    return [store sdl_objectForName:SDLRPCParameterNameId];
}

- (void)setTimeStamp:(NSArray<NSNumber<SDLInt> *> *)timeStamp {
    [store sdl_setObject:timeStamp forName:SDLRPCParameterNameTS];
}

- (NSArray<NSNumber<SDLInt> *> *)timeStamp {
    return [store sdl_objectForName:SDLRPCParameterNameTS];
}

- (void)setCoord:(NSArray<SDLTouchCoord *> *)coord {
    [store sdl_setObject:coord forName:SDLRPCParameterNameCoordinate];
}

- (NSArray<SDLTouchCoord *> *)coord {
    return [store sdl_objectsForName:SDLRPCParameterNameCoordinate ofClass:SDLTouchCoord.class];
}

@end

NS_ASSUME_NONNULL_END
