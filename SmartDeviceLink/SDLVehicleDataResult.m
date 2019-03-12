//  SDLVehicleDataResult.m
//

#import "SDLVehicleDataResult.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVehicleDataResult

- (void)setDataType:(SDLVehicleDataType)dataType {
    [store sdl_setObject:dataType forName:SDLRPCParameterNameDataType];
}

- (SDLVehicleDataType)dataType {
    return [store sdl_objectForName:SDLRPCParameterNameDataType];
}

- (void)setResultCode:(SDLVehicleDataResultCode)resultCode {
    [store sdl_setObject:resultCode forName:SDLRPCParameterNameResultCode];
}

- (SDLVehicleDataResultCode)resultCode {
    return [store sdl_objectForName:SDLRPCParameterNameResultCode];
}

@end

NS_ASSUME_NONNULL_END
