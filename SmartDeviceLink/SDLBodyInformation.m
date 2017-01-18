//  SDLBodyInformation.m
//


#import "SDLBodyInformation.h"

#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLNames.h"

@implementation SDLBodyInformation

- (void)setParkBrakeActive:(NSNumber<SDLBool> *)parkBrakeActive {
    if (parkBrakeActive != nil) {
        [store setObject:parkBrakeActive forKey:SDLNameParkBrakeActive];
    } else {
        [store removeObjectForKey:SDLNameParkBrakeActive];
    }
}

- (NSNumber<SDLBool> *)parkBrakeActive {
    return [store objectForKey:SDLNameParkBrakeActive];
}

- (void)setIgnitionStableStatus:(SDLIgnitionStableStatus)ignitionStableStatus {
    if (ignitionStableStatus != nil) {
        [store setObject:ignitionStableStatus forKey:SDLNameIgnitionStableStatus];
    } else {
        [store removeObjectForKey:SDLNameIgnitionStableStatus];
    }
}

- (SDLIgnitionStableStatus)ignitionStableStatus {
    NSObject *obj = [store objectForKey:SDLNameIgnitionStableStatus];
    return (SDLIgnitionStableStatus)obj;
}

- (void)setIgnitionStatus:(SDLIgnitionStatus)ignitionStatus {
    if (ignitionStatus != nil) {
        [store setObject:ignitionStatus forKey:SDLNameIgnitionStatus];
    } else {
        [store removeObjectForKey:SDLNameIgnitionStatus];
    }
}

- (SDLIgnitionStatus)ignitionStatus {
    NSObject *obj = [store objectForKey:SDLNameIgnitionStatus];
    return (SDLIgnitionStatus)obj;
}

- (void)setDriverDoorAjar:(nullable NSNumber<SDLBool> *)driverDoorAjar {
    if (driverDoorAjar != nil) {
        [store setObject:driverDoorAjar forKey:SDLNameDriverDoorAjar];
    } else {
        [store removeObjectForKey:SDLNameDriverDoorAjar];
    }
}

- (nullable NSNumber<SDLBool> *)driverDoorAjar {
    return [store objectForKey:SDLNameDriverDoorAjar];
}

- (void)setPassengerDoorAjar:(nullable NSNumber<SDLBool> *)passengerDoorAjar {
    if (passengerDoorAjar != nil) {
        [store setObject:passengerDoorAjar forKey:SDLNamePassengerDoorAjar];
    } else {
        [store removeObjectForKey:SDLNamePassengerDoorAjar];
    }
}

- (nullable NSNumber<SDLBool> *)passengerDoorAjar {
    return [store objectForKey:SDLNamePassengerDoorAjar];
}

- (void)setRearLeftDoorAjar:(nullable NSNumber<SDLBool> *)rearLeftDoorAjar {
    if (rearLeftDoorAjar != nil) {
        [store setObject:rearLeftDoorAjar forKey:SDLNameRearLeftDoorAjar];
    } else {
        [store removeObjectForKey:SDLNameRearLeftDoorAjar];
    }
}

- (nullable NSNumber<SDLBool> *)rearLeftDoorAjar {
    return [store objectForKey:SDLNameRearLeftDoorAjar];
}

- (void)setRearRightDoorAjar:(nullable NSNumber<SDLBool> *)rearRightDoorAjar {
    if (rearRightDoorAjar != nil) {
        [store setObject:rearRightDoorAjar forKey:SDLNameRearRightDoorAjar];
    } else {
        [store removeObjectForKey:SDLNameRearRightDoorAjar];
    }
}

- (nullable NSNumber<SDLBool> *)rearRightDoorAjar {
    return [store objectForKey:SDLNameRearRightDoorAjar];
}

@end
