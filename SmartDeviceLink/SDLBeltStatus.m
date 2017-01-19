//  SDLBeltStatus.m
//

#import "SDLBeltStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLVehicleDataEventStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLBeltStatus

- (void)setDriverBeltDeployed:(SDLVehicleDataEventStatus)driverBeltDeployed {
    [store sdl_setObject:driverBeltDeployed forName:SDLNameDriverBeltDeployed];
}

- (SDLVehicleDataEventStatus)driverBeltDeployed {
    return [store sdl_objectForName:SDLNameDriverBeltDeployed];
}

- (void)setPassengerBeltDeployed:(SDLVehicleDataEventStatus)passengerBeltDeployed {
    [store sdl_setObject:passengerBeltDeployed forName:SDLNamePassengerBeltDeployed];
}

- (SDLVehicleDataEventStatus)passengerBeltDeployed {
    return [store sdl_objectForName:SDLNamePassengerBeltDeployed];
}

- (void)setPassengerBuckleBelted:(SDLVehicleDataEventStatus)passengerBuckleBelted {
    [store sdl_setObject:passengerBuckleBelted forName:SDLNamePassengerBuckleBelted];
}

- (SDLVehicleDataEventStatus)passengerBuckleBelted {
    return [store sdl_objectForName:SDLNamePassengerBuckleBelted];
}

- (void)setDriverBuckleBelted:(SDLVehicleDataEventStatus)driverBuckleBelted {
    [store sdl_setObject:driverBuckleBelted forName:SDLNameDriverBuckleBelted];
}

- (SDLVehicleDataEventStatus)driverBuckleBelted {
    return [store sdl_objectForName:SDLNameDriverBuckleBelted];
}

- (void)setLeftRow2BuckleBelted:(SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    [store sdl_setObject:leftRow2BuckleBelted forName:SDLNameLeftRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    return [store sdl_objectForName:SDLNameLeftRow2BuckleBelted];
}

- (void)setPassengerChildDetected:(SDLVehicleDataEventStatus)passengerChildDetected {
    [store sdl_setObject:passengerChildDetected forName:SDLNamePassengerChildDetected];
}

- (SDLVehicleDataEventStatus)passengerChildDetected {
    return [store sdl_objectForName:SDLNamePassengerChildDetected];
}

- (void)setRightRow2BuckleBelted:(SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    [store sdl_setObject:rightRow2BuckleBelted forName:SDLNameRightRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    return [store sdl_objectForName:SDLNameRightRow2BuckleBelted];
}

- (void)setMiddleRow2BuckleBelted:(SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    [store sdl_setObject:middleRow2BuckleBelted forName:SDLNameMiddleRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    return [store sdl_objectForName:SDLNameMiddleRow2BuckleBelted];
}

- (void)setMiddleRow3BuckleBelted:(SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    [store sdl_setObject:middleRow3BuckleBelted forName:SDLNameMiddleRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    return [store sdl_objectForName:SDLNameMiddleRow3BuckleBelted];
}

- (void)setLeftRow3BuckleBelted:(SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    [store sdl_setObject:leftRow3BuckleBelted forName:SDLNameLeftRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    return [store sdl_objectForName:SDLNameLeftRow3BuckleBelted];
}

- (void)setRightRow3BuckleBelted:(SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    [store sdl_setObject:rightRow3BuckleBelted forName:SDLNameRightRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    return [store sdl_objectForName:SDLNameRightRow3BuckleBelted];
}

- (void)setLeftRearInflatableBelted:(SDLVehicleDataEventStatus)leftRearInflatableBelted {
    [store sdl_setObject:leftRearInflatableBelted forName:SDLNameLeftRearInflatableBelted];
}

- (SDLVehicleDataEventStatus)leftRearInflatableBelted {
    return [store sdl_objectForName:SDLNameLeftRearInflatableBelted];
}

- (void)setRightRearInflatableBelted:(SDLVehicleDataEventStatus)rightRearInflatableBelted {
    [store sdl_setObject:rightRearInflatableBelted forName:SDLNameRightRearInflatableBelted];
}

- (SDLVehicleDataEventStatus)rightRearInflatableBelted {
    return [store sdl_objectForName:SDLNameRightRearInflatableBelted];
}

- (void)setMiddleRow1BeltDeployed:(SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    [store sdl_setObject:middleRow1BeltDeployed forName:SDLNameMiddleRow1BeltDeployed];
}

- (SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    return [store sdl_objectForName:SDLNameMiddleRow1BeltDeployed];
}

- (void)setMiddleRow1BuckleBelted:(SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    [store sdl_setObject:middleRow1BuckleBelted forName:SDLNameMiddleRow1BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    return [store sdl_objectForName:SDLNameMiddleRow1BuckleBelted];
}

@end

NS_ASSUME_NONNULL_END
