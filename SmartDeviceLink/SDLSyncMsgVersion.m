//  SDLSyncMsgVersion.m
//


#import "SDLSyncMsgVersion.h"

#import "SDLNames.h"

@implementation SDLSyncMsgVersion

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
