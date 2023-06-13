//
//  SDLProtocolSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLControlFramePayloadAudioStartServiceAck.h"
#import "SDLControlFramePayloadRegisterSecondaryTransportNak.h"
#import "SDLControlFramePayloadRPCStartServiceAck.h"
#import "SDLControlFramePayloadVideoStartServiceAck.h"
#import "SDLDeleteCommand.h"
#import "SDLEncryptionLifecycleManager.h"
#import "SDLGlobals.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLProtocolMessageDisassembler.h"
#import "SDLProtocolReceivedMessageRouter.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCRequest.h"
#import "SDLRPCParameterNames.h"
#import "SDLTransportType.h"
#import "SDLV1ProtocolMessage.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLV1ProtocolHeader.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLVersion.h"

QuickSpecBegin(SDLProtocolSpec)

//Test dictionaries
NSDictionary* dictionaryV1 = @{SDLRPCParameterNameRequest:
                                   @{SDLRPCParameterNameOperationName:@"DeleteCommand",
                                     SDLRPCParameterNameCorrelationId:@0x98765,
                                     SDLRPCParameterNameParameters:
                                         @{SDLRPCParameterNameCommandId:@55}}};

// Send StartService Tests
describe(@"Send StartService Tests", ^{
    // Insecure
    context(@"Insecure", ^{
        // Should send the correct data
        it(@"Should send the correct data", ^{
            // Reset max protocol version before test. (This test case expects V1 header. If other test ran
            // prior to this one, SDLGlobals would keep the max protocol version and this test case would fail.)
            [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = [SDLVersion versionWithString:@"1.0.0"];
            
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
            SDLProtocol *testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];
            
            [testProtocol startServiceWithType:SDLServiceTypeBulkData payload:nil];
            
            expect(verified).to(beTrue());
        });

        it(@"Should reuse stored header of RPC service when starting other service", ^{
            // reset max protocol version before test
            [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = [SDLVersion versionWithString:@"2.0.0"];

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

            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;

                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                expect(dataSent).to(equal(headerData));
            }] sendData:[OCMArg any]];
            SDLProtocol *testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

            [testProtocol storeHeader:header forServiceType:SDLServiceTypeRPC];
            [testProtocol startServiceWithType:serviceTypeToStart payload:nil];

            expect(verified).to(beTrue());
        });
    });
    
    context(@"Secure", ^{
        it(@"Should send the correct data", ^{
            // TODO: How do we properly test the security? Assume a correct / fail?
            // TODO: The security methods need to be split out to their own class so they can be public.
            // Abstract Protocol needs to be combined into Protocol
        });
    });
});

// Send EndSession Tests
describe(@"Send EndSession Tests", ^{
    // During V1 session
    context(@"During V1 session", ^{
        // Should send the correct data
        it(@"Should send the correct data", ^{
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
            SDLProtocol *testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

            SDLV1ProtocolHeader *testHeader = [[SDLV1ProtocolHeader alloc] init];
            testHeader.serviceType = SDLServiceTypeRPC;
            testHeader.sessionID = 0x03;
            [testProtocol protocol:testProtocol didReceiveStartServiceACK:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]];
            
            [testProtocol endServiceWithType:SDLServiceTypeRPC];
            
            expect(verified).to(beTrue());
        });
    });
    
    context(@"During V2 session", ^{
        it(@"Should send the correct data", ^{
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
            SDLProtocol *testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

            SDLV2ProtocolHeader *testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:2];
            testHeader.serviceType = SDLServiceTypeRPC;
            testHeader.sessionID = 0x61;
            [testProtocol protocol:testProtocol didReceiveStartServiceACK:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]];
            
            [testProtocol endServiceWithType:SDLServiceTypeRPC];
            
            expect(verified).to(beTrue());
        });
    });
});

