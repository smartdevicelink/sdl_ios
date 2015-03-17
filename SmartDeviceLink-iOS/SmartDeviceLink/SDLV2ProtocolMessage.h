//  SDLSmartDeviceLinkV2ProtocolMessage.h
//


#import "SDLProtocolMessage.h"

@interface SDLV2ProtocolMessage : SDLProtocolMessage

- (id)initWithHeader:(SDLProtocolHeader*)header andPayload:(NSData *)payload;
- (NSDictionary *)rpcDictionary;

@end
