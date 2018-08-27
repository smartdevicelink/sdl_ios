//  SDLECallInfo.h
//

#import "SDLRPCMessage.h"

#import "SDLECallConfirmationStatus.h"
#import "SDLVehicleDataNotificationStatus.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A vehicle data struct for emergency call information
 */
@interface SDLECallInfo : SDLRPCStruct

/**
 References signal "eCallNotification_4A". See VehicleDataNotificationStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataNotificationStatus eCallNotificationStatus;

/**
 References signal "eCallNotification". See VehicleDataNotificationStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataNotificationStatus auxECallNotificationStatus;

/**
 References signal "eCallConfirmation". See ECallConfirmationStatus.

 Required
 */
@property (strong, nonatomic) SDLECallConfirmationStatus eCallConfirmationStatus;

@end

NS_ASSUME_NONNULL_END
