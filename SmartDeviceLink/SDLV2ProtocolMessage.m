//  SDLSmartDeviceLinkV2ProtocolMessage.m
//

#import "SDLV2ProtocolMessage.h"
#import "SDLFunctionID.h"
#import "SDLDebugTool.h"
#import "SDLProtocolHeader.h"
#import "SDLRPCPayload.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLV2ProtocolMessage

- (instancetype)initWithHeader:(SDLProtocolHeader *)header andPayload:(nullable NSData *)payload {
    if (self = [self init]) {
        self.header = header;
        self.payload = payload;
    }
    return self;
}

// Convert RPC payload to dictionary (for consumption by RPC layer)
- (nullable NSDictionary<NSString *, id> *)rpcDictionary {
    // Only applicable to RPCs
    if ((self.header.serviceType != SDLServiceType_RPC) && (self.header.serviceType != SDLServiceType_BulkData)) {
        return nil;
    }

    NSMutableDictionary<NSString *, id> *rpcMessageAsDictionary = [[NSMutableDictionary alloc] init];

    // Parse the payload as RPC struct
    SDLRPCPayload *rpcPayload = [SDLRPCPayload rpcPayloadWithData:self.payload];

    // Create the inner dictionary with the RPC properties
    NSMutableDictionary <NSString *, id> *innerDictionary = [[NSMutableDictionary alloc] init];
    NSString *functionName = [[SDLFunctionID sharedInstance] functionNameForId:rpcPayload.functionID];
    [innerDictionary setObject:functionName forKey:SDLNameOperationName];
    [innerDictionary setObject:[NSNumber numberWithInt:rpcPayload.correlationID] forKey:SDLNameCorrelationId];

    // Get the json data from the struct
    if (rpcPayload.jsonData) {
        NSError *error = nil;
        NSDictionary<NSString *, id> * jsonDictionary = [NSJSONSerialization JSONObjectWithData:rpcPayload.jsonData options:kNilOptions error:&error];
        if (error != nil) {
            [SDLDebugTool logInfo:[NSString stringWithFormat:@"Error decoding JSON data: %@", error] withType:SDLDebugType_Protocol];
        } else if (jsonDictionary) {
            [innerDictionary setObject:jsonDictionary forKey:SDLNameParameters];
        }
    }

    // Store it in the containing dictionary
    UInt8 rpcType = rpcPayload.rpcType;
    NSArray<NSString *> *rpcTypeNames = @[SDLNameRequest, SDLNameResponse, SDLNameNotification];
    [rpcMessageAsDictionary setObject:innerDictionary forKey:rpcTypeNames[rpcType]];

    // The bulk data also goes in the dictionary
    if (rpcPayload.binaryData) {
        [rpcMessageAsDictionary setObject:rpcPayload.binaryData forKey:SDLNameBulkData];
    }

    return rpcMessageAsDictionary;
}
@end

NS_ASSUME_NONNULL_END
