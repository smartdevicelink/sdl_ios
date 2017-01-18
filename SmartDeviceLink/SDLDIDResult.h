//  SDLDIDResult.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataResultCode.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLDIDResult : SDLRPCStruct

@property (strong) SDLVehicleDataResultCode resultCode;
@property (strong) NSNumber<SDLInt> *didLocation;
@property (nullable, strong) NSString *data;

@end

NS_ASSUME_NONNULL_END
