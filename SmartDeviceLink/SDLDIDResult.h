//  SDLDIDResult.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataResultCode.h"


@interface SDLDIDResult : SDLRPCStruct

@property (strong) SDLVehicleDataResultCode resultCode;
@property (strong) NSNumber *didLocation;
@property (strong) NSString *data;

@end
