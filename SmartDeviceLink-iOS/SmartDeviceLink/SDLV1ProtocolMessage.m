//  SDLV1ProtocolMessage.m
//

#import "SDLJsonDecoder.h"
#import "SDLProtocolHeader.h"
#import "SDLV1ProtocolMessage.h"


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
