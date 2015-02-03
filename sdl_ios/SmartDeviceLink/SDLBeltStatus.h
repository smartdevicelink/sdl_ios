//  SDLBeltStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLVehicleDataEventStatus.h>

@interface SDLBeltStatus : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataEventStatus* driverBeltDeployed;
@property(strong) SDLVehicleDataEventStatus* passengerBeltDeployed;
@property(strong) SDLVehicleDataEventStatus* passengerBuckleBelted;
@property(strong) SDLVehicleDataEventStatus* driverBuckleBelted;
@property(strong) SDLVehicleDataEventStatus* leftRow2BuckleBelted;
@property(strong) SDLVehicleDataEventStatus* passengerChildDetected;
@property(strong) SDLVehicleDataEventStatus* rightRow2BuckleBelted;
@property(strong) SDLVehicleDataEventStatus* middleRow2BuckleBelted;
@property(strong) SDLVehicleDataEventStatus* middleRow3BuckleBelted;
@property(strong) SDLVehicleDataEventStatus* leftRow3BuckleBelted;
@property(strong) SDLVehicleDataEventStatus* rightRow3BuckleBelted;
@property(strong) SDLVehicleDataEventStatus* leftRearInflatableBelted;
@property(strong) SDLVehicleDataEventStatus* rightRearInflatableBelted;
@property(strong) SDLVehicleDataEventStatus* middleRow1BeltDeployed;
@property(strong) SDLVehicleDataEventStatus* middleRow1BuckleBelted;

@end
