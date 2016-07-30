//  SDLSingleTireStatus.m
//

#import "SDLSingleTireStatus.h"

#import "SDLComponentVolumeStatus.h"
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

- (void)setStatus:(SDLComponentVolumeStatus *)status {
    if (status != nil) {
        [store setObject:status forKey:NAMES_status];
    } else {
        [store removeObjectForKey:NAMES_status];
    }
}

- (SDLComponentVolumeStatus *)status {
    NSObject *obj = [store objectForKey:NAMES_status];
    if (obj == nil || [obj isKindOfClass:SDLComponentVolumeStatus.class]) {
        return (SDLComponentVolumeStatus *)obj;
    } else {
        return [SDLComponentVolumeStatus valueOf:(NSString *)obj];
    }
}

@end
