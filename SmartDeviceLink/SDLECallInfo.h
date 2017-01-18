//  SDLECallInfo.h
//

#import "SDLRPCMessage.h"

#import "SDLECallConfirmationStatus.h"
#import "SDLVehicleDataNotificationStatus.h"


@interface SDLECallInfo : SDLRPCStruct

@property (strong, nonatomic) SDLVehicleDataNotificationStatus eCallNotificationStatus;
@property (strong, nonatomic) SDLVehicleDataNotificationStatus auxECallNotificationStatus;
@property (strong, nonatomic) SDLECallConfirmationStatus eCallConfirmationStatus;

@end
