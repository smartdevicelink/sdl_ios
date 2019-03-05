//  SDLSmartDeviceLinkV2ProtocolMessage.m
//

#import "SDLV2ProtocolMessage.h"
#import "SDLFunctionID.h"
#import "SDLLogMacros.h"
#import "SDLProtocolHeader.h"
#import "SDLRPCPayload.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLV2ProtocolMessage

- (instancetype)initWithHeader:(SDLProtocolHeader *)header andPayload:(nullable NSData *)payload {
    if (self = [self init]) {
        self.header = header;
        self.payload = payload;

        self.header.bytesInPayload = (UInt32)self.payload.length;
    }
    return self;
}

// Convert RPC payload to dictionary (for consumption by RPC layer)
- (nullable NSDictionary<NSString *, id> *)rpcDictionary {
    // Only applicable to RPCs
    if ((self.header.serviceType != SDLServiceTypeRPC) && (self.header.serviceType != SDLServiceTypeBulkData)) {
        return nil;
    }

    NSMutableDictionary<NSString *, id> *rpcMessageAsDictionary = [[NSMutableDictionary alloc] init];

    // Parse the payload as RPC struct
    SDLRPCPayload *rpcPayload = [SDLRPCPayload rpcPayloadWithData:self.payload];

    // Create the inner dictionary with the RPC properties
    NSMutableDictionary <NSString *, id> *innerDictionary = [[NSMutableDictionary alloc] init];
    NSString *functionName = [[SDLFunctionID sharedInstance] functionNameForId:rpcPayload.functionID];
    innerDictionary[SDLRPCParameterNameOperationName] = functionName;
    innerDictionary[SDLRPCParameterNameCorrelationId] = @(rpcPayload.correlationID);

    // Get the json data from the struct
    if (rpcPayload.jsonData) {
        NSError *error = nil;
        NSDictionary<NSString *, id> * jsonDictionary = [NSJSONSerialization JSONObjectWithData:rpcPayload.jsonData options:kNilOptions error:&error];
        if (error != nil) {
            SDLLogE(@"Error decoding JSON data: %@", error);
        } else if (jsonDictionary) {
            [innerDictionary setObject:jsonDictionary forKey:SDLRPCParameterNameParameters];
        }
    }

    // Store it in the containing dictionary
    UInt8 rpcType = rpcPayload.rpcType;
    NSArray<NSString *> *rpcTypeNames = @[SDLRPCParameterNameRequest, SDLRPCParameterNameResponse, SDLRPCParameterNameNotification];
    [rpcMessageAsDictionary setObject:innerDictionary forKey:rpcTypeNames[rpcType]];

    // The bulk data also goes in the dictionary
    if (rpcPayload.binaryData) {
        [rpcMessageAsDictionary setObject:rpcPayload.binaryData forKey:SDLRPCParameterNameBulkData];
    }

    return rpcMessageAsDictionary;
}
@end

NS_ASSUME_NONNULL_END
