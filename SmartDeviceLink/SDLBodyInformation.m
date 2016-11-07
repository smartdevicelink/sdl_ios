//  SDLBodyInformation.m
//


#import "SDLBodyInformation.h"

#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLNames.h"

@implementation SDLBodyInformation

- (void)setParkBrakeActive:(NSNumber<SDLBool> *)parkBrakeActive {
    [self setObject:parkBrakeActive forName:SDLNameParkBrakeActive];
}

- (NSNumber<SDLBool> *)parkBrakeActive {
    return [self objectForName:SDLNameParkBrakeActive];
}

- (void)setIgnitionStableStatus:(SDLIgnitionStableStatus)ignitionStableStatus {
    [self setObject:ignitionStableStatus forName:SDLNameIgnitionStableStatus];
}

- (SDLIgnitionStableStatus)ignitionStableStatus {
    return [self objectForName:SDLNameIgnitionStableStatus];
}

- (void)setIgnitionStatus:(SDLIgnitionStatus)ignitionStatus {
    [self setObject:ignitionStatus forName:SDLNameIgnitionStatus];
}

- (SDLIgnitionStatus)ignitionStatus {
    return [self objectForName:SDLNameIgnitionStatus];
}

- (void)setDriverDoorAjar:(NSNumber<SDLBool> *)driverDoorAjar {
    [self setObject:driverDoorAjar forName:SDLNameDriverDoorAjar];
}

- (NSNumber<SDLBool> *)driverDoorAjar {
    return [self objectForName:SDLNameDriverDoorAjar];
}

- (void)setPassengerDoorAjar:(NSNumber<SDLBool> *)passengerDoorAjar {
    [self setObject:passengerDoorAjar forName:SDLNamePassengerDoorAjar];
}

- (NSNumber<SDLBool> *)passengerDoorAjar {
    return [self objectForName:SDLNamePassengerDoorAjar];
}

- (void)setRearLeftDoorAjar:(NSNumber<SDLBool> *)rearLeftDoorAjar {
    [self setObject:rearLeftDoorAjar forName:SDLNameRearLeftDoorAjar];
}

- (NSNumber<SDLBool> *)rearLeftDoorAjar {
    return [self objectForName:SDLNameRearLeftDoorAjar];
}

- (void)setRearRightDoorAjar:(NSNumber<SDLBool> *)rearRightDoorAjar {
    [self setObject:rearRightDoorAjar forName:SDLNameRearRightDoorAjar];
}

- (NSNumber<SDLBool> *)rearRightDoorAjar {
    return [self objectForName:SDLNameRearRightDoorAjar];
}

@end