// Send Register Secondary Transport Tests
describe(@"Send Register Secondary Transport Tests", ^{
    // Should send the correct data
    it(@"Should send the correct data", ^{
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
        SDLProtocol *testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

        // receive a Start Service ACK frame of RPC to configure protocol version
        SDLV2ProtocolHeader *refHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
        refHeader.frameType = SDLFrameTypeControl;
        refHeader.serviceType = SDLServiceTypeRPC;
        refHeader.frameData = SDLFrameInfoStartServiceACK;
        refHeader.sessionID = 0x11;
        [testProtocol protocol:testProtocol didReceiveStartServiceACK:[SDLProtocolMessage messageWithHeader:refHeader andPayload:nil]];

        // store the header to apply Session ID value to Register Secondary Transport frame
        [testProtocol storeHeader:refHeader forServiceType:SDLServiceTypeControl];

        [testProtocol registerSecondaryTransport];

        expect(verified).to(beTrue());
    });
});

// SendRPC Tests
describe(@"SendRPC Tests", ^{
    __block id mockRequest;
    beforeEach(^{
        mockRequest = OCMPartialMock([[SDLRPCRequest alloc] init]);
    });

    afterEach(^{
        [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = [SDLVersion versionWithMajor:1 minor:0 patch:0];
    });

    // During V1 session
    context(@"During V1 session", ^{
        // Should send the correct data
        it(@"Should send the correct data", ^{
            [[[[mockRequest stub] andReturn:dictionaryV1] ignoringNonObjectArgs] serializeAsDictionary:1];
            
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
            SDLProtocol *testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

            SDLV1ProtocolHeader *testHeader = [[SDLV1ProtocolHeader alloc] init];
            testHeader.serviceType = SDLServiceTypeRPC;
            testHeader.sessionID = 0xFF;
            [testProtocol protocol:testProtocol didReceiveStartServiceACK:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]];
            
            NSError *error = nil;
            BOOL sent = [testProtocol sendRPC:mockRequest error:&error];
            
            expect(verified).to(beTrue());
            expect(sent).to(beTrue());
            expect(error).to(beNil());
        });
    });

    // During V2 session
    context(@"During V2 session", ^{
        beforeEach(^{
            [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = [SDLVersion versionWithMajor:2 minor:0 patch:0];
        });

        // Should send the correct data bulk data when bulk data is available
        it(@"should correctly send a request smaller than the MTU size", ^{
            SDLDeleteCommand *deleteRequest = [[SDLDeleteCommand alloc] initWithId:55];
            deleteRequest.correlationID = @12345;
            deleteRequest.bulkData = [NSData dataWithBytes:"COMMAND" length:strlen("COMMAND")];

            __block NSUInteger numTimesCalled = 0;
            id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
            [[[transportMock stub] andDo:^(NSInvocation *invocation) {
                numTimesCalled++;
            }] sendData:[OCMArg any]];

            SDLProtocol *testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

            // Send a start service ack to ensure that it's set up for sending the RPC
            SDLV2ProtocolHeader *testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:2];
            testHeader.serviceType = SDLServiceTypeRPC;
            testHeader.sessionID = 0x01;
            [testProtocol protocol:testProtocol didReceiveStartServiceACK:[SDLProtocolMessage messageWithHeader:testHeader andPayload:nil]];

            NSError *error = nil;
            BOOL sent = [testProtocol sendRPC:mockRequest error:&error];
            
            expect(numTimesCalled).to(equal(1));
            expect(sent).to(beTrue());
            expect(error).to(beNil());
        });

		it(@"should correctly send a request larger than the MTU size", ^{
            char dummyBytes[1100];

            SDLDeleteCommand *deleteRequest = [[SDLDeleteCommand alloc] initWithId:55];
            deleteRequest.correlationID = @12345;
            deleteRequest.bulkData = [NSData dataWithBytes:dummyBytes length:1100];

            __block NSUInteger numTimesCalled = 0;
            id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
            [[[transportMock stub] andDo:^(NSInvocation *invocation) {
                numTimesCalled++;
            }] sendData:[OCMArg any]];

            SDLProtocol *testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

            NSError *error = nil;
            [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = [SDLVersion versionWithMajor:2 minor:0 patch:0];
            BOOL sent = [testProtocol sendRPC:deleteRequest error:&error];

            expect(numTimesCalled).to(equal(3));
            expect(sent).to(beTrue());
            expect(error).to(beNil());
        });

        describe(@"when encrypting the requests", ^{
            context(@"when the encryption manager is not ready", ^{
                it(@"should not send the request and return an error", ^{
                    char dummyBytes[20000];

                    SDLDeleteCommand *deleteRequest = [[SDLDeleteCommand alloc] initWithId:55];
                    deleteRequest.correlationID = @12345;
                    deleteRequest.bulkData = [NSData dataWithBytes:dummyBytes length:20000];
                    deleteRequest.payloadProtected = YES;

                    __block NSUInteger numTimesCalled = 0;
                    id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
                    [[[transportMock stub] andDo:^(NSInvocation *invocation) {
                        numTimesCalled++;
                    }] sendData:[OCMArg any]];

                    SDLProtocol *testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

                    NSError *error = nil;
                    [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
                    BOOL sent = [testProtocol sendRPC:deleteRequest error:&error];

                    expect(numTimesCalled).to(equal(0));
                    expect(sent).to(beFalse());
                    expect(error).toNot(beNil());
                });
            });

            context(@"when the encryption manager is ready", ^{
                __block NSUInteger numTimesCalled = 0;
                __block SDLProtocol *testProtocol = nil;
                NSUInteger dataSize = 20000;
                beforeEach(^{
                    id transportMock = OCMProtocolMock(@protocol(SDLTransportType));
                    [[[transportMock stub] andDo:^(NSInvocation *invocation) {
                        numTimesCalled++;
                    }] sendData:[OCMArg any]];

                    SDLEncryptionLifecycleManager *encryptionMock = OCMClassMock([SDLEncryptionLifecycleManager class]);
                    OCMStub(encryptionMock.isEncryptionReady).andReturn(YES);

                    id securityManager = OCMProtocolMock(@protocol(SDLSecurityType));
                    char dummyBytes[dataSize];
                    NSData *returnData = [NSData dataWithBytes:dummyBytes length:dataSize];
                    OCMStub([securityManager encryptData:[OCMArg any] withError:[OCMArg setTo:nil]]).andReturn(returnData);

                    testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:encryptionMock];
                    testProtocol.securityManager = securityManager;
                });

                it(@"should correctly adjust the MTU size when the packet is encrypted and the service MTU size is larger than the TLS max size", ^{
                    char dummyBytes[dataSize];
                    
                    SDLDeleteCommand *deleteRequest = [[SDLDeleteCommand alloc] initWithId:55];
                    deleteRequest.correlationID = @12345;
                    deleteRequest.bulkData = [NSData dataWithBytes:dummyBytes length:dataSize];
                    deleteRequest.payloadProtected = YES;

                    NSError *error = nil;
                    [SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
                    BOOL sent = [testProtocol sendRPC:deleteRequest error:&error];

                    expect(numTimesCalled).to(equal(3));
                    expect(sent).to(beTrue());
                    expect(error).to(beNil());
                });
            });
        });
    });
});

// HandleBytesFromTransport Tests
describe(@"HandleBytesFromTransport Tests", ^{
    // During V1 session
    context(@"During V1 session", ^{
//        it(@"Should parse the data correctly", ^{
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

    // During V2 session
    context(@"During V2 session", ^{
//        it(@"Should parse the data correctly", ^{
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

// HandleProtocolSessionStarted tests
describe(@"HandleProtocolSessionStarted tests", ^{
    __block id transportMock = nil;
    __block SDLProtocol *testProtocol = nil;
    __block id delegateMock = nil;
    int64_t testMTU = 989786483;
    int32_t hashId = 1545784;
    NSString *testAuthToken = @"testAuthToken";;
    NSString *testMake = @"Livio";
    NSString *testModel = @"Is";
    NSString *testTrim = @"Awesome";
    NSString *testModelYear = @"2021";
    NSString *testSystemSoftwareVersion = @"1.1.1.1";
    NSString *testSystemHardwareVersion = @"2.2.2.2";

    beforeEach(^{
        transportMock = OCMProtocolMock(@protocol(SDLTransportType));
        testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];
        delegateMock = OCMProtocolMock(@protocol(SDLProtocolDelegate));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
        [[SDLGlobals sharedGlobals] init]; // Make sure to reset between tests
#pragma clang diagnostic pop
    });

    // For protocol versions 5.0.0 and greater
    context(@"For protocol versions 5.0.0 and greater", ^{
        // If the service type is RPC
        context(@"If the service type is RPC", ^{
            it(@"Should store the auth token, system info, and the protocol version and pass the start service along to the delegate", ^{
                SDLControlFramePayloadRPCStartServiceAck *testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:hashId mtu:testMTU authToken:testAuthToken protocolVersion:@"5.2.0" secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil make:testMake model:testModel trim:testTrim modelYear:testModelYear systemSoftwareVersion:testSystemSoftwareVersion systemHardwareVersion:testSystemHardwareVersion];
                NSData *testData = testPayload.data;

                SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testHeader.frameType = SDLFrameTypeControl;
                testHeader.serviceType = SDLServiceTypeRPC;
                testHeader.frameData = SDLFrameInfoStartServiceACK;
                testHeader.sessionID = 0x93;
                testHeader.bytesInPayload = (UInt32)testData.length;

                SDLProtocolMessage *ackMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:testData];
                OCMExpect([delegateMock protocol:testProtocol didReceiveStartServiceACK:ackMessage]);

                [testProtocol.protocolDelegateTable addObject:delegateMock];
                [testProtocol protocol:testProtocol didReceiveStartServiceACK:ackMessage];

                OCMVerifyAllWithDelay(delegateMock, 0.1);

                expect(testProtocol.authToken).to(equal(testAuthToken));
                expect([SDLGlobals sharedGlobals].protocolVersion.stringVersion).to(equal(@"5.2.0"));
                expect([SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion.stringVersion).to(equal(@"5.2.0"));
            });

            it(@"Should store the protocol version, but not get the auth token, and pass the start service along to the delegate if the protocol version is greater than 5.0.0 but less than 5.2.0", ^{
                SDLControlFramePayloadRPCStartServiceAck *testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:hashId mtu:testMTU authToken:testAuthToken protocolVersion:@"5.1.0" secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil make:nil model:nil trim:nil modelYear:nil systemSoftwareVersion:nil systemHardwareVersion:nil];
                NSData *testData = testPayload.data;

                SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testHeader.frameType = SDLFrameTypeControl;
                testHeader.serviceType = SDLServiceTypeRPC;
                testHeader.frameData = SDLFrameInfoStartServiceACK;
                testHeader.sessionID = 0x93;
                testHeader.bytesInPayload = (UInt32)testData.length;

                SDLProtocolMessage *ackMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:testData];
                OCMExpect([delegateMock protocol:testProtocol didReceiveStartServiceACK:ackMessage]);

                [testProtocol.protocolDelegateTable addObject:delegateMock];
                [testProtocol protocol:testProtocol didReceiveStartServiceACK:ackMessage];

                OCMVerifyAllWithDelay(delegateMock, 0.1);

                expect(testProtocol.authToken).to(equal(testAuthToken));
                expect([SDLGlobals sharedGlobals].protocolVersion.stringVersion).to(equal(@"5.1.0"));
                expect([SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion.stringVersion).to(equal(@"5.1.0"));
            });

            it(@"Should set the max head unit version using the header version if the protocol version is missing from the payload", ^{
                SDLControlFramePayloadRPCStartServiceAck *testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:hashId mtu:testMTU authToken:nil protocolVersion:nil secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil make:nil model:nil trim:nil modelYear:nil systemSoftwareVersion:nil systemHardwareVersion:nil];
                NSData *testData = testPayload.data;

                SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testHeader.frameType = SDLFrameTypeControl;
                testHeader.serviceType = SDLServiceTypeRPC;
                testHeader.frameData = SDLFrameInfoStartServiceACK;
                testHeader.sessionID = 0x93;
                testHeader.bytesInPayload = (UInt32)testData.length;

                SDLProtocolMessage *ackMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:testData];
                OCMExpect([delegateMock protocol:testProtocol didReceiveStartServiceACK:ackMessage]);

                [testProtocol.protocolDelegateTable addObject:delegateMock];
                [testProtocol protocol:testProtocol didReceiveStartServiceACK:ackMessage];

                OCMVerifyAllWithDelay(delegateMock, 0.1);

                expect(testProtocol.authToken).to(beNil());
                expect([SDLGlobals sharedGlobals].protocolVersion.stringVersion).to(equal(@"5.0.0"));
                expect([SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion.stringVersion).to(equal(@"5.0.0"));
            });
        });

        context(@"If the service type is control", ^{
            it(@"Should just pass the start service along to the delegate", ^{
                SDLControlFramePayloadRPCStartServiceAck *testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:hashId mtu:testMTU authToken:testAuthToken protocolVersion:@"5.1.0" secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil make:nil model:nil trim:nil modelYear:nil systemSoftwareVersion:nil systemHardwareVersion:nil];
                NSData *testData = testPayload.data;

                SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testHeader.frameType = SDLFrameTypeControl;
                testHeader.serviceType = SDLServiceTypeControl;
                testHeader.frameData = SDLFrameInfoStartServiceACK;
                testHeader.sessionID = 0x93;
                testHeader.bytesInPayload = (UInt32)testData.length;

                SDLProtocolMessage *ackMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:testData];
                OCMExpect([delegateMock protocol:testProtocol didReceiveStartServiceACK:ackMessage]);

                [testProtocol.protocolDelegateTable addObject:delegateMock];
                [testProtocol protocol:testProtocol didReceiveStartServiceACK:ackMessage];

                OCMVerifyAllWithDelay(delegateMock, 0.1);

                // Should keep their default values
                expect(testProtocol.authToken).to(beNil());
                expect([SDLGlobals sharedGlobals].protocolVersion.stringVersion).to(equal(@"1.0.0"));
                expect([SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion.stringVersion).to(equal(@"0.0.0"));
            });
        });
        
        context(@"If the service type is Audio", ^{
            it(@"Should just pass the start service along to the delegate", ^{
                SDLControlFramePayloadAudioStartServiceAck *testPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithMTU:testMTU];
                NSData *testData = testPayload.data;

                SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testHeader.frameType = SDLFrameTypeControl;
                testHeader.serviceType = SDLServiceTypeAudio;
                testHeader.frameData = SDLFrameInfoStartServiceACK;
                testHeader.sessionID = 0x93;
                testHeader.bytesInPayload = (UInt32)testData.length;

                SDLProtocolMessage *ackMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:testData];
                OCMExpect([delegateMock protocol:testProtocol didReceiveStartServiceACK:ackMessage]);

                [testProtocol.protocolDelegateTable addObject:delegateMock];
                [testProtocol protocol:testProtocol didReceiveStartServiceACK:ackMessage];

                OCMVerifyAllWithDelay(delegateMock, 0.1);

                // Should keep their default values
                expect(testProtocol.authToken).to(beNil());
                expect([SDLGlobals sharedGlobals].protocolVersion.stringVersion).to(equal(@"1.0.0"));
                expect([[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeAudio]).to(equal(testMTU));
                expect([SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion.stringVersion).to(equal(@"0.0.0"));
            });
        });
        
        context(@"If the service type is Video", ^{
            it(@"Should just pass the start service along to the delegate", ^{
                SDLControlFramePayloadVideoStartServiceAck *testPayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithMTU:testMTU height:0 width:0 protocol:nil codec:nil];
                NSData *testData = testPayload.data;

                SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testHeader.frameType = SDLFrameTypeControl;
                testHeader.serviceType = SDLServiceTypeVideo;
                testHeader.frameData = SDLFrameInfoStartServiceACK;
                testHeader.sessionID = 0x93;
                testHeader.bytesInPayload = (UInt32)testData.length;

                SDLProtocolMessage *ackMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:testData];
                OCMExpect([delegateMock protocol:testProtocol didReceiveStartServiceACK:ackMessage]);

                [testProtocol.protocolDelegateTable addObject:delegateMock];
                [testProtocol protocol:testProtocol didReceiveStartServiceACK:ackMessage];

                OCMVerifyAllWithDelay(delegateMock, 0.1);

                // Should keep their default values
                expect(testProtocol.authToken).to(beNil());
                expect([SDLGlobals sharedGlobals].protocolVersion.stringVersion).to(equal(@"1.0.0"));
                expect([[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeVideo]).to(equal(testMTU));
                expect([SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion.stringVersion).to(equal(@"0.0.0"));
            });
        });
    });

    // For protocol versions below 5.0.0
    context(@"For protocol versions below 5.0.0", ^{
        // If the service type is RPC
        context(@"If the service type is RPC", ^{
            it(@"Should store the protocol version and pass the start service along to the delegate", ^{
                SDLControlFramePayloadRPCStartServiceAck *testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:hashId mtu:testMTU authToken:nil protocolVersion:@"3.1.0" secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil make:nil model:nil trim:nil modelYear:nil systemSoftwareVersion:nil systemHardwareVersion:nil];
                NSData *testData = testPayload.data;

                SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testHeader.frameType = SDLFrameTypeControl;
                testHeader.serviceType = SDLServiceTypeRPC;
                testHeader.frameData = SDLFrameInfoStartServiceACK;
                testHeader.sessionID = 0x93;
                testHeader.bytesInPayload = (UInt32)testData.length;

                SDLProtocolMessage *ackMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:testData];
                OCMExpect([delegateMock protocol:testProtocol didReceiveStartServiceACK:ackMessage]);

                [testProtocol.protocolDelegateTable addObject:delegateMock];
                [testProtocol protocol:testProtocol didReceiveStartServiceACK:ackMessage];

                OCMVerifyAllWithDelay(delegateMock, 0.1);

                expect([SDLGlobals sharedGlobals].protocolVersion.stringVersion).to(equal(@"3.1.0"));
                expect([SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion.stringVersion).to(equal(@"3.1.0"));
            });
        });

        context(@"If the service type is not RPC", ^{
            it(@"Should just pass the start service along to the delegate", ^{
                SDLControlFramePayloadRPCStartServiceAck *testPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:hashId mtu:testMTU authToken:nil protocolVersion:@"4.1.0" secondaryTransports:nil audioServiceTransports:nil videoServiceTransports:nil make:nil model:nil trim:nil modelYear:nil systemSoftwareVersion:nil systemHardwareVersion:nil];
                NSData *testData = testPayload.data;

                SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:4];
                testHeader.frameType = SDLFrameTypeControl;
                testHeader.serviceType = SDLServiceTypeControl;
                testHeader.frameData = SDLFrameInfoStartServiceACK;
                testHeader.sessionID = 0x93;
                testHeader.bytesInPayload = (UInt32)testData.length;

                SDLProtocolMessage *ackMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:testData];
                OCMExpect([delegateMock protocol:testProtocol didReceiveStartServiceACK:ackMessage]);

                [testProtocol.protocolDelegateTable addObject:delegateMock];
                [testProtocol protocol:testProtocol didReceiveStartServiceACK:ackMessage];

                // Should keep their default values
                expect([SDLGlobals sharedGlobals].protocolVersion.stringVersion).to(equal(@"1.0.0"));
                expect([SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion.stringVersion).to(equal(@"0.0.0"));
                OCMVerifyAllWithDelay(delegateMock, 0.1);
            });
        });
        
        context(@"If the service type is Audio", ^{
            it(@"Should just pass the start service along to the delegate", ^{
                SDLControlFramePayloadAudioStartServiceAck *testPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithMTU:testMTU];
                NSData *testData = testPayload.data;

                SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:4];
                testHeader.frameType = SDLFrameTypeControl;
                testHeader.serviceType = SDLServiceTypeAudio;
                testHeader.frameData = SDLFrameInfoStartServiceACK;
                testHeader.sessionID = 0x93;
                testHeader.bytesInPayload = (UInt32)testData.length;

                SDLProtocolMessage *ackMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:testData];
                OCMExpect([delegateMock protocol:testProtocol didReceiveStartServiceACK:ackMessage]);

                [testProtocol.protocolDelegateTable addObject:delegateMock];
                [testProtocol protocol:testProtocol didReceiveStartServiceACK:ackMessage];

                // Should keep their default values
                expect([SDLGlobals sharedGlobals].protocolVersion.stringVersion).to(equal(@"1.0.0"));
                expect([[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeAudio]).to(equal(1024));
                expect([SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion.stringVersion).to(equal(@"0.0.0"));
                OCMVerifyAllWithDelay(delegateMock, 0.1);
            });
        });
        
        context(@"If the service type is Video", ^{
            it(@"Should just pass the start service along to the delegate", ^{
                SDLControlFramePayloadVideoStartServiceAck *testPayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithMTU:testMTU height:0 width:0 protocol:nil codec:nil];
                NSData *testData = testPayload.data;

                SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:4];
                testHeader.frameType = SDLFrameTypeControl;
                testHeader.serviceType = SDLServiceTypeVideo;
                testHeader.frameData = SDLFrameInfoStartServiceACK;
                testHeader.sessionID = 0x93;
                testHeader.bytesInPayload = (UInt32)testData.length;

                SDLProtocolMessage *ackMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:testData];
                OCMExpect([delegateMock protocol:testProtocol didReceiveStartServiceACK:ackMessage]);

                [testProtocol.protocolDelegateTable addObject:delegateMock];
                [testProtocol protocol:testProtocol didReceiveStartServiceACK:ackMessage];

                // Should keep their default values
                expect([SDLGlobals sharedGlobals].protocolVersion.stringVersion).to(equal(@"1.0.0"));
                expect([[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeVideo]).to(equal(1024));
                expect([SDLGlobals sharedGlobals].maxHeadUnitProtocolVersion.stringVersion).to(equal(@"0.0.0"));
                OCMVerifyAllWithDelay(delegateMock, 0.1);
            });
        });
    });
});

