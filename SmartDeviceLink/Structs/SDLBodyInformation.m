//  SDLBodyInformation.m
//


#import "SDLBodyInformation.h"

#import "NSMutableDictionary+Store.h"
#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLBodyInformation

- (void)setParkBrakeActive:(NSNumber<SDLBool> *)parkBrakeActive {
    [store sdl_setObject:parkBrakeActive forName:SDLNameParkBrakeActive];
}

- (NSNumber<SDLBool> *)parkBrakeActive {
    return [store sdl_objectForName:SDLNameParkBrakeActive];
}

- (void)setIgnitionStableStatus:(SDLIgnitionStableStatus)ignitionStableStatus {
    [store sdl_setObject:ignitionStableStatus forName:SDLNameIgnitionStableStatus];
}

- (SDLIgnitionStableStatus)ignitionStableStatus {
    return [store sdl_objectForName:SDLNameIgnitionStableStatus];
}

- (void)setIgnitionStatus:(SDLIgnitionStatus)ignitionStatus {
    [store sdl_setObject:ignitionStatus forName:SDLNameIgnitionStatus];
}

- (SDLIgnitionStatus)ignitionStatus {
    return [store sdl_objectForName:SDLNameIgnitionStatus];
}

- (void)setDriverDoorAjar:(nullable NSNumber<SDLBool> *)driverDoorAjar {
    [store sdl_setObject:driverDoorAjar forName:SDLNameDriverDoorAjar];
}

- (nullable NSNumber<SDLBool> *)driverDoorAjar {
    return [store sdl_objectForName:SDLNameDriverDoorAjar];
}

- (void)setPassengerDoorAjar:(nullable NSNumber<SDLBool> *)passengerDoorAjar {
    [store sdl_setObject:passengerDoorAjar forName:SDLNamePassengerDoorAjar];
}

- (nullable NSNumber<SDLBool> *)passengerDoorAjar {
    return [store sdl_objectForName:SDLNamePassengerDoorAjar];
}

- (void)setRearLeftDoorAjar:(nullable NSNumber<SDLBool> *)rearLeftDoorAjar {
    [store sdl_setObject:rearLeftDoorAjar forName:SDLNameRearLeftDoorAjar];
}

- (nullable NSNumber<SDLBool> *)rearLeftDoorAjar {
    return [store sdl_objectForName:SDLNameRearLeftDoorAjar];
}

- (void)setRearRightDoorAjar:(nullable NSNumber<SDLBool> *)rearRightDoorAjar {
    [store sdl_setObject:rearRightDoorAjar forName:SDLNameRearRightDoorAjar];
}

- (nullable NSNumber<SDLBool> *)rearRightDoorAjar {
    return [store sdl_objectForName:SDLNameRearRightDoorAjar];
}

@end

NS_ASSUME_NONNULL_END
