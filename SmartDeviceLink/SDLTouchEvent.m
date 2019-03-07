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
    NSError *error;
    return [store sdl_objectForName:SDLNameId ofClass:NSNumber.class error:&error];
}

- (void)setTimeStamp:(NSArray<NSNumber<SDLInt> *> *)timeStamp {
    [store sdl_setObject:timeStamp forName:SDLNameTimestamp];
}

- (NSArray<NSNumber<SDLInt> *> *)timeStamp {
    NSError *error;
    return [store sdl_objectsForName:SDLNameTimestamp ofClass:NSNumber.class error:&error];
}

- (void)setCoord:(NSArray<SDLTouchCoord *> *)coord {
    [store sdl_setObject:coord forName:SDLNameCoordinate];
}

- (NSArray<SDLTouchCoord *> *)coord {
    NSError *error;
    return [store sdl_objectsForName:SDLNameCoordinate ofClass:SDLTouchCoord.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
