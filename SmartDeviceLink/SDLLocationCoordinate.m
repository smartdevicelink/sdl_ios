//  SDLLocationCoordinate.m
//

#import "SDLLocationCoordinate.h"
#import "SDLNames.h"

@implementation SDLLocationCoordinate

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    if (longitudeDegrees != nil) {
        store[NAMES_longitudeDegrees] = longitudeDegrees;
    } else {
        [store removeObjectForKey:NAMES_longitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return store[NAMES_longitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        store[NAMES_latitudeDegrees] = latitudeDegrees;
    } else {
        [store removeObjectForKey:NAMES_latitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return store[NAMES_latitudeDegrees];
}

@end
