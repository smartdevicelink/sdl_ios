//  SDLRPCPayload.h
//


#import <Foundation/Foundation.h>

#import "SDLRPCMessageType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCPayload : NSObject

@property (assign, nonatomic) SDLRPCMessageType rpcType;
@property (assign, nonatomic) UInt32 functionID;
@property (assign, nonatomic) UInt32 correlationID;
@property (nullable, strong, nonatomic) NSData *jsonData;
@property (nullable, strong, nonatomic) NSData *binaryData;

- (NSData *)data;
+ (nullable id)rpcPayloadWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
