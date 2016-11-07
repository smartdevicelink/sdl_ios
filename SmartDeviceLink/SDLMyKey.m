//  SDLMyKey.m
//

#import "SDLMyKey.h"

#import "SDLNames.h"
#import "SDLVehicleDataStatus.h"

@implementation SDLMyKey

- (void)setE911Override:(SDLVehicleDataStatus)e911Override {
    [self setObject:e911Override forName:SDLNameE911Override];
}

- (SDLVehicleDataStatus)e911Override {
    return [self objectForName:SDLNameE911Override];
}

@end
