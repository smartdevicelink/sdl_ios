//
//  SDLProtocolSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLTransportType.h"
#import "SDLControlFramePayloadRegisterSecondaryTransportNak.h"
#import "SDLGlobals.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLProtocolReceivedMessageRouter.h"
#import "SDLRPCRequest.h"
#import "SDLNames.h"
#import "SDLV1ProtocolMessage.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLV1ProtocolHeader.h"
#import "SDLV2ProtocolHeader.h"


QuickSpecBegin(SDLProtocolSpec)

//Test dictionaries
NSDictionary* dictionaryV1 = @{SDLNameRequest:
                                   @{SDLNameOperationName:@"DeleteCommand",
                                     SDLNameCorrelationId:@0x98765,
                                     SDLNameParameters:
                                         @{SDLNameCommandId:@55}}};
NSDictionary* dictionaryV2 = @{SDLNameCommandId:@55};

describe(@"Send StartService Tests", ^ {
    context(@"Unsecure", ^{
        it(@"Should send the correct data", ^ {
            // Reset max protocol version before test. (This test case expects V1 header. If other test ran
            // prior to this one, SDLGlobals would keep the max protocol version and this test case would fail.)
            [[SDLGlobals sharedGlobals] setMaxHeadUnitVersion:@"1.0.0"];

            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            
            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                
                const char testHeader[8] = {0x10 | SDLFrameTypeControl, SDLServiceTypeBulkData, SDLFrameInfoStartService, 0x00, 0x00, 0x00, 0x00, 0x00};
                expect(dataSent).to(equal([NSData dataWithBytes:testHeader length:8]));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;
            
            [testProtocol startServiceWithType:SDLServiceTypeBulkData payload:nil];
            
            expect(@(verified)).toEventually(beTruthy());
        });

        it(@"Should reuse stored header of RPC service when starting other service", ^{
            // reset max protocol version before test
            [[SDLGlobals sharedGlobals] setMaxHeadUnitVersion:@"2.0.0"];

            SDLServiceType serviceTypeToStart = SDLServiceTypeVideo;

            // reference header (which is taken from Start Service ACK of Version Negotiation)
            SDLV2ProtocolHeader *refHeader = [[SDLV2ProtocolHeader alloc] init];
            refHeader.frameType = SDLFrameTypeControl;
            refHeader.serviceType = SDLServiceTypeRPC;
            refHeader.frameData = SDLFrameInfoStartServiceACK;
            refHeader.sessionID = 100;

            SDLV2ProtocolHeader *header = [refHeader copy];
            header.serviceType = serviceTypeToStart;
            header.frameData = SDLFrameInfoStartService;
            NSData *headerData = [header data];

            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];

            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;

                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                expect(dataSent).to(equal(headerData));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;

            [testProtocol storeHeader:header forServiceType:SDLServiceTypeRPC];
            [testProtocol startServiceWithType:serviceTypeToStart payload:nil];

            expect(@(verified)).toEventually(beTruthy());
        });
    });
    
    context(@"Secure", ^{
        it(@"Should send the correct data", ^ {
            // TODO: How do we properly test the security? Assume a correct / fail?
            // TODO: The security methods need to be split out to their own class so they can be public.
            // Abstract Protocol needs to be combined into Protocol
        });
    });
});

