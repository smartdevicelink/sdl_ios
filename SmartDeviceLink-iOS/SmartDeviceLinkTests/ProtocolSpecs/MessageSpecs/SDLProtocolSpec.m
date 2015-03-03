//
//  SDLProtocolSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Jacob Keeler on 2/16/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLProtocol.h"
#import "SDLV1ProtocolMessage.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLV1ProtocolHeader.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLTransport.h"
#import "SDLProtocolRecievedMessageRouter.h"
#import "SDLNames.h"

QuickSpecBegin(SDLProtocolSpec)

//Test dictionaries
NSDictionary* dictionaryV1 = @{NAMES_request:
                                   @{NAMES_operation_name:@"DeleteCommand",
                                     NAMES_correlationID:@0x98765,
                                     NAMES_parameters:
                                         @{NAMES_cmdID:@55}}};
NSDictionary* dictionaryV2 = @{NAMES_cmdID:@55};

describe(@"SendStartSession Tests", ^ {
    it(@"Should send the correct data", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
        
        __block BOOL verified = NO;
        id transportMock = OCMProtocolMock(@protocol(SDLTransport));
        [[[transportMock stub] andDo:^(NSInvocation* invocation) {
            verified = YES;
            
            //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
            __unsafe_unretained NSData* data;
            [invocation getArgument:&data atIndex:2];
            NSData* dataSent = [data copy];
            
            const char testHeader[8] = {0x10 | SDLFrameType_Control, SDLServiceType_BulkData, SDLFrameData_StartSession, 0x00, 0x00, 0x00, 0x00, 0x00};
            expect(dataSent).to(equal([NSData dataWithBytes:testHeader length:8]));
        }] sendData:[OCMArg any]];
        testProtocol.transport = transportMock;
        
        [testProtocol sendStartSessionWithType:SDLServiceType_BulkData];
        
        expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
    });
});

describe(@"SendEndSession Tests", ^ {
    context(@"During V1 session", ^ {
        it(@"Should send the correct data", ^ {
            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            [testProtocol handleProtocolSessionStarted:SDLServiceType_RPC sessionID:0x03 version:0x01];
            
            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransport));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                
                const char testHeader[8] = {0x10 | SDLFrameType_Control, SDLServiceType_RPC, SDLFrameData_EndSession, 0x03, 0x00, 0x00, 0x00, 0x00};
                expect(dataSent).to(equal([NSData dataWithBytes:testHeader length:8]));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;
            
            [testProtocol sendEndSessionWithType:SDLServiceType_RPC sessionID:0x03];
            
            expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
        });
    });
    
    context(@"During V2 session", ^ {
        it(@"Should send the correct data", ^ {
            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            [testProtocol handleProtocolSessionStarted:SDLServiceType_RPC sessionID:0x61 version:0x02];
            
            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransport));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                
                const char testHeader[12] = {0x20 | SDLFrameType_Control, SDLServiceType_RPC, SDLFrameData_EndSession, 0x61, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
                expect(dataSent).to(equal([NSData dataWithBytes:testHeader length:12]));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;
            
            [testProtocol sendEndSessionWithType:SDLServiceType_RPC sessionID:0x61];
            
            expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
        });
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
            [testProtocol handleProtocolSessionStarted:SDLServiceType_RPC sessionID:0xFF version:0x01];
            
            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransport));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                
                NSData* jsonTestData = [NSJSONSerialization dataWithJSONObject:dictionaryV1 options:0 error:0];
                NSUInteger dataLength = jsonTestData.length;
                
                const char testHeader[8] = {0x10 | SDLFrameType_Single, SDLServiceType_RPC, SDLFrameData_SingleFrame, 0xFF, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};
                NSMutableData* testData = [NSMutableData dataWithBytes:testHeader length:8];
                [testData appendData:jsonTestData];
                
                expect(dataSent).to(equal([testData copy]));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;
            
            [testProtocol sendRPCRequest:mockRequest];
            
            expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
        });
    });
    
    context(@"During V2 session", ^ {
        it(@"Should send the correct data", ^ {
            [[[[mockRequest stub] andReturn:dictionaryV2] ignoringNonObjectArgs] serializeAsDictionary:2];
            [[[mockRequest stub] andReturn:@0x98765] correlationID];
            [[[mockRequest stub] andReturn:@"DeleteCommand"] getFunctionName];
            [[[mockRequest stub] andReturn:[NSData dataWithBytes:"COMMAND" length:strlen("COMMAND")]] bulkData];
            
            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            [testProtocol handleProtocolSessionStarted:SDLServiceType_RPC sessionID:0x01 version:0x02];
            
            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransport));
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
                
                const char testHeader[12] = {0x20 | SDLFrameType_Single, SDLServiceType_RPC, SDLFrameData_SingleFrame, 0x01, (payloadData.length >> 24) & 0xFF, (payloadData.length >> 16) & 0xFF,
                                              (payloadData.length >> 8) & 0xFF, payloadData.length & 0xFF, 0x00, 0x00, 0x00, 0x01};
                
                NSMutableData* testData = [NSMutableData dataWithBytes:testHeader length:12];
                [testData appendData:payloadData];
                
                expect(dataSent).to(equal([testData copy]));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;
            
            [testProtocol sendRPCRequest:mockRequest];
            
            expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
        });
    });
});

