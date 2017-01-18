//  SDLRPCPayload.h
//


#import <Foundation/Foundation.h>

#import "SDLRPCMessageType.h"


@interface SDLRPCPayload : NSObject

@property (assign, nonatomic) SDLRPCMessageType rpcType;
@property (assign, nonatomic) UInt32 functionID;
@property (assign, nonatomic) UInt32 correlationID;
@property (strong, nonatomic) NSData *jsonData;
@property (strong, nonatomic) NSData *binaryData;

- (NSData *)data;
+ (id)rpcPayloadWithData:(NSData *)data;

@end
