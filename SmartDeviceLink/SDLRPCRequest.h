//  SDLRPCRequest.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCRequest : SDLRPCMessage

/**
 *  A unique id assigned to message sent to Core. The Correlation ID is used to map a request to its response.
 */
@property (strong, nonatomic) NSNumber<SDLInt> *correlationID;

@end

NS_ASSUME_NONNULL_END
