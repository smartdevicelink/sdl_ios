//  SDLSmartDeviceLinkV1ProtocolMessage.h
//


#import "SDLProtocolMessage.h"

@interface SDLV1ProtocolMessage : SDLProtocolMessage

- (instancetype)initWithHeader:(SDLProtocolHeader*)header andPayload:(NSData *)payload;
- (NSDictionary *)rpcDictionary;

@end
