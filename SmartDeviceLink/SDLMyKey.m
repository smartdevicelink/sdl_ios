//  SDLMyKey.m
//

#import "SDLMyKey.h"

#import "SDLNames.h"
#import "SDLVehicleDataStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMyKey

- (void)setE911Override:(SDLVehicleDataStatus)e911Override {
    if (e911Override != nil) {
        [store setObject:e911Override forKey:SDLNameE911Override];
    } else {
        [store removeObjectForKey:SDLNameE911Override];
    }
}

- (SDLVehicleDataStatus)e911Override {
    NSObject *obj = [store objectForKey:SDLNameE911Override];
    return (SDLVehicleDataStatus)obj;
}

@end

NS_ASSUME_NONNULL_END