// HandleProtocolRegisterSecondaryTransport Tests
describe(@"HandleProtocolRegisterSecondaryTransport Tests", ^{
    __block id transportMock = nil;
    __block SDLProtocol *testProtocol = nil;

    beforeEach(^{
        transportMock = OCMProtocolMock(@protocol(SDLTransportType));
        testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];
    });

    // Should pass information along to delegate when ACKed
    it(@"Should pass information along to delegate when ACKed", ^{
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolDelegate));

        SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
        testHeader.frameType = SDLFrameTypeControl;
        testHeader.serviceType = SDLServiceTypeControl;
        testHeader.frameData = SDLFrameInfoRegisterSecondaryTransportACK;
        testHeader.sessionID = 0x32;
        testHeader.messageID = 2;
        testHeader.bytesInPayload = 0;

        SDLProtocolMessage *ackMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:nil];
        OCMExpect([delegateMock protocol:testProtocol didReceiveRegisterSecondaryTransportACK:ackMessage]);

        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol protocol:testProtocol didReceiveRegisterSecondaryTransportACK:ackMessage];

        OCMVerifyAllWithDelay(delegateMock, 0.1);
    });

    // Should pass information along to delegate when NAKed
    it(@"Should pass information along to delegate when NAKed", ^{
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolDelegate));

        SDLV2ProtocolHeader* testHeader = [[SDLV2ProtocolHeader alloc] init];
        testHeader.frameType = SDLFrameTypeControl;
        testHeader.serviceType = SDLServiceTypeControl;
        testHeader.frameData = SDLFrameInfoRegisterSecondaryTransportNACK;
        testHeader.sessionID = 0x56;
        testHeader.messageID = 2;

        SDLControlFramePayloadRegisterSecondaryTransportNak *payload = [[SDLControlFramePayloadRegisterSecondaryTransportNak alloc] initWithReason:@"Sample reason"];
        NSData *payloadData = payload.data;

        SDLProtocolMessage *nakMessage = [SDLProtocolMessage messageWithHeader:testHeader andPayload:payloadData];
        OCMExpect([delegateMock protocol:testProtocol didReceiveRegisterSecondaryTransportNAK:nakMessage]);

        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol protocol:testProtocol didReceiveRegisterSecondaryTransportNAK:nakMessage];

        OCMVerifyAllWithDelay(delegateMock, 0.1);
    });
});