describe(@"HandleBytesFromTransport Tests", ^ {
    context(@"During V1 session", ^ {
        it(@"Should parse the data correctly", ^ {
            id routerMock = OCMClassMock(SDLProtocolRecievedMessageRouter.class);
            
            //Override initialization methods so that our protocol will use our object instead
            [[[routerMock stub] andReturn:routerMock] alloc];
            (void)[[[routerMock stub] andReturn:routerMock] init];
            
            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            [testProtocol handleProtocolSessionStarted:SDLServiceType_RPC sessionID:0x43 version:0x01];
            
            NSData* jsonTestData = [NSJSONSerialization dataWithJSONObject:dictionaryV1 options:0 error:0];
            NSUInteger dataLength = jsonTestData.length;
            
            __block BOOL verified = NO;
            [[[routerMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained SDLV1ProtocolMessage* message;
                [invocation getArgument:&message atIndex:2];
                
                SDLV1ProtocolMessage* messageReceived = message;
                
                expect(messageReceived.payload).to(equal(jsonTestData));
                expect([NSNumber numberWithInteger:[messageReceived header].version]).to(equal(@1));
                expect([NSNumber numberWithBool:[messageReceived header].compressed]).to(equal([NSNumber numberWithBool:NO]));
                expect([NSNumber numberWithInteger:[messageReceived header].frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Single]));
                expect([NSNumber numberWithInteger:[messageReceived header].sessionID]).to(equal(@0xFF));
                expect([NSNumber numberWithInteger:[messageReceived header].serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_RPC]));
                expect([NSNumber numberWithInteger:[messageReceived header].frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_SingleFrame]));
                expect([NSNumber numberWithInteger:[messageReceived header].bytesInPayload]).to(equal([NSNumber numberWithInteger:dataLength]));
            }] handleRecievedMessage:[OCMArg any]];
            
            const char testHeader[8] = {0x10 | SDLFrameType_Single, SDLServiceType_RPC, SDLFrameData_SingleFrame, 0xFF, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};
            NSMutableData* testData = [NSMutableData dataWithBytes:testHeader length:8];
            [testData appendData:jsonTestData];
            
            [testProtocol handleBytesFromTransport:testData];
            
            expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
        });
    });
    
    context(@"During V2 session", ^ {
        it(@"Should parse the data correctly", ^ {
            id routerMock = OCMClassMock(SDLProtocolRecievedMessageRouter.class);
            
            //Override initialization methods so that our protocol will use our object instead
            [[[routerMock stub] andReturn:routerMock] alloc];
            (void)[[[routerMock stub] andReturn:routerMock] init];
            
            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            [testProtocol handleProtocolSessionStarted:SDLServiceType_RPC sessionID:0xF5 version:0x02];
            
            NSData* jsonTestData = [NSJSONSerialization dataWithJSONObject:dictionaryV2 options:0 error:0];
            NSUInteger dataLength = jsonTestData.length;
            
            const char testPayloadHeader[12] = {0x00, 0x00, 0x00, 0x06, 0x00, 0x09, 0x87, 0x65, (dataLength >> 24) & 0xFF, (dataLength >> 16) & 0xFF, (dataLength >> 8) & 0xFF, dataLength & 0xFF};
            
            NSMutableData* payloadData = [NSMutableData dataWithBytes:testPayloadHeader length:12];
            [payloadData appendData:jsonTestData];
            [payloadData appendBytes:"COMMAND" length:strlen("COMMAND")];
            
            __block BOOL verified = NO;
            [[[routerMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained SDLV2ProtocolMessage* message;
                [invocation getArgument:&message atIndex:2];
                
                SDLV2ProtocolMessage* messageReceived = message;
                
                expect(messageReceived.payload).to(equal(payloadData));
                expect([NSNumber numberWithInteger:[messageReceived header].version]).to(equal(@2));
                expect([NSNumber numberWithBool:[messageReceived header].compressed]).to(equal([NSNumber numberWithBool:NO]));
                expect([NSNumber numberWithInteger:[messageReceived header].frameType]).to(equal([NSNumber numberWithInteger:SDLFrameType_Single]));
                expect([NSNumber numberWithInteger:[messageReceived header].sessionID]).to(equal(@0x01));
                expect([NSNumber numberWithInteger:[messageReceived header].serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_RPC]));
                expect([NSNumber numberWithInteger:[messageReceived header].frameData]).to(equal([NSNumber numberWithInteger:SDLFrameData_SingleFrame]));
                expect([NSNumber numberWithInteger:[messageReceived header].bytesInPayload]).to(equal([NSNumber numberWithInteger:payloadData.length]));
                expect([NSNumber numberWithInteger:((SDLV2ProtocolHeader*)[messageReceived header]).messageID]).to(equal(@1));
                
            }] handleRecievedMessage:[OCMArg any]];
            testProtocol.transport = routerMock;
            
            const char testHeader[12] = {0x20 | SDLFrameType_Single, SDLServiceType_RPC, SDLFrameData_SingleFrame, 0x01, (payloadData.length >> 24) & 0xFF, (payloadData.length >> 16) & 0xFF,
                (payloadData.length >> 8) & 0xFF, payloadData.length & 0xFF, 0x00, 0x00, 0x00, 0x01};
            
            NSMutableData* testData = [NSMutableData dataWithBytes:testHeader length:12];
            [testData appendData:payloadData];
            
            [testProtocol handleBytesFromTransport:testData];
            
            expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
        });
    });
});

