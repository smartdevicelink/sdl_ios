//  SDLBodyInformation.m
//


#import "SDLBodyInformation.h"

#import "NSMutableDictionary+Store.h"
#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLNames.h"

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

- (void)setDriverDoorAjar:(NSNumber<SDLBool> *)driverDoorAjar {
    [store sdl_setObject:driverDoorAjar forName:SDLNameDriverDoorAjar];
}

- (NSNumber<SDLBool> *)driverDoorAjar {
    return [store sdl_objectForName:SDLNameDriverDoorAjar];
}

- (void)setPassengerDoorAjar:(NSNumber<SDLBool> *)passengerDoorAjar {
    [store sdl_setObject:passengerDoorAjar forName:SDLNamePassengerDoorAjar];
}

- (NSNumber<SDLBool> *)passengerDoorAjar {
    return [store sdl_objectForName:SDLNamePassengerDoorAjar];
}

- (void)setRearLeftDoorAjar:(NSNumber<SDLBool> *)rearLeftDoorAjar {
    [store sdl_setObject:rearLeftDoorAjar forName:SDLNameRearLeftDoorAjar];
}

- (NSNumber<SDLBool> *)rearLeftDoorAjar {
    return [store sdl_objectForName:SDLNameRearLeftDoorAjar];
}

- (void)setRearRightDoorAjar:(NSNumber<SDLBool> *)rearRightDoorAjar {
    [store sdl_setObject:rearRightDoorAjar forName:SDLNameRearRightDoorAjar];
}

- (NSNumber<SDLBool> *)rearRightDoorAjar {
    return [store sdl_objectForName:SDLNameRearRightDoorAjar];
}

@end
