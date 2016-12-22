//  SDLRPCResponse.h
//


#import "SDLRPCMessage.h"

#import "SDLResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCResponse : SDLRPCMessage

@property (nullable, strong) NSNumber<SDLInt> *correlationID;
@property (nullable, strong) NSNumber<SDLBool> *success;
@property (nullable, strong) SDLResult resultCode;
@property (nullable, strong) NSString *info;

@end

NS_ASSUME_NONNULL_END
