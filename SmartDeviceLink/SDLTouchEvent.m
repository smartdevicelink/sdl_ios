//  SDLTouchEvent.m
//


#import "SDLTouchEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLTouchCoord.h"

@implementation SDLTouchEvent

- (void)setTouchEventId:(NSNumber<SDLInt> *)touchEventId {
    [store sdl_setObject:touchEventId forName:SDLNameId];
}

- (NSNumber<SDLInt> *)touchEventId {
    return [store sdl_objectForName:SDLNameId];
}

- (void)setTimeStamp:(NSMutableArray<NSNumber<SDLInt> *> *)timeStamp {
    [store sdl_setObject:timeStamp forName:SDLNameTimestamp];
}

- (NSMutableArray<NSNumber<SDLInt> *> *)timeStamp {
    return [store sdl_objectForName:SDLNameTimestamp];
}

- (void)setCoord:(NSMutableArray<SDLTouchCoord *> *)coord {
    [store sdl_setObject:coord forName:SDLNameCoordinate];
}

- (NSMutableArray<SDLTouchCoord *> *)coord {
    return [store sdl_objectsForName:SDLNameCoordinate ofClass:SDLTouchCoord.class];
}

@end
