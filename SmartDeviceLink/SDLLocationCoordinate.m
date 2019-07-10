//  SDLLocationCoordinate.m
//

#import "SDLLocationCoordinate.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLocationCoordinate

- (instancetype)initWithLatitudeDegrees:(float)latitudeDegrees longitudeDegrees:(float)longitudeDegrees {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.latitudeDegrees = @(latitudeDegrees);
    self.longitudeDegrees = @(longitudeDegrees);

    return self;
}

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    [self.store sdl_setObject:longitudeDegrees forName:SDLRPCParameterNameLongitudeDegrees];
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLongitudeDegrees ofClass:NSNumber.class error:&error];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [self.store sdl_setObject:latitudeDegrees forName:SDLRPCParameterNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLatitudeDegrees ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
