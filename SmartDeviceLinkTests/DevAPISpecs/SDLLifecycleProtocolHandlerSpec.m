//
//  SDLLifecycleProtocolHandler.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 6/25/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLConfiguration.h"
#import "SDLFunctionID.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLifecycleProtocolHandler.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLProtocol.h"
#import "SDLProtocolDelegate.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocolMessage.h"
#import "SDLRPCPayload.h"
#import "SDLShow.h"
#import "SDLSystemInfo.h"
#import "SDLTimer.h"
#import "TestSystemInfoHandler.h"

@interface SDLLifecycleProtocolHandler ()

@property (weak, nonatomic) SDLNotificationDispatcher *notificationDispatcher;
@property (strong, nonatomic) SDLTimer *rpcStartServiceTimeoutTimer;
@property (copy, nonatomic) NSString *appId;

@end

QuickSpecBegin(SDLLifecycleProtocolHandlerSpec)

describe(@"SDLLifecycleProtocolHandler tests", ^{
    __block SDLLifecycleProtocolHandler *testHandler = nil;
    __block id mockProtocol = nil;
    __block id mockNotificationDispatcher = nil;
    __block id mockTimer = nil;

    beforeEach(^{
        mockProtocol = OCMClassMock([SDLProtocol class]);
        mockNotificationDispatcher = OCMClassMock([SDLNotificationDispatcher class]);
        mockTimer = OCMClassMock([SDLTimer class]);

        SDLLifecycleConfiguration *testLifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:@"test" fullAppId:@"appid"];
        SDLConfiguration *testConfig = [[SDLConfiguration alloc] initWithLifecycle:testLifecycleConfig lockScreen:nil logging:nil fileManager:nil encryption:nil];

        testHandler = [[SDLLifecycleProtocolHandler alloc] initWithProtocol:mockProtocol notificationDispatcher:mockNotificationDispatcher configuration:testConfig];
        testHandler.rpcStartServiceTimeoutTimer = mockTimer;
    });

    describe(@"when started", ^{
        beforeEach(^{
            OCMExpect([(SDLProtocol *)mockProtocol start]);
            [testHandler start];
        });

        it(@"should start the protocol", ^{
            OCMVerifyAll(mockProtocol);
        });
    });

    describe(@"when stopped", ^{
        beforeEach(^{
            OCMExpect([(SDLProtocol *)mockProtocol stopWithCompletionHandler:[OCMArg any]]);
            [testHandler stopWithCompletionHandler:^{}];
        });

        it(@"should stop the protocol", ^{
            OCMVerifyAll(mockProtocol);
        });
    });

    describe(@"when the protocol notifies us", ^{
        context(@"of the transport opening", ^{
            beforeEach(^{
                OCMExpect([mockNotificationDispatcher postNotificationName:[OCMArg isEqual:SDLTransportDidConnect] infoObject:[OCMArg isNil]]);
                OCMExpect([mockProtocol startServiceWithType:0 payload:[OCMArg any]]).ignoringNonObjectArgs();
                OCMExpect([(SDLTimer *)mockTimer start]);
                [testHandler protocolDidOpen:mockProtocol];
            });

            it(@"should set everything up", ^{
                OCMVerifyAll(mockNotificationDispatcher);
                OCMVerifyAll(mockProtocol);
                OCMVerifyAll(mockTimer);
            });
        });

        context(@"of the transport closing", ^{
            beforeEach(^{
                OCMExpect([mockNotificationDispatcher postNotificationName:[OCMArg isEqual:SDLTransportDidDisconnect] infoObject:[OCMArg isNil]]);
                [testHandler protocolDidClose:mockProtocol];
            });

            it(@"should send a notification", ^{
                OCMVerifyAll(mockNotificationDispatcher);
            });
        });

        context(@"of the transport erroring", ^{
            beforeEach(^{
                OCMExpect([mockNotificationDispatcher postNotificationName:[OCMArg isEqual:SDLTransportConnectError] infoObject:[OCMArg isNotNil]]);
                [testHandler protocol:mockProtocol transportDidError:[NSError errorWithDomain:@"test" code:1 userInfo:nil]];
            });

            it(@"should send a notification", ^{
                OCMVerifyAll(mockNotificationDispatcher);
            });
        });

        context(@"of an RPC Start Service ACK", ^{
            beforeEach(^{
                SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:4];
                header.serviceType = SDLServiceTypeRPC;
                header.frameData = SDLFrameInfoStartServiceACK;
                SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];

                OCMExpect([mockNotificationDispatcher postNotificationName:[OCMArg isEqual:SDLRPCServiceDidConnect] infoObject:[OCMArg isNil]]);
                OCMExpect([(SDLTimer *)mockTimer cancel]);

                [testHandler protocol:mockProtocol didReceiveStartServiceACK:message];
            });

            it(@"should stop the timer and send a notification", ^{
                OCMVerifyAll(mockNotificationDispatcher);
                OCMVerifyAll(mockTimer);
            });
        });

        context(@"of an RPC Start Service NAK", ^{
            beforeEach(^{
                SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:4];
                header.serviceType = SDLServiceTypeRPC;
                header.frameData = SDLFrameInfoStartServiceNACK;
                SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];

                OCMExpect([mockNotificationDispatcher postNotificationName:[OCMArg isEqual:SDLRPCServiceConnectionDidError] infoObject:[OCMArg isNil]]);
                OCMExpect([(SDLTimer *)mockTimer cancel]);

                [testHandler protocol:mockProtocol didReceiveStartServiceNAK:message];
            });

            it(@"should stop the timer and send a notification", ^{
                OCMVerifyAll(mockNotificationDispatcher);
                OCMVerifyAll(mockTimer);
            });
        });

        context(@"no response from the module to the RPC Start Service", ^{
            beforeEach(^{
                testHandler.rpcStartServiceTimeoutTimer = nil;
            });

            it(@"should send a transport disconnected notification when the timer elapses", ^{
                OCMExpect([mockProtocol stopWithCompletionHandler:[OCMArg any]]);

                [testHandler protocolDidOpen:mockProtocol];

                OCMVerifyAllWithDelay(mockProtocol, 11.0);
            });
        });

        context(@"of an RPC End Service ACK", ^{
            beforeEach(^{
                SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:4];
                header.serviceType = SDLServiceTypeRPC;
                header.frameData = SDLFrameInfoEndServiceACK;
                SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];

                OCMExpect([mockNotificationDispatcher postNotificationName:[OCMArg isEqual:SDLRPCServiceDidDisconnect] infoObject:[OCMArg isNil]]);
                OCMExpect([(SDLTimer *)mockTimer cancel]);

                [testHandler protocol:mockProtocol didReceiveEndServiceACK:message];
            });

            it(@"should stop the timer and send a notification", ^{
                OCMVerifyAll(mockNotificationDispatcher);
                OCMVerifyAll(mockTimer);
            });
        });

        context(@"of an RPC End Service NAK", ^{
            beforeEach(^{
                SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:4];
                header.serviceType = SDLServiceTypeRPC;
                header.frameData = SDLFrameInfoEndServiceNACK;
                SDLProtocolMessage *message = [SDLProtocolMessage messageWithHeader:header andPayload:nil];

                OCMExpect([mockNotificationDispatcher postNotificationName:[OCMArg isEqual:SDLRPCServiceConnectionDidError] infoObject:[OCMArg any]]);

                [testHandler protocol:mockProtocol didReceiveEndServiceNAK:message];
            });

            it(@"should send a RPC service connection error notification", ^{
                OCMVerifyAll(mockNotificationDispatcher);
            });
        });

        context(@"of a protocol message", ^{
            beforeEach(^{
                SDLShow *showRPC = [[SDLShow alloc] initWithMainField1:@"Test1" mainField2:@"Test2" mainField3:nil mainField4:nil alignment:SDLTextAlignmentLeft statusBar:nil mediaTrack:nil graphic:nil secondaryGraphic:nil softButtons:nil customPresets:nil metadataTags:nil templateTitle:nil windowID:nil templateConfiguration:nil];

                SDLProtocolHeader *header = [SDLProtocolHeader headerForVersion:4];
                header.serviceType = SDLServiceTypeRPC;
                header.frameData = SDLFrameInfoSingleFrame;

                NSDictionary *dict = [showRPC serializeAsDictionary:4];
                NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
                SDLRPCPayload *messagePayload = [[SDLRPCPayload alloc] init];
                messagePayload.jsonData = data;
                messagePayload.rpcType = SDLRPCMessageTypeRequest;
                messagePayload.correlationID = 1;
                messagePayload.functionID = [[SDLFunctionID sharedInstance] functionIdForName:SDLRPCFunctionNameShow].unsignedIntValue;

                SDLProtocolMessage *testMessage = [SDLProtocolMessage messageWithHeader:header andPayload:messagePayload.data];

                OCMExpect([mockNotificationDispatcher postRPCRequestNotification:[OCMArg isEqual:SDLDidReceiveShowRequest] request:[OCMArg isNotNil]]);

                [testHandler protocol:mockProtocol didReceiveMessage:testMessage];
            });

            it(@"should send the notification", ^{
                OCMVerifyAll(mockNotificationDispatcher);
            });
        });
    });

    describe(@"SDLSystemInfoHandler protocol", ^{
        __block TestSystemInfoHandler *testSystemInfoHandler = nil;
        __block SDLSystemInfo *systemInfo = nil;
        beforeEach(^{
            systemInfo = [[SDLSystemInfo alloc] init];
            testSystemInfoHandler = [[TestSystemInfoHandler alloc] init];
            testHandler.systemInfoHandler = testSystemInfoHandler;
        });

        it(@"expect test objects to be instantiated", ^{
            expect(systemInfo).notTo(beNil());
            expect(testSystemInfoHandler).notTo(beNil());
        });

        context(@"didReceiveSystemInfo:", ^{
            it(@"expect callback to be called upon systemInfoHandler", ^{
                testSystemInfoHandler.boolResponse = NO;
                testSystemInfoHandler.lastSystemInfo = nil;
                expect(testSystemInfoHandler.lastSystemInfo).to(beNil());
                BOOL boolResult = [testHandler didReceiveSystemInfo:systemInfo];
                expect(boolResult).to(equal(@NO));
                expect(testSystemInfoHandler.lastSystemInfo).to(equal(systemInfo));

                testSystemInfoHandler.boolResponse = YES;
                testSystemInfoHandler.lastSystemInfo = nil;
                expect(testSystemInfoHandler.lastSystemInfo).to(beNil());
                boolResult = [testHandler didReceiveSystemInfo:systemInfo];
                expect(boolResult).to(equal(@YES));
                expect(testSystemInfoHandler.lastSystemInfo).to(equal(systemInfo));
            });
        });

        context(@"protocol:doDisconnectWithSystemInfo:", ^{
            it(@"expect callback to be called upon systemInfoHandler", ^{
                expect(testSystemInfoHandler.lastSystemInfo).to(beNil());
                [testHandler protocol:mockProtocol doDisconnectWithSystemInfo:systemInfo];
                expect(testSystemInfoHandler.lastSystemInfo).to(equal(systemInfo));
            });
        });
    });
});

QuickSpecEnd
