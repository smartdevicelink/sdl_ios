//  SDLMyKey.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataStatus.h"


@interface SDLMyKey : SDLRPCStruct

@property (strong, nonatomic) SDLVehicleDataStatus e911Override;

@end
