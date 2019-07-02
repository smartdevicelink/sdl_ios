//  SDLImageResolution.m
//


#import "SDLImageResolution.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLImageResolution

- (instancetype)initWithWidth:(uint16_t)width height:(uint16_t)height {
    self = [self init];
    if (!self) { return nil; }

    self.resolutionWidth = @(width);
    self.resolutionHeight = @(height);

    return self;
}

- (void)setResolutionWidth:(NSNumber<SDLInt> *)resolutionWidth {
    [self.store sdl_setObject:resolutionWidth forName:SDLRPCParameterNameResolutionWidth];
}

- (NSNumber<SDLInt> *)resolutionWidth {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameResolutionWidth ofClass:NSNumber.class error:&error];
}

- (void)setResolutionHeight:(NSNumber<SDLInt> *)resolutionHeight {
    [self.store sdl_setObject:resolutionHeight forName:SDLRPCParameterNameResolutionHeight];
}

- (NSNumber<SDLInt> *)resolutionHeight {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameResolutionHeight ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
