//  SDLDIDResult.m
//

#import "SDLDIDResult.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDIDResult

- (void)setResultCode:(SDLVehicleDataResultCode)resultCode {
    [store sdl_setObject:resultCode forName:SDLRPCParameterNameResultCode];
}

- (SDLVehicleDataResultCode)resultCode {
    return [store sdl_objectForName:SDLRPCParameterNameResultCode];
}

- (void)setDidLocation:(NSNumber<SDLInt> *)didLocation {
    [store sdl_setObject:didLocation forName:SDLRPCParameterNameDIDLocation];
}

- (NSNumber<SDLInt> *)didLocation {
    return [store sdl_objectForName:SDLRPCParameterNameDIDLocation];
}

- (void)setData:(nullable NSString *)data {
    [store sdl_setObject:data forName:SDLRPCParameterNameData];
}

- (nullable NSString *)data {
    return [store sdl_objectForName:SDLRPCParameterNameData];
}

@end

NS_ASSUME_NONNULL_END
