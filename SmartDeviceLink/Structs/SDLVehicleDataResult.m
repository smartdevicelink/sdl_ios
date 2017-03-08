//  SDLVehicleDataResult.m
//

#import "SDLVehicleDataResult.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVehicleDataResult

- (void)setDataType:(SDLVehicleDataType)dataType {
    [store sdl_setObject:dataType forName:SDLNameDataType];
}

- (SDLVehicleDataType)dataType {
    return [store sdl_objectForName:SDLNameDataType];
}

- (void)setResultCode:(SDLVehicleDataResultCode)resultCode {
    [store sdl_setObject:resultCode forName:SDLNameResultCode];
}

- (SDLVehicleDataResultCode)resultCode {
    return [store sdl_objectForName:SDLNameResultCode];
}

@end

NS_ASSUME_NONNULL_END