// HandleHeartbeatForSession Tests
describe(@"HandleHeartbeatForSession Tests", ^{
    __block id transportMock = nil;
    __block SDLProtocol *testProtocol = nil;
    __block id delegateMock = nil;

    beforeEach(^{
        transportMock = OCMProtocolMock(@protocol(SDLTransportType));
        testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

        delegateMock = OCMProtocolMock(@protocol(SDLProtocolDelegate));
        OCMExpect([delegateMock handleHeartbeatForSession:0x44]);

        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol handleHeartbeatForSession:0x44];
    });

    it(@"Should pass information along to delegate", ^{
        OCMVerifyAllWithDelay(delegateMock, 0.1);
    });
});

// OnProtocolMessageReceived Tests
describe(@"OnProtocolMessageReceived Tests", ^{
    __block id transportMock = nil;
    __block SDLProtocol *testProtocol = nil;
    __block id delegateMock = nil;

    beforeEach(^{
        transportMock = OCMProtocolMock(@protocol(SDLTransportType));
        testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

        SDLProtocolMessage *testMessage = [[SDLProtocolMessage alloc] init];
        SDLV2ProtocolHeader *testHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:3];
        testHeader.serviceType = SDLServiceTypeRPC;
        testMessage.header = testHeader;

        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolDelegate));
        OCMExpect([delegateMock protocol:testProtocol didReceiveMessage:[OCMArg any]]);

        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol protocol:testProtocol didReceiveMessage:testMessage];
    });

    it(@"Should pass information along to delegate", ^{
        OCMVerifyAllWithDelay(delegateMock, 0.1);
    });
});

