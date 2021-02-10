//  SDLImageResolution.m
//


#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLImageResolution + StreamingVideoExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLImageResolution (StreamingVideoExtensions)

- (CGSize)makeSize {
    return CGSizeMake(self.resolutionWidth.floatValue, self.resolutionHeight.floatValue);
}

- (float)normalizedAspectRatio {
    const float width = self.resolutionWidth.floatValue;
    const float height = self.resolutionHeight.floatValue;
    return (width == 0 || height == 0) ? 0 : fmaxf(width, height)/fminf(width, height);
}

- (SDLImageResolutionKind)kind {
    if (!self.resolutionHeight || !self.resolutionWidth) {
        return SDLImageResolutionKindUndefined;
    }
    const float ratio = self.resolutionWidth.floatValue/self.resolutionHeight.floatValue;
    const float ratioSquared = ratio * ratio;
    const float tolerance = 0.001f;
    if (ratioSquared < 1.0 - tolerance) {
        return SDLImageResolutionKindPortrait;
    }
    if (ratioSquared > 1.0 + tolerance) {
        return SDLImageResolutionKindLandscape;
    }
    return SDLImageResolutionKindSquare;
}

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"[%@ x %@]", self.resolutionWidth, self.resolutionHeight];
}

- (NSString *)description {
    NSString *kindString = @{@(SDLImageResolutionKindUndefined):@"Undef", @(SDLImageResolutionKindLandscape):@"Landscape", @(SDLImageResolutionKindPortrait):@"Portrait", @(SDLImageResolutionKindSquare):@"Square"}[@(self.kind)];
    return [NSString stringWithFormat:@"<%@:%p> {%@ x %@ : %@}", NSStringFromClass(self.class), self, self.resolutionWidth, self.resolutionHeight, kindString];
}

@end

NS_ASSUME_NONNULL_END
