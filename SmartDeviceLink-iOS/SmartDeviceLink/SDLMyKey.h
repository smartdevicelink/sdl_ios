//  SDLMyKey.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataStatus;


@interface SDLMyKey : SDLRPCStruct {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLVehicleDataStatus *e911Override;

@end
