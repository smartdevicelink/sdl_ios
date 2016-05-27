//
//  SDLV2ProtocolHeaderSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLV2ProtocolHeader.h"
#import "SDLNames.h"

QuickSpecBegin(SDLV2ProtocolHeaderSpec)

__block SDLV2ProtocolHeader* testHeader;
__block NSData* testData;

beforeSuite(^ {
    //Set up test header
    testHeader = [[SDLV2ProtocolHeader alloc] init];
    
    testHeader.encrypted = YES;
    testHeader.frameType = SDLFrameType_Control;
    testHeader.serviceType = SDLServiceType_RPC;
    testHeader.frameData = SDLFrameData_StartSession;
    testHeader.sessionID = 0x53;
    testHeader.bytesInPayload = 0x1234;
    testHeader.messageID = 0x6DAB424F;
    
    const char testBytes[12] = {0x28 | (SDLFrameType_Control & 0xFF), SDLServiceType_RPC, SDLFrameData_StartSession, 0x53, 0x00, 0x00, 0x12, 0x34, 0x6D, 0xAB, 0x42, 0x4F};
    testData = [NSData dataWithBytes:testBytes length:12];
});

describe(@"Getter/Setter Tests", ^ {
    it(@"Should get readonly values correctly", ^ {
        expect(@(testHeader.version)).to(equal(@2));
        expect(@(testHeader.size)).to(equal(@12));
    });
    
    it(@"Should set and get correctly", ^ {
        expect(@(testHeader.encrypted)).to(equal(@YES));
        expect(@(testHeader.frameType)).to(equal(@(SDLFrameType_Control)));
        expect(@(testHeader.serviceType)).to(equal(@(SDLServiceType_RPC)));
        expect(@(testHeader.frameData)).to(equal(@(SDLFrameData_StartSession)));
        expect(@(testHeader.sessionID)).to(equal(@0x53));
        expect(@(testHeader.bytesInPayload)).to(equal(@0x1234));
        expect(@(testHeader.messageID)).to(equal(@0x6DAB424F));
    });
});

describe(@"Copy Tests", ^ {
    it(@"Should copy correctly", ^ {
        SDLV2ProtocolHeader* headerCopy = [testHeader copy];
        
        expect(@(headerCopy.version)).to(equal(@2));
        expect(@(headerCopy.size)).to(equal(@12));
        
        expect(@(headerCopy.encrypted)).to(equal(@YES));
        expect(@(headerCopy.frameType)).to(equal(@(SDLFrameType_Control)));
        expect(@(headerCopy.serviceType)).to(equal(@(SDLServiceType_RPC)));
        expect(@(headerCopy.frameData)).to(equal(@(SDLFrameData_StartSession)));
        expect(@(headerCopy.sessionID)).to(equal(@0x53));
        expect(@(headerCopy.bytesInPayload)).to(equal(@0x1234));
        expect(@(testHeader.messageID)).to(equal(@0x6DAB424F));
        
        expect(headerCopy).toNot(beIdenticalTo(testHeader));
    });
});

describe(@"compressed deprecated spec", ^{
    describe(@"setting encrypted", ^{
        __block BOOL value = NO;
        beforeEach(^{
            testHeader.encrypted = value;
        });
        
        it(@"should give the same value for compressed", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(@(testHeader.compressed)).to(equal(@(value)));
#pragma clang diagnostic pop
        });
    });
    
    describe(@"setting compressed", ^{
        __block BOOL value = YES;
        beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testHeader.compressed = value;
#pragma clang diagnostic pop
        });
        
        it(@"should give the same value for compressed", ^{
            expect(@(testHeader.encrypted)).to(equal(@(value)));
        });
    });
});

describe(@"Data Tests", ^ {
    it (@"Should convert to byte data correctly", ^ {
        expect(testHeader.data).to(equal(testData));
    });
});

describe(@"RPCPayloadWithData Test", ^ {
    it (@"Should convert from byte data correctly", ^ {
        SDLV2ProtocolHeader* constructedHeader = [[SDLV2ProtocolHeader alloc] init];
        
        [constructedHeader parse:testData];
        
        expect(@(constructedHeader.encrypted)).to(equal(@YES));
        expect(@(constructedHeader.frameType)).to(equal(@(SDLFrameType_Control)));
        expect(@(constructedHeader.serviceType)).to(equal(@(SDLServiceType_RPC)));
        expect(@(constructedHeader.frameData)).to(equal(@(SDLFrameData_StartSession)));
        expect(@(constructedHeader.sessionID)).to(equal(@0x53));
        expect(@(constructedHeader.bytesInPayload)).to(equal(@0x1234));
        expect(@(testHeader.messageID)).to(equal(@0x6DAB424F));
    });
});

QuickSpecEnd