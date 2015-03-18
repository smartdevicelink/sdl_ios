//  SDLGetDTCsResponse.h
//


#import "SDLRPCResponse.h"

/**
 * SDLGetDTCsResponse is sent, when SDLGetDTCs has been called
 *
 * Since <b>SmartDeviceLink 2.0</b>
 */
@interface SDLGetDTCsResponse : SDLRPCResponse {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSNumber *ecuHeader;
@property (strong) NSMutableArray *dtc;

@end
