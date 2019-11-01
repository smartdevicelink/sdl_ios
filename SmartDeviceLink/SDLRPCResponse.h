//  SDLRPCResponse.h
//


#import "SDLRPCMessage.h"

#import "SDLResult.h"

NS_ASSUME_NONNULL_BEGIN

/// Basic information that all RPC responses contain
@interface SDLRPCResponse : SDLRPCMessage

/**
 *  The correlation id of the corresponding SDLRPCRequest.
 */
@property (strong, nonatomic) NSNumber<SDLInt> *correlationID;

/**
 *  Whether or not the SDLRPCRequest was successful.
 */
@property (strong, nonatomic) NSNumber<SDLBool> *success;

/**
 *  The result of the SDLRPCRequest. If the request failed, the result code contains the failure reason.
 */
@property (strong, nonatomic) SDLResult resultCode;

/**
 *  More detailed success or error message.
 */
@property (nullable, strong, nonatomic) NSString *info;

@end

NS_ASSUME_NONNULL_END
