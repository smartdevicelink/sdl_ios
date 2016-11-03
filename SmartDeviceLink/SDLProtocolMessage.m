//  SDLProtocolMessage.m
//


#import "SDLProtocolMessage.h"
#import "SDLFunctionID.h"
#import "SDLProtocolHeader.h"
#import "SDLRPCPayload.h"
#import "SDLV1ProtocolMessage.h"
#import "SDLV2ProtocolMessage.h"

@interface SDLProtocolMessage ()

@property (strong) NSMutableData *internalBuffer;

@end

@implementation SDLProtocolMessage

// For use in decoding a stream of bytes.
// Pass in bytes representing message (or beginning of message)
// Looks at and parses first byte to determine version.
+ (UInt8)determineVersion:(NSData *)data {
    UInt8 firstByte = ((UInt8 *)data.bytes)[0];
    UInt8 version = firstByte >> 4;
    return version;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSDictionary *)rpcDictionary {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSUInteger)size {
    return (self.header.size + self.payload.length);
}

- (NSData *)data {
    NSMutableData *dataOut = [NSMutableData dataWithCapacity:[self size]];
    [dataOut appendData:self.header.data];
    [dataOut appendData:self.payload];

    return dataOut;
}

- (NSString *)description {
    // Print the header data.
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendString:self.header.description];

    // If it's an RPC, provide greater detail
    if (((self.header.serviceType == SDLServiceType_RPC) || (self.header.serviceType == SDLServiceType_BulkData)) && (self.header.frameType == SDLFrameType_Single)) {
        // version of RPC Message determines how we access the info.
        if (self.header.version >= 2) {
            SDLRPCPayload *rpcPayload = [SDLRPCPayload rpcPayloadWithData:self.payload];
            if (rpcPayload) {
                NSString *functionName = [[[SDLFunctionID alloc] init] getFunctionName:rpcPayload.functionID];

                UInt8 rpcType = rpcPayload.rpcType;
                NSArray *rpcTypeNames = @[@"Request", @"Response", @"Notification"];
                NSString *rpcTypeString = nil;
                if (rpcType >= 0 && rpcType < rpcTypeNames.count) {
                    rpcTypeString = rpcTypeNames[rpcType];
                }
                [description appendFormat:@" RPC Info: %@ %@", functionName, rpcTypeString];
            }
        } else {
            // version == 1
            // turn payload (which is JSON string) into dictionary and extract fields of interest.
        }
    } else {
        // Not an RPC, provide generic info.
        [description appendFormat:@" Payload: %lu bytes.", (unsigned long)self.payload.length];
    }

    return description;
}

// Returns a V1 or V2 object
+ (id)messageWithHeader:(SDLProtocolHeader *)header andPayload:(NSData *)payload {
    SDLProtocolMessage *newMessage = nil;

    UInt8 version = header.version;
    if (version == 1) {
        newMessage = [[SDLV1ProtocolMessage alloc] initWithHeader:(SDLProtocolHeader *)header andPayload:(NSData *)payload];
    } else if (version >= 2) {
        newMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:(SDLProtocolHeader *)header andPayload:(NSData *)payload];
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempted to create an SDLMessage, but the version of the header passed was 0" userInfo:nil];
    }

    return newMessage;
}

@end
