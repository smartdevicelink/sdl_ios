//  SDLVehicleDataResult.m
//

#import "SDLVehicleDataResult.h"

#import "SDLNames.h"
#import "SDLVehicleDataResultCode.h"
#import "SDLVehicleDataType.h"

@implementation SDLVehicleDataResult

- (void)setDataType:(SDLVehicleDataType *)dataType {
    if (dataType != nil) {
        [store setObject:dataType forKey:SDLNameDataType];
    } else {
        [store removeObjectForKey:SDLNameDataType];
    }
}

- (SDLVehicleDataType *)dataType {
    NSObject *obj = [store objectForKey:SDLNameDataType];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataType.class]) {
        return (SDLVehicleDataType *)obj;
    } else {
        return [SDLVehicleDataType valueOf:(NSString *)obj];
    }
}

- (void)setResultCode:(SDLVehicleDataResultCode *)resultCode {
    if (resultCode != nil) {
        [store setObject:resultCode forKey:SDLNameResultCode];
    } else {
        [store removeObjectForKey:SDLNameResultCode];
    }
}

- (SDLVehicleDataResultCode *)resultCode {
    NSObject *obj = [store objectForKey:SDLNameResultCode];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResultCode.class]) {
        return (SDLVehicleDataResultCode *)obj;
    } else {
        return [SDLVehicleDataResultCode valueOf:(NSString *)obj];
    }
}

@end
