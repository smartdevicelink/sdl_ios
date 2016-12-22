//  SDLRPCPayload.h
//


#import <Foundation/Foundation.h>

#import "SDLRPCMessageType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCPayload : NSObject

@property (assign) SDLRPCMessageType rpcType;
@property (assign) UInt32 functionID;
@property (assign) UInt32 correlationID;
@property (nullable, strong) NSData *jsonData;
@property (nullable, strong) NSData *binaryData;

- (NSData *)data;
+ (nullable id)rpcPayloadWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
