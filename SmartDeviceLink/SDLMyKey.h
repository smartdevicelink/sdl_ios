//  SDLMyKey.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataStatus.h"


@interface SDLMyKey : SDLRPCStruct

@property (strong) SDLVehicleDataStatus e911Override;

@end
