//  SDLRPCRequest.h
//


#import "SDLRPCMessage.h"

@interface SDLRPCRequest : SDLRPCMessage

@property (strong, nonatomic) NSNumber<SDLInt> *correlationID;

@end
