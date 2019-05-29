//  SDLDIDResult.m
//

#import "SDLDIDResult.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDIDResult

- (void)setResultCode:(SDLVehicleDataResultCode)resultCode {
    [self.store sdl_setObject:resultCode forName:SDLRPCParameterNameResultCode];
}

- (SDLVehicleDataResultCode)resultCode {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameResultCode error:&error];
}

- (void)setDidLocation:(NSNumber<SDLInt> *)didLocation {
    [self.store sdl_setObject:didLocation forName:SDLRPCParameterNameDIDLocation];
}

- (NSNumber<SDLInt> *)didLocation {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameDIDLocation ofClass:NSNumber.class error:&error];
}

- (void)setData:(nullable NSString *)data {
    [self.store sdl_setObject:data forName:SDLRPCParameterNameData];
}

- (nullable NSString *)data {
    return [self.store sdl_objectForName:SDLRPCParameterNameData ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
