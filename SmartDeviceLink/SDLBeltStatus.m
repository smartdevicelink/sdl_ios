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
    NSError *error;
    return [store sdl_enumForName:SDLNameDriverBeltDeployed error:&error];
}

- (void)setPassengerBeltDeployed:(SDLVehicleDataEventStatus)passengerBeltDeployed {
    [store sdl_setObject:passengerBeltDeployed forName:SDLNamePassengerBeltDeployed];
}

- (SDLVehicleDataEventStatus)passengerBeltDeployed {
    NSError *error;
    return [store sdl_enumForName:SDLNamePassengerBeltDeployed error:&error];
}

- (void)setPassengerBuckleBelted:(SDLVehicleDataEventStatus)passengerBuckleBelted {
    [store sdl_setObject:passengerBuckleBelted forName:SDLNamePassengerBuckleBelted];
}

- (SDLVehicleDataEventStatus)passengerBuckleBelted {
    NSError *error;
    return [store sdl_enumForName:SDLNamePassengerBuckleBelted error:&error];
}

- (void)setDriverBuckleBelted:(SDLVehicleDataEventStatus)driverBuckleBelted {
    [store sdl_setObject:driverBuckleBelted forName:SDLNameDriverBuckleBelted];
}

- (SDLVehicleDataEventStatus)driverBuckleBelted {
    NSError *error;
    return [store sdl_enumForName:SDLNameDriverBuckleBelted error:&error];
}

- (void)setLeftRow2BuckleBelted:(SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    [store sdl_setObject:leftRow2BuckleBelted forName:SDLNameLeftRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    NSError *error;
    return [store sdl_enumForName:SDLNameLeftRow2BuckleBelted error:&error];
}

- (void)setPassengerChildDetected:(SDLVehicleDataEventStatus)passengerChildDetected {
    [store sdl_setObject:passengerChildDetected forName:SDLNamePassengerChildDetected];
}

- (SDLVehicleDataEventStatus)passengerChildDetected {
    NSError *error;
    return [store sdl_enumForName:SDLNamePassengerChildDetected error:&error];
}

- (void)setRightRow2BuckleBelted:(SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    [store sdl_setObject:rightRow2BuckleBelted forName:SDLNameRightRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    NSError *error;
    return [store sdl_enumForName:SDLNameRightRow2BuckleBelted error:&error];
}

- (void)setMiddleRow2BuckleBelted:(SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    [store sdl_setObject:middleRow2BuckleBelted forName:SDLNameMiddleRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    NSError *error;
    return [store sdl_enumForName:SDLNameMiddleRow2BuckleBelted error:&error];
}

- (void)setMiddleRow3BuckleBelted:(SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    [store sdl_setObject:middleRow3BuckleBelted forName:SDLNameMiddleRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    NSError *error;
    return [store sdl_enumForName:SDLNameMiddleRow3BuckleBelted error:&error];
}

- (void)setLeftRow3BuckleBelted:(SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    [store sdl_setObject:leftRow3BuckleBelted forName:SDLNameLeftRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    NSError *error;
    return [store sdl_enumForName:SDLNameLeftRow3BuckleBelted error:&error];
}

- (void)setRightRow3BuckleBelted:(SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    [store sdl_setObject:rightRow3BuckleBelted forName:SDLNameRightRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    NSError *error;
    return [store sdl_enumForName:SDLNameRightRow3BuckleBelted error:&error];
}

- (void)setLeftRearInflatableBelted:(SDLVehicleDataEventStatus)leftRearInflatableBelted {
    [store sdl_setObject:leftRearInflatableBelted forName:SDLNameLeftRearInflatableBelted];
}

- (SDLVehicleDataEventStatus)leftRearInflatableBelted {
    NSError *error;
    return [store sdl_enumForName:SDLNameLeftRearInflatableBelted error:&error];
}

- (void)setRightRearInflatableBelted:(SDLVehicleDataEventStatus)rightRearInflatableBelted {
    [store sdl_setObject:rightRearInflatableBelted forName:SDLNameRightRearInflatableBelted];
}

- (SDLVehicleDataEventStatus)rightRearInflatableBelted {
    NSError *error;
    return [store sdl_enumForName:SDLNameRightRearInflatableBelted error:&error];
}

- (void)setMiddleRow1BeltDeployed:(SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    [store sdl_setObject:middleRow1BeltDeployed forName:SDLNameMiddleRow1BeltDeployed];
}

- (SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    NSError *error;
    return [store sdl_enumForName:SDLNameMiddleRow1BeltDeployed error:&error];
}

- (void)setMiddleRow1BuckleBelted:(SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    [store sdl_setObject:middleRow1BuckleBelted forName:SDLNameMiddleRow1BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    NSError *error;
    return [store sdl_enumForName:SDLNameMiddleRow1BuckleBelted error:&error];
}

@end

NS_ASSUME_NONNULL_END