describe(@"Send EndSession Tests", ^ {
    context(@"During V1 session", ^ {
        it(@"Should send the correct data", ^ {
            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            SDLV1ProtocolHeader *testHeader = [[SDLV1ProtocolHeader alloc] init];
            testHeader.serviceType = SDLServiceTypeRPC;
            testHeader.sessionID = 0x03;
            [testProtocol handleProtocolStartServiceACKMessage:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]];
            
            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                
                const char testHeader[8] = {0x10 | SDLFrameTypeControl, SDLServiceTypeRPC, SDLFrameInfoEndService, 0x03, 0x00, 0x00, 0x00, 0x00};
                expect(dataSent).to(equal([NSData dataWithBytes:testHeader length:8]));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;
            
            [testProtocol endServiceWithType:SDLServiceTypeRPC];
            
            expect(@(verified)).toEventually(beTruthy());
        });
    });
    
    context(@"During V2 session", ^ {
        it(@"Should send the correct data", ^ {
            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            SDLV2ProtocolHeader *testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:2];
            testHeader.serviceType = SDLServiceTypeRPC;
            testHeader.sessionID = 0x61;
            [testProtocol handleProtocolStartServiceACKMessage:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]];
            
            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                
                const char testHeader[12] = {0x20 | SDLFrameTypeControl, SDLServiceTypeRPC, SDLFrameInfoEndService, 0x61, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
                expect(dataSent).to(equal([NSData dataWithBytes:testHeader length:12]));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;
            
            [testProtocol endServiceWithType:SDLServiceTypeRPC];
            
            expect(@(verified)).toEventually(beTruthy());
        });
    });
});

describe(@"Send Register Secondary Transport Tests", ^ {
    it(@"Should send the correct data", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];

        // receive a Start Service ACK frame of RPC to configure protocol version
        SDLV2ProtocolHeader *refHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
        refHeader.frameType = SDLFrameTypeControl;
        refHeader.serviceType = SDLServiceTypeRPC;
        refHeader.frameData = SDLFrameInfoStartServiceACK;
        refHeader.sessionID = 0x11;
        [testProtocol handleProtocolStartServiceACKMessage:[SDLProtocolMessage messageWithHeader:refHeader andPayload:nil]];

        // store the header to apply Session ID value to Register Secondary Transport frame
        [testProtocol storeHeader:refHeader forServiceType:SDLServiceTypeControl];

        __block BOOL verified = NO;
        id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
        [[[transportMock stub] andDo:^(NSInvocation* invocation) {
            verified = YES;

            __unsafe_unretained NSData* data;
            [invocation getArgument:&data atIndex:2];
            NSData* dataSent = [data copy];

            const char testHeader[12] = {0x50 | SDLFrameTypeControl, SDLServiceTypeControl, SDLFrameInfoRegisterSecondaryTransport, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01};
            expect(dataSent).to(equal([NSData dataWithBytes:testHeader length:12]));
        }] sendData:[OCMArg any]];
        testProtocol.transport = transportMock;

        [testProtocol registerSecondaryTransport];

        expect(@(verified)).toEventually(beTruthy());
    });
});

