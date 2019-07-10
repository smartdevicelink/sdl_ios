//  SDLMyKey.m
//

#import "SDLMyKey.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLVehicleDataStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMyKey

- (void)setE911Override:(SDLVehicleDataStatus)e911Override {
    [self.store sdl_setObject:e911Override forName:SDLRPCParameterNameE911Override];
}

- (SDLVehicleDataStatus)e911Override {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameE911Override error:&error];
}

@end

NS_ASSUME_NONNULL_END
