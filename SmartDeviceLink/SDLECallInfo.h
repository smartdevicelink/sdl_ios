//  SDLECallInfo.h
//

#import "SDLRPCMessage.h"

#import "SDLECallConfirmationStatus.h"
#import "SDLVehicleDataNotificationStatus.h"


@interface SDLECallInfo : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLVehicleDataNotificationStatus eCallNotificationStatus;
@property (strong) SDLVehicleDataNotificationStatus auxECallNotificationStatus;
@property (strong) SDLECallConfirmationStatus eCallConfirmationStatus;

@end
