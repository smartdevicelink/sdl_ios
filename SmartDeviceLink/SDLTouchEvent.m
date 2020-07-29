//  SDLTouchEvent.m
//


#import "SDLTouchEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLTouchCoord.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTouchEvent

- (void)setTouchEventId:(NSNumber<SDLInt> *)touchEventId {
    [self.store sdl_setObject:touchEventId forName:SDLRPCParameterNameId];
}

- (NSNumber<SDLInt> *)touchEventId {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameId ofClass:NSNumber.class error:&error];
}

- (void)setTimeStamp:(NSArray<NSNumber *> *)timeStamp {
    [self.store sdl_setObject:timeStamp forName:SDLRPCParameterNameTS];
}

- (NSArray<NSNumber *> *)timeStamp {
    NSError *error = nil;
    return [self.store sdl_objectsForName:SDLRPCParameterNameTS ofClass:NSNumber.class error:&error];
}

- (void)setCoord:(NSArray<SDLTouchCoord *> *)coord {
    [self.store sdl_setObject:coord forName:SDLRPCParameterNameCoordinate];
}

- (NSArray<SDLTouchCoord *> *)coord {
    NSError *error = nil;
    return [self.store sdl_objectsForName:SDLRPCParameterNameCoordinate ofClass:SDLTouchCoord.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
