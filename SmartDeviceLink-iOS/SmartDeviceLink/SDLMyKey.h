//  SDLMyKey.h
//


#import "SDLRPCMessage.h"

#import "SDLVehicleDataStatus.h"

@interface SDLMyKey : SDLRPCStruct {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLVehicleDataStatus *e911Override;

@end
