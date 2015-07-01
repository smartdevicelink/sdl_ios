//  SDLSmartDeviceLinkV2ProtocolMessage.h
//


#import "SDLProtocolMessage.h"

@class SDLProtocolHeader;


@interface SDLV2ProtocolMessage : SDLProtocolMessage

- (instancetype)initWithHeader:(SDLProtocolHeader *)header andPayload:(NSData *)payload;
- (NSDictionary *)rpcDictionary;

@end
