//  SDLMyKey.h
//

#import "SDLRPCMessage.h"
#import "SDLVehicleDataStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMyKey : SDLRPCStruct

@property (strong, nonatomic) SDLVehicleDataStatus e911Override;

@end

NS_ASSUME_NONNULL_END
