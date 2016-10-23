//  SDLDIDResult.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataResultCode.h"


@interface SDLDIDResult : SDLRPCStruct

@property (strong) SDLVehicleDataResultCode resultCode;
@property (strong) NSNumber<SDLInt> *didLocation;
@property (strong) NSString *data;

@end
