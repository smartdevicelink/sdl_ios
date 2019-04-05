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
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameMajorVersion ofClass:NSNumber.class error:&error];
}

- (void)setMinorVersion:(NSNumber<SDLInt> *)minorVersion {
    [store sdl_setObject:minorVersion forName:SDLRPCParameterNameMinorVersion];
}

- (NSNumber<SDLInt> *)minorVersion {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameMinorVersion ofClass:NSNumber.class error:&error];
}

- (void)setPatchVersion:(nullable NSNumber<SDLInt> *)patchVersion {
    [store sdl_setObject:patchVersion forName:SDLRPCParameterNamePatchVersion];
}

- (nullable NSNumber<SDLInt> *)patchVersion {
    return [store sdl_objectForName:SDLRPCParameterNamePatchVersion ofClass:NSNumber.class error:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@.%@.%@", self.majorVersion, self.minorVersion, self.patchVersion];
}
@end

NS_ASSUME_NONNULL_END
