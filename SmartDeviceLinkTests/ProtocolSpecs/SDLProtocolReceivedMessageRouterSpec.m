//
//  SDLProtocolReceivedMessageRouterSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLProtocol.h"
#import "SDLProtocolReceivedMessageRouter.h"
#import "SDLRPCParameterNames.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"

QuickSpecBegin(SDLProtocolReceivedMessageRouterSpec)

describe(@"HandleReceivedMessage Tests", ^{
    __block SDLProtocolReceivedMessageRouter *router = nil;
    __block id delegateMock = nil;
    __block SDLProtocol *mockProtocol = nil;
    
    beforeEach(^{
        router = [[SDLProtocolReceivedMessageRouter alloc] init];
        delegateMock = OCMProtocolMock(@protocol(SDLProtocolDelegate));
        router.delegate = delegateMock;
        mockProtocol = OCMStrictClassMock([SDLProtocol class]);
    });
    
    context(@"When handling control message", ^{
        __block SDLV2ProtocolMessage *testMessage = nil;
        __block SDLV2ProtocolHeader *testHeader = nil;
        
        beforeEach(^{
            testMessage = [[SDLV2ProtocolMessage alloc] init];
            testMessage.payload = [NSData data];
            
            testHeader.frameType = SDLFrameTypeControl;
            testHeader.serviceType = SDLServiceTypeRPC;
            testHeader.frameData = SDLFrameInfoStartServiceNACK;
            testHeader.sessionID = 0x93;
            testHeader.bytesInPayload = 0;
            testMessage.header = testHeader;
            testHeader = [[SDLV2ProtocolHeader alloc] init];
        });
        
        it(@"Should route a start service ACK message correctly", ^{
            testHeader.frameData = SDLFrameInfoStartServiceACK;
            testMessage.header = testHeader;
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            OCMVerify([delegateMock handleProtocolStartServiceACKMessage:testMessage protocol:mockProtocol]);
        });
        
        it(@"Should route a start service NAK message correctly", ^{
            testHeader.frameData = SDLFrameInfoStartServiceNACK;
            testMessage.header = testHeader;
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            OCMVerify([delegateMock handleProtocolStartServiceNAKMessage:testMessage protocol:mockProtocol]);
        });
        
        it(@"Should route an end service ACK message correctly", ^{
            testHeader.frameData = SDLFrameInfoEndServiceACK;
            testMessage.header = testHeader;
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            OCMVerify([delegateMock handleProtocolEndServiceACKMessage:testMessage protocol:mockProtocol]);
        });
        
        it(@"Should route an end service NAK message correctly", ^{
            testHeader.frameData = SDLFrameInfoEndServiceNACK;
            testMessage.header = testHeader;
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            OCMVerify([delegateMock handleProtocolEndServiceNAKMessage:testMessage protocol:mockProtocol]);
        });
        
        it(@"Should route register secondary transport ACK message correctly", ^{
            testHeader.frameData = SDLFrameInfoRegisterSecondaryTransportACK;
            testMessage.header = testHeader;
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            OCMVerify([delegateMock handleProtocolRegisterSecondaryTransportACKMessage:testMessage protocol:mockProtocol]);
        });
        
        it(@"Should route register secondary transport NAK message correctly", ^{
            testHeader.frameData = SDLFrameInfoRegisterSecondaryTransportNACK;
            testMessage.header = testHeader;
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            OCMVerify([delegateMock handleProtocolRegisterSecondaryTransportNAKMessage:testMessage protocol:mockProtocol]);
        });
        
        it(@"Should route a transport event update message correctly", ^{
            testHeader.frameData = SDLFrameInfoTransportEventUpdate;
            testMessage.header = testHeader;
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            OCMVerify([delegateMock handleTransportEventUpdateMessage:testMessage protocol:mockProtocol]);
        });
        
        it(@"Should route a heartbeat message correctly", ^{
            testHeader.frameData = SDLFrameInfoHeartbeat;
            testMessage.header = testHeader;
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            OCMVerify([delegateMock handleHeartbeatForSession:testHeader.sessionID]);
        });
        
        it(@"Should route a heartbeat ACK message correctly", ^{
            testHeader.frameData = SDLFrameInfoHeartbeatACK;
            testMessage.header = testHeader;
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            OCMVerify([delegateMock handleHeartbeatACK]);
        });
    });
    
    context(@"When handling single frame message", ^{
        it(@"Should route message correctly", ^{
            SDLV2ProtocolMessage* testMessage = [[SDLV2ProtocolMessage alloc] init];
            SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
            
            testHeader.frameType = SDLFrameTypeSingle;
            testHeader.serviceType = SDLServiceTypeRPC;
            testHeader.frameData = SDLFrameInfoSingleFrame;
            testHeader.sessionID = 0x07;
            testHeader.bytesInPayload = 0;
            
            testMessage.header = testHeader;
            
            testMessage.payload = [NSData data];
            
            __block BOOL verified = NO;
            [[[[delegateMock stub] andDo: ^(NSInvocation* invocation) {
                verified = YES;
                
                __unsafe_unretained SDLProtocolMessage* message;
                
                [invocation getArgument:&message atIndex:2];
                
                SDLV2ProtocolMessage* messageReceived = (SDLV2ProtocolMessage *)message;
                
                expect(messageReceived).to(beIdenticalTo(testMessage));
            }] ignoringNonObjectArgs] onProtocolMessageReceived:[OCMArg any] protocol:mockProtocol];
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            expect(@(verified)).to(beTruthy());
        });
    });
    
    context(@"When handling multi-frame message", ^{
        it(@"Should route message correctly", ^{
            //Allocate 2000 bytes and use it as test data
            const NSUInteger dataLength = 2000;
            char dummyBytes[dataLength];
            
            const char testPayloadHeader[12] = {0x20, 0x55, 0x64, 0x73, 0x12, 0x34, 0x43, 0x21, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};
            
            NSMutableData* payloadData = [NSMutableData dataWithBytes:testPayloadHeader length:12];
            [payloadData appendBytes:dummyBytes length:dataLength];
            
            SDLV2ProtocolMessage* testMessage = [[SDLV2ProtocolMessage alloc] init];
            SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
            
            //First frame
            testHeader.frameType = SDLFrameTypeFirst;
            testHeader.serviceType = SDLServiceTypeBulkData;
            testHeader.frameData = 1;
            testHeader.sessionID = 0x33;
            testHeader.bytesInPayload = 8;
            
            testMessage.header = testHeader;
            
            const char firstPayload[8] = {(payloadData.length >> 24) & 0xFF, (payloadData.length >> 16) & 0xFF, (payloadData.length >> 8) & 0xFF, payloadData.length & 0xFF, 0x00, 0x00, 0x00, ceil(payloadData.length / 500.0)};
            testMessage.payload = [NSData dataWithBytes:firstPayload length:8];
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            testMessage.header.frameType = SDLFrameTypeConsecutive;
            testMessage.header.bytesInPayload = 500;
            
            NSUInteger frameNumber = 1;
            NSUInteger offset = 0;
            while ((offset + 500) < payloadData.length) {
                //Consectutive frames
                testMessage.header.frameData = frameNumber;
                testMessage.payload = [payloadData subdataWithRange:NSMakeRange(offset, 500)];
                [router handleReceivedMessage:testMessage protocol:mockProtocol];
                
                frameNumber++;
                offset += 500;
            }
            
            //Final frame
            testMessage.header.frameData = 0;
            testMessage.payload = [payloadData subdataWithRange:NSMakeRange(offset, payloadData.length - offset)];
            
            __block BOOL verified = NO;
            [[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained SDLProtocolMessage* message;
                [invocation getArgument:&message atIndex:2];
                SDLProtocolMessage* assembledMessage = message;
                
                expect(assembledMessage.payload).to(equal(payloadData));
                expect(@(assembledMessage.header.frameType)).to(equal(@(SDLFrameTypeSingle)));
                expect(@(assembledMessage.header.serviceType)).to(equal(@(SDLServiceTypeBulkData)));
                expect(@(assembledMessage.header.frameData)).to(equal(@(SDLFrameInfoSingleFrame)));
                expect(@(assembledMessage.header.sessionID)).to(equal(@0x33));
                expect(@(assembledMessage.header.bytesInPayload)).to(equal(@(payloadData.length)));
            }] onProtocolMessageReceived:[OCMArg any] protocol:mockProtocol];
            
            router.delegate = delegateMock;
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            expect(@(verified)).to(beTruthy());
        });
    });
});

QuickSpecEnd
