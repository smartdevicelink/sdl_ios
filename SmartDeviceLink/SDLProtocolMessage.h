//  SDLSmartDeviceLinkProtocolMessage.h
//

#import <Foundation/Foundation.h>

@class SDLProtocolHeader;

@interface SDLProtocolMessage : NSObject

@property (strong, nonatomic) SDLProtocolHeader *header;
@property (strong, nonatomic) NSData *payload;
@property (strong, nonatomic, readonly) NSData *data;

+ (id)messageWithHeader:(SDLProtocolHeader *)header andPayload:(NSData *)payload; // Returns a V1 or V2 object

- (NSUInteger)size;
- (NSString *)description;
- (NSDictionary<NSString *, id> *)rpcDictionary; // Use for RPC type messages to obtain the data in a dictionary

+ (UInt8)determineVersion:(NSData *)data;


@end
