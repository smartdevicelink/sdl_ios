//  SDLEmergencyEvent.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLEmergencyEventType.h>
#import <SmartDeviceLink/SDLFuelCutoffStatus.h>
#import <SmartDeviceLink/SDLVehicleDataEventStatus.h>

@interface SDLEmergencyEvent : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLEmergencyEventType* emergencyEventType;
@property(strong) SDLFuelCutoffStatus* fuelCutoffStatus;
@property(strong) SDLVehicleDataEventStatus* rolloverEvent;
@property(strong) NSNumber* maximumChangeVelocity;
@property(strong) SDLVehicleDataEventStatus* multipleEvents;

@end
