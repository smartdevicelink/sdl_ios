//  SDLStartTime.m
//


#import "SDLStartTime.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLStartTime

- (instancetype)initWithHours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.hours = @(hours);
    self.minutes = @(minutes);
    self.seconds = @(seconds);

    return self;
}

- (void)setHours:(NSNumber<SDLInt> *)hours {
    [store sdl_setObject:hours forName:SDLNameHours];
}

- (NSNumber<SDLInt> *)hours {
    NSError *error;
    return [store sdl_objectForName:SDLNameHours ofClass:NSNumber.class error:&error];
}

- (void)setMinutes:(NSNumber<SDLInt> *)minutes {
    [store sdl_setObject:minutes forName:SDLNameMinutes];
}

- (NSNumber<SDLInt> *)minutes {
    NSError *error;
    return [store sdl_objectForName:SDLNameMinutes ofClass:NSNumber.class error:&error];
}

- (void)setSeconds:(NSNumber<SDLInt> *)seconds {
    [store sdl_setObject:seconds forName:SDLNameSeconds];
}

- (NSNumber<SDLInt> *)seconds {
    NSError *error;
    return [store sdl_objectForName:SDLNameSeconds ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
