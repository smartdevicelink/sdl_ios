//  SDLECallInfo.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataNotificationStatus;
@class SDLECallConfirmationStatus;


@interface SDLECallInfo : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataNotificationStatus* eCallNotificationStatus;
@property(strong) SDLVehicleDataNotificationStatus* auxECallNotificationStatus;
@property(strong) SDLECallConfirmationStatus* eCallConfirmationStatus;

@end
