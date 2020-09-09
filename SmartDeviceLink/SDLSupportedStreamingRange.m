//
//  SDLSupportedStreamingRange.m
//  SmartDeviceLink
//
//  Created on 6/11/20.
//

#import "SDLSupportedStreamingRange.h"
#import "SDLImageResolution.h"

@implementation SDLSupportedStreamingRange

- (instancetype)initWithResolutionsMinimum:(SDLImageResolution*)minResolution maximun:(SDLImageResolution*)maxResolution {
    if ((self = [super init])) {
        _minimumResolution = minResolution;
        _maximumResolution = maxResolution;
    }
    return self;
}

+ (instancetype)defaultPortraitRange {
    //TODO: decide what default values are
    SDLImageResolution *minResolution = [[SDLImageResolution alloc] initWithWidth:240 height:320];
    SDLImageResolution *maxResolution = [[SDLImageResolution alloc] initWithWidth:600 height:800];
    return [[self alloc] initWithResolutionsMinimum:minResolution maximun:maxResolution];
}

+ (instancetype)defaultLandscapeRange {
    SDLImageResolution *minResolution = [[SDLImageResolution alloc] initWithWidth:320 height:240];
    SDLImageResolution *maxResolution = [[SDLImageResolution alloc] initWithWidth:800 height:600];
    return [[self alloc] initWithResolutionsMinimum:minResolution maximun:maxResolution];
}

- (instancetype)copy {
    return [[self.class alloc] initWithResolutionsMinimum:self.minimumResolution maximun:self.maximumResolution];
}

- (BOOL)isImageResolutionInRange:(SDLImageResolution*)imageResolution {
    if (!imageResolution) {
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
