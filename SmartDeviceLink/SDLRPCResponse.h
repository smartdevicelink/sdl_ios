//  SDLRPCResponse.h
//


#import "SDLRPCMessage.h"

#import "SDLResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCResponse : SDLRPCMessage

@property (strong) NSNumber<SDLInt> *correlationID;
@property (strong) NSNumber<SDLBool> *success;
@property (strong) SDLResult resultCode;
@property (nullable, strong) NSString *info;

@end

NS_ASSUME_NONNULL_END
