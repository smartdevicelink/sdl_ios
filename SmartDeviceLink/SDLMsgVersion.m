//
//  SDLMsgVersion.m
//  SmartDeviceLink
//
//  Created by Justin Gluck on 7/18/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLMsgVersion.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

@implementation SDLMsgVersion

+ (nullable instancetype)versionWithString:(NSString *)versionString {
    NSArray<NSString *> *components = [versionString componentsSeparatedByString:@"."];
    if (3 != components.count) {
        return nil;
    }
    const UInt8 majorVersion = (UInt8)components[0].intValue;
    const UInt8 minorVersion = (UInt8)components[1].intValue;
    const UInt8 patchVersion = (UInt8)components[2].intValue;
    return [[self alloc] initWithMajorVersion:majorVersion minorVersion:minorVersion patchVersion:patchVersion];
}

- (instancetype)initWithMajorVersion:(UInt8)majorVersion minorVersion:(UInt8)minorVersion patchVersion:(UInt8)patchVersion {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.majorVersion = @(majorVersion);
    self.minorVersion = @(minorVersion);
    self.patchVersion = @(patchVersion);

    return self;
}

- (void)setMajorVersion:(NSNumber<SDLInt> *)majorVersion {
    [self.store sdl_setObject:majorVersion forName:SDLRPCParameterNameMajorVersion];
}

- (NSNumber<SDLInt> *)majorVersion {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameMajorVersion ofClass:NSNumber.class error:&error];
}

- (void)setMinorVersion:(NSNumber<SDLInt> *)minorVersion {
    [self.store sdl_setObject:minorVersion forName:SDLRPCParameterNameMinorVersion];
}

- (NSNumber<SDLInt> *)minorVersion {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameMinorVersion ofClass:NSNumber.class error:&error];
}

- (void)setPatchVersion:(nullable NSNumber<SDLInt> *)patchVersion {
    [self.store sdl_setObject:patchVersion forName:SDLRPCParameterNamePatchVersion];
}

- (nullable NSNumber<SDLInt> *)patchVersion {
    return [self.store sdl_objectForName:SDLRPCParameterNamePatchVersion ofClass:NSNumber.class error:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@.%@.%@", self.majorVersion, self.minorVersion, self.patchVersion];
}

@end
