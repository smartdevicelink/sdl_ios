//  SDLDIDResult.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataResultCode.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A vehicle data struct
 */
@interface SDLDIDResult : SDLRPCStruct

/**
 Individual DID result code.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataResultCode resultCode;

/**
 Location of raw data from vehicle data DID

 Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *didLocation;

/**
 Raw DID-based data returned for requested element.

 Optional
 */
@property (nullable, strong, nonatomic) NSString *data;

@end

NS_ASSUME_NONNULL_END
