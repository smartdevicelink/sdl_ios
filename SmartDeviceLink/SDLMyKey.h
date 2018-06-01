//  SDLMyKey.h
//

#import "SDLRPCMessage.h"
#import "SDLVehicleDataStatus.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Vehicle Data struct
 */
@interface SDLMyKey : SDLRPCStruct

/**
 Indicates whether e911 override is on.  References signal "MyKey_e911Override_St". See VehicleDataStatus.
 */
@property (strong, nonatomic) SDLVehicleDataStatus e911Override;

@end

NS_ASSUME_NONNULL_END
