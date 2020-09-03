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

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVideoStreamingCapability

- (instancetype)initWithPreferredResolution:(nullable SDLImageResolution *)preferredResolution maxBitrate:(int32_t)maxBitrate supportedFormats:(nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats hapticDataSupported:(BOOL)hapticDataSupported diagonalScreenSize:(float)diagonalScreenSize pixelPerInch:(float)pixelPerInch scale:(float)scale {
    self = [self init];
    if (!self) {
        return self;
    }

    self.maxBitrate = @(maxBitrate);
    self.preferredResolution = preferredResolution;
    self.supportedFormats = supportedFormats;
    self.hapticSpatialDataSupported = @(hapticDataSupported);
    self.diagonalScreenSize = @(diagonalScreenSize);
    self.pixelPerInch = @(pixelPerInch);
    self.scale = @(scale);

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

@end

NS_ASSUME_NONNULL_END
