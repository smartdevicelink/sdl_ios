//  SDLSingleTireStatus.m
//

#import "SDLSingleTireStatus.h"

#import "SDLNames.h"


@implementation SDLSingleTireStatus

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

- (void)setStatus:(SDLComponentVolumeStatus)status {
    if (status != nil) {
        [store setObject:status forKey:NAMES_status];
    } else {
        [store removeObjectForKey:NAMES_status];
    }
}

- (SDLComponentVolumeStatus)status {
    NSObject *obj = [store objectForKey:NAMES_status];
    return (SDLComponentVolumeStatus)obj;
}

@end
