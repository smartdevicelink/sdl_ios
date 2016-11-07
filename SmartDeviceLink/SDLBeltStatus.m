//  SDLBeltStatus.m
//

#import "SDLBeltStatus.h"

#import "SDLNames.h"
#import "SDLVehicleDataEventStatus.h"

@implementation SDLBeltStatus

- (void)setDriverBeltDeployed:(SDLVehicleDataEventStatus)driverBeltDeployed {
    [self setObject:driverBeltDeployed forName:SDLNameDriverBeltDeployed];
}

- (SDLVehicleDataEventStatus)driverBeltDeployed {
    return [self objectForName:SDLNameDriverBeltDeployed];
}

- (void)setPassengerBeltDeployed:(SDLVehicleDataEventStatus)passengerBeltDeployed {
    [self setObject:passengerBeltDeployed forName:SDLNamePassengerBeltDeployed];
}

- (SDLVehicleDataEventStatus)passengerBeltDeployed {
    return [self objectForName:SDLNamePassengerBeltDeployed];
}

- (void)setPassengerBuckleBelted:(SDLVehicleDataEventStatus)passengerBuckleBelted {
    [self setObject:passengerBuckleBelted forName:SDLNamePassengerBuckleBelted];
}

- (SDLVehicleDataEventStatus)passengerBuckleBelted {
    return [self objectForName:SDLNamePassengerBuckleBelted];
}

- (void)setDriverBuckleBelted:(SDLVehicleDataEventStatus)driverBuckleBelted {
    [self setObject:driverBuckleBelted forName:SDLNameDriverBuckleBelted];
}

- (SDLVehicleDataEventStatus)driverBuckleBelted {
    return [self objectForName:SDLNameDriverBuckleBelted];
}

- (void)setLeftRow2BuckleBelted:(SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    [self setObject:leftRow2BuckleBelted forName:SDLNameLeftRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    return [self objectForName:SDLNameLeftRow2BuckleBelted];
}

- (void)setPassengerChildDetected:(SDLVehicleDataEventStatus)passengerChildDetected {
    [self setObject:passengerChildDetected forName:SDLNamePassengerChildDetected];
}

- (SDLVehicleDataEventStatus)passengerChildDetected {
    return [self objectForName:SDLNamePassengerChildDetected];
}

- (void)setRightRow2BuckleBelted:(SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    [self setObject:rightRow2BuckleBelted forName:SDLNameRightRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    return [self objectForName:SDLNameRightRow2BuckleBelted];
}

- (void)setMiddleRow2BuckleBelted:(SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    [self setObject:middleRow2BuckleBelted forName:SDLNameMiddleRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    return [self objectForName:SDLNameMiddleRow2BuckleBelted];
}

- (void)setMiddleRow3BuckleBelted:(SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    [self setObject:middleRow3BuckleBelted forName:SDLNameMiddleRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    return [self objectForName:SDLNameMiddleRow3BuckleBelted];
}

- (void)setLeftRow3BuckleBelted:(SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    [self setObject:leftRow3BuckleBelted forName:SDLNameLeftRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    return [self objectForName:SDLNameLeftRow3BuckleBelted];
}

- (void)setRightRow3BuckleBelted:(SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    [self setObject:rightRow3BuckleBelted forName:SDLNameRightRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    return [self objectForName:SDLNameRightRow3BuckleBelted];
}

- (void)setLeftRearInflatableBelted:(SDLVehicleDataEventStatus)leftRearInflatableBelted {
    [self setObject:leftRearInflatableBelted forName:SDLNameLeftRearInflatableBelted];
}

- (SDLVehicleDataEventStatus)leftRearInflatableBelted {
    return [self objectForName:SDLNameLeftRearInflatableBelted];
}

- (void)setRightRearInflatableBelted:(SDLVehicleDataEventStatus)rightRearInflatableBelted {
    [self setObject:rightRearInflatableBelted forName:SDLNameRightRearInflatableBelted];
}

- (SDLVehicleDataEventStatus)rightRearInflatableBelted {
    return [self objectForName:SDLNameRightRearInflatableBelted];
}

- (void)setMiddleRow1BeltDeployed:(SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    [self setObject:middleRow1BeltDeployed forName:SDLNameMiddleRow1BeltDeployed];
}

- (SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    return [self objectForName:SDLNameMiddleRow1BeltDeployed];
}

- (void)setMiddleRow1BuckleBelted:(SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    [self setObject:middleRow1BuckleBelted forName:SDLNameMiddleRow1BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    return [self objectForName:SDLNameMiddleRow1BuckleBelted];
}

@end
