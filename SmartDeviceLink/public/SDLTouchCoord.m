//  SDLTouchCoord.m
//


#import "SDLTouchCoord.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTouchCoord

- (instancetype)initWithX:(UInt16)x y:(UInt16)y {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.x = @(x);
    self.y = @(y);
    return self;
}

- (void)setX:(NSNumber<SDLFloat> *)x {
    [self.store sdl_setObject:x forName:SDLRPCParameterNameX];
}

- (NSNumber<SDLFloat> *)x {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameX ofClass:NSNumber.class error:&error];
}

- (void)setY:(NSNumber<SDLFloat> *)y {
    [self.store sdl_setObject:y forName:SDLRPCParameterNameY];
}

- (NSNumber<SDLFloat> *)y {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameY ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
