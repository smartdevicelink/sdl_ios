//  SDLECallInfo.h
//



#import "SDLRPCMessage.h"

#import "SDLVehicleDataNotificationStatus.h"
#import "SDLECallConfirmationStatus.h"

@interface SDLECallInfo : SDLRPCStruct {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataNotificationStatus* eCallNotificationStatus;
@property(strong) SDLVehicleDataNotificationStatus* auxECallNotificationStatus;
@property(strong) SDLECallConfirmationStatus* eCallConfirmationStatus;

@end
