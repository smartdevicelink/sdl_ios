//  SDLSyncMsgVersion.m
//


#import "SDLSyncMsgVersion.h"

#import "SDLNames.h"

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

- (instancetype)initWithMajorVersion:(NSInteger)majorVersion minorVersion:(NSInteger)minorVersion {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.majorVersion = @(majorVersion);
    self.minorVersion = @(minorVersion);

    return self;
}

- (void)setMajorVersion:(NSNumber *)majorVersion {
    if (majorVersion != nil) {
        [store setObject:majorVersion forKey:NAMES_majorVersion];
    } else {
        [store removeObjectForKey:NAMES_majorVersion];
    }
}

- (NSNumber *)majorVersion {
    return [store objectForKey:NAMES_majorVersion];
}

- (void)setMinorVersion:(NSNumber *)minorVersion {
    if (minorVersion != nil) {
        [store setObject:minorVersion forKey:NAMES_minorVersion];
    } else {
        [store removeObjectForKey:NAMES_minorVersion];
    }
}

- (NSNumber *)minorVersion {
    return [store objectForKey:NAMES_minorVersion];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@.%@", self.majorVersion, self.minorVersion];
}
@end
