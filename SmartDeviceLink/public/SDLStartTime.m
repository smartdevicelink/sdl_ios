//  SDLStartTime.m
//


#import "SDLStartTime.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLStartTime

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval {
    self = [self init];
    if (!self) { return nil; }

    // https://stackoverflow.com/a/15304826/1221798
    long seconds = lround(timeInterval);
    self.hours = @(seconds / 3600);
    self.minutes = @((seconds % 3600) / 60);
    self.seconds = @(seconds % 60);

    return self;
}

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
    [self.store sdl_setObject:hours forName:SDLRPCParameterNameHours];
}

- (NSNumber<SDLInt> *)hours {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameHours ofClass:NSNumber.class error:&error];
}

- (void)setMinutes:(NSNumber<SDLInt> *)minutes {
    [self.store sdl_setObject:minutes forName:SDLRPCParameterNameMinutes];
}

- (NSNumber<SDLInt> *)minutes {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameMinutes ofClass:NSNumber.class error:&error];
}

- (void)setSeconds:(NSNumber<SDLInt> *)seconds {
    [self.store sdl_setObject:seconds forName:SDLRPCParameterNameSeconds];
}

- (NSNumber<SDLInt> *)seconds {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameSeconds ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
