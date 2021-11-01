//
//  SDLVideoStreamingRange.m
//  SmartDeviceLink
//
//  Created on 6/11/20.
//

#import "SDLVideoStreamingRange.h"

#import "SDLError.h"
#import "SDLImageResolution+StreamingVideoExtensions.h"
#import "SDLLogMacros.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVideoStreamingRange

- (instancetype)init {
    return [self initWithMinimumResolution:[[SDLImageResolution alloc] initWithWidth:0.0 height:0.0] maximumResolution:[[SDLImageResolution alloc] initWithWidth:0.0 height:0.0]];
}

- (instancetype)initWithMinimumResolution:(nullable SDLImageResolution *)minResolution maximumResolution:(nullable SDLImageResolution *)maxResolution {
    return [self initWithMinimumResolution:minResolution maximumResolution:maxResolution minimumAspectRatio:1.0 maximumAspectRatio:9999.0 minimumDiagonal:0.0];
}

- (instancetype)initWithMinimumResolution:(nullable SDLImageResolution *)minResolution maximumResolution:(nullable SDLImageResolution *)maxResolution minimumAspectRatio:(float)minimumAspectRatio maximumAspectRatio:(float)maximumAspectRatio minimumDiagonal:(float)minimumDiagonal {
    self = [super init];
    if (!self) { return nil; }

    // Min must be below max, if this `if` passes, this is an invalid check, throw an exception.
    if ((minResolution != nil && maxResolution != nil) &&
        ((minResolution.resolutionWidth.floatValue > maxResolution.resolutionWidth.floatValue) ||
        (minResolution.resolutionHeight.floatValue > maxResolution.resolutionHeight.floatValue))) {
        SDLLogE(@"VideoStreamingRange minResolution is bigger than maxResolution (%@ <> %@)", minResolution, maxResolution);
        @throw [NSException sdl_invalidVideoStreamingRange];
    }

    _minimumResolution = minResolution;
    _maximumResolution = maxResolution;
    self.minimumDiagonal = minimumDiagonal;
    self.minimumAspectRatio = minimumAspectRatio;
    self.maximumAspectRatio = maximumAspectRatio;

    return self;
}

+ (instancetype)disabled {
    return [[self alloc] init];
}

#pragma mark - Setters

- (void)setMinimumAspectRatio:(float)minimumAspectRatio {
    if (minimumAspectRatio < 1.0) {
        _minimumAspectRatio = 1.0;
    } else {
        _minimumAspectRatio = minimumAspectRatio;
    }
}

- (void)setMaximumAspectRatio:(float)maximumAspectRatio {
    if (maximumAspectRatio < 1.0) {
        _maximumAspectRatio = 1.0;
    } else {
        _maximumAspectRatio = maximumAspectRatio;
    }
}

- (void)setMinimumDiagonal:(float)minimumDiagonal {
    if (minimumDiagonal < 0.0) {
        _minimumDiagonal = 0.0;
    } else {
        _minimumDiagonal = minimumDiagonal;
    }
}

#pragma mark - Instance Methods

- (BOOL)sdl_isImageResolutionRangeValid {
    return ((self.minimumResolution != nil) || (self.maximumResolution != nil));
}

- (BOOL)isImageResolutionInRange:(SDLImageResolution *)imageResolution {
    if (!imageResolution) {
        return NO;
    }
    if (![self sdl_isImageResolutionRangeValid]) {
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
    if (self.minimumAspectRatio <= 1.f && self.maximumAspectRatio <= 1.f) {
        // min/max ratio not specified - any aspectRatio is OK
        return YES;
    }

    BOOL isInRange = YES;
    if (self.minimumAspectRatio >= 1.f) {
        isInRange = (aspectRatio >= self.minimumAspectRatio);
    }
    if (isInRange && (self.maximumAspectRatio >= 1.f)) {
        isInRange = (aspectRatio <= self.maximumAspectRatio);
    }
    return isInRange;
}

- (NSString *)description {
    NSString *strClass = NSStringFromClass(self.class);
    NSString *strRatio = [NSString stringWithFormat:@"ratio-min/max:[%2.2f/%2.2f]", self.minimumAspectRatio, self.maximumAspectRatio];
    NSString *strDiagonal = [NSString stringWithFormat:@"min-diagonal:%2.2f", self.minimumDiagonal];
    NSString *strResolution = [NSString stringWithFormat:@"resolution-min/max:[%@x%@/%@x%@]", self.minimumResolution.resolutionWidth, self.minimumResolution.resolutionHeight, self.maximumResolution.resolutionWidth, self.maximumResolution.resolutionHeight];
    return [NSString stringWithFormat:@"%@: {%@, %@, %@}", strClass, strRatio, strDiagonal, strResolution];
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) aCopy = [[self.class allocWithZone:zone] init];
    // create a deep copy to prevent resolutions from outside update
    aCopy.minimumResolution = [self.minimumResolution copyWithZone:zone];
    aCopy.maximumResolution = [self.maximumResolution copyWithZone:zone];
    aCopy->_minimumAspectRatio = self->_minimumAspectRatio;
    aCopy->_maximumAspectRatio = self->_maximumAspectRatio;
    aCopy->_minimumDiagonal = self->_minimumDiagonal;
    return aCopy;
}

@end

NS_ASSUME_NONNULL_END
