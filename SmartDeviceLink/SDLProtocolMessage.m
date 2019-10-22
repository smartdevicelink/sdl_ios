//  SDLProtocolMessage.m
//


#import "SDLProtocolMessage.h"

#import "NSMutableDictionary+Store.h"
#import "SDLFunctionID.h"
#import "SDLRPCParameterNames.h"
#import "SDLProtocolHeader.h"
#import "SDLRPCPayload.h"
#import "SDLV1ProtocolMessage.h"
#import "SDLV2ProtocolMessage.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLProtocolMessage

// Returns a V1 or V2 object
+ (instancetype)messageWithHeader:(SDLProtocolHeader *)header andPayload:(nullable NSData *)payload {
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

- (nullable NSDictionary<NSString *, id> *)rpcDictionary {
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

    if (self.header.encrypted) {
        [description appendString:@", Payload is encrypted - no description can be provided"];
        return description;
    }

    // If it's an RPC, provide greater detail
    if (((self.header.serviceType == SDLServiceTypeRPC) || (self.header.serviceType == SDLServiceTypeBulkData)) && (self.header.frameType == SDLFrameTypeSingle)) {
        // version of RPC Message determines how we access the info.
        if (self.header.version >= 2) {
            SDLRPCPayload *rpcPayload = [SDLRPCPayload rpcPayloadWithData:self.payload];
            if (rpcPayload) {
                SDLRPCParameterName functionName = [[SDLFunctionID sharedInstance] functionNameForId:rpcPayload.functionID];

                UInt8 rpcType = rpcPayload.rpcType;
                NSArray<NSString *> *rpcTypeNames = @[@"Request", @"Response", @"Notification"];
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

@end

NS_ASSUME_NONNULL_END
