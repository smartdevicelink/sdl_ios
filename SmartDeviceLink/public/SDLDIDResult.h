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
 * @param resultCode - resultCode
 * @param didLocation - @(didLocation)
 * @return A SDLDIDResult object
 */
- (instancetype)initWithResultCode:(SDLVehicleDataResultCode)resultCode didLocation:(UInt16)didLocation;

/**
 * @param resultCode - resultCode
 * @param didLocation - @(didLocation)
 * @param data - data
 * @return A SDLDIDResult object
 */
- (instancetype)initWithResultCode:(SDLVehicleDataResultCode)resultCode didLocation:(UInt16)didLocation data:(nullable NSString *)data;

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
