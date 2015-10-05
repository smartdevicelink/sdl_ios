//  SDLEmergencyEvent.h
//

#import "SDLRPCMessage.h"

@class SDLEmergencyEventType;
@class SDLFuelCutoffStatus;
@class SDLVehicleDataEventStatus;


@interface SDLEmergencyEvent : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLEmergencyEventType *emergencyEventType;
@property (strong) SDLFuelCutoffStatus *fuelCutoffStatus;
@property (strong) SDLVehicleDataEventStatus *rolloverEvent;
@property (strong) NSNumber *maximumChangeVelocity;
@property (strong) SDLVehicleDataEventStatus *multipleEvents;

@end
