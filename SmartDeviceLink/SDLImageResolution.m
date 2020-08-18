//  SDLImageResolution.m
//


#import "NSMutableDictionary+Store.h"
#import "SDLImageResolution.h"
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

- (CGSize)makeSize {
    return CGSizeMake(self.resolutionWidth.floatValue, self.resolutionHeight.floatValue);
}

- (float)normalizedAspectRatio {
    const float width = self.resolutionWidth.floatValue;
    const float height = self.resolutionHeight.floatValue;
    return (0 == width || 0 == height) ? 0 : fabsf(fmaxf(width, height)/fminf(width, height));
}

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"[%@ x %@]", self.resolutionWidth, self.resolutionHeight];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p> {%@ x %@}", NSStringFromClass(self.class), self, self.resolutionWidth, self.resolutionHeight];
}

@end

NS_ASSUME_NONNULL_END
