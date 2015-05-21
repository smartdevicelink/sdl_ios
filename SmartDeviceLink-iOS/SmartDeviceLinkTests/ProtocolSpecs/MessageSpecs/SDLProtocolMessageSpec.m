//
//  SDLProtocolMessageSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLProtocolHeader.h"
#import "SDLProtocolMessage.h"
#import "SDLV1ProtocolHeader.h"
#import "SDLV1ProtocolMessage.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLNames.h"

QuickSpecBegin(SDLProtocolMessageSpec)

describe(@"MessageWithHeader Tests", ^ {
    it(@"Should return an appropriate object", ^ {
        NSData* testPayload = [NSData dataWithBytes:"Test Data" length:strlen("Test Data")];
        SDLV1ProtocolHeader* testHeaderV1 = [[SDLV1ProtocolHeader alloc] init];
        SDLProtocolMessage* testMessageV1 = [SDLProtocolMessage messageWithHeader:testHeaderV1 andPayload:testPayload];
        
        expect(testMessageV1).to(beAKindOf(SDLV1ProtocolMessage.class));
        expect(testMessageV1.header).to(equal(testHeaderV1));
        expect(testMessageV1.payload).to(equal(testPayload));
        
        SDLV2ProtocolHeader* testHeaderV2 = [[SDLV2ProtocolHeader alloc] init];
        SDLProtocolMessage* testMessageV2 = [SDLProtocolMessage messageWithHeader:testHeaderV2 andPayload:testPayload];
        
        expect(testMessageV2).to(beAKindOf(SDLV2ProtocolMessage.class));
        expect(testMessageV2.header).to(equal(testHeaderV2));
        expect(testMessageV2.payload).to(equal(testPayload));
    });
});

describe(@"DetermineVersion Tests", ^ {
    it(@"Should return the correct version", ^ {
        const char bytesV1[8] = {0x10 | SDLFrameType_First, SDLServiceType_BulkData, SDLFrameData_StartSessionACK, 0x5E, 0x00, 0x00, 0x00, 0x00};
        NSData* messageV1 = [NSData dataWithBytes:bytesV1 length:8];
        expect(@([SDLProtocolMessage determineVersion:messageV1])).to(equal(@1));
        
        const char bytesV2[12] = {0x20 | SDLFrameType_First, SDLServiceType_BulkData, SDLFrameData_StartSessionACK, 0x5E, 0x00, 0x00, 0x00, 0x00, 0x44, 0x44, 0x44, 0x44};
        NSData* messageV2 = [NSData dataWithBytes:bytesV2 length:12];
        expect(@([SDLProtocolMessage determineVersion:messageV2])).to(equal(@2));
    });
});

describe(@"Data tests", ^ {
    it(@"Should return the correct data", ^ {
        SDLProtocolMessage* testMessage = [[SDLProtocolMessage alloc] init];
        
        SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
        
        id headerMock = OCMPartialMock(testHeader);
        const char headerData[12] = {0x20 | SDLFrameType_First, SDLServiceType_BulkData, SDLFrameData_StartSessionACK, 0x5E, 0x0E, 0x00, 0x00, strlen("Test Data"), 0x65, 0x22, 0x41, 0x38};
        [[[headerMock stub] andReturn:[NSData dataWithBytes:headerData length:12]] data];
        
        testMessage.header = testHeader;
        testMessage.payload = [NSData dataWithBytes:"Test Data" length:strlen("Test Data")];
        
        NSMutableData* testData = [NSMutableData dataWithBytes:headerData length:12];
        [testData appendBytes:"Test Data" length:strlen("Test Data")];
        expect(testMessage.data).to(equal([testData copy]));
    });
});

QuickSpecEnd