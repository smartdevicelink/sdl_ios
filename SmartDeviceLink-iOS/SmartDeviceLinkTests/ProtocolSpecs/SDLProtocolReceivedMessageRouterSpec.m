//
//  SDLProtocolReceivedMessageRouterSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Jacob Keeler on 2/16/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLProtocolRecievedMessageRouter.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLNames.h"

QuickSpecBegin(SDLProtocolReceivedMessageRouterSpec)

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
            
            __block BOOL verified = NO;
            [[[[delegateMock stub] andDo: ^(NSInvocation* invocation) {
                verified = YES;
                Byte serviceType;
                Byte sessionID;
                Byte version;
                
                [invocation getArgument:&serviceType atIndex:2];
                [invocation getArgument:&sessionID atIndex:3];
                [invocation getArgument:&version atIndex:4];
                
                expect([NSNumber numberWithInteger:serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_RPC]));
                expect([NSNumber numberWithInteger:sessionID]).to(equal(@0x93));
                expect([NSNumber numberWithInteger:version]).to(equal(@0x02));
            }] ignoringNonObjectArgs] handleProtocolSessionStarted:0 sessionID:0 version:0];
            
            SDLProtocolRecievedMessageRouter* router = [[SDLProtocolRecievedMessageRouter alloc] init];
            router.delegate = delegateMock;
            
            [router handleRecievedMessage:testMessage];
            
            expect([NSNumber numberWithBool:verified]).to(beTruthy());
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
                
                SDLV2ProtocolMessage* messageReceived = (SDLV2ProtocolMessage*)message;
                
                expect(messageReceived).to(beIdenticalTo(testMessage));
            }] ignoringNonObjectArgs] onProtocolMessageReceived:[OCMArg any]];
            
            SDLProtocolRecievedMessageRouter* router = [[SDLProtocolRecievedMessageRouter alloc] init];
            router.delegate = delegateMock;
            
            [router handleRecievedMessage:testMessage];
            
            expect([NSNumber numberWithBool:verified]).to(beTruthy());
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
            
            SDLProtocolRecievedMessageRouter* router = [[SDLProtocolRecievedMessageRouter alloc] init];
            
            [router handleRecievedMessage:testMessage];
            
            testMessage.header.frameType = SDLFrameType_Consecutive;
            testMessage.header.bytesInPayload = 500;
            
            NSUInteger frameNumber = 1;
            NSUInteger offset = 0;
            while ((offset + 500) < payloadData.length) {
                //Consectutive frames
                testMessage.header.frameData = frameNumber;
                testMessage.payload = [payloadData subdataWithRange:NSMakeRange(offset, 500)];
                [router handleRecievedMessage:testMessage];
                
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
                expect([NSNumber numberWithInteger:[assembledMessage header].frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Single]));
                expect([NSNumber numberWithInteger:[assembledMessage header].serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_BulkData]));
                expect([NSNumber numberWithInteger:[assembledMessage header].frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_SingleFrame]));
                expect([NSNumber numberWithInteger:[assembledMessage header].sessionID]).to(equal(@0x33));
                expect([NSNumber numberWithInteger:[assembledMessage header].bytesInPayload]).to(equal([NSNumber numberWithInteger:payloadData.length]));
            }] onProtocolMessageReceived:[OCMArg any]];
            
            router.delegate = delegateMock;
            [router handleRecievedMessage:testMessage];
            
            expect([NSNumber numberWithBool:verified]).to(beTruthy());
        });
    });
});

QuickSpecEnd