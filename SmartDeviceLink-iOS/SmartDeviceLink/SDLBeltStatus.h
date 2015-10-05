//  SDLBeltStatus.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataEventStatus;


@interface SDLBeltStatus : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLVehicleDataEventStatus *driverBeltDeployed;
@property (strong) SDLVehicleDataEventStatus *passengerBeltDeployed;
@property (strong) SDLVehicleDataEventStatus *passengerBuckleBelted;
@property (strong) SDLVehicleDataEventStatus *driverBuckleBelted;
@property (strong) SDLVehicleDataEventStatus *leftRow2BuckleBelted;
@property (strong) SDLVehicleDataEventStatus *passengerChildDetected;
@property (strong) SDLVehicleDataEventStatus *rightRow2BuckleBelted;
@property (strong) SDLVehicleDataEventStatus *middleRow2BuckleBelted;
@property (strong) SDLVehicleDataEventStatus *middleRow3BuckleBelted;
@property (strong) SDLVehicleDataEventStatus *leftRow3BuckleBelted;
@property (strong) SDLVehicleDataEventStatus *rightRow3BuckleBelted;
@property (strong) SDLVehicleDataEventStatus *leftRearInflatableBelted;
@property (strong) SDLVehicleDataEventStatus *rightRearInflatableBelted;
@property (strong) SDLVehicleDataEventStatus *middleRow1BeltDeployed;
@property (strong) SDLVehicleDataEventStatus *middleRow1BuckleBelted;

@end
