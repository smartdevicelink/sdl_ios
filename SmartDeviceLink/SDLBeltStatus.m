//  SDLBeltStatus.m
//

#import "SDLBeltStatus.h"

#import "SDLNames.h"
#import "SDLVehicleDataEventStatus.h"

@implementation SDLBeltStatus

- (void)setDriverBeltDeployed:(SDLVehicleDataEventStatus)driverBeltDeployed {
    if (driverBeltDeployed != nil) {
        [store setObject:driverBeltDeployed forKey:SDLNameDriverBeltDeployed];
    } else {
        [store removeObjectForKey:SDLNameDriverBeltDeployed];
    }
}

- (SDLVehicleDataEventStatus)driverBeltDeployed {
    NSObject *obj = [store objectForKey:SDLNameDriverBeltDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setPassengerBeltDeployed:(SDLVehicleDataEventStatus)passengerBeltDeployed {
    if (passengerBeltDeployed != nil) {
        [store setObject:passengerBeltDeployed forKey:SDLNamePassengerBeltDeployed];
    } else {
        [store removeObjectForKey:SDLNamePassengerBeltDeployed];
    }
}

- (SDLVehicleDataEventStatus)passengerBeltDeployed {
    NSObject *obj = [store objectForKey:SDLNamePassengerBeltDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setPassengerBuckleBelted:(SDLVehicleDataEventStatus)passengerBuckleBelted {
    if (passengerBuckleBelted != nil) {
        [store setObject:passengerBuckleBelted forKey:SDLNamePassengerBuckleBelted];
    } else {
        [store removeObjectForKey:SDLNamePassengerBuckleBelted];
    }
}

- (SDLVehicleDataEventStatus)passengerBuckleBelted {
    NSObject *obj = [store objectForKey:SDLNamePassengerBuckleBelted];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setDriverBuckleBelted:(SDLVehicleDataEventStatus)driverBuckleBelted {
    if (driverBuckleBelted != nil) {
        [store setObject:driverBuckleBelted forKey:SDLNameDriverBuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameDriverBuckleBelted];
    }
}

- (SDLVehicleDataEventStatus)driverBuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameDriverBuckleBelted];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setLeftRow2BuckleBelted:(SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    if (leftRow2BuckleBelted != nil) {
        [store setObject:leftRow2BuckleBelted forKey:SDLNameLeftRow2BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameLeftRow2BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameLeftRow2BuckleBelted];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setPassengerChildDetected:(SDLVehicleDataEventStatus)passengerChildDetected {
    if (passengerChildDetected != nil) {
        [store setObject:passengerChildDetected forKey:SDLNamePassengerChildDetected];
    } else {
        [store removeObjectForKey:SDLNamePassengerChildDetected];
    }
}

- (SDLVehicleDataEventStatus)passengerChildDetected {
    NSObject *obj = [store objectForKey:SDLNamePassengerChildDetected];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setRightRow2BuckleBelted:(SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    if (rightRow2BuckleBelted != nil) {
        [store setObject:rightRow2BuckleBelted forKey:SDLNameRightRow2BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameRightRow2BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameRightRow2BuckleBelted];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setMiddleRow2BuckleBelted:(SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    if (middleRow2BuckleBelted != nil) {
        [store setObject:middleRow2BuckleBelted forKey:SDLNameMiddleRow2BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameMiddleRow2BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameMiddleRow2BuckleBelted];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setMiddleRow3BuckleBelted:(SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    if (middleRow3BuckleBelted != nil) {
        [store setObject:middleRow3BuckleBelted forKey:SDLNameMiddleRow3BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameMiddleRow3BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameMiddleRow3BuckleBelted];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setLeftRow3BuckleBelted:(SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    if (leftRow3BuckleBelted != nil) {
        [store setObject:leftRow3BuckleBelted forKey:SDLNameLeftRow3BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameLeftRow3BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameLeftRow3BuckleBelted];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setRightRow3BuckleBelted:(SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    if (rightRow3BuckleBelted != nil) {
        [store setObject:rightRow3BuckleBelted forKey:SDLNameRightRow3BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameRightRow3BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameRightRow3BuckleBelted];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setLeftRearInflatableBelted:(SDLVehicleDataEventStatus)leftRearInflatableBelted {
    if (leftRearInflatableBelted != nil) {
        [store setObject:leftRearInflatableBelted forKey:SDLNameLeftRearInflatableBelted];
    } else {
        [store removeObjectForKey:SDLNameLeftRearInflatableBelted];
    }
}

- (SDLVehicleDataEventStatus)leftRearInflatableBelted {
    NSObject *obj = [store objectForKey:SDLNameLeftRearInflatableBelted];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setRightRearInflatableBelted:(SDLVehicleDataEventStatus)rightRearInflatableBelted {
    if (rightRearInflatableBelted != nil) {
        [store setObject:rightRearInflatableBelted forKey:SDLNameRightRearInflatableBelted];
    } else {
        [store removeObjectForKey:SDLNameRightRearInflatableBelted];
    }
}

- (SDLVehicleDataEventStatus)rightRearInflatableBelted {
    NSObject *obj = [store objectForKey:SDLNameRightRearInflatableBelted];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setMiddleRow1BeltDeployed:(SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    if (middleRow1BeltDeployed != nil) {
        [store setObject:middleRow1BeltDeployed forKey:SDLNameMiddleRow1BeltDeployed];
    } else {
        [store removeObjectForKey:SDLNameMiddleRow1BeltDeployed];
    }
}

- (SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    NSObject *obj = [store objectForKey:SDLNameMiddleRow1BeltDeployed];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setMiddleRow1BuckleBelted:(SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    if (middleRow1BuckleBelted != nil) {
        [store setObject:middleRow1BuckleBelted forKey:SDLNameMiddleRow1BuckleBelted];
    } else {
        [store removeObjectForKey:SDLNameMiddleRow1BuckleBelted];
    }
}

- (SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    NSObject *obj = [store objectForKey:SDLNameMiddleRow1BuckleBelted];
    return (SDLVehicleDataEventStatus)obj;
}

@end
