//  SDLTouchEvent.m
//


#import "SDLTouchEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLTouchCoord.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTouchEvent

- (void)setTouchEventId:(NSNumber<SDLInt> *)touchEventId {
    [store sdl_setObject:touchEventId forName:SDLNameId];
}

- (NSNumber<SDLInt> *)touchEventId {
    return [store sdl_objectForName:SDLNameId];
}

- (void)setTimeStamp:(NSArray<NSNumber<SDLInt> *> *)timeStamp {
    [store sdl_setObject:timeStamp forName:SDLNameTimestamp];
}

- (NSArray<NSNumber<SDLInt> *> *)timeStamp {
    return [store sdl_objectForName:SDLNameTimestamp];
}

- (void)setCoord:(NSArray<SDLTouchCoord *> *)coord {
    [store sdl_setObject:coord forName:SDLNameCoordinate];
}

- (NSArray<SDLTouchCoord *> *)coord {
    return [store sdl_objectsForName:SDLNameCoordinate ofClass:SDLTouchCoord.class];
}

@end

NS_ASSUME_NONNULL_END