describe(@"SendHeartbeat Tests", ^ {
    context(@"During V1 session", ^ {
        it(@"Should send the correct data", ^ {
            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            [testProtocol handleProtocolSessionStarted:SDLServiceType_RPC sessionID:0x43 version:0x01];
            
            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransport));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                
                const char testHeader[8] = {0x10 | SDLFrameType_Control, 0x00, SDLFrameData_Heartbeat, 0x43, 0x00, 0x00, 0x00, 0x00};
                expect(dataSent).to(equal([NSData dataWithBytes:testHeader length:8]));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;
            
            [testProtocol sendHeartbeat];
            
            expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
        });
    });
    
    context(@"During V2 session", ^ {
        it(@"Should send the correct data", ^ {
            SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
            [testProtocol handleProtocolSessionStarted:SDLServiceType_RPC sessionID:0xF5 version:0x02];
            
            __block BOOL verified = NO;
            id transportMock = OCMProtocolMock(@protocol(SDLTransport));
            [[[transportMock stub] andDo:^(NSInvocation* invocation) {
                verified = YES;
                
                //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
                __unsafe_unretained NSData* data;
                [invocation getArgument:&data atIndex:2];
                NSData* dataSent = [data copy];
                
                const char testHeader[12] = {0x20 | SDLFrameType_Control, 0x00, SDLFrameData_Heartbeat, 0xF5, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
                expect(dataSent).to(equal([NSData dataWithBytes:testHeader length:12]));
            }] sendData:[OCMArg any]];
            testProtocol.transport = transportMock;
            
            [testProtocol sendHeartbeat];
            
            expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
        });
    });
});

