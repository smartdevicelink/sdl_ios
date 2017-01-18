//  SDLV1ProtocolMessage.h
//

#import "SDLProtocolMessage.h"

@class SDLProtocolHeader;

NS_ASSUME_NONNULL_BEGIN

@interface SDLV1ProtocolMessage : SDLProtocolMessage

- (instancetype)initWithHeader:(SDLProtocolHeader *)header andPayload:(nullable NSData *)payload;
- (nullable NSDictionary<NSString *, id> *)rpcDictionary;

@end

NS_ASSUME_NONNULL_END
