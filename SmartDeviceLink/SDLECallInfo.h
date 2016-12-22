//  SDLECallInfo.h
//

#import "SDLRPCMessage.h"

#import "SDLECallConfirmationStatus.h"
#import "SDLVehicleDataNotificationStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLECallInfo : SDLRPCStruct

@property (strong) SDLVehicleDataNotificationStatus eCallNotificationStatus;
@property (strong) SDLVehicleDataNotificationStatus auxECallNotificationStatus;
@property (strong) SDLECallConfirmationStatus eCallConfirmationStatus;

@end

NS_ASSUME_NONNULL_END
