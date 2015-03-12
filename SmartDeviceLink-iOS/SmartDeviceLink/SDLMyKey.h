//  SDLMyKey.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataStatus;


@interface SDLMyKey : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataStatus* e911Override;

@end
