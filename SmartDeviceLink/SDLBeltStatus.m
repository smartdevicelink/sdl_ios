//  SDLBeltStatus.m
//

#import "SDLBeltStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLVehicleDataEventStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLBeltStatus

- (void)setDriverBeltDeployed:(SDLVehicleDataEventStatus)driverBeltDeployed {
    [store sdl_setObject:driverBeltDeployed forName:SDLRPCParameterNameDriverBeltDeployed];
}

- (SDLVehicleDataEventStatus)driverBeltDeployed {
    return [store sdl_objectForName:SDLRPCParameterNameDriverBeltDeployed];
}

- (void)setPassengerBeltDeployed:(SDLVehicleDataEventStatus)passengerBeltDeployed {
    [store sdl_setObject:passengerBeltDeployed forName:SDLRPCParameterNamePassengerBeltDeployed];
}

- (SDLVehicleDataEventStatus)passengerBeltDeployed {
    return [store sdl_objectForName:SDLRPCParameterNamePassengerBeltDeployed];
}

- (void)setPassengerBuckleBelted:(SDLVehicleDataEventStatus)passengerBuckleBelted {
    [store sdl_setObject:passengerBuckleBelted forName:SDLRPCParameterNamePassengerBuckleBelted];
}

- (SDLVehicleDataEventStatus)passengerBuckleBelted {
    return [store sdl_objectForName:SDLRPCParameterNamePassengerBuckleBelted];
}

- (void)setDriverBuckleBelted:(SDLVehicleDataEventStatus)driverBuckleBelted {
    [store sdl_setObject:driverBuckleBelted forName:SDLRPCParameterNameDriverBuckleBelted];
}

- (SDLVehicleDataEventStatus)driverBuckleBelted {
    return [store sdl_objectForName:SDLRPCParameterNameDriverBuckleBelted];
}

- (void)setLeftRow2BuckleBelted:(SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    [store sdl_setObject:leftRow2BuckleBelted forName:SDLRPCParameterNameLeftRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    return [store sdl_objectForName:SDLRPCParameterNameLeftRow2BuckleBelted];
}

- (void)setPassengerChildDetected:(SDLVehicleDataEventStatus)passengerChildDetected {
    [store sdl_setObject:passengerChildDetected forName:SDLRPCParameterNamePassengerChildDetected];
}

- (SDLVehicleDataEventStatus)passengerChildDetected {
    return [store sdl_objectForName:SDLRPCParameterNamePassengerChildDetected];
}

- (void)setRightRow2BuckleBelted:(SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    [store sdl_setObject:rightRow2BuckleBelted forName:SDLRPCParameterNameRightRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    return [store sdl_objectForName:SDLRPCParameterNameRightRow2BuckleBelted];
}

- (void)setMiddleRow2BuckleBelted:(SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    [store sdl_setObject:middleRow2BuckleBelted forName:SDLRPCParameterNameMiddleRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    return [store sdl_objectForName:SDLRPCParameterNameMiddleRow2BuckleBelted];
}

- (void)setMiddleRow3BuckleBelted:(SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    [store sdl_setObject:middleRow3BuckleBelted forName:SDLRPCParameterNameMiddleRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    return [store sdl_objectForName:SDLRPCParameterNameMiddleRow3BuckleBelted];
}

- (void)setLeftRow3BuckleBelted:(SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    [store sdl_setObject:leftRow3BuckleBelted forName:SDLRPCParameterNameLeftRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    return [store sdl_objectForName:SDLRPCParameterNameLeftRow3BuckleBelted];
}

- (void)setRightRow3BuckleBelted:(SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    [store sdl_setObject:rightRow3BuckleBelted forName:SDLRPCParameterNameRightRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    return [store sdl_objectForName:SDLRPCParameterNameRightRow3BuckleBelted];
}

- (void)setLeftRearInflatableBelted:(SDLVehicleDataEventStatus)leftRearInflatableBelted {
    [store sdl_setObject:leftRearInflatableBelted forName:SDLRPCParameterNameLeftRearInflatableBelted];
}

- (SDLVehicleDataEventStatus)leftRearInflatableBelted {
    return [store sdl_objectForName:SDLRPCParameterNameLeftRearInflatableBelted];
}

- (void)setRightRearInflatableBelted:(SDLVehicleDataEventStatus)rightRearInflatableBelted {
    [store sdl_setObject:rightRearInflatableBelted forName:SDLRPCParameterNameRightRearInflatableBelted];
}

- (SDLVehicleDataEventStatus)rightRearInflatableBelted {
    return [store sdl_objectForName:SDLRPCParameterNameRightRearInflatableBelted];
}

- (void)setMiddleRow1BeltDeployed:(SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    [store sdl_setObject:middleRow1BeltDeployed forName:SDLRPCParameterNameMiddleRow1BeltDeployed];
}

- (SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    return [store sdl_objectForName:SDLRPCParameterNameMiddleRow1BeltDeployed];
}

- (void)setMiddleRow1BuckleBelted:(SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    [store sdl_setObject:middleRow1BuckleBelted forName:SDLRPCParameterNameMiddleRow1BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    return [store sdl_objectForName:SDLRPCParameterNameMiddleRow1BuckleBelted];
}

@end

NS_ASSUME_NONNULL_END
