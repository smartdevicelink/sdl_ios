//  SDLMyKey.m
//

#import "SDLMyKey.h"


#import "SDLVehicleDataStatus.h"


@implementation SDLMyKey

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

- (void)setE911Override:(SDLVehicleDataStatus *)e911Override {
    if (e911Override != nil) {
        [store setObject:e911Override forKey:SDLNameE911Override];
    } else {
        [store removeObjectForKey:SDLNameE911Override];
    }
}

- (SDLVehicleDataStatus *)e911Override {
    NSObject *obj = [store objectForKey:SDLNameE911Override];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataStatus.class]) {
        return (SDLVehicleDataStatus *)obj;
    } else {
        return [SDLVehicleDataStatus valueOf:(NSString *)obj];
    }
}

@end
