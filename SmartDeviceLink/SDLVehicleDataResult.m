//  SDLVehicleDataResult.m
//

#import "SDLVehicleDataResult.h"

#import "SDLNames.h"

@implementation SDLVehicleDataResult

- (void)setDataType:(SDLVehicleDataType)dataType {
    [self setObject:dataType forName:SDLNameDataType];
}

- (SDLVehicleDataType)dataType {
    return [self objectForName:SDLNameDataType];
}

- (void)setResultCode:(SDLVehicleDataResultCode)resultCode {
    [self setObject:resultCode forName:SDLNameResultCode];
}

- (SDLVehicleDataResultCode)resultCode {
    return [self objectForName:SDLNameResultCode];
}

@end
