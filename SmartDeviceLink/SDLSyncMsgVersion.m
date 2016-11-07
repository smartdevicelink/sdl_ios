//  SDLSyncMsgVersion.m
//


#import "SDLSyncMsgVersion.h"

#import "SDLNames.h"

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
    [self setObject:majorVersion forName:SDLNameMajorVersion];
}

- (NSNumber<SDLInt> *)majorVersion {
    return [self objectForName:SDLNameMajorVersion];
}

- (void)setMinorVersion:(NSNumber<SDLInt> *)minorVersion {
    [self setObject:minorVersion forName:SDLNameMinorVersion];
}

- (NSNumber<SDLInt> *)minorVersion {
    return [self objectForName:SDLNameMinorVersion];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@.%@", self.majorVersion, self.minorVersion];
}
@end
