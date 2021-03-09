//
//  SDLVideoStreamingCapability + StreamingVideoExtensions.m
//  SmartDeviceLink-iOS
//
//  Created by yoooriii on 2/13/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLImageResolution + StreamingVideoExtensions.h"
#import "SDLVideoStreamingCapability + StreamingVideoExtensions.h"
#import "SDLVideoStreamingFormat.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLStreamingVideoScaleManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVideoStreamingCapability (StreamingVideoExtensions)

// note: it does not copy additionalVideoStreamingCapabilities
- (instancetype)shortCopy {
    typeof(self) aCopy = [[self class] new];
    aCopy.preferredResolution = self.preferredResolution;
    aCopy.maxBitrate = self.maxBitrate;
    aCopy.supportedFormats = self.supportedFormats;
    aCopy.preferredResolution = self.preferredResolution;
    aCopy.hapticSpatialDataSupported = self.hapticSpatialDataSupported;
    aCopy.diagonalScreenSize = self.diagonalScreenSize;
    aCopy.pixelPerInch = self.pixelPerInch;
    aCopy.scale = self.scale;
    return aCopy;
}

- (NSArray <SDLVideoStreamingCapability *> *)allVideoStreamingCapabilities {
    NSMutableArray *capabilitiesArray = [NSMutableArray arrayWithObject:[self shortCopy]];
    for (SDLVideoStreamingCapability *capability in self.additionalVideoStreamingCapabilities) {
        NSArray *childCapabilities = [capability allVideoStreamingCapabilities];
        if (childCapabilities.count) {
            [capabilitiesArray addObjectsFromArray:childCapabilities];
        }
    }
    return capabilitiesArray;
}

- (SDLImageResolution *)makeImageResolution {
    const float scale = (self.scale == nil) ? 1.0 : self.scale.floatValue;
    const CGSize size = [SDLStreamingVideoScaleManager scale:scale size:self.preferredResolution.makeSize];
    return [[SDLImageResolution alloc] initWithWidth:(uint16_t)size.width height:(uint16_t)size.height];
}

- (NSArray<SDLImageResolution *> *)allImageResolutions {
    NSMutableArray<SDLImageResolution *> *resolutions = [NSMutableArray arrayWithCapacity:self.additionalVideoStreamingCapabilities.count + 1];
    if (self.preferredResolution) {
        [resolutions addObject:self.preferredResolution];
    }
    for (SDLVideoStreamingCapability *nextCapability in self.additionalVideoStreamingCapabilities) {
        if (nextCapability.preferredResolution) {
            [resolutions addObject:nextCapability.preferredResolution];
        }
    }
    return resolutions;
}

- (NSArray<SDLImageResolution *> *)allImageResolutionsScaled {
    NSMutableArray<SDLImageResolution *> *resolutions = [NSMutableArray arrayWithCapacity:self.additionalVideoStreamingCapabilities.count + 1];
    SDLImageResolution *imgResolution = [self makeImageResolution];
    if (imgResolution) {
        [resolutions addObject:imgResolution];
    }
    for (SDLVideoStreamingCapability *nextCapability in self.additionalVideoStreamingCapabilities) {
        SDLImageResolution *imgResolution = [nextCapability makeImageResolution];
        if (imgResolution) {
            [resolutions addObject:imgResolution];
        }
    }
    return resolutions;
}

BOOL sdl_isResolutionEqual(SDLImageResolution *imageResolutionL, SDLImageResolution *imageResolutionR) {
    return ((imageResolutionL == nil && imageResolutionR == nil) ? YES : [imageResolutionL isEqual:imageResolutionR]);
}

BOOL sdl_isNumberEqual(NSNumber *numberL, NSNumber *numberR) {
    return (numberL == nil && numberR == nil) ? YES : (numberL && numberR ? [numberL isEqualToNumber:numberR] : NO);
}

- (BOOL)isEqual:(id)object {
    if (!object) {
        return NO;
    }
    if (object == self) {
        return YES;
    }
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    typeof(self) other = object;
    if (!sdl_isResolutionEqual(self.preferredResolution, other.preferredResolution)) {
        return NO;
    }
    if (!sdl_isNumberEqual(self.maxBitrate, other.maxBitrate)) {
        return NO;
    }
    if (!sdl_isNumberEqual(self.diagonalScreenSize, other.diagonalScreenSize)) {
        return NO;
    }
    if (!sdl_isNumberEqual(self.pixelPerInch, other.pixelPerInch)) {
        return NO;
    }
    if (!sdl_isNumberEqual(self.scale, other.scale)) {
        return NO;
    }
    return YES;
}

- (NSString *)description {
    NSMutableString *formats = [NSMutableString string];
    [formats setString:@"supportedFormats:"];
    for (SDLVideoStreamingFormat *f in self.supportedFormats) {
        [formats appendFormat:@"%@; ", f];
    }
    NSString *strClass = [NSString stringWithFormat:@"<%@:%p>", NSStringFromClass(self.class), self];
    NSString *strResolution = [NSString stringWithFormat:@"preferredResolution:%@", self.preferredResolution];
    NSString *strBitrate = [NSString stringWithFormat:@"maxBitrate:%@", self.maxBitrate];
    NSString *strHaptic = [NSString stringWithFormat:@"hapticSpatialDataSupported:%@", self.hapticSpatialDataSupported == nil ? @"(nil)" : (self.hapticSpatialDataSupported.boolValue ? @"YES" : @"NO")];
    NSString *strDiagonal = [NSString stringWithFormat:@"diagonalScreenSize:%@", self.diagonalScreenSize];
    NSString *strPPI = [NSString stringWithFormat:@"pixelPerInch:%@", self.pixelPerInch];
    NSString *strScale = [NSString stringWithFormat:@"scale:%@", self.scale];
    NSString *strAdditionalVideoStreamingCapabilities = [NSString stringWithFormat:@"additionalVideoStreamingCapabilities[%d]:%@", (int)self.additionalVideoStreamingCapabilities.count, self.additionalVideoStreamingCapabilities];

    NSMutableString *resultDescription = [NSMutableString stringWithCapacity:strClass.length + strResolution.length + strBitrate.length + strHaptic.length + strDiagonal.length + strPPI.length + strScale.length + strAdditionalVideoStreamingCapabilities.length + 20];
    [resultDescription appendString:strClass];
    [resultDescription appendString:@"{\n\t"];
    [resultDescription appendString:strResolution];
    [resultDescription appendString:@"\n\t"];
    [resultDescription appendString:strBitrate];
    [resultDescription appendString:@"\n\t"];
    [resultDescription appendString:strHaptic];
    [resultDescription appendString:@"\n\t"];
    [resultDescription appendString:strDiagonal];
    [resultDescription appendString:@"\n\t"];
    [resultDescription appendString:strPPI];
    [resultDescription appendString:@"\n\t"];
    [resultDescription appendString:strScale];
    [resultDescription appendString:@"\n\t"];
    [resultDescription appendString:strAdditionalVideoStreamingCapabilities];
    [resultDescription appendString:@"}"];

    // return immutable copy
    return [resultDescription copy];
}

@end

NS_ASSUME_NONNULL_END
