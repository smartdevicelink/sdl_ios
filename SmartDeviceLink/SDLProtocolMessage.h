//  SDLSmartDeviceLinkProtocolMessage.h
//

#import <Foundation/Foundation.h>

@class SDLProtocolHeader;

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolMessage : NSObject

@property (strong, nonatomic) SDLProtocolHeader *header;
@property (nullable, strong, nonatomic) NSData *payload;
@property (strong, nonatomic, readonly) NSData *data;

+ (instancetype)messageWithHeader:(SDLProtocolHeader *)header andPayload:(nullable NSData *)payload; // Returns a V1 or V2 object

- (NSUInteger)size;
- (NSString *)description;
- (nullable NSDictionary<NSString *, id> *)rpcDictionary; // Use for RPC type messages to obtain the data in a dictionary

@end

NS_ASSUME_NONNULL_END
