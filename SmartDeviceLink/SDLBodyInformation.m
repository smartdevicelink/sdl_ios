//  SDLBodyInformation.m
//


#import "SDLBodyInformation.h"

#import "NSMutableDictionary+Store.h"
#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLBodyInformation

- (void)setParkBrakeActive:(NSNumber<SDLBool> *)parkBrakeActive {
    [store sdl_setObject:parkBrakeActive forName:SDLRPCParameterNameParkBrakeActive];
}

- (NSNumber<SDLBool> *)parkBrakeActive {
    return [store sdl_objectForName:SDLRPCParameterNameParkBrakeActive];
}

- (void)setIgnitionStableStatus:(SDLIgnitionStableStatus)ignitionStableStatus {
    [store sdl_setObject:ignitionStableStatus forName:SDLRPCParameterNameIgnitionStableStatus];
}

- (SDLIgnitionStableStatus)ignitionStableStatus {
    return [store sdl_objectForName:SDLRPCParameterNameIgnitionStableStatus];
}

- (void)setIgnitionStatus:(SDLIgnitionStatus)ignitionStatus {
    [store sdl_setObject:ignitionStatus forName:SDLRPCParameterNameIgnitionStatus];
}

- (SDLIgnitionStatus)ignitionStatus {
    return [store sdl_objectForName:SDLRPCParameterNameIgnitionStatus];
}

- (void)setDriverDoorAjar:(nullable NSNumber<SDLBool> *)driverDoorAjar {
    [store sdl_setObject:driverDoorAjar forName:SDLRPCParameterNameDriverDoorAjar];
}

- (nullable NSNumber<SDLBool> *)driverDoorAjar {
    return [store sdl_objectForName:SDLRPCParameterNameDriverDoorAjar];
}

- (void)setPassengerDoorAjar:(nullable NSNumber<SDLBool> *)passengerDoorAjar {
    [store sdl_setObject:passengerDoorAjar forName:SDLRPCParameterNamePassengerDoorAjar];
}

- (nullable NSNumber<SDLBool> *)passengerDoorAjar {
    return [store sdl_objectForName:SDLRPCParameterNamePassengerDoorAjar];
}

- (void)setRearLeftDoorAjar:(nullable NSNumber<SDLBool> *)rearLeftDoorAjar {
    [store sdl_setObject:rearLeftDoorAjar forName:SDLRPCParameterNameRearLeftDoorAjar];
}

- (nullable NSNumber<SDLBool> *)rearLeftDoorAjar {
    return [store sdl_objectForName:SDLRPCParameterNameRearLeftDoorAjar];
}

- (void)setRearRightDoorAjar:(nullable NSNumber<SDLBool> *)rearRightDoorAjar {
    [store sdl_setObject:rearRightDoorAjar forName:SDLRPCParameterNameRearRightDoorAjar];
}

- (nullable NSNumber<SDLBool> *)rearRightDoorAjar {
    return [store sdl_objectForName:SDLRPCParameterNameRearRightDoorAjar];
}

@end

NS_ASSUME_NONNULL_END
