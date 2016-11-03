//
//  SDLProtocolReceivedMessageRouterSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLProtocolReceivedMessageRouter.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLNames.h"

QuickSpecBegin(SDLProtocolReceivedMessageRouterSpec)

// TODO: This should be rewritten using an actual mock (i.e. SDLProtocolListenerDelegateMock class to avoid OCMock)
describe(@"HandleReceivedMessage Tests", ^ {
    context(@"When handling control message", ^ {
        it(@"Should route message correctly", ^ {
            id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
            
            SDLV2ProtocolMessage* testMessage = [[SDLV2ProtocolMessage alloc] init];
            SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
            
            testHeader.frameType = SDLFrameType_Control;
            testHeader.serviceType = SDLServiceType_RPC;
            testHeader.frameData = SDLFrameData_StartSessionACK;
            testHeader.sessionID = 0x93;
            testHeader.bytesInPayload = 0;
            
            testMessage.header = testHeader;
            testMessage.payload = [NSData data];
            
            SDLProtocolReceivedMessageRouter* router = [[SDLProtocolReceivedMessageRouter alloc] init];
            router.delegate = delegateMock;
            [router handleReceivedMessage:testMessage];
            
            OCMVerify([delegateMock handleProtocolStartSessionACK:testMessage.header]);
        });
    });
    
    context(@"When handling single frame message", ^ {
        it(@"Should route message correctly", ^ {
            id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
            
            SDLV2ProtocolMessage* testMessage = [[SDLV2ProtocolMessage alloc] init];
            SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
            
            testHeader.frameType = SDLFrameType_Single;
            testHeader.serviceType = SDLServiceType_RPC;
            testHeader.frameData = SDLFrameData_SingleFrame;
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
            }] ignoringNonObjectArgs] onProtocolMessageReceived:[OCMArg any]];
            
            SDLProtocolReceivedMessageRouter* router = [[SDLProtocolReceivedMessageRouter alloc] init];
            router.delegate = delegateMock;
            
            [router handleReceivedMessage:testMessage];
            
            expect(@(verified)).to(beTruthy());
        });
    });
    
    context(@"When handling multi-frame message", ^ {
        it(@"Should route message correctly", ^ {
            //Allocate 2000 bytes and use it as test data
            const NSUInteger dataLength = 2000;
            char dummyBytes[dataLength];
            
            const char testPayloadHeader[12] = {0x20, 0x55, 0x64, 0x73, 0x12, 0x34, 0x43, 0x21, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};
            
            NSMutableData* payloadData = [NSMutableData dataWithBytes:testPayloadHeader length:12];
            [payloadData appendBytes:dummyBytes length:dataLength];
            
            SDLV2ProtocolMessage* testMessage = [[SDLV2ProtocolMessage alloc] init];
            SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
            
            //First frame
            testHeader.frameType = SDLFrameType_First;
            testHeader.serviceType = SDLServiceType_BulkData;
            testHeader.frameData = 1;
            testHeader.sessionID = 0x33;
            testHeader.bytesInPayload = 8;
            
            testMessage.header = testHeader;
            
            const char firstPayload[8] = {(payloadData.length >> 24) & 0xFF, (payloadData.length >> 16) & 0xFF, (payloadData.length >> 8) & 0xFF, payloadData.length & 0xFF, 0x00, 0x00, 0x00, ceil(payloadData.length / 500.0)};
            testMessage.payload = [NSData dataWithBytes:firstPayload length:8];
            
            SDLProtocolReceivedMessageRouter* router = [[SDLProtocolReceivedMessageRouter alloc] init];
            
            [router handleReceivedMessage:testMessage];
            
            testMessage.header.frameType = SDLFrameType_Consecutive;
            testMessage.header.bytesInPayload = 500;
            
            NSUInteger frameNumber = 1;
            NSUInteger offset = 0;
            while ((offset + 500) < payloadData.length) {
                //Consectutive frames
                testMessage.header.frameData = frameNumber;
                testMessage.payload = [payloadData subdataWithRange:NSMakeRange(offset, 500)];
                [router handleReceivedMessage:testMessage];
                
                frameNumber++;
                offset += 500;
            }
            
            //Final frame
            testMessage.header.frameData = 0;
            testMessage.payload = [payloadData subdataWithRange:NSMakeRange(offset, payloadData.length - offset)];
            
            id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
            
            __block BOOL verified = NO;
            [[[delegateMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained SDLProtocolMessage* message;
                [invocation getArgument:&message atIndex:2];
                SDLProtocolMessage* assembledMessage = message;
                
                expect(assembledMessage.payload).to(equal(payloadData));
                expect(@(assembledMessage.header.frameType)).to(equal(@(SDLFrameType_Single)));
                expect(@(assembledMessage.header.serviceType)).to(equal(@(SDLServiceType_BulkData)));
                expect(@(assembledMessage.header.frameData)).to(equal(@(SDLFrameData_SingleFrame)));
                expect(@(assembledMessage.header.sessionID)).to(equal(@0x33));
                expect(@(assembledMessage.header.bytesInPayload)).to(equal(@(payloadData.length)));
            }] onProtocolMessageReceived:[OCMArg any]];
            
            router.delegate = delegateMock;
            [router handleReceivedMessage:testMessage];
            
            expect(@(verified)).to(beTruthy());
        });
    });
});

QuickSpecEnd
