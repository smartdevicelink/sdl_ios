//  SDLRPCRequest.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCRequest : SDLRPCMessage

@property (strong, nonatomic) NSNumber<SDLInt> *correlationID;

@end

NS_ASSUME_NONNULL_END
