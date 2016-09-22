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
        [store setObject:driverBeltDeployed forKey:SDLNameDriverBeltDeployed];
    } else {
        [store removeObjectForKey:SDLNameDriverBeltDeployed];
    }
}

- (SDLVehicleDataEventStatus *)driverBeltDeployed {
    NSObject *obj = [store objectForKey:SDLNameDriverBeltDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerBeltDeployed:(SDLVehicleDataEventStatus *)passengerBeltDeployed {
    if (passengerBeltDeployed != nil) {
        [store setObject:passengerBeltDeployed forKey:SDLNamePassengerBeltDeployed];
    } else {
        [store removeObjectForKey:SDLNamePassengerBeltDeployed];
    }
}

- (SDLVehicleDataEventStatus *)passengerBeltDeployed {
    NSObject *obj = [store objectForKey:SDLNamePassengerBeltDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerBuckleBelted:(SDLVehicleDataEventStatus *)passengerBuckleBelted {
    if (passengerBuckleBelted != nil) {
        [store setObject:passengerBuckleBelted forKey:SDLNamePassengerBuckleBelted];
    } else {
        [store removeObjectForKey:SDLNamePassengerBuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)passengerBuckleBelted {
    NSObject *obj = [store objectForKey:SDLNamePassengerBuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setDriverBuckleBelted:(SDLVehicleDataEventStatus *)driverBuckleBelted {
    if (driverBuckleBelted != nil) {
        [store setObject:driverBuckleBelted forKey:SDLNameDriverBuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameDriverBuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)driverBuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameDriverBuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setLeftRow2BuckleBelted:(SDLVehicleDataEventStatus *)leftRow2BuckleBelted {
    if (leftRow2BuckleBelted != nil) {
        [store setObject:leftRow2BuckleBelted forKey:SDLNameLeftRow2BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameLeftRow2BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)leftRow2BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameLeftRow2BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setPassengerChildDetected:(SDLVehicleDataEventStatus *)passengerChildDetected {
    if (passengerChildDetected != nil) {
        [store setObject:passengerChildDetected forKey:SDLNamePassengerChildDetected];
    } else {
        [store removeObjectForKey:SDLNamePassengerChildDetected];
    }
}

- (SDLVehicleDataEventStatus *)passengerChildDetected {
    NSObject *obj = [store objectForKey:SDLNamePassengerChildDetected];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setRightRow2BuckleBelted:(SDLVehicleDataEventStatus *)rightRow2BuckleBelted {
    if (rightRow2BuckleBelted != nil) {
        [store setObject:rightRow2BuckleBelted forKey:SDLNameRightRow2BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameRightRow2BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)rightRow2BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameRightRow2BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setMiddleRow2BuckleBelted:(SDLVehicleDataEventStatus *)middleRow2BuckleBelted {
    if (middleRow2BuckleBelted != nil) {
        [store setObject:middleRow2BuckleBelted forKey:SDLNameMiddleRow2BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameMiddleRow2BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)middleRow2BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameMiddleRow2BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setMiddleRow3BuckleBelted:(SDLVehicleDataEventStatus *)middleRow3BuckleBelted {
    if (middleRow3BuckleBelted != nil) {
        [store setObject:middleRow3BuckleBelted forKey:SDLNameMiddleRow3BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameMiddleRow3BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)middleRow3BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameMiddleRow3BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setLeftRow3BuckleBelted:(SDLVehicleDataEventStatus *)leftRow3BuckleBelted {
    if (leftRow3BuckleBelted != nil) {
        [store setObject:leftRow3BuckleBelted forKey:SDLNameLeftRow3BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameLeftRow3BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)leftRow3BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameLeftRow3BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setRightRow3BuckleBelted:(SDLVehicleDataEventStatus *)rightRow3BuckleBelted {
    if (rightRow3BuckleBelted != nil) {
        [store setObject:rightRow3BuckleBelted forKey:SDLNameRightRow3BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameRightRow3BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)rightRow3BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameRightRow3BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setLeftRearInflatableBelted:(SDLVehicleDataEventStatus *)leftRearInflatableBelted {
    if (leftRearInflatableBelted != nil) {
        [store setObject:leftRearInflatableBelted forKey:SDLNameLeftRearInflatableBelted];
    } else {
        [store removeObjectForKey:SDLNameLeftRearInflatableBelted];
    }
}

- (SDLVehicleDataEventStatus *)leftRearInflatableBelted {
    NSObject *obj = [store objectForKey:SDLNameLeftRearInflatableBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setRightRearInflatableBelted:(SDLVehicleDataEventStatus *)rightRearInflatableBelted {
    if (rightRearInflatableBelted != nil) {
        [store setObject:rightRearInflatableBelted forKey:SDLNameRightRearInflatableBelted];
    } else {
        [store removeObjectForKey:SDLNameRightRearInflatableBelted];
    }
}

- (SDLVehicleDataEventStatus *)rightRearInflatableBelted {
    NSObject *obj = [store objectForKey:SDLNameRightRearInflatableBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setMiddleRow1BeltDeployed:(SDLVehicleDataEventStatus *)middleRow1BeltDeployed {
    if (middleRow1BeltDeployed != nil) {
        [store setObject:middleRow1BeltDeployed forKey:SDLNameMiddleRow1BeltDeployed];
    } else {
        [store removeObjectForKey:SDLNameMiddleRow1BeltDeployed];
    }
}

- (SDLVehicleDataEventStatus *)middleRow1BeltDeployed {
    NSObject *obj = [store objectForKey:SDLNameMiddleRow1BeltDeployed];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setMiddleRow1BuckleBelted:(SDLVehicleDataEventStatus *)middleRow1BuckleBelted {
    if (middleRow1BuckleBelted != nil) {
        [store setObject:middleRow1BuckleBelted forKey:SDLNameMiddleRow1BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameMiddleRow1BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus *)middleRow1BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameMiddleRow1BuckleBelted];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

@end