describe(@"SendRPCRequest Tests", ^ {
    __block id mockRequest;
    beforeEach(^ {
        mockRequest = OCMPartialMock([[SDLRPCRequest alloc] init]);
    });
    
    context(@"During V1 session", ^ {
        it(@"Should send the correct data", ^ {
            [[[[mockRequest stub] andReturn:dictionaryV1] ignoringNonObjectArgs] serializeAsDictionary:1];
            
            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            SDLV1ProtocolHeader *testHeader = [[SDLV1ProtocolHeader alloc] init];
            testHeader.serviceType = SDLServiceTypeRPC;
            testHeader.sessionID = 0xFF;
            [testProtocol handleProtocolStartServiceACKMessage:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]];
            
            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                
                NSData* jsonTestData = [NSJSONSerialization dataWithJSONObject:dictionaryV1 options:0 error:0];
                NSUInteger dataLength = jsonTestData.length;
                
                const char testHeader[8] = {0x10 | SDLFrameTypeSingle, SDLServiceTypeRPC, SDLFrameInfoSingleFrame, 0xFF, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};
                NSMutableData* testData = [NSMutableData dataWithBytes:testHeader length:8];
                [testData appendData:jsonTestData];
                
                expect(dataSent).to(equal([testData copy]));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;
            
            [testProtocol sendRPC:mockRequest];
            
            expect(@(verified)).toEventually(beTruthy());
        });
    });
    
    context(@"During V2 session", ^ {
        it(@"Should send the correct data bulk data when bulk data is available", ^ {
            [[[[mockRequest stub] andReturn:dictionaryV2] ignoringNonObjectArgs] serializeAsDictionary:2];
            [[[mockRequest stub] andReturn:@0x98765] correlationID];
            [[[mockRequest stub] andReturn:@"DeleteCommand"] getFunctionName];
            [[[mockRequest stub] andReturn:[NSData dataWithBytes:"COMMAND" length:strlen("COMMAND")]] bulkData];
            
            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            SDLV2ProtocolHeader *testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:2];
            testHeader.serviceType = SDLServiceTypeRPC;
            testHeader.sessionID = 0x01;
            [testProtocol handleProtocolStartServiceACKMessage:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]];
            
            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                
                NSData* jsonTestData = [NSJSONSerialization dataWithJSONObject:dictionaryV2 options:0 error:0];
                NSUInteger dataLength = jsonTestData.length;
                
                const char testPayloadHeader[12] = {0x00, 0x00, 0x00, 0x06, 0x00, 0x09, 0x87, 0x65, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};
                
                NSMutableData* payloadData = [NSMutableData dataWithBytes:testPayloadHeader length:12];
                [payloadData appendData:jsonTestData];
                [payloadData appendBytes:"COMMAND" length:strlen("COMMAND")];
                
                const char testHeader[12] = {0x20 | SDLFrameTypeSingle, SDLServiceTypeBulkData, SDLFrameInfoSingleFrame, 0x01, (payloadData.length >> 24) & 0xFF, (payloadData.length >> 16) & 0xFF,(payloadData.length >> 8) & 0xFF, payloadData.length & 0xFF, 0x00, 0x00, 0x00, 0x01};
                
                NSMutableData* testData = [NSMutableData dataWithBytes:testHeader length:12];
                [testData appendData:payloadData];
                
                expect(dataSent).to(equal([testData copy]));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;
            
            [testProtocol sendRPC:mockRequest];
            
            expect(@(verified)).toEventually(beTruthy());
        });
    });
});

