//  SDLVehicleDataResult.m
//

#import "SDLVehicleDataResult.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVehicleDataResult

- (void)setDataType:(SDLVehicleDataType)dataType {
    if (dataType != nil) {
        [store setObject:dataType forKey:SDLNameDataType];
    } else {
        [store removeObjectForKey:SDLNameDataType];
    }
}

- (SDLVehicleDataType)dataType {
    NSObject *obj = [store objectForKey:SDLNameDataType];
    return (SDLVehicleDataType)obj;
}

- (void)setResultCode:(SDLVehicleDataResultCode)resultCode {
    if (resultCode != nil) {
        [store setObject:resultCode forKey:SDLNameResultCode];
    } else {
        [store removeObjectForKey:SDLNameResultCode];
    }
}

- (SDLVehicleDataResultCode)resultCode {
    NSObject *obj = [store objectForKey:SDLNameResultCode];
    return (SDLVehicleDataResultCode)obj;
}

@end

NS_ASSUME_NONNULL_END
