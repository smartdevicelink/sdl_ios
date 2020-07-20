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

describe(@"HandleReceivedMessage Tests", ^ {
    __block SDLProtocol *mockProtocol = nil;

    beforeEach(^{
        mockProtocol = OCMStrictClassMock([SDLProtocol class]);
    });

    context(@"When handling control message", ^ {
        it(@"Should route message correctly", ^ {
            id delegateMock = OCMProtocolMock(@protocol(SDLProtocolDelegate));

            SDLV2ProtocolMessage *testMessage = [[SDLV2ProtocolMessage alloc] init];
            SDLV2ProtocolHeader *testHeader = [[SDLV2ProtocolHeader alloc] init];
            
            testHeader.frameType = SDLFrameTypeControl;
            testHeader.serviceType = SDLServiceTypeRPC;
            testHeader.frameData = SDLFrameInfoStartServiceACK;
            testHeader.sessionID = 0x93;
            testHeader.bytesInPayload = 0;
            
            testMessage.header = testHeader;
            testMessage.payload = [NSData data];
            
            SDLProtocolReceivedMessageRouter* router = [[SDLProtocolReceivedMessageRouter alloc] init];
            router.delegate = delegateMock;
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
            OCMVerify([delegateMock handleProtocolStartServiceACKMessage:testMessage protocol:mockProtocol]);
        });
    });
    
    context(@"When handling single frame message", ^ {
        it(@"Should route message correctly", ^ {
            id delegateMock = OCMProtocolMock(@protocol(SDLProtocolDelegate));

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
            
            SDLProtocolReceivedMessageRouter* router = [[SDLProtocolReceivedMessageRouter alloc] init];
            router.delegate = delegateMock;
            
            [router handleReceivedMessage:testMessage protocol:mockProtocol];
            
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
            testHeader.frameType = SDLFrameTypeFirst;
            testHeader.serviceType = SDLServiceTypeBulkData;
            testHeader.frameData = 1;
            testHeader.sessionID = 0x33;
            testHeader.bytesInPayload = 8;
            
            testMessage.header = testHeader;
            
            const char firstPayload[8] = {(payloadData.length >> 24) & 0xFF, (payloadData.length >> 16) & 0xFF, (payloadData.length >> 8) & 0xFF, payloadData.length & 0xFF, 0x00, 0x00, 0x00, ceil(payloadData.length / 500.0)};
            testMessage.payload = [NSData dataWithBytes:firstPayload length:8];
            
            SDLProtocolReceivedMessageRouter* router = [[SDLProtocolReceivedMessageRouter alloc] init];
            
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
            
            id delegateMock = OCMProtocolMock(@protocol(SDLProtocolDelegate));
            
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
