//  SDLVehicleDataResult.m
//

#import "SDLVehicleDataResult.h"

#import "SDLNames.h"
#import "SDLVehicleDataResultCode.h"
#import "SDLVehicleDataType.h"


@implementation SDLVehicleDataResult

- (void)setDataType:(SDLVehicleDataType *)dataType {
    if (dataType != nil) {
        [store setObject:dataType forKey:NAMES_dataType];
    } else {
        [store removeObjectForKey:NAMES_dataType];
    }
}

- (SDLVehicleDataType *)dataType {
    NSObject *obj = [store objectForKey:NAMES_dataType];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataType.class]) {
        return (SDLVehicleDataType *)obj;
    } else {
        return [SDLVehicleDataType valueOf:(NSString *)obj];
    }
}

- (void)setResultCode:(SDLVehicleDataResultCode *)resultCode {
    if (resultCode != nil) {
        [store setObject:resultCode forKey:NAMES_resultCode];
    } else {
        [store removeObjectForKey:NAMES_resultCode];
    }
}

- (SDLVehicleDataResultCode *)resultCode {
    NSObject *obj = [store objectForKey:NAMES_resultCode];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataResultCode.class]) {
        return (SDLVehicleDataResultCode *)obj;
    } else {
        return [SDLVehicleDataResultCode valueOf:(NSString *)obj];
    }
}

@end
