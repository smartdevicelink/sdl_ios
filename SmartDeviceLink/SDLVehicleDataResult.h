//  SDLVehicleDataResult.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataType.h"
#import "SDLVehicleDataResultCode.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Individual published data request result
 */
@interface SDLVehicleDataResult : SDLRPCStruct

/**
 Defined published data element type
 */
@property (strong, nonatomic) SDLVehicleDataType dataType __deprecated_msg("Use customDataType parameter");

/**
 Defined published data element type
 */
@property (strong, nonatomic) NSString *customDataType;

/**
 Published data result code
 */
@property (strong, nonatomic) SDLVehicleDataResultCode resultCode;

@end

NS_ASSUME_NONNULL_END
