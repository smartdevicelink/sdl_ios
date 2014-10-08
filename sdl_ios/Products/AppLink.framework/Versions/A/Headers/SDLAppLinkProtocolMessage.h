//  SDLAppLinkProtocolMessage.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLAppLinkProtocolHeader.h"


@interface SDLAppLinkProtocolMessage : NSObject

@property (strong) SDLAppLinkProtocolHeader *header;
@property (strong) NSData *payload;
@property (strong, readonly) NSData *data;

- (id)init;
+ (id)messageWithHeader:(SDLAppLinkProtocolHeader*)header andPayload:(NSData *)payload; // Returns a V1 or V2 object

- (NSUInteger)size;
- (NSString *)description;
- (NSDictionary *)rpcDictionary; // Use for RPC type messages to obtain the data in a dictionary

+ (UInt8)determineVersion:(NSData *)data;


@end
