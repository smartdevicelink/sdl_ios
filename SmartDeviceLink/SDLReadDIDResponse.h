//  SDLReadDIDResponse.h
//


#import "SDLRPCResponse.h"

@class SDLDIDResult;

/**
 A response to ReadDID
 
 Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLReadDIDResponse : SDLRPCResponse

/**
 Array of requested DID results (with data if available).
 */
@property (nullable, strong, nonatomic) NSArray<SDLDIDResult *> *didResult;

@end

NS_ASSUME_NONNULL_END
