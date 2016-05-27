//  SDLV1ProtocolMessage.m
//

#import "SDLV1ProtocolMessage.h"
#import "SDLJsonDecoder.h"
#import "SDLProtocolHeader.h"


@implementation SDLV1ProtocolMessage

- (instancetype)initWithHeader:(SDLProtocolHeader *)header andPayload:(NSData *)payload {
    if (self = [self init]) {
        self.header = header;
        self.payload = payload;
    }
    return self;
}

- (NSDictionary *)rpcDictionary {
    NSDictionary *rpcMessageAsDictionary = [[SDLJsonDecoder instance] decode:self.payload];
    return rpcMessageAsDictionary;
}

@end
