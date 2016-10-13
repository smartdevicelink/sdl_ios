//  SDLReadDIDResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Read DID Response is sent, when ReadDID has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLReadDIDResponse : SDLRPCResponse

@property (strong) NSMutableArray *didResult;

@end