describe(@"HandleProtocolSessionStarted Tests", ^ {
    it(@"Should pass information along to delegate", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
        
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        __block BOOL verified = NO;
        [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
            verified = YES;
            Byte serviceType;
            Byte sessionID;
            Byte version;
            
            [invocation getArgument:&serviceType atIndex:2];
            [invocation getArgument:&sessionID atIndex:3];
            [invocation getArgument:&version atIndex:4];
            
            expect([NSNumber numberWithInteger:serviceType]).to(equal([NSNumber numberWithInteger:SDLServiceType_BulkData]));
            expect([NSNumber numberWithInteger:sessionID]).to(equal(@0x44));
            expect([NSNumber numberWithInteger:version]).to(equal(@0x03));
        }] ignoringNonObjectArgs] handleProtocolSessionStarted:0 sessionID:0 version:0];
        
        testProtocol.protocolDelegate = delegateMock;
        
        [testProtocol handleProtocolSessionStarted:SDLServiceType_BulkData sessionID:0x44 version:0x03];
        
        expect([NSNumber numberWithBool:verified]).to(beTruthy());
    });
});

describe(@"OnProtocolMessageReceived Tests", ^ {
    it(@"Should pass information along to delegate", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
        
        SDLProtocolMessage* testMessage = [[SDLProtocolMessage alloc] init];
        
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        __block BOOL verified = NO;
        [[[[delegateMock stub] andDo:^(NSInvocation* invocation) {
            verified = YES;
            
            //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
            __unsafe_unretained SDLProtocolMessage* message;
            
            [invocation getArgument:&message atIndex:2];
            
            expect(message).to(beIdenticalTo(testMessage));
        }] ignoringNonObjectArgs] onProtocolMessageReceived:[OCMArg any]];
        
        testProtocol.protocolDelegate = delegateMock;
        
        [testProtocol onProtocolMessageReceived:testMessage];
        
        expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
    });
});

describe(@"OnProtocolOpened Tests", ^ {
    it(@"Should pass information along to delegate", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
        
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        __block BOOL verified = NO;
        [[[delegateMock stub] andDo:^(NSInvocation* invocation) {
            verified = YES;
        }] onProtocolOpened];
        
        testProtocol.protocolDelegate = delegateMock;
        
        [testProtocol onProtocolOpened];
        
        expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
    });
});

describe(@"OnProtocolClosed Tests", ^ {
    it(@"Should pass information along to delegate", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
        
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        __block BOOL verified = NO;
        [[[delegateMock stub] andDo:^(NSInvocation* invocation) {
            verified = YES;
        }] onProtocolClosed];
        
        testProtocol.protocolDelegate = delegateMock;
        
        [testProtocol onProtocolClosed];
        
        expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
    });
});

describe(@"OnError Tests", ^ {
    it(@"Should pass information along to delegate", ^ {
        SDLProtocol* testProtocol = [[SDLProtocol alloc] init];
        
        NSException* testException = [[NSException alloc] initWithName:@"Name" reason:@"No Reason" userInfo:@{}];
        
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        __block BOOL verified = NO;
        [[[delegateMock stub] andDo:^(NSInvocation* invocation) {
            verified = YES;
            //Without the __unsafe_unretained, a double release will occur. More information: https://github.com/erikdoe/ocmock/issues/123
            __unsafe_unretained NSString* message;
            __unsafe_unretained NSException* exception;
            
            [invocation getArgument:&message atIndex:2];
            [invocation getArgument:&exception atIndex:3];
            
            expect(message).to(equal(@"Nothing actually happened"));
            expect(exception).to(equal(testException));
        }] onError:[OCMArg any] exception:[OCMArg any]];
        
        testProtocol.protocolDelegate = delegateMock;
        
        [testProtocol onError:@"Nothing actually happened" exception:testException];
        
        expect([NSNumber numberWithBool:verified]).toEventually(beTruthy());
    });
});

QuickSpecEnd