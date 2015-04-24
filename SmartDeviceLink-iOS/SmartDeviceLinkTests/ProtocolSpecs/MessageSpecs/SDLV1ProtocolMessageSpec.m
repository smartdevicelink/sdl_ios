//
//  SDLV1ProtocolMessageSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLV1ProtocolMessage.h"
#import "SDLV1ProtocolHeader.h"


QuickSpecBegin(SDLV1ProtocolMessageSpec)

describe(@"RPCDictionary Tests", ^ {
    it(@"Should return the correct dictionary", ^ {
        SDLV1ProtocolHeader* testHeader = [[SDLV1ProtocolHeader alloc] init];
        NSDictionary* testDictionary = @{@"Oyster": @"Soup",
                                         @"Soup": @"Kitchen",
                                         @"Kitchen": @"Floor",
                                         @"Floor": @"Wax",
                                         @"Wax": @"Museum"};
        SDLV1ProtocolMessage* testMessage = [[SDLV1ProtocolMessage alloc] initWithHeader:testHeader andPayload:[NSJSONSerialization dataWithJSONObject:testDictionary options:0 error:0]];
        
        expect([testMessage rpcDictionary]).to(equal(testDictionary));
    });
});

QuickSpecEnd