describe(@"HandleBytesFromTransport Tests", ^ {
    context(@"During V1 session", ^ {
//        it(@"Should parse the data correctly", ^ {
//            id routerMock = OCMClassMock(SDLProtocolReceivedMessageRouter.class);
//            
//            //Override initialization methods so that our protocol will use our object instead
//            [[[routerMock stub] andReturn:routerMock] alloc];
//            (void)[[[routerMock stub] andReturn:routerMock] init];
//            
//            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
//            SDLV1ProtocolHeader *testHeader = [[SDLV1ProtocolHeader alloc] init];
//            testHeader.serviceType = SDLServiceTypeRPC;
//            testHeader.sessionID = 0x03;
//            [testProtocol handleProtocolStartSessionACK:testHeader];
//            
//            NSData* jsonTestData = [NSJSONSerialization dataWithJSONObject:dictionaryV1 options:0 error:0];
//            NSUInteger dataLength = jsonTestData.length;
//            
//            __block BOOL verified = NO;
//            [[[routerMock stub] andDo:^(NSInvocation* invocation) {
//                verified = YES;
//                
//                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
//                __unsafe_unretained SDLV1ProtocolMessage* message;
//                [invocation getArgument:&message atIndex:2];
//                
//                SDLV1ProtocolMessage* messageReceived = message;
//                
//                expect(messageReceived.payload).to(equal(jsonTestData));
//                expect(@(messageReceived.header.version)).to(equal(@1));
//                expect(@(messageReceived.header.encrypted)).to(equal(@NO));
//                expect(@(messageReceived.header.frameType)).to(equal(@(SDLFrameTypeSingle)));
//                expect(@(messageReceived.header.sessionID)).to(equal(@0xFF));
//                expect(@(messageReceived.header.serviceType)).to(equal(@(SDLServiceTypeRPC)));
//                expect(@(messageReceived.header.frameData)).to(equal(@(SDLFrameInfoSingleFrame)));
//                expect(@(messageReceived.header.bytesInPayload)).to(equal(@(dataLength)));
//            }] handleReceivedMessage:[OCMArg any]];
//            
//            const char testHeader2Data[8] = {0x10 | SDLFrameTypeSingle, SDLServiceTypeRPC, SDLFrameInfoSingleFrame, 0xFF, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};
//            NSMutableData* testData = [NSMutableData dataWithBytes:testHeader2Data length:8];
//            [testData appendData:jsonTestData];
//            
//            [testProtocol handleBytesFromTransport:testData];
//            
//            expect(@(verified)).toEventually(beTruthy());
//        });
    });
    
    context(@"During V2 session", ^ {
//        it(@"Should parse the data correctly", ^ {
//            id routerMock = OCMClassMock(SDLProtocolReceivedMessageRouter.class);
//            
//            //Override initialization methods so that our protocol will use our object instead
//            [[[routerMock stub] andReturn:routerMock] alloc];
//            (void)[[[routerMock stub] andReturn:routerMock] init];
//            
//            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
//            SDLV2ProtocolHeader *testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:2];
//            testHeader.serviceType = SDLServiceTypeRPC;
//            testHeader.sessionID = 0xF5;
//            [testProtocol handleProtocolStartSessionACK:testHeader];
//            
//            NSData* jsonTestData = [NSJSONSerialization dataWithJSONObject:dictionaryV2 options:0 error:0];
//            NSUInteger dataLength = jsonTestData.length;
//            
//            const char testPayloadHeader[12] = {0x00, 0x00, 0x00, 0x06, 0x00, 0x09, 0x87, 0x65, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};
//            
//            NSMutableData* payloadData = [NSMutableData dataWithBytes:testPayloadHeader length:12];
//            [payloadData appendData:jsonTestData];
//            [payloadData appendBytes:"COMMAND" length:strlen("COMMAND")];
//            
//            __block BOOL verified = NO;
//            [[[routerMock stub] andDo:^(NSInvocation* invocation) {
//                verified = YES;
//                
//                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
//                __unsafe_unretained SDLV2ProtocolMessage* message;
//                [invocation getArgument:&message atIndex:2];
//                
//                SDLV2ProtocolMessage* messageReceived = message;
//                
//                expect(messageReceived.payload).to(equal(payloadData));
//                expect(@(messageReceived.header.version)).to(equal(@2));
//                expect(@(messageReceived.header.encrypted)).to(equal(@NO));
//                expect(@(messageReceived.header.frameType)).to(equal(@(SDLFrameTypeSingle)));
//                expect(@(messageReceived.header.sessionID)).to(equal(@0x01));
//                expect(@(messageReceived.header.serviceType)).to(equal(@(SDLServiceTypeRPC)));
//                expect(@(messageReceived.header.frameData)).to(equal(@(SDLFrameInfoSingleFrame)));
//                expect(@(messageReceived.header.bytesInPayload)).to(equal(@(payloadData.length)));
//                expect(@(((SDLV2ProtocolHeader *)messageReceived.header).messageID)).to(equal(@1));
//                
//            }] handleReceivedMessage:[OCMArg any]];
//            testProtocol.transport = routerMock;
//            
//            const char testHeader2Data[12] = {0x20 | SDLFrameTypeSingle, SDLServiceTypeRPC, SDLFrameInfoSingleFrame, 0x01, (payloadData.length >> 24) & 0xFF, (payloadData.length >> 16) & 0xFF,
//                (payloadData.length >> 8) & 0xFF, payloadData.length & 0xFF, 0x00, 0x00, 0x00, 0x01};
//            
//            NSMutableData* testData = [NSMutableData dataWithBytes:testHeader2Data length:12];
//            [testData appendData:payloadData];
//            
//            [testProtocol handleBytesFromTransport:testData];
//            
//            expect(@(verified)).toEventually(beTruthy());
//        });
    });
});

