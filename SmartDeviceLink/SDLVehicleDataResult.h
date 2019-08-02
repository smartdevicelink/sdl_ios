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

- (instancetype)initWithDataType:(SDLVehicleDataType)dataType SDLVehicleDataResultCode:(SDLVehicleDataResultCode)resultCode;

- (instancetype)initWithOEMCustomDataType:(NSString *)customDataType SDLVehicleDataResultCode:(SDLVehicleDataResultCode)resultCode;

/**
 Defined published data element type
 */
@property (strong, nonatomic) SDLVehicleDataType dataType;

/**
 Defined published data element type
 */
@property (nullable, strong, nonatomic) NSString *oemCustomDataType;

/**
 Published data result code
 */
@property (strong, nonatomic) SDLVehicleDataResultCode resultCode;

@end

NS_ASSUME_NONNULL_END
