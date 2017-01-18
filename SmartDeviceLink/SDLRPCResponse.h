//  SDLRPCResponse.h
//


#import "SDLRPCMessage.h"

#import "SDLResult.h"

@interface SDLRPCResponse : SDLRPCMessage

@property (strong, nonatomic) NSNumber<SDLInt> *correlationID;
@property (strong, nonatomic) NSNumber<SDLBool> *success;
@property (strong, nonatomic) SDLResult resultCode;
@property (strong, nonatomic) NSString *info;

@end
