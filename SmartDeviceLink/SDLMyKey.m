//  SDLMyKey.m
//

#import "SDLMyKey.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLVehicleDataStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMyKey

- (void)setE911Override:(SDLVehicleDataStatus)e911Override {
    [store sdl_setObject:e911Override forName:SDLNameE911Override];
}

- (SDLVehicleDataStatus)e911Override {
    NSError *error;
    return [store sdl_enumForName:SDLNameE911Override error:&error];
}

@end

NS_ASSUME_NONNULL_END
