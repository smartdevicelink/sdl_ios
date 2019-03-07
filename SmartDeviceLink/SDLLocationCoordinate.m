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
    NSError *error;
    return [store sdl_objectForName:SDLNameLongitudeDegrees ofClass:NSNumber.class error:&error];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [store sdl_setObject:latitudeDegrees forName:SDLNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    NSError *error;
    return [store sdl_objectForName:SDLNameLatitudeDegrees ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
