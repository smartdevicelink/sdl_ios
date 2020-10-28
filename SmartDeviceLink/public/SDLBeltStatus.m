//  SDLBeltStatus.m
//

#import "SDLBeltStatus.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLVehicleDataEventStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLBeltStatus

- (instancetype)initWithDriverBeltDeployed:(SDLVehicleDataEventStatus)driverBeltDeployed passengerBeltDeployed:(SDLVehicleDataEventStatus)passengerBeltDeployed passengerBuckleBelted:(SDLVehicleDataEventStatus)passengerBuckleBelted driverBuckleBelted:(SDLVehicleDataEventStatus)driverBuckleBelted leftRow2BuckleBelted:(SDLVehicleDataEventStatus)leftRow2BuckleBelted passengerChildDetected:(SDLVehicleDataEventStatus)passengerChildDetected rightRow2BuckleBelted:(SDLVehicleDataEventStatus)rightRow2BuckleBelted middleRow2BuckleBelted:(SDLVehicleDataEventStatus)middleRow2BuckleBelted middleRow3BuckleBelted:(SDLVehicleDataEventStatus)middleRow3BuckleBelted leftRow3BuckleBelted:(SDLVehicleDataEventStatus)leftRow3BuckleBelted rightRow3BuckleBelted:(SDLVehicleDataEventStatus)rightRow3BuckleBelted leftRearInflatableBelted:(SDLVehicleDataEventStatus)leftRearInflatableBelted rightRearInflatableBelted:(SDLVehicleDataEventStatus)rightRearInflatableBelted middleRow1BeltDeployed:(SDLVehicleDataEventStatus)middleRow1BeltDeployed middleRow1BuckleBelted:(SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.driverBeltDeployed = driverBeltDeployed;
    self.passengerBeltDeployed = passengerBeltDeployed;
    self.passengerBuckleBelted = passengerBuckleBelted;
    self.driverBuckleBelted = driverBuckleBelted;
    self.leftRow2BuckleBelted = leftRow2BuckleBelted;
    self.passengerChildDetected = passengerChildDetected;
    self.rightRow2BuckleBelted = rightRow2BuckleBelted;
    self.middleRow2BuckleBelted = middleRow2BuckleBelted;
    self.middleRow3BuckleBelted = middleRow3BuckleBelted;
    self.leftRow3BuckleBelted = leftRow3BuckleBelted;
    self.rightRow3BuckleBelted = rightRow3BuckleBelted;
    self.leftRearInflatableBelted = leftRearInflatableBelted;
    self.rightRearInflatableBelted = rightRearInflatableBelted;
    self.middleRow1BeltDeployed = middleRow1BeltDeployed;
    self.middleRow1BuckleBelted = middleRow1BuckleBelted;
    return self;
}

- (void)setDriverBeltDeployed:(SDLVehicleDataEventStatus)driverBeltDeployed {
    [self.store sdl_setObject:driverBeltDeployed forName:SDLRPCParameterNameDriverBeltDeployed];
}

- (SDLVehicleDataEventStatus)driverBeltDeployed {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameDriverBeltDeployed error:&error];
}

- (void)setPassengerBeltDeployed:(SDLVehicleDataEventStatus)passengerBeltDeployed {
    [self.store sdl_setObject:passengerBeltDeployed forName:SDLRPCParameterNamePassengerBeltDeployed];
}

- (SDLVehicleDataEventStatus)passengerBeltDeployed {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNamePassengerBeltDeployed error:&error];
}

- (void)setPassengerBuckleBelted:(SDLVehicleDataEventStatus)passengerBuckleBelted {
    [self.store sdl_setObject:passengerBuckleBelted forName:SDLRPCParameterNamePassengerBuckleBelted];
}

- (SDLVehicleDataEventStatus)passengerBuckleBelted {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNamePassengerBuckleBelted error:&error];
}

- (void)setDriverBuckleBelted:(SDLVehicleDataEventStatus)driverBuckleBelted {
    [self.store sdl_setObject:driverBuckleBelted forName:SDLRPCParameterNameDriverBuckleBelted];
}

- (SDLVehicleDataEventStatus)driverBuckleBelted {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameDriverBuckleBelted error:&error];
}

- (void)setLeftRow2BuckleBelted:(SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    [self.store sdl_setObject:leftRow2BuckleBelted forName:SDLRPCParameterNameLeftRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)leftRow2BuckleBelted {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameLeftRow2BuckleBelted error:&error];
}

- (void)setPassengerChildDetected:(SDLVehicleDataEventStatus)passengerChildDetected {
    [self.store sdl_setObject:passengerChildDetected forName:SDLRPCParameterNamePassengerChildDetected];
}

- (SDLVehicleDataEventStatus)passengerChildDetected {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNamePassengerChildDetected error:&error];
}

- (void)setRightRow2BuckleBelted:(SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    [self.store sdl_setObject:rightRow2BuckleBelted forName:SDLRPCParameterNameRightRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)rightRow2BuckleBelted {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameRightRow2BuckleBelted error:&error];
}

- (void)setMiddleRow2BuckleBelted:(SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    [self.store sdl_setObject:middleRow2BuckleBelted forName:SDLRPCParameterNameMiddleRow2BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow2BuckleBelted {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameMiddleRow2BuckleBelted error:&error];
}

- (void)setMiddleRow3BuckleBelted:(SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    [self.store sdl_setObject:middleRow3BuckleBelted forName:SDLRPCParameterNameMiddleRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow3BuckleBelted {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameMiddleRow3BuckleBelted error:&error];
}

- (void)setLeftRow3BuckleBelted:(SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    [self.store sdl_setObject:leftRow3BuckleBelted forName:SDLRPCParameterNameLeftRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)leftRow3BuckleBelted {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameLeftRow3BuckleBelted error:&error];
}

- (void)setRightRow3BuckleBelted:(SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    [self.store sdl_setObject:rightRow3BuckleBelted forName:SDLRPCParameterNameRightRow3BuckleBelted];
}

- (SDLVehicleDataEventStatus)rightRow3BuckleBelted {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameRightRow3BuckleBelted error:&error];
}

- (void)setLeftRearInflatableBelted:(SDLVehicleDataEventStatus)leftRearInflatableBelted {
    [self.store sdl_setObject:leftRearInflatableBelted forName:SDLRPCParameterNameLeftRearInflatableBelted];
}

- (SDLVehicleDataEventStatus)leftRearInflatableBelted {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameLeftRearInflatableBelted error:&error];
}

- (void)setRightRearInflatableBelted:(SDLVehicleDataEventStatus)rightRearInflatableBelted {
    [self.store sdl_setObject:rightRearInflatableBelted forName:SDLRPCParameterNameRightRearInflatableBelted];
}

- (SDLVehicleDataEventStatus)rightRearInflatableBelted {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameRightRearInflatableBelted error:&error];
}

- (void)setMiddleRow1BeltDeployed:(SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    [self.store sdl_setObject:middleRow1BeltDeployed forName:SDLRPCParameterNameMiddleRow1BeltDeployed];
}

- (SDLVehicleDataEventStatus)middleRow1BeltDeployed {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameMiddleRow1BeltDeployed error:&error];
}

- (void)setMiddleRow1BuckleBelted:(SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    [self.store sdl_setObject:middleRow1BuckleBelted forName:SDLRPCParameterNameMiddleRow1BuckleBelted];
}

- (SDLVehicleDataEventStatus)middleRow1BuckleBelted {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameMiddleRow1BuckleBelted error:&error];
}

@end

NS_ASSUME_NONNULL_END
