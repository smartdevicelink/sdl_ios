//  SDLGetDTCsResponse.h
//


#import "SDLRPCResponse.h"

/**
 * SDLGetDTCsResponse is sent, when SDLGetDTCs has been called
 *
 * Since <b>SmartDeviceLink 2.0</b>
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetDTCsResponse : SDLRPCResponse

@property (strong, nonatomic) NSNumber<SDLInt> *ecuHeader;
@property (strong, nonatomic) NSArray<NSString *> *dtc;

@end

NS_ASSUME_NONNULL_END
