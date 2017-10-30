//  SDLSyncMsgVersion.m
//


#import "SDLSyncMsgVersion.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

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
    [store sdl_setObject:majorVersion forName:SDLNameMajorVersion];
}

- (NSNumber<SDLInt> *)majorVersion {
    return [store sdl_objectForName:SDLNameMajorVersion];
}

- (void)setMinorVersion:(NSNumber<SDLInt> *)minorVersion {
    [store sdl_setObject:minorVersion forName:SDLNameMinorVersion];
}

- (NSNumber<SDLInt> *)minorVersion {
    return [store sdl_objectForName:SDLNameMinorVersion];
}

- (void)setPatchVersion:(nullable NSNumber<SDLInt> *)patchVersion {
    [store sdl_setObject:patchVersion forName:SDLNamePatchVersion];
}

- (nullable NSNumber<SDLInt> *)patchVersion {
    return [store sdl_objectForName:SDLNamePatchVersion];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@.%@.%@", self.majorVersion, self.minorVersion, self.patchVersion];
}
@end

NS_ASSUME_NONNULL_END
