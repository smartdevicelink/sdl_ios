//  SDLEmergencyEvent.h
//


#import "SDLRPCMessage.h"

#import "SDLEmergencyEventType.h"
#import "SDLFuelCutoffStatus.h"
#import "SDLVehicleDataEventStatus.h"

@interface SDLEmergencyEvent : SDLRPCStruct {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLEmergencyEventType *emergencyEventType;
@property (strong) SDLFuelCutoffStatus *fuelCutoffStatus;
@property (strong) SDLVehicleDataEventStatus *rolloverEvent;
@property (strong) NSNumber *maximumChangeVelocity;
@property (strong) SDLVehicleDataEventStatus *multipleEvents;

@end
