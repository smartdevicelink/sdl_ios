//  SDLSyncMsgVersion.m
//


#import "SDLSyncMsgVersion.h"



@implementation SDLSyncMsgVersion

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setMajorVersion:(NSNumber *)majorVersion {
    if (majorVersion != nil) {
        [store setObject:majorVersion forKey:SDLNameMajorVersion];
    } else {
        [store removeObjectForKey:SDLNameMajorVersion];
    }
}

- (NSNumber *)majorVersion {
    return [store objectForKey:SDLNameMajorVersion];
}

- (void)setMinorVersion:(NSNumber *)minorVersion {
    if (minorVersion != nil) {
        [store setObject:minorVersion forKey:SDLNameMinorVersion];
    } else {
        [store removeObjectForKey:SDLNameMinorVersion];
    }
}

- (NSNumber *)minorVersion {
    return [store objectForKey:SDLNameMinorVersion];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@.%@", self.majorVersion, self.minorVersion];
}
@end
