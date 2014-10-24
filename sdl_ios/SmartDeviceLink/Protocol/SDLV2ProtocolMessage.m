//  SDLSmartDeviceLinkV2ProtocolMessage.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLV2ProtocolMessage.h"
#import "SDLRPCPayload.h"
#import "SDLJsonDecoder.h"
#import "SDLFunctionID.h"
#import "SDLNames.h"


@implementation SDLV2ProtocolMessage

- (id)initWithHeader:(SDLProtocolHeader*)header andPayload:(NSData *)payload {
	if (self = [self init]) {
        self.header = header;
        self.payload = payload;
	}
	return self;
}

// Convert RPC payload to dictionary (for consumption by RPC layer)
- (NSDictionary *)rpcDictionary {
    // Only applicable to RPCs
    if (self.header.serviceType != SDLServiceType_RPC) {
        return nil;
    }


    NSMutableDictionary* rpcMessageAsDictionary = [[NSMutableDictionary alloc] init];

    // Parse the payload as RPC struct
    SDLRPCPayload *rpcPayload = [SDLRPCPayload rpcPayloadWithData:self.payload];

    // Get the json data from the struct
    NSDictionary *jsonDictionary = [[SDLJsonDecoder instance] decode:rpcPayload.jsonData];

    // Create the inner dictionary with the RPC properties
    NSMutableDictionary *innerDictionary = [[NSMutableDictionary alloc] init];
    NSString *functionName = [[[SDLFunctionID alloc] init] getFunctionName:rpcPayload.functionID];
    [innerDictionary setObject:functionName forKey:NAMES_operation_name];
    [innerDictionary setObject:[NSNumber numberWithInt:rpcPayload.correlationID] forKey:NAMES_correlationID];
    [innerDictionary setObject:jsonDictionary forKey:NAMES_parameters];

    // Store it in the containing dictionary
    UInt8 rpcType = rpcPayload.rpcType;
    NSArray *rpcTypeNames = @[NAMES_request, NAMES_response, NAMES_notification];
    [rpcMessageAsDictionary setObject:innerDictionary forKey:rpcTypeNames[rpcType]];

    // The bulk data also goes in the dictionary
    if (rpcPayload.binaryData) {
        [rpcMessageAsDictionary setObject:rpcPayload.binaryData forKey:NAMES_bulkData];
    }

    return rpcMessageAsDictionary;

}
@end
