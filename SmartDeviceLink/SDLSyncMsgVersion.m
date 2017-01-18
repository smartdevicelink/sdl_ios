//  SDLSyncMsgVersion.m
//


#import "SDLSyncMsgVersion.h"

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
    if (majorVersion != nil) {
        [store setObject:majorVersion forKey:SDLNameMajorVersion];
    } else {
        [store removeObjectForKey:SDLNameMajorVersion];
    }
}

- (NSNumber<SDLInt> *)majorVersion {
    return [store objectForKey:SDLNameMajorVersion];
}

- (void)setMinorVersion:(NSNumber<SDLInt> *)minorVersion {
    if (minorVersion != nil) {
        [store setObject:minorVersion forKey:SDLNameMinorVersion];
    } else {
        [store removeObjectForKey:SDLNameMinorVersion];
    }
}

- (NSNumber<SDLInt> *)minorVersion {
    return [store objectForKey:SDLNameMinorVersion];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@.%@", self.majorVersion, self.minorVersion];
}
@end

NS_ASSUME_NONNULL_END
