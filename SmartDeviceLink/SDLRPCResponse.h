//  SDLRPCResponse.h
//


#import "SDLRPCMessage.h"

#import "SDLResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCResponse : SDLRPCMessage

@property (strong, nonatomic) NSNumber<SDLInt> *correlationID;
@property (strong, nonatomic) NSNumber<SDLBool> *success;
@property (strong, nonatomic) SDLResult resultCode;
@property (nullable, strong, nonatomic) NSString *info;

@end

NS_ASSUME_NONNULL_END
