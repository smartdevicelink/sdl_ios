//  SDLRPCRequest.h
//


#import "SDLRPCMessage.h"

@interface SDLRPCRequest : SDLRPCMessage

@property (strong) NSNumber<SDLInt> *correlationID;

@end
