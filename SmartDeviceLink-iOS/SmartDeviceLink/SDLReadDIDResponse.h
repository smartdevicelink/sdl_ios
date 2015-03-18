//  SDLReadDIDResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Read DID Response is sent, when ReadDID has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLReadDIDResponse : SDLRPCResponse {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSMutableArray *didResult;

@end
