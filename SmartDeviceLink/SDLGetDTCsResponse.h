//  SDLGetDTCsResponse.h
//


#import "SDLRPCResponse.h"

/**
 * SDLGetDTCsResponse is sent, when SDLGetDTCs has been called
 *
 * Since <b>SmartDeviceLink 2.0</b>
 */
@interface SDLGetDTCsResponse : SDLRPCResponse

@property (strong, nonatomic) NSNumber<SDLInt> *ecuHeader;
@property (strong, nonatomic) NSMutableArray<NSString *> *dtc;

@end
