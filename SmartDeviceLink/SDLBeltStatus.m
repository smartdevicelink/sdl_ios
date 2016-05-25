//  SDLBeltStatus.m
//

#import "SDLBeltStatus.h"

#import "SDLNames.h"
#import "SDLVehicleDataEventStatus.h"


@implementation SDLBeltStatus

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setDriverBeltDeployed:(SDLVehicleDataEventStatus *)driverBeltDeployed {
    if (driverBeltDeployed != nil) {
        [store setObject:driverBeltDeployed forKey:NAMES_driverBeltDeployed];
    } else {
        [store removeObjectForKey:NAMES_driverBeltDeployed];
    }
}

- (SDLVehicleDataEventStatus *)driverBeltDeployed {
    NSObject *obj = [store objectForKey:NAMES_driverBeltDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerBeltDeployed:(SDLVehicleDataEventStatus *)passengerBeltDeployed {
    if (passengerBeltDeployed != nil) {
        [store setObject:passengerBeltDeployed forKey:NAMES_passengerBeltDeployed];
    } else {
        [store removeObjectForKey:NAMES_passengerBeltDeployed];
    }
}

- (SDLVehicleDataEventStatus *)passengerBeltDeployed {
    NSObject *obj = [store objectForKey:NAMES_passengerBeltDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerBuckleBelted:(SDLVehicleDataEventStatus *)passengerBuckleBelted {
    if (passengerBuckleBelted != nil) {
        [store setObject:passengerBuckleBelted forKey:NAMES_passengerBuckleBelted];
    } else {
        [store removeObjectForKey:NAMES_passengerBuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)passengerBuckleBelted {
    NSObject *obj = [store objectForKey:NAMES_passengerBuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setDriverBuckleBelted:(SDLVehicleDataEventStatus *)driverBuckleBelted {
    if (driverBuckleBelted != nil) {
        [store setObject:driverBuckleBelted forKey:NAMES_driverBuckleBelted];
    } else {
        [store removeObjectForKey:NAMES_driverBuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)driverBuckleBelted {
    NSObject *obj = [store objectForKey:NAMES_driverBuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setLeftRow2BuckleBelted:(SDLVehicleDataEventStatus *)leftRow2BuckleBelted {
    if (leftRow2BuckleBelted != nil) {
        [store setObject:leftRow2BuckleBelted forKey:NAMES_leftRow2BuckleBelted];
    } else {
        [store removeObjectForKey:NAMES_leftRow2BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)leftRow2BuckleBelted {
    NSObject *obj = [store objectForKey:NAMES_leftRow2BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerChildDetected:(SDLVehicleDataEventStatus *)passengerChildDetected {
    if (passengerChildDetected != nil) {
        [store setObject:passengerChildDetected forKey:NAMES_passengerChildDetected];
    } else {
        [store removeObjectForKey:NAMES_passengerChildDetected];
    }
}

- (SDLVehicleDataEventStatus *)passengerChildDetected {
    NSObject *obj = [store objectForKey:NAMES_passengerChildDetected];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setRightRow2BuckleBelted:(SDLVehicleDataEventStatus *)rightRow2BuckleBelted {
    if (rightRow2BuckleBelted != nil) {
        [store setObject:rightRow2BuckleBelted forKey:NAMES_rightRow2BuckleBelted];
    } else {
        [store removeObjectForKey:NAMES_rightRow2BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)rightRow2BuckleBelted {
    NSObject *obj = [store objectForKey:NAMES_rightRow2BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setMiddleRow2BuckleBelted:(SDLVehicleDataEventStatus *)middleRow2BuckleBelted {
    if (middleRow2BuckleBelted != nil) {
        [store setObject:middleRow2BuckleBelted forKey:NAMES_middleRow2BuckleBelted];
    } else {
        [store removeObjectForKey:NAMES_middleRow2BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)middleRow2BuckleBelted {
    NSObject *obj = [store objectForKey:NAMES_middleRow2BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setMiddleRow3BuckleBelted:(SDLVehicleDataEventStatus *)middleRow3BuckleBelted {
    if (middleRow3BuckleBelted != nil) {
        [store setObject:middleRow3BuckleBelted forKey:NAMES_middleRow3BuckleBelted];
    } else {
        [store removeObjectForKey:NAMES_middleRow3BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)middleRow3BuckleBelted {
    NSObject *obj = [store objectForKey:NAMES_middleRow3BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setLeftRow3BuckleBelted:(SDLVehicleDataEventStatus *)leftRow3BuckleBelted {
    if (leftRow3BuckleBelted != nil) {
        [store setObject:leftRow3BuckleBelted forKey:NAMES_leftRow3BuckleBelted];
    } else {
        [store removeObjectForKey:NAMES_leftRow3BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)leftRow3BuckleBelted {
    NSObject *obj = [store objectForKey:NAMES_leftRow3BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setRightRow3BuckleBelted:(SDLVehicleDataEventStatus *)rightRow3BuckleBelted {
    if (rightRow3BuckleBelted != nil) {
        [store setObject:rightRow3BuckleBelted forKey:NAMES_rightRow3BuckleBelted];
    } else {
        [store removeObjectForKey:NAMES_rightRow3BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)rightRow3BuckleBelted {
    NSObject *obj = [store objectForKey:NAMES_rightRow3BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setLeftRearInflatableBelted:(SDLVehicleDataEventStatus *)leftRearInflatableBelted {
    if (leftRearInflatableBelted != nil) {
        [store setObject:leftRearInflatableBelted forKey:NAMES_leftRearInflatableBelted];
    } else {
        [store removeObjectForKey:NAMES_leftRearInflatableBelted];
    }
}

- (SDLVehicleDataEventStatus *)leftRearInflatableBelted {
    NSObject *obj = [store objectForKey:NAMES_leftRearInflatableBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setRightRearInflatableBelted:(SDLVehicleDataEventStatus *)rightRearInflatableBelted {
    if (rightRearInflatableBelted != nil) {
        [store setObject:rightRearInflatableBelted forKey:NAMES_rightRearInflatableBelted];
    } else {
        [store removeObjectForKey:NAMES_rightRearInflatableBelted];
    }
}

- (SDLVehicleDataEventStatus *)rightRearInflatableBelted {
    NSObject *obj = [store objectForKey:NAMES_rightRearInflatableBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setMiddleRow1BeltDeployed:(SDLVehicleDataEventStatus *)middleRow1BeltDeployed {
    if (middleRow1BeltDeployed != nil) {
        [store setObject:middleRow1BeltDeployed forKey:NAMES_middleRow1BeltDeployed];
    } else {
        [store removeObjectForKey:NAMES_middleRow1BeltDeployed];
    }
}

- (SDLVehicleDataEventStatus *)middleRow1BeltDeployed {
    NSObject *obj = [store objectForKey:NAMES_middleRow1BeltDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setMiddleRow1BuckleBelted:(SDLVehicleDataEventStatus *)middleRow1BuckleBelted {
    if (middleRow1BuckleBelted != nil) {
        [store setObject:middleRow1BuckleBelted forKey:NAMES_middleRow1BuckleBelted];
    } else {
        [store removeObjectForKey:NAMES_middleRow1BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)middleRow1BuckleBelted {
    NSObject *obj = [store objectForKey:NAMES_middleRow1BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

@end
