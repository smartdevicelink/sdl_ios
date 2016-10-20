//  SDLECallInfo.h
//

#import "SDLRPCMessage.h"

#import "SDLECallConfirmationStatus.h"
#import "SDLVehicleDataNotificationStatus.h"


@interface SDLECallInfo : SDLRPCStruct

@property (strong) SDLVehicleDataNotificationStatus eCallNotificationStatus;
@property (strong) SDLVehicleDataNotificationStatus auxECallNotificationStatus;
@property (strong) SDLECallConfirmationStatus eCallConfirmationStatus;

@end
