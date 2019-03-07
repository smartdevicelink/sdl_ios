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
    NSError *error;
    return [store sdl_enumForName:SDLNameDataType error:&error];
}

- (void)setResultCode:(SDLVehicleDataResultCode)resultCode {
    [store sdl_setObject:resultCode forName:SDLNameResultCode];
}

- (SDLVehicleDataResultCode)resultCode {
    NSError *error;
    return [store sdl_enumForName:SDLNameResultCode error:&error];
}

@end

NS_ASSUME_NONNULL_END
