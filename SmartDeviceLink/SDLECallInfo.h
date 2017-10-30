//  SDLECallInfo.h
//

#import "SDLRPCMessage.h"

#import "SDLECallConfirmationStatus.h"
#import "SDLVehicleDataNotificationStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLECallInfo : SDLRPCStruct

@property (strong, nonatomic) SDLVehicleDataNotificationStatus eCallNotificationStatus;
@property (strong, nonatomic) SDLVehicleDataNotificationStatus auxECallNotificationStatus;
@property (strong, nonatomic) SDLECallConfirmationStatus eCallConfirmationStatus;

@end

NS_ASSUME_NONNULL_END
