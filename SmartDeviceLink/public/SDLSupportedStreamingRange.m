//
//  SDLSupportedStreamingRange.m
//  SmartDeviceLink
//
//  Created on 6/11/20.
//

#import "SDLSupportedStreamingRange.h"
#import "SDLImageResolution.h"
#import "SDLLogMacros.h"

@implementation SDLSupportedStreamingRange

- (instancetype)initWithResolutionsMinimum:(SDLImageResolution *)minResolution maximun:(SDLImageResolution *)maxResolution {
    if ((self = [super init])) {
        if (minResolution && maxResolution) {
            // if both min and max present then min must be below max
            if ((minResolution.resolutionWidth.floatValue > maxResolution.resolutionWidth.floatValue) ||
                (minResolution.resolutionHeight.floatValue > maxResolution.resolutionHeight.floatValue)) {
                SDLLogD(@"minResolution is bigger than maxResolution (%@ <> %@)", minResolution, maxResolution);
            }
        }
        _minimumResolution = minResolution;
        _maximumResolution = maxResolution;
    }
    return self;
}

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    typeof(self) aCopy = [[self.class allocWithZone:zone] init];
    // create a deep copy to prevent resolutions from outside update
    aCopy.minimumResolution = [self.minimumResolution copyWithZone:zone];
    aCopy.maximumResolution = [self.maximumResolution copyWithZone:zone];
    aCopy->_minimumAspectRatio = self->_minimumAspectRatio;
    aCopy->_maximumAspectRatio = self->_maximumAspectRatio;
    aCopy->_minimumDiagonal = self->_minimumDiagonal;
    return aCopy;
}

- (BOOL)isImageResolutionRangeValid {
    return (self.minimumResolution || self.maximumResolution);
}

- (BOOL)isImageResolutionInRange:(SDLImageResolution *)imageResolution {
    if (!imageResolution) {
        return NO;
    }
    if (![self isImageResolutionRangeValid]) {
        // no min & max resolutions - no restriction, no resolution pass
        return NO;
    }
    const CGSize size = imageResolution.makeSize;
    BOOL isAboveMin = YES;
    BOOL isBelowMax = YES;
    if (self.minimumResolution) {
        // is the size bigger than min? (no check if not set)
        const CGSize minSize = self.minimumResolution.makeSize;
        isAboveMin = ((size.width >= minSize.width) && (size.height >= minSize.height));
    }
    if (self.maximumResolution) {
        // is the size smaller than max? (no check if not set)
        const CGSize maxSize = self.maximumResolution.makeSize;
        isBelowMax = ((size.width <= maxSize.width) && (size.height <= maxSize.height));
    }
    return isAboveMin && isBelowMax;
}

- (BOOL)isAspectRatioInRange:(float)aspectRatio {
    if (self.minimumAspectRatio <= 0 && self.maximumAspectRatio <= 0) {
        return NO;
    }

    BOOL isInRange = YES;
    if (0 < self.minimumAspectRatio) {
        isInRange = (aspectRatio >= self.minimumAspectRatio);
    }
    if (isInRange && (0 < self.maximumAspectRatio)) {
        isInRange = (aspectRatio <= self.maximumAspectRatio);
    }
    return isInRange;
}

- (float)minimumAspectRatio {
    return self.minimumResolution ? [self.minimumResolution normalizedAspectRatio] : _minimumAspectRatio;
}

- (float)maximumAspectRatio {
    return self.maximumResolution ? [self.maximumResolution normalizedAspectRatio] : _maximumAspectRatio;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: ratio-min/max:[%2.2f/%2.2f], min-diagonal:%2.2f, resolution-min/max:[%@/%@]", NSStringFromClass(self.class), self.minimumAspectRatio, self.maximumAspectRatio, self.minimumDiagonal, self.minimumResolution.stringValue, self.maximumResolution.stringValue];
}

@end
