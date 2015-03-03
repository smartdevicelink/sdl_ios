//
//  SDLV2ProtocolHeaderSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Jacob Keeler on 2/16/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//

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
    
    testHeader.compressed = YES;
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
        expect([NSNumber numberWithInteger:testHeader.version]).to(equal(@2));
        expect([NSNumber numberWithInteger:testHeader.size]).to(equal(@12));
    });
    
    it(@"Should set and get correctly", ^ {
        expect([NSNumber numberWithBool:testHeader.compressed]).to(equal([NSNumber numberWithBool:YES]));
        expect([NSNumber numberWithInteger:testHeader.frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Control]));
        expect([NSNumber numberWithInteger:testHeader.serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_RPC]));
        expect([NSNumber numberWithInteger:testHeader.frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_StartSession]));
        expect([NSNumber numberWithInteger:testHeader.sessionID]).to(equal(@0x53));
        expect([NSNumber numberWithInteger:testHeader.bytesInPayload]).to(equal(@0x1234));
        expect([NSNumber numberWithInteger:testHeader.messageID]).to(equal(@0x6DAB424F));
    });
});

describe(@"Copy Tests", ^ {
    it(@"Should copy correctly", ^ {
        SDLV2ProtocolHeader* headerCopy = [testHeader copy];
        
        expect([NSNumber numberWithInteger:headerCopy.version]).to(equal(@2));
        expect([NSNumber numberWithInteger:headerCopy.size]).to(equal(@12));
        
        expect([NSNumber numberWithBool:headerCopy.compressed]).to(equal([NSNumber numberWithBool:YES]));
        expect([NSNumber numberWithInteger:headerCopy.frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Control]));
        expect([NSNumber numberWithInteger:headerCopy.serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_RPC]));
        expect([NSNumber numberWithInteger:headerCopy.frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_StartSession]));
        expect([NSNumber numberWithInteger:headerCopy.sessionID]).to(equal(@0x53));
        expect([NSNumber numberWithInteger:headerCopy.bytesInPayload]).to(equal(@0x1234));
        expect([NSNumber numberWithInteger:testHeader.messageID]).to(equal(@0x6DAB424F));
        
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
        SDLV2ProtocolHeader* constructedHeader = [[SDLV2ProtocolHeader alloc] init];
        
        [constructedHeader parse:testData];
        
        expect([NSNumber numberWithBool:constructedHeader.compressed]).to(equal([NSNumber numberWithBool:YES]));
        expect([NSNumber numberWithInteger:constructedHeader.frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Control]));
        expect([NSNumber numberWithInteger:constructedHeader.serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_RPC]));
        expect([NSNumber numberWithInteger:constructedHeader.frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_StartSession]));
        expect([NSNumber numberWithInteger:constructedHeader.sessionID]).to(equal(@0x53));
        expect([NSNumber numberWithInteger:constructedHeader.bytesInPayload]).to(equal(@0x1234));
        expect([NSNumber numberWithInteger:testHeader.messageID]).to(equal(@0x6DAB424F));
    });
});

QuickSpecEnd