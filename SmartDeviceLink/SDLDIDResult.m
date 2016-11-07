//  SDLDIDResult.m
//

#import "SDLDIDResult.h"

#import "SDLNames.h"

@implementation SDLDIDResult

- (void)setResultCode:(SDLVehicleDataResultCode)resultCode {
    [self setObject:resultCode forName:SDLNameResultCode];
}

- (SDLVehicleDataResultCode)resultCode {
    return [self objectForName:SDLNameResultCode];
}

- (void)setDidLocation:(NSNumber<SDLInt> *)didLocation {
    [self setObject:didLocation forName:SDLNameDIDLocation];
}

- (NSNumber<SDLInt> *)didLocation {
    return [self objectForName:SDLNameDIDLocation];
}

- (void)setData:(NSString *)data {
    [self setObject:data forName:SDLNameData];
}

- (NSString *)data {
    return [self objectForName:SDLNameData];
}

@end
