//
//  SDLV2ProtocolMessageSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLV2ProtocolMessage.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLRPCPayload.h"
#import "SDLNames.h"

QuickSpecBegin(SDLV2ProtocolMessageSpec)

describe(@"RPCDictionary Tests", ^ {
    it(@"Should return the correct dictionary", ^ {
        SDLServiceType serviceType = SDLServiceType_RPC;
        
        SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
        id headerMock = OCMPartialMock(testHeader);
        [[[headerMock stub] andReturnValue:[NSValue value:&serviceType withObjCType:@encode(SDLServiceType)]] serviceType];
        
        NSDictionary* dictionary = @{@"A": @1,
                                     @"B": @2,
                                     @"C": @3,
                                     @"D": @4,
                                     @"E": @5};
        UInt32 correlationID = 99;
        UInt32 functionID = 26;
        Byte rpcType = 0;
        
        SDLRPCPayload* testPayload = [[SDLRPCPayload alloc] init];
        id payloadMock = OCMPartialMock(testPayload);
        [[[payloadMock stub] andReturn:[NSJSONSerialization dataWithJSONObject:dictionary options:0 error:0]] jsonData];
        [[[payloadMock stub] andReturnValue:[NSValue value:&correlationID withObjCType:@encode(UInt32)]] correlationID];
        [[[payloadMock stub] andReturnValue:[NSValue value:&functionID withObjCType:@encode(UInt32)]] functionID];
        [[[payloadMock stub] andReturnValue:[NSValue value:&rpcType withObjCType:@encode(Byte)]] rpcType];
        [[[payloadMock stub] andReturn:[NSData dataWithBytes:"Database" length:strlen("Database")]] binaryData];
        
        id payloadClassMock = OCMClassMock(SDLRPCPayload.class);
        [[[payloadClassMock stub] andReturn:testPayload] rpcPayloadWithData:[OCMArg any]];
        
        SDLV2ProtocolMessage* testMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testHeader andPayload:[[NSMutableData alloc] initWithCapacity:0]];
        
        expect([testMessage rpcDictionary]).to(equal(@{NAMES_request:
                                                           @{NAMES_operation_name:NAMES_Slider,
                                                             NAMES_correlationID:@99,
                                                             NAMES_parameters:dictionary},
                                                       NAMES_bulkData:[NSData dataWithBytes:"Database" length:strlen("Database")]}));
    });
});

QuickSpecEnd