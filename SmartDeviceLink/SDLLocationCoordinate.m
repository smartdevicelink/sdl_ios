//  SDLLocationCoordinate.m
//

#import "SDLLocationCoordinate.h"
#import "SDLNames.h"

@implementation SDLLocationCoordinate

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    if (longitudeDegrees != nil) {
        store[SDLNameLongitudeDegrees] = longitudeDegrees;
    } else {
        [store removeObjectForKey:SDLNameLongitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return [self objectForName:SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        store[SDLNameLatitudeDegrees] = latitudeDegrees;
    } else {
        [store removeObjectForKey:SDLNameLatitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return [self objectForName:SDLNameLatitudeDegrees];
}

@end
