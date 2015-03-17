//
//  SDLV1ProtocolHeaderSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLV1ProtocolHeader.h"
#import "SDLNames.h"

QuickSpecBegin(SDLV1ProtocolHeaderSpec)
    
__block SDLV1ProtocolHeader* testHeader;
__block NSData* testData;
    
beforeSuite(^ {
    //Set up test header
    testHeader = [[SDLV1ProtocolHeader alloc] init];
 
    testHeader.compressed = YES;
    testHeader.frameType = SDLFrameType_Control;
    testHeader.serviceType = SDLServiceType_RPC;
    testHeader.frameData = SDLFrameData_StartSession;
    testHeader.sessionID = 0x53;
    testHeader.bytesInPayload = 0x1234;
    
    const char testBytes[8] = {0x18 | (SDLFrameType_Control & 0xFF), SDLServiceType_RPC, SDLFrameData_StartSession, 0x53, 0x00, 0x00, 0x12, 0x34};
    testData = [NSData dataWithBytes:testBytes length:8];
});
    
describe(@"Getter/Setter Tests", ^ {
    it(@"Should get readonly values correctly", ^ {
        expect([NSNumber numberWithInteger:testHeader.version]).to(equal(@1));
        expect([NSNumber numberWithInteger:testHeader.size]).to(equal(@8));
    });
    
    it(@"Should set and get correctly", ^ {
        expect([NSNumber numberWithBool:testHeader.compressed]).to(equal([NSNumber numberWithBool:YES]));
        expect([NSNumber numberWithInteger:testHeader.frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Control]));
        expect([NSNumber numberWithInteger:testHeader.serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_RPC]));
        expect([NSNumber numberWithInteger:testHeader.frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_StartSession]));
        expect([NSNumber numberWithInteger:testHeader.sessionID]).to(equal(@0x53));
        expect([NSNumber numberWithInteger:testHeader.bytesInPayload]).to(equal(@0x1234));
    });
});

describe(@"Copy Tests", ^ {
    it(@"Should copy correctly", ^ {
        SDLV1ProtocolHeader* headerCopy = [testHeader copy];
        
        expect([NSNumber numberWithInteger:headerCopy.version]).to(equal(@1));
        expect([NSNumber numberWithInteger:headerCopy.size]).to(equal(@8));
        
        expect([NSNumber numberWithBool:headerCopy.compressed]).to(equal([NSNumber numberWithBool:YES]));
        expect([NSNumber numberWithInteger:headerCopy.frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Control]));
        expect([NSNumber numberWithInteger:headerCopy.serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_RPC]));
        expect([NSNumber numberWithInteger:headerCopy.frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_StartSession]));
        expect([NSNumber numberWithInteger:headerCopy.sessionID]).to(equal(@0x53));
        expect([NSNumber numberWithInteger:headerCopy.bytesInPayload]).to(equal(@0x1234));
        
        expect(headerCopy).toNot(beIdenticalTo(testHeader));
    });
});
    
describe(@"Data Tests", ^ {
    it (@"Should convert to byte data correctly", ^ {
        expect(testHeader.data).to(equal(testData));
    });
});
    
describe(@"RPCPayloadWithData Test", ^ {
    it (@"Should convert from byte data correctly", ^ {
        SDLV1ProtocolHeader* constructedHeader = [[SDLV1ProtocolHeader alloc] init];
        
        [constructedHeader parse:testData];
        
        expect([NSNumber numberWithBool:constructedHeader.compressed]).to(equal([NSNumber numberWithBool:YES]));
        expect([NSNumber numberWithInteger:constructedHeader.frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Control]));
        expect([NSNumber numberWithInteger:constructedHeader.serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_RPC]));
        expect([NSNumber numberWithInteger:constructedHeader.frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_StartSession]));
        expect([NSNumber numberWithInteger:constructedHeader.sessionID]).to(equal(@0x53));
        expect([NSNumber numberWithInteger:constructedHeader.bytesInPayload]).to(equal(@0x1234));
    });
});

QuickSpecEnd