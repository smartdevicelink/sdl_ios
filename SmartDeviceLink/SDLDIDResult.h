//  SDLDIDResult.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataResultCode;


@interface SDLDIDResult : SDLRPCStruct

@property (strong) SDLVehicleDataResultCode *resultCode;
@property (strong) NSNumber *didLocation;
@property (strong) NSString *data;

@end
