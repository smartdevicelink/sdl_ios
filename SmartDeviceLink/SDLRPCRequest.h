//  SDLRPCRequest.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCRequest : SDLRPCMessage

@property (nullable, strong) NSNumber<SDLInt> *correlationID;

@end

NS_ASSUME_NONNULL_END
