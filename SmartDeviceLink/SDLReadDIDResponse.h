//  SDLReadDIDResponse.h
//


#import "SDLRPCResponse.h"

@class SDLDIDResult;

/**
 * Read DID Response is sent, when ReadDID has been called
 *
 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLReadDIDResponse : SDLRPCResponse

@property (nullable, strong, nonatomic) NSArray<SDLDIDResult *> *didResult;

@end

NS_ASSUME_NONNULL_END
