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

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setStatus:(SDLComponentVolumeStatus *)status {
    if (status != nil) {
        [store setObject:status forKey:SDLNameStatus];
    } else {
        [store removeObjectForKey:SDLNameStatus];
    }
}

- (SDLComponentVolumeStatus *)status {
    NSObject *obj = [store objectForKey:SDLNameStatus];
    if (obj == nil || [obj isKindOfClass:SDLComponentVolumeStatus.class]) {
        return (SDLComponentVolumeStatus *)obj;
    } else {
        return [SDLComponentVolumeStatus valueOf:(NSString *)obj];
    }
}

@end
