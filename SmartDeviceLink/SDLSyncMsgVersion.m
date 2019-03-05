//  SDLSyncMsgVersion.m
//


#import "SDLSyncMsgVersion.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSyncMsgVersion

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
    [store sdl_setObject:majorVersion forName:SDLRPCParameterNameMajorVersion];
}

- (NSNumber<SDLInt> *)majorVersion {
    return [store sdl_objectForName:SDLRPCParameterNameMajorVersion];
}

- (void)setMinorVersion:(NSNumber<SDLInt> *)minorVersion {
    [store sdl_setObject:minorVersion forName:SDLRPCParameterNameMinorVersion];
}

- (NSNumber<SDLInt> *)minorVersion {
    return [store sdl_objectForName:SDLRPCParameterNameMinorVersion];
}

- (void)setPatchVersion:(nullable NSNumber<SDLInt> *)patchVersion {
    [store sdl_setObject:patchVersion forName:SDLRPCParameterNamePatchVersion];
}

- (nullable NSNumber<SDLInt> *)patchVersion {
    return [store sdl_objectForName:SDLRPCParameterNamePatchVersion];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@.%@.%@", self.majorVersion, self.minorVersion, self.patchVersion];
}
@end

NS_ASSUME_NONNULL_END
