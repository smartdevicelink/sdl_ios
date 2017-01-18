//  SDLDIDResult.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataResultCode.h"


@interface SDLDIDResult : SDLRPCStruct

@property (strong, nonatomic) SDLVehicleDataResultCode resultCode;
@property (strong, nonatomic) NSNumber<SDLInt> *didLocation;
@property (strong, nonatomic) NSString *data;

@end
