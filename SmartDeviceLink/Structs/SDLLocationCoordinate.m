//  SDLLocationCoordinate.m
//

#import "SDLLocationCoordinate.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLocationCoordinate

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    [store sdl_setObject:longitudeDegrees forName:SDLNameLongitudeDegrees];
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return [store sdl_objectForName:SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [store sdl_setObject:latitudeDegrees forName:SDLNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return [store sdl_objectForName:SDLNameLatitudeDegrees];
}

@end

NS_ASSUME_NONNULL_END
