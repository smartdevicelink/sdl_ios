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
 *  Convenience init for creating a SDLVehicleDataResult with a dataType
 *
 *  @param dataType The Vehicle DataType data
 *  @param resultCode The VehicleData ResultCode data
 */
- (instancetype)initWithDataType:(SDLVehicleDataType)dataType resultCode:(SDLVehicleDataResultCode)resultCode;

/**
 *  Convenience init for creating a SDLVehicleDataResult with a customDataType
 *
 *  @param customDataType The custom dataType data
 *  @param resultCode The VehicleData ResultCode data
 */
- (instancetype)initWithCustomOEMDataType:(NSString *)customDataType resultCode:(SDLVehicleDataResultCode)resultCode;

/**
 Defined published data element type
 */
@property (strong, nonatomic) SDLVehicleDataType dataType;

/**
 OEM custom defined published data element type
 
 Added SmartDeviceLink 6.0
 */
@property (nullable, strong, nonatomic) NSString *customOEMDataType;

/**
 Published data result code
 */
@property (strong, nonatomic) SDLVehicleDataResultCode resultCode;

@end

NS_ASSUME_NONNULL_END