// OnProtocolOpened Tests
describe(@"OnProtocolOpened Tests", ^{
    __block id transportMock = nil;
    __block SDLProtocol *testProtocol = nil;
    __block id delegateMock = nil;

    beforeEach(^{
        transportMock = OCMProtocolMock(@protocol(SDLTransportType));
        testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolDelegate));
        OCMExpect([delegateMock protocolDidOpen:testProtocol]);

        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol onTransportConnected];
    });

    it(@"Should pass information along to delegate", ^{
        OCMVerifyAllWithDelay(delegateMock, 0.1);
    });
});

// OnProtocolClosed Tests
describe(@"OnProtocolClosed Tests", ^{
    __block id transportMock = nil;
    __block SDLProtocol *testProtocol = nil;
    __block id delegateMock = nil;

    beforeEach(^{
        transportMock = OCMProtocolMock(@protocol(SDLTransportType));
        testProtocol = [[SDLProtocol alloc] initWithTransport:transportMock encryptionManager:nil];

        delegateMock = OCMProtocolMock(@protocol(SDLProtocolDelegate));
        OCMExpect([delegateMock protocolDidClose:testProtocol]);

        [testProtocol.protocolDelegateTable addObject:delegateMock];
        [testProtocol onTransportDisconnected];
    });

    it(@"Should pass information along to delegate", ^{
        OCMVerifyAllWithDelay(delegateMock, 0.1);
    });
});

QuickSpecEnd
