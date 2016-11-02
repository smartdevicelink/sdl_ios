//  SDLLocationCoordinate.m
//

#import "SDLLocationCoordinate.h"
#import "SDLNames.h"

@implementation SDLLocationCoordinate

- (void)setLongitudeDegrees:(NSNumber *)longitudeDegrees {
    if (longitudeDegrees != nil) {
        store[NAMES_longitudeDegrees] = longitudeDegrees;
    } else {
        [store removeObjectForKey:NAMES_longitudeDegrees];
    }
}

- (NSNumber *)longitudeDegrees {
    return store[NAMES_longitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        store[NAMES_latitudeDegrees] = latitudeDegrees;
    } else {
        [store removeObjectForKey:NAMES_latitudeDegrees];
    }
}

- (NSNumber *)latitudeDegrees {
    return store[NAMES_latitudeDegrees];
}

@end
