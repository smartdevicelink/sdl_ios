//  SDLBodyInformation.m
//


#import "SDLBodyInformation.h"

#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLNames.h"

@implementation SDLBodyInformation

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setParkBrakeActive:(NSNumber *)parkBrakeActive {
    if (parkBrakeActive != nil) {
        [store setObject:parkBrakeActive forKey:SDLNameParkBrakeActive];
    } else {
        [store removeObjectForKey:SDLNameParkBrakeActive];
    }
}

- (NSNumber *)parkBrakeActive {
    return [store objectForKey:SDLNameParkBrakeActive];
}

- (void)setIgnitionStableStatus:(SDLIgnitionStableStatus *)ignitionStableStatus {
    if (ignitionStableStatus != nil) {
        [store setObject:ignitionStableStatus forKey:SDLNameIgnitionStableStatus];
    } else {
        [store removeObjectForKey:SDLNameIgnitionStableStatus];
    }
}

- (SDLIgnitionStableStatus *)ignitionStableStatus {
    NSObject *obj = [store objectForKey:SDLNameIgnitionStableStatus];
    if (obj == nil || [obj isKindOfClass:SDLIgnitionStableStatus.class]) {
        return (SDLIgnitionStableStatus *)obj;
    } else {
        return [SDLIgnitionStableStatus valueOf:(NSString *)obj];
    }
}

- (void)setIgnitionStatus:(SDLIgnitionStatus *)ignitionStatus {
    if (ignitionStatus != nil) {
        [store setObject:ignitionStatus forKey:SDLNameIgnitionStatus];
    } else {
        [store removeObjectForKey:SDLNameIgnitionStatus];
    }
}

- (SDLIgnitionStatus *)ignitionStatus {
    NSObject *obj = [store objectForKey:SDLNameIgnitionStatus];
    if (obj == nil || [obj isKindOfClass:SDLIgnitionStatus.class]) {
        return (SDLIgnitionStatus *)obj;
    } else {
        return [SDLIgnitionStatus valueOf:(NSString *)obj];
    }
}

- (void)setDriverDoorAjar:(NSNumber *)driverDoorAjar {
    if (driverDoorAjar != nil) {
        [store setObject:driverDoorAjar forKey:SDLNameDriverDoorAjar];
    } else {
        [store removeObjectForKey:SDLNameDriverDoorAjar];
    }
}

- (NSNumber *)driverDoorAjar {
    return [store objectForKey:SDLNameDriverDoorAjar];
}

- (void)setPassengerDoorAjar:(NSNumber *)passengerDoorAjar {
    if (passengerDoorAjar != nil) {
        [store setObject:passengerDoorAjar forKey:SDLNamePassengerDoorAjar];
    } else {
        [store removeObjectForKey:SDLNamePassengerDoorAjar];
    }
}

- (NSNumber *)passengerDoorAjar {
    return [store objectForKey:SDLNamePassengerDoorAjar];
}

- (void)setRearLeftDoorAjar:(NSNumber *)rearLeftDoorAjar {
    if (rearLeftDoorAjar != nil) {
        [store setObject:rearLeftDoorAjar forKey:SDLNameRearLeftDoorAjar];
    } else {
        [store removeObjectForKey:SDLNameRearLeftDoorAjar];
    }
}

- (NSNumber *)rearLeftDoorAjar {
    return [store objectForKey:SDLNameRearLeftDoorAjar];
}

- (void)setRearRightDoorAjar:(NSNumber *)rearRightDoorAjar {
    if (rearRightDoorAjar != nil) {
        [store setObject:rearRightDoorAjar forKey:SDLNameRearRightDoorAjar];
    } else {
        [store removeObjectForKey:SDLNameRearRightDoorAjar];
    }
}

- (NSNumber *)rearRightDoorAjar {
    return [store objectForKey:SDLNameRearRightDoorAjar];
}

@end
