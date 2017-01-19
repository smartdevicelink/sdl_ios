//  SDLSyncMsgVersion.m
//


#import "SDLSyncMsgVersion.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSyncMsgVersion

- (instancetype)initWithMajorVersion:(NSInteger)majorVersion minorVersion:(NSInteger)minorVersion {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.majorVersion = @(majorVersion);
    self.minorVersion = @(minorVersion);

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

- (NSString *)description {
    return [NSString stringWithFormat:@"%@.%@", self.majorVersion, self.minorVersion];
}
@end

NS_ASSUME_NONNULL_END