xdescribe(@"HandleProtocolSessionStarted Tests", ^ {
    it(@"Should pass information along to delegate", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
        
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
        testHeader.frameType = SDLFrameTypeControl;
        testHeader.serviceType = SDLServiceTypeRPC;
        testHeader.frameData = SDLFrameInfoStartServiceACK;
        testHeader.sessionID = 0x93;
        testHeader.bytesInPayload = 0;
        
        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol handleProtocolStartServiceACKMessage:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]];
        
        OCMExpect([delegateMock handleProtocolStartServiceACKMessage:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]]);
    });
});

xdescribe(@"HandleProtocolRegisterSecondaryTransport Tests", ^ {
    it(@"Should pass information along to delegate when ACKed", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];

        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));

        SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
        testHeader.frameType = SDLFrameTypeControl;
        testHeader.serviceType = SDLServiceTypeControl;
        testHeader.frameData = SDLFrameInfoRegisterSecondaryTransportACK;
        testHeader.sessionID = 0x32;
        testHeader.messageID = 2;
        testHeader.bytesInPayload = 0;

        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol handleProtocolRegisterSecondaryTransportACKMessage:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]];

        OCMExpect([delegateMock handleProtocolRegisterSecondaryTransportACKMessage:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]]);
    });

    it(@"Should pass information along to delegate when NAKed", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];

        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));

        SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
        testHeader.frameType = SDLFrameTypeControl;
        testHeader.serviceType = SDLServiceTypeControl;
        testHeader.frameData = SDLFrameInfoRegisterSecondaryTransportNACK;
        testHeader.sessionID = 0x56;
        testHeader.messageID = 2;

        SDLControlFramePayloadRegisterSecondaryTransportNak *payload = [[SDLControlFramePayloadRegisterSecondaryTransportNak alloc] initWithReason:@"Sample reason"];
        NSData *payloadData = payload.data;

        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol handleProtocolRegisterSecondaryTransportACKMessage:[SDLProtocolMessage messageWithHeader:testHeader andPayload:payloadData]];

        OCMExpect([delegateMock handleProtocolRegisterSecondaryTransportNAKMessage:[SDLProtocolMessage messageWithHeader:testHeader andPayload:payloadData]]);
    });
});

xdescribe(@"HandleHeartbeatForSession Tests", ^{
    // TODO: Test automatically sending data to head unit (dependency injection?)
    it(@"Should pass information along to delegate", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
        
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol handleHeartbeatForSession:0x44];
        
        OCMExpect([delegateMock handleHeartbeatForSession:0]);
    });
});

xdescribe(@"OnProtocolMessageReceived Tests", ^ {
    it(@"Should pass information along to delegate", ^ {
        SDLProtocol *testProtocol = [[SDLProtocol alloc] init];
        
        SDLProtocolMessage *testMessage = [[SDLProtocolMessage alloc] init];
        SDLV2ProtocolHeader *testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:3];
        testHeader.serviceType = SDLServiceTypeRPC;
        testMessage.header = testHeader;
        
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol onProtocolMessageReceived:testMessage];
        
        OCMExpect([delegateMock onProtocolMessageReceived:[OCMArg any]]);
    });
});

xdescribe(@"OnProtocolOpened Tests", ^ {
    it(@"Should pass information along to delegate", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
        
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol onProtocolOpened];
        
        OCMExpect([delegateMock onProtocolOpened]);
    });
});

xdescribe(@"OnProtocolClosed Tests", ^ {
    it(@"Should pass information along to delegate", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
        
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol onProtocolClosed];
        
        OCMExpect([delegateMock onProtocolClosed]);
    });
});

xdescribe(@"OnError Tests", ^ {
    it(@"Should pass information along to delegate", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
        
        NSException* testException = [[NSException alloc] initWithName:@"Name" reason:@"No Reason" userInfo:@{}];
        
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol onError:@"Nothing actually happened" exception:testException];
        
        OCMExpect([delegateMock onError:[OCMArg any] exception:[OCMArg any]]);
    });
});

QuickSpecEnd
