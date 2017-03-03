//  SDLV1ProtocolMessage.m
//

#import "SDLV1ProtocolMessage.h"
#import "SDLMacros.h"
#import "SDLProtocolHeader.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLV1ProtocolMessage

- (instancetype)initWithHeader:(SDLProtocolHeader *)header andPayload:(nullable NSData *)payload {
    if (self = [self init]) {
        self.header = header;
        self.payload = payload;
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
        // [SDLDebugTool logInfo:[NSString stringWithFormat:@"Error decoding JSON data: %@", error] withType:SDLDebugType_Protocol];
        return nil;
    }
    
    return rpcMessageAsDictionary;
}

@end

NS_ASSUME_NONNULL_END
