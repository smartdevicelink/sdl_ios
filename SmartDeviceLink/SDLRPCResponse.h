//  SDLRPCResponse.h
//


#import "SDLRPCMessage.h"

#import "SDLResult.h"

@interface SDLRPCResponse : SDLRPCMessage

@property (strong) NSNumber<SDLInt> *correlationID;
@property (strong) NSNumber<SDLBool> *success;
@property (strong) SDLResult resultCode;
@property (strong) NSString *info;

@end
