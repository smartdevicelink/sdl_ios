//  SDLDIDResult.m
//

#import "SDLDIDResult.h"

#import "SDLNames.h"

@implementation SDLDIDResult

- (void)setResultCode:(SDLVehicleDataResultCode)resultCode {
    [store sdl_setObject:resultCode forName:SDLNameResultCode];
}

- (SDLVehicleDataResultCode)resultCode {
    return [store sdl_objectForName:SDLNameResultCode];
}

- (void)setDidLocation:(NSNumber<SDLInt> *)didLocation {
    [store sdl_setObject:didLocation forName:SDLNameDIDLocation];
}

- (NSNumber<SDLInt> *)didLocation {
    return [store sdl_objectForName:SDLNameDIDLocation];
}

- (void)setData:(NSString *)data {
    [store sdl_setObject:data forName:SDLNameData];
}

- (NSString *)data {
    return [store sdl_objectForName:SDLNameData];
}

@end
