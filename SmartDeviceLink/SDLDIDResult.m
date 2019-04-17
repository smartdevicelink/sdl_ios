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
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameResultCode error:&error];
}

- (void)setDidLocation:(NSNumber<SDLInt> *)didLocation {
    [store sdl_setObject:didLocation forName:SDLRPCParameterNameDIDLocation];
}

- (NSNumber<SDLInt> *)didLocation {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameDIDLocation ofClass:NSNumber.class error:&error];
}

- (void)setData:(nullable NSString *)data {
    [store sdl_setObject:data forName:SDLRPCParameterNameData];
}

- (nullable NSString *)data {
    return [store sdl_objectForName:SDLRPCParameterNameData ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
