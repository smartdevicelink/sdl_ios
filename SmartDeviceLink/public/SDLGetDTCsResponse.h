//  SDLGetDTCsResponse.h
//


#import "SDLRPCResponse.h"

/**
 Response to SDLGetDTCs
 
 Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetDTCsResponse : SDLRPCResponse

/**
 2 byte ECU Header for DTC response (as defined in VHR_Layout_Specification_DTCs.pdf)

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *ecuHeader;

/**
 Array of all reported DTCs on module (ecuHeader contains information if list is truncated). Each DTC is represented by 4 bytes (3 bytes of data and 1 byte status as defined in VHR_Layout_Specification_DTCs.pdf).
 */
@property (strong, nonatomic) NSArray<NSString *> *dtc;

@end

NS_ASSUME_NONNULL_END
