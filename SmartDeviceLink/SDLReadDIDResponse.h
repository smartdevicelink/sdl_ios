//  SDLReadDIDResponse.h
//


#import "SDLRPCResponse.h"

@class SDLDIDResult;

/**
 * Read DID Response is sent, when ReadDID has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLReadDIDResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) NSMutableArray<SDLDIDResult *> *didResult;

@end
