//  SDLBeltStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataEventStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLBeltStatus : SDLRPCStruct

@property (strong, nonatomic) SDLVehicleDataEventStatus driverBeltDeployed;
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerBeltDeployed;
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerBuckleBelted;
@property (strong, nonatomic) SDLVehicleDataEventStatus driverBuckleBelted;
@property (strong, nonatomic) SDLVehicleDataEventStatus leftRow2BuckleBelted;
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerChildDetected;
@property (strong, nonatomic) SDLVehicleDataEventStatus rightRow2BuckleBelted;
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow2BuckleBelted;
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow3BuckleBelted;
@property (strong, nonatomic) SDLVehicleDataEventStatus leftRow3BuckleBelted;
@property (strong, nonatomic) SDLVehicleDataEventStatus rightRow3BuckleBelted;
@property (strong, nonatomic) SDLVehicleDataEventStatus leftRearInflatableBelted;
@property (strong, nonatomic) SDLVehicleDataEventStatus rightRearInflatableBelted;
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow1BeltDeployed;
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow1BuckleBelted;

@end

NS_ASSUME_NONNULL_END
