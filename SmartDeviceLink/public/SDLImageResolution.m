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

- (SDLImageResolutionKind)kind {
    if (!self.resolutionHeight || !self.resolutionWidth) {
        return SDLImageResolutionKindUndefined;
    }
    const float ratio = self.resolutionWidth.floatValue/self.resolutionHeight.floatValue;
    const float ratio2 = ratio * ratio;
    const float tolerance = 0.001f;
    if (ratio2 < 1.0 - tolerance) {
        return SDLImageResolutionKindPortrait;
    }
    if (ratio2 > 1.0 + tolerance) {
        return SDLImageResolutionKindLandscape;
    }
    return SDLImageResolutionKindSquare;
}

#define EQUAL_NUM(property) ((nil == self.property && nil == res2.property) ? YES : [self.property isEqualToNumber:res2.property])

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    typeof(self) res2 = object;
    return EQUAL_NUM(resolutionWidth) && EQUAL_NUM(resolutionHeight);
}

#undef EQUAL_NUM

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"[%@ x %@]", self.resolutionWidth, self.resolutionHeight];
}

- (NSString *)description {
    NSString *kindString = @{@(SDLImageResolutionKindUndefined):@"Undef", @(SDLImageResolutionKindLandscape):@"Landscape", @(SDLImageResolutionKindPortrait):@"Portrait", @(SDLImageResolutionKindSquare):@"Square"}[@(self.kind)];
    return [NSString stringWithFormat:@"<%@:%p> {%@ x %@ : %@}", NSStringFromClass(self.class), self, self.resolutionWidth, self.resolutionHeight, kindString];
}

@end

NS_ASSUME_NONNULL_END
