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

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    typeof(self) aCopy = [[self.class allocWithZone:zone] init];
    // copy boxed values to keep nil cases if any and avoid outside updates
    aCopy.resolutionWidth = [self.resolutionWidth copyWithZone:zone];
    aCopy.resolutionHeight = [self.resolutionHeight copyWithZone:zone];
    return aCopy;
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
    return (0 == width || 0 == height) ? 0 : fmaxf(width, height)/fminf(width, height);
}

- (NSNumber<SDLInt> *)isPortrait {
    if (!self.resolutionHeight || !self.resolutionWidth) {
        return nil;
    }
    return @(self.resolutionWidth.floatValue < self.resolutionHeight.floatValue);
}

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"[%@ x %@]", self.resolutionWidth, self.resolutionHeight];
}

- (NSString *)description {
    NSNumber *isPortrait = self.isPortrait;
    return [NSString stringWithFormat:@"<%@:%p> {%@ x %@ : %@}", NSStringFromClass(self.class), self, self.resolutionWidth, self.resolutionHeight, isPortrait ? (isPortrait.boolValue ? @"P" : @"L") : @"?"];
}

@end

NS_ASSUME_NONNULL_END
