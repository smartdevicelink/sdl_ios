//  SDLLocationCoordinate.m
//

#import "SDLLocationCoordinate.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLocationCoordinate

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    if (longitudeDegrees != nil) {
        store[SDLNameLongitudeDegrees] = longitudeDegrees;
    } else {
        [store removeObjectForKey:SDLNameLongitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return store[SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        store[SDLNameLatitudeDegrees] = latitudeDegrees;
    } else {
        [store removeObjectForKey:SDLNameLatitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return store[SDLNameLatitudeDegrees];
}

@end

NS_ASSUME_NONNULL_END
