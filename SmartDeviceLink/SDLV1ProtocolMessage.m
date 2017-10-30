//  SDLV1ProtocolMessage.m
//

#import "SDLV1ProtocolMessage.h"
#import "SDLLogMacros.h"
#import "SDLProtocolHeader.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLV1ProtocolMessage

- (instancetype)initWithHeader:(SDLProtocolHeader *)header andPayload:(nullable NSData *)payload {
    if (self = [self init]) {
        self.header = header;
        self.payload = payload;

        self.header.bytesInPayload = (UInt32)self.payload.length;
    }
    return self;
}

- (nullable NSDictionary<NSString *, id> *)rpcDictionary {
    if (self.payload.length == 0) {
        return nil;
    }
    
    NSError *error = nil;
    NSDictionary<NSString *, id> * rpcMessageAsDictionary = [NSJSONSerialization JSONObjectWithData:self.payload options:kNilOptions error:&error];
    if (error != nil) {
        SDLLogE(@"Error decoding JSON data: %@", error);
        return nil;
    }
    
    return rpcMessageAsDictionary;
}

@end

NS_ASSUME_NONNULL_END
