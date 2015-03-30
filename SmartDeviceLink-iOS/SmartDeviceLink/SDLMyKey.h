//  SDLMyKey.h
//



#import "SDLRPCMessage.h"

#import "SDLVehicleDataStatus.h"

@interface SDLMyKey : SDLRPCStruct {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataStatus* e911Override;

@end
