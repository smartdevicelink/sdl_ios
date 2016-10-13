//  SDLMyKey.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataStatus;


@interface SDLMyKey : SDLRPCStruct

@property (strong) SDLVehicleDataStatus *e911Override;

@end
