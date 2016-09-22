//  SDLECallInfo.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataNotificationStatus;
@class SDLECallConfirmationStatus;


@interface SDLECallInfo : SDLRPCStruct

@property (strong) SDLVehicleDataNotificationStatus *eCallNotificationStatus;
@property (strong) SDLVehicleDataNotificationStatus *auxECallNotificationStatus;
@property (strong) SDLECallConfirmationStatus *eCallConfirmationStatus;

@end
