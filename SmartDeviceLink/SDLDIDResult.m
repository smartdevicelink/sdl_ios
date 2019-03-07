//  SDLDIDResult.m
//

#import "SDLDIDResult.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDIDResult

- (void)setResultCode:(SDLVehicleDataResultCode)resultCode {
    [store sdl_setObject:resultCode forName:SDLNameResultCode];
}

- (SDLVehicleDataResultCode)resultCode {
    NSError *error;
    return [store sdl_enumForName:SDLNameResultCode error:&error];
}

- (void)setDidLocation:(NSNumber<SDLInt> *)didLocation {
    [store sdl_setObject:didLocation forName:SDLNameDIDLocation];
}

- (NSNumber<SDLInt> *)didLocation {
    NSError *error;
    return [store sdl_objectForName:SDLNameDIDLocation ofClass:NSNumber.class error:&error];
}

- (void)setData:(nullable NSString *)data {
    [store sdl_setObject:data forName:SDLNameData];
}

- (nullable NSString *)data {
    return [store sdl_objectForName:SDLNameData ofClass:NSString.class];
}

@end

NS_ASSUME_NONNULL_END
