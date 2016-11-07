//  SDLLocationCoordinate.m
//

#import "SDLLocationCoordinate.h"
#import "SDLNames.h"

@implementation SDLLocationCoordinate

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    [self setObject:longitudeDegrees forName:SDLNameLongitudeDegrees];
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return [self objectForName:SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [self setObject:latitudeDegrees forName:SDLNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return [self objectForName:SDLNameLatitudeDegrees];
}

@end
