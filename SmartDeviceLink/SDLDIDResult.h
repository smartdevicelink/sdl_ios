//  SDLDIDResult.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataResultCode.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLDIDResult : SDLRPCStruct

@property (strong, nonatomic) SDLVehicleDataResultCode resultCode;
@property (strong, nonatomic) NSNumber<SDLInt> *didLocation;
@property (nullable, strong, nonatomic) NSString *data;

@end

NS_ASSUME_NONNULL_END
