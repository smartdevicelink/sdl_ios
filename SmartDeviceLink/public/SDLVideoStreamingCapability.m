//
//  SDLVideoStreamingCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/31/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLImageResolution.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLVideoStreamingFormat.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLStreamingVideoScaleManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVideoStreamingCapability

// deprecated method, and will be removed in the future
- (instancetype)initWithPreferredResolution:(nullable SDLImageResolution *)preferredResolution maxBitrate:(int32_t)maxBitrate supportedFormats:(nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats hapticDataSupported:(BOOL)hapticDataSupported diagonalScreenSize:(float)diagonalScreenSize pixelPerInch:(float)pixelPerInch scale:(float)scale {
    return [self initWithPreferredResolution:preferredResolution maxBitrate:@(maxBitrate) supportedFormats:supportedFormats hapticSpatialDataSupported:@(hapticDataSupported) diagonalScreenSize:@(diagonalScreenSize) pixelPerInch:@(pixelPerInch) scale:@(scale) preferredFPS:nil];
}

- (instancetype)initWithPreferredResolution:(nullable SDLImageResolution *)preferredResolution maxBitrate:(nullable NSNumber<SDLUInt> *)maxBitrate supportedFormats:(nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats hapticSpatialDataSupported:(nullable NSNumber<SDLBool> *)hapticSpatialDataSupported diagonalScreenSize:(nullable NSNumber<SDLFloat> *)diagonalScreenSize pixelPerInch:(nullable NSNumber<SDLFloat> *)pixelPerInch scale:(nullable NSNumber<SDLFloat> *)scale preferredFPS:(nullable NSNumber<SDLUInt> *)preferredFPS {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.preferredResolution = preferredResolution;
    self.maxBitrate = maxBitrate;
    self.supportedFormats = supportedFormats;
    self.hapticSpatialDataSupported = hapticSpatialDataSupported;
    self.diagonalScreenSize = diagonalScreenSize;
    self.pixelPerInch = pixelPerInch;
    self.scale = scale;
    self.preferredFPS = preferredFPS;
    return self;
}

- (void)setPreferredResolution:(nullable SDLImageResolution *)preferredResolution {
    [self.store sdl_setObject:preferredResolution forName:SDLRPCParameterNamePreferredResolution];
}

- (nullable SDLImageResolution *)preferredResolution {
    return [self.store sdl_objectForName:SDLRPCParameterNamePreferredResolution ofClass:SDLImageResolution.class error:nil];
}

- (void)setMaxBitrate:(nullable NSNumber<SDLInt> *)maxBitrate {
    [self.store sdl_setObject:maxBitrate forName:SDLRPCParameterNameMaxBitrate];
}

- (nullable NSNumber<SDLInt> *)maxBitrate {
    return [self.store sdl_objectForName:SDLRPCParameterNameMaxBitrate ofClass:NSNumber.class error:nil];
}

- (void)setSupportedFormats:(nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats {
    [self.store sdl_setObject:supportedFormats forName:SDLRPCParameterNameSupportedFormats];
}

- (nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats {
    return [self.store sdl_objectsForName:SDLRPCParameterNameSupportedFormats ofClass:SDLVideoStreamingFormat.class error:nil];
}

- (void)setHapticSpatialDataSupported:(nullable NSNumber<SDLBool> *)hapticSpatialDataSupported {
    [self.store sdl_setObject:hapticSpatialDataSupported forName:SDLRPCParameterNameHapticSpatialDataSupported];
}

- (nullable NSNumber<SDLBool> *)hapticSpatialDataSupported {
    return [self.store sdl_objectForName:SDLRPCParameterNameHapticSpatialDataSupported ofClass:NSNumber.class error:nil];
}

- (void)setDiagonalScreenSize:(nullable NSNumber<SDLFloat> *)diagonalScreenSize {
    [self.store sdl_setObject:diagonalScreenSize forName:SDLRPCParameterNameDiagonalScreenSize];
}

- (nullable NSNumber<SDLFloat> *)diagonalScreenSize {
    return [self.store sdl_objectForName:SDLRPCParameterNameDiagonalScreenSize ofClass:NSNumber.class error:nil];
}

- (void)setPixelPerInch:(nullable NSNumber<SDLFloat> *)pixelPerInch {
    [self.store sdl_setObject:pixelPerInch forName:SDLRPCParameterNamePixelPerInch];
}

- (nullable NSNumber<SDLFloat> *)pixelPerInch {
    return [self.store sdl_objectForName:SDLRPCParameterNamePixelPerInch ofClass:NSNumber.class error:nil];
}

- (void)setScale:(nullable NSNumber<SDLFloat> *)scale {
    [self.store sdl_setObject:scale forName:SDLRPCParameterNameScale];
}

- (nullable NSNumber<SDLFloat> *)scale {
    return [self.store sdl_objectForName:SDLRPCParameterNameScale ofClass:NSNumber.class error:nil];
}

- (void)setAdditionalVideoStreamingCapabilities:(nullable NSArray <SDLVideoStreamingCapability*> *)capabilities {
    [self.store sdl_setObject:capabilities forName:SDLRPCParameterNameAdditionalVideoStreamingCapabilities];
}

- (nullable NSArray <SDLVideoStreamingCapability*> *)additionalVideoStreamingCapabilities {
    NSError *error = nil;
    return [self.store sdl_objectsForName:SDLRPCParameterNameAdditionalVideoStreamingCapabilities ofClass:SDLVideoStreamingCapability.class error:&error];
}

// note: it does not copy additionalVideoStreamingCapabilities
- (instancetype)shortCopy {
    typeof(self) aCopy = [[self class] new];
#define COPY_PROP(property) aCopy.property = self.property
    COPY_PROP(preferredResolution);
    COPY_PROP(maxBitrate);
    COPY_PROP(supportedFormats);
    COPY_PROP(preferredResolution);
    COPY_PROP(hapticSpatialDataSupported);
    COPY_PROP(diagonalScreenSize);
    COPY_PROP(pixelPerInch);
    COPY_PROP(scale);
#undef COPY_PROP
    return aCopy;
}

- (NSArray <SDLVideoStreamingCapability *> *)allVideoStreamingCapabilitiesPlain {
    NSMutableArray *capabilitiesArray = [NSMutableArray arrayWithObject:[self shortCopy]];
    for (SDLVideoStreamingCapability *capability in self.additionalVideoStreamingCapabilities) {
        NSArray *childCapabilities = [capability allVideoStreamingCapabilitiesPlain];
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

#define EQUAL_RES ((self.preferredResolution == nil && other.preferredResolution == nil) ? YES : [self.preferredResolution isEqual:other.preferredResolution])
#define EQUAL_NUM(property) ((self.property == nil && other.property == nil) ? YES : [self.property isEqualToNumber:other.property])

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    typeof(self) other = object;
    if (!EQUAL_RES) {
        return NO;
    }
    if (!EQUAL_NUM(maxBitrate)) {
        return NO;
    }
    if (!EQUAL_NUM(diagonalScreenSize)) {
        return NO;
    }
    if (!EQUAL_NUM(pixelPerInch)) {
        return NO;
    }
    if (!EQUAL_NUM(scale)) {
        return NO;
    }
    return YES;
}

#undef EQUAL_RES
#undef EQUAL_NUM

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

- (void)setPreferredFPS:(nullable NSNumber<SDLUInt> *)preferredFPS {
    [self.store sdl_setObject:preferredFPS forName:SDLRPCParameterNamePreferredFPS];
}

- (nullable NSNumber<SDLUInt> *)preferredFPS {
    return [self.store sdl_objectForName:SDLRPCParameterNamePreferredFPS ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
