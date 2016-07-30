//  SDLV1ProtocolMessage.h
//

#import "SDLProtocolMessage.h"

@class SDLProtocolHeader;


@interface SDLV1ProtocolMessage : SDLProtocolMessage

- (instancetype)initWithHeader:(SDLProtocolHeader *)header andPayload:(NSData *)payload;
- (NSDictionary *)rpcDictionary;

@end
