//  SDLRPCResponse.h
//


#import "SDLRPCMessage.h"

@class SDLResult;

@interface SDLRPCResponse : SDLRPCMessage {
}

@property (strong) NSNumber *correlationID;
@property (strong) NSNumber *success;
@property (strong) SDLResult *resultCode;
@property (strong) NSString *info;

@end
