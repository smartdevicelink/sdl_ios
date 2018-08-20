//
//  SDLSecondaryTransportManagerSpec.m
//  SmartDeviceLinkTests
//
//  Created by Sho Amano on 2018/03/25.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLControlFramePayloadRegisterSecondaryTransportNak.h"
#import "SDLControlFramePayloadRPCStartServiceAck.h"
#import "SDLControlFramePayloadTransportEventUpdate.h"
#import "SDLIAPTransport.h"
#import "SDLProtocol.h"
#import "SDLSecondaryTransportManager.h"
#import "SDLStateMachine.h"
#import "SDLTCPTransport.h"
#import "SDLV2ProtocolMessage.h"

/* copied from SDLSecondaryTransportManager.m */
typedef NSNumber SDLServiceTypeBox;

typedef NS_ENUM(NSInteger, SDLTransportClass) {
    SDLTransportClassInvalid = 0,
    SDLTransportClassPrimary = 1,
    SDLTransportClassSecondary = 2,
};
typedef NSNumber SDLTransportClassBox;

typedef NS_ENUM(NSInteger, SDLSecondaryTransportType) {
    SDLTransportSelectionDisabled,   // only for Secondary Transport
    SDLTransportSelectionIAP,
    SDLTransportSelectionTCP
};

// should be in sync with SDLSecondaryTransportManager.m
static const float RetryConnectionDelay = 5.0;
static const int TCPPortUnspecified = -1;


@interface SDLSecondaryTransportManager ()

// we need to reach to private properties for the tests
@property (assign, nonatomic) SDLSecondaryTransportType secondaryTransportType;
@property (nullable, strong, nonatomic) id<SDLTransportType> secondaryTransport;
@property (nullable, strong, nonatomic) SDLProtocol *secondaryProtocol;
@property (strong, nonatomic, nonnull) NSArray<SDLTransportClassBox *> *transportsForAudioService;
@property (strong, nonatomic, nonnull) NSArray<SDLTransportClassBox *> *transportsForVideoService;
@property (strong, nonatomic) NSMutableDictionary<SDLServiceTypeBox *, SDLTransportClassBox *> *streamingServiceTransportMap;
@property (strong, nonatomic, nullable) NSString *ipAddress;
@property (assign, nonatomic) int tcpPort;

@end

@interface SDLSecondaryTransportManager (ForTest)
// Swap sdl_getAppState method to dummy implementation.
// Since the test runs on the main thread, dispatch_sync()-ing to the main thread doesn't work.
+ (void)swapGetAppStateMethod;
@end

@implementation SDLSecondaryTransportManager (ForTest)
- (UIApplicationState)dummyGetAppState {
    NSLog(@"Testing: app state for secondary transport manager is always ACTIVE");
    return UIApplicationStateActive;
}

+ (void)swapGetAppStateMethod {
    SEL selector = NSSelectorFromString(@"sdl_getAppState");
    Method from = class_getInstanceMethod(self, selector);
    Method to = class_getInstanceMethod(self, @selector(dummyGetAppState));
    method_exchangeImplementations(from, to);
}
@end

@interface SDLTCPTransport (ConnectionDisabled)
// Disable connect and disconnect methods
+ (void)swapConnectionMethods;
@end

@implementation SDLTCPTransport (ConnectionDisabled)
- (void)dummyConnect {
    NSLog(@"SDLTCPTransport connect doing nothing");
}
- (void)dummyDisconnect {
    NSLog(@"SDLTCPTransport disconnect doing nothing");
}

+ (void)swapConnectionMethods {
    Method from = class_getInstanceMethod(self, @selector(connect));
    Method to = class_getInstanceMethod(self, @selector(dummyConnect));
    method_exchangeImplementations(from, to);

    from = class_getInstanceMethod(self, @selector(disconnect));
    to = class_getInstanceMethod(self, @selector(dummyDisconnect));
    method_exchangeImplementations(from, to);
}
@end

@interface SDLIAPTransport (ConnectionDisabled)
// Disable connect and disconnect methods
+ (void)swapConnectionMethods;
@end

@implementation SDLIAPTransport (ConnectionDisabled)
- (void)dummyConnect {
    NSLog(@"SDLIAPTransport connect doing nothing");
}
- (void)dummyDisconnect {
    NSLog(@"SDLIAPTransport disconnect doing nothing");
}

+ (void)swapConnectionMethods {
    Method from = class_getInstanceMethod(self, @selector(connect));
    Method to = class_getInstanceMethod(self, @selector(dummyConnect));
    method_exchangeImplementations(from, to);

    from = class_getInstanceMethod(self, @selector(disconnect));
    to = class_getInstanceMethod(self, @selector(dummyDisconnect));
    method_exchangeImplementations(from, to);
}
@end


QuickSpecBegin(SDLSecondaryTransportManagerSpec)

describe(@"the secondary transport manager ", ^{
    __block SDLSecondaryTransportManager *manager = nil;
    __block dispatch_queue_t testStateMachineQueue;
    __block SDLProtocol *testPrimaryProtocol = nil;
    __block id<SDLTransportType> testPrimaryTransport = nil;
    __block id testStreamingProtocolDelegate = nil;

    beforeEach(^{
        [SDLSecondaryTransportManager swapGetAppStateMethod];
        [SDLTCPTransport swapConnectionMethods];
        [SDLIAPTransport swapConnectionMethods];

        // "strict" mock. If one of the delegate methods is called without prior expectation, it will throw an exception
        testStreamingProtocolDelegate = OCMStrictProtocolMock(@protocol(SDLStreamingProtocolDelegate));
        testStateMachineQueue = dispatch_queue_create("com.sdl.testsecondarytransportmanager", DISPATCH_QUEUE_SERIAL);
        manager = [[SDLSecondaryTransportManager alloc] initWithStreamingProtocolDelegate:testStreamingProtocolDelegate serialQueue:testStateMachineQueue];
    });

    afterEach(^{
        // it is possible that manager calls methods of SDLStreamingProtocolDelegate while stopping, so accept them
        // (Don't put OCMVerifyAll() after calling stop.)
        OCMExpect([testStreamingProtocolDelegate audioServiceProtocolDidUpdateFromOldProtocol:OCMOCK_ANY toNewProtocol:nil]);
        OCMExpect([testStreamingProtocolDelegate videoServiceProtocolDidUpdateFromOldProtocol:OCMOCK_ANY toNewProtocol:nil]);

        dispatch_sync(testStateMachineQueue, ^{
            [manager stop];
        });
        manager = nil;

        [SDLIAPTransport swapConnectionMethods];
        [SDLTCPTransport swapConnectionMethods];
        [SDLSecondaryTransportManager swapGetAppStateMethod];
    });


    it(@"should initialize its property", ^{
        expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
        expect((NSInteger)manager.secondaryTransportType).to(equal(SDLTransportSelectionDisabled));
        expect(manager.transportsForAudioService).to(equal(@[]));
        expect(manager.transportsForVideoService).to(equal(@[]));
        NSMutableDictionary<SDLServiceTypeBox *, SDLTransportClassBox *> *expectedAssignedTransport = [@{@(SDLServiceTypeAudio):@(SDLTransportClassInvalid),
           @(SDLServiceTypeVideo):@(SDLTransportClassInvalid)} mutableCopy];
        expect(manager.streamingServiceTransportMap).to(equal(expectedAssignedTransport));
        expect(manager.ipAddress).to(beNil());
        expect(manager.tcpPort).to(equal(TCPPortUnspecified));
    });


    describe(@"when started", ^{
        beforeEach(^{
            testPrimaryProtocol = [[SDLProtocol alloc] init];
        });

        it(@"should transition to Started state", ^{
            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });

            expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStarted));
            OCMVerifyAll(testStreamingProtocolDelegate);
        });
    });


    describe(@"In Started state", ^{
        beforeEach(^{
            // In the tests, we assume primary transport is iAP
            testPrimaryProtocol = [[SDLProtocol alloc] init];
            testPrimaryTransport = [[SDLIAPTransport alloc] init];
            testPrimaryProtocol.transport = testPrimaryTransport;

            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });
        });

        describe(@"when received Start Service ACK on primary transport", ^{
            __block SDLProtocolHeader *testStartServiceACKHeader = nil;
            __block SDLProtocolMessage *testStartServiceACKMessage = nil;
            __block SDLControlFramePayloadRPCStartServiceAck *testStartServiceACKPayload = nil;
            __block int32_t testHashId = 12345;
            __block int64_t testMtu = 12345678;
            __block NSString *testProtocolVersion = @"5.1.0";
            __block NSArray<NSString *> *testSecondaryTransports = nil;
            __block NSArray<NSNumber *> *testAudioServiceTransports = nil;
            __block NSArray<NSNumber *> *testVideoServiceTransports = nil;

            beforeEach(^{
                testStartServiceACKHeader = [SDLProtocolHeader headerForVersion:5];
                testStartServiceACKHeader.frameType = SDLFrameTypeControl;
                testStartServiceACKHeader.serviceType = SDLServiceTypeRPC;
                testStartServiceACKHeader.frameData = SDLFrameInfoStartServiceACK;

                testSecondaryTransports = nil;
                testAudioServiceTransports = nil;
                testVideoServiceTransports = nil;
            });

            context(@"with parameters for TCP secondary transport", ^{
                beforeEach(^{
                    testSecondaryTransports = @[@"TCP_WIFI"];
                    testAudioServiceTransports = @[@(2), @(1)];
                    testVideoServiceTransports = @[@(2)];

                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];

                });

                it(@"should configure its properties and transition to Configured state", ^{
                    // in this configuration, only audio service is allowed on primary transport
                    OCMExpect([testStreamingProtocolDelegate audioServiceProtocolDidUpdateFromOldProtocol:nil toNewProtocol:testPrimaryProtocol]);

                    [testPrimaryProtocol handleBytesFromTransport:testStartServiceACKMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));

                    expect((NSInteger)manager.secondaryTransportType).to(equal(SDLTransportSelectionTCP));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForAudioService = @[@(SDLTransportClassSecondary), @(SDLTransportClassPrimary)];
                    expect(manager.transportsForAudioService).to(equal(expectedTransportsForAudioService));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForVideoService = @[@(SDLTransportClassSecondary)];
                    expect(manager.transportsForVideoService).to(equal(expectedTransportsForVideoService));

                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            context(@"with only secondary transports parameter for TCP", ^{
                beforeEach(^{
                    // Note: this is not allowed for now. It should contain only one element.
                    testSecondaryTransports = @[@"TCP_WIFI", @"IAP_USB_HOST_MODE"];

                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];
                });

                it(@"should configure its properties and transition to Configured state", ^{
                    // in this case, audio and video services start on primary transport (for compatibility)
                    OCMExpect([testStreamingProtocolDelegate audioServiceProtocolDidUpdateFromOldProtocol:nil toNewProtocol:testPrimaryProtocol]);
                    OCMExpect([testStreamingProtocolDelegate videoServiceProtocolDidUpdateFromOldProtocol:nil toNewProtocol:testPrimaryProtocol]);

                    [testPrimaryProtocol handleBytesFromTransport:testStartServiceACKMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));

                    expect((NSInteger)manager.secondaryTransportType).to(equal(SDLTransportSelectionTCP));
                    expect(manager.transportsForAudioService).to(equal(@[@(SDLTransportClassPrimary)]));
                    expect(manager.transportsForVideoService).to(equal(@[@(SDLTransportClassPrimary)]));

                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            context(@"with parameters for iAP secondary transport", ^{
                beforeEach(^{
                    testSecondaryTransports = @[@"IAP_USB_HOST_MODE"];
                    testAudioServiceTransports = @[@(2)];
                    testVideoServiceTransports = @[@(2)];

                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];
                });

                it(@"should transition to Configured state with transport type disabled", ^{
                    // Since primary transport is iAP, we cannot use iAP for secondary transport.
                    // So both services run on primary transport.
                    OCMExpect([testStreamingProtocolDelegate audioServiceProtocolDidUpdateFromOldProtocol:nil toNewProtocol:testPrimaryProtocol]);
                    OCMExpect([testStreamingProtocolDelegate videoServiceProtocolDidUpdateFromOldProtocol:nil toNewProtocol:testPrimaryProtocol]);

                    [testPrimaryProtocol handleBytesFromTransport:testStartServiceACKMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));

                    // see the comment above
                    expect((NSInteger)manager.secondaryTransportType).to(equal(SDLTransportSelectionDisabled));
                    expect(manager.transportsForAudioService).to(equal(@[@(SDLTransportClassPrimary)]));
                    expect(manager.transportsForVideoService).to(equal(@[@(SDLTransportClassPrimary)]));

                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            context(@"without secondary transport related parameter", ^{
                beforeEach(^{
                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];
                });

                it(@"should transition to Configured state with transport type disabled", ^{
                    // both services run on primary transport
                    OCMExpect([testStreamingProtocolDelegate audioServiceProtocolDidUpdateFromOldProtocol:nil toNewProtocol:testPrimaryProtocol]);
                    OCMExpect([testStreamingProtocolDelegate videoServiceProtocolDidUpdateFromOldProtocol:nil toNewProtocol:testPrimaryProtocol]);

                    [testPrimaryProtocol handleBytesFromTransport:testStartServiceACKMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));

                    expect((NSInteger)manager.secondaryTransportType).to(equal(SDLTransportSelectionDisabled));
                    expect(manager.transportsForAudioService).to(equal(@[@(SDLTransportClassPrimary)]));
                    expect(manager.transportsForVideoService).to(equal(@[@(SDLTransportClassPrimary)]));

                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });
        });

        describe(@"when received Transport Event Update frame on primary transport prior to Start Service ACK", ^{
            __block SDLProtocolHeader *testTransportEventUpdateHeader = nil;
            __block SDLProtocolMessage *testTransportEventUpdateMessage = nil;
            __block SDLControlFramePayloadTransportEventUpdate *testTransportEventUpdatePayload = nil;
            __block NSString *testTcpIpAddress = nil;
            __block int32_t testTcpPort = TCPPortUnspecified;

            beforeEach(^{
                testTransportEventUpdateHeader = [SDLProtocolHeader headerForVersion:5];
                testTransportEventUpdateHeader.frameType = SDLFrameTypeControl;
                testTransportEventUpdateHeader.serviceType = SDLServiceTypeControl;
                testTransportEventUpdateHeader.frameData = SDLFrameInfoTransportEventUpdate;
                testTcpIpAddress = @"192.168.1.1";
                testTcpPort = 12345;

                testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
            });

            it(@"should configure its properties but stay in Started state", ^{
                [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                [NSThread sleepForTimeInterval:0.1];

                expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStarted));

                expect((NSInteger)manager.secondaryTransportType).to(equal(SDLTransportSelectionDisabled));
                expect(manager.transportsForAudioService).to(equal(@[]));
                expect(manager.transportsForVideoService).to(equal(@[]));
                expect(manager.ipAddress).to(equal(testTcpIpAddress));
                expect(manager.tcpPort).to(equal(testTcpPort));

                OCMVerifyAll(testStreamingProtocolDelegate);
            });
        });

        describe(@"when received Transport Event Update frame and then Start Service ACK on primary transport", ^{
            __block SDLProtocolHeader *testTransportEventUpdateHeader = nil;
            __block SDLProtocolMessage *testTransportEventUpdateMessage = nil;
            __block SDLControlFramePayloadTransportEventUpdate *testTransportEventUpdatePayload = nil;
            __block NSString *testTcpIpAddress = nil;
            __block int32_t testTcpPort = TCPPortUnspecified;

            __block SDLProtocolHeader *testStartServiceACKHeader = nil;
            __block SDLProtocolMessage *testStartServiceACKMessage = nil;
            __block SDLControlFramePayloadRPCStartServiceAck *testStartServiceACKPayload = nil;
            __block int32_t testHashId = 12345;
            __block int64_t testMtu = 1234567;
            __block NSString *testProtocolVersion = @"5.1.0";
            __block NSArray<NSString *> *testSecondaryTransports = @[@"TCP_WIFI"];
            __block NSArray<NSNumber *> *testAudioServiceTransports = @[@(2)];
            __block NSArray<NSNumber *> *testVideoServiceTransports = @[@(2)];

            beforeEach(^{
                testTransportEventUpdateHeader = [SDLProtocolHeader headerForVersion:5];
                testTransportEventUpdateHeader.frameType = SDLFrameTypeControl;
                testTransportEventUpdateHeader.serviceType = SDLServiceTypeControl;
                testTransportEventUpdateHeader.frameData = SDLFrameInfoTransportEventUpdate;

                testStartServiceACKHeader = [SDLProtocolHeader headerForVersion:5];
                testStartServiceACKHeader.frameType = SDLFrameTypeControl;
                testStartServiceACKHeader.serviceType = SDLServiceTypeRPC;
                testStartServiceACKHeader.frameData = SDLFrameInfoStartServiceACK;
            });

            context(@"and if TCP configuration is valid", ^{
                beforeEach(^{
                    testTcpIpAddress = @"fd12:3456:789a::1";
                    testTcpPort = 5678;
                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];

                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];
                });

                it(@"should configure its properties and immediately transition to Connecting state", ^{
                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [testPrimaryProtocol handleBytesFromTransport:testStartServiceACKMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConnecting));

                    expect((NSInteger)manager.secondaryTransportType).to(equal(SDLTransportSelectionTCP));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForAudioService = @[@(SDLTransportClassSecondary)];
                    expect(manager.transportsForAudioService).to(equal(expectedTransportsForAudioService));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForVideoService = @[@(SDLTransportClassSecondary)];
                    expect(manager.transportsForVideoService).to(equal(expectedTransportsForVideoService));
                    expect(manager.ipAddress).to(equal(testTcpIpAddress));
                    expect(manager.tcpPort).to(equal(testTcpPort));

                    SDLTCPTransport *secondaryTransport = (SDLTCPTransport *)manager.secondaryTransport;
                    expect(secondaryTransport.hostName).to(equal(testTcpIpAddress));
                    NSString *portNumberString = [NSString stringWithFormat:@"%d", testTcpPort];
                    expect(secondaryTransport.portNumber).to(equal(portNumberString));

                    // audio and video services will not start until secondary transport is established
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            context(@"and if TCP configuration is invalid", ^{
                beforeEach(^{
                    testTcpIpAddress = @"";
                    testTcpPort = 5678;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];

                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];
                });

                it(@"should configure its properties and transition to Configured state", ^{
                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [testPrimaryProtocol handleBytesFromTransport:testStartServiceACKMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));

                    expect((NSInteger)manager.secondaryTransportType).to(equal(SDLTransportSelectionTCP));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForAudioService = @[@(SDLTransportClassSecondary)];
                    expect(manager.transportsForAudioService).to(equal(expectedTransportsForAudioService));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForVideoService = @[@(SDLTransportClassSecondary)];
                    expect(manager.transportsForVideoService).to(equal(expectedTransportsForVideoService));
                    expect(manager.ipAddress).to(equal(testTcpIpAddress));
                    expect(manager.tcpPort).to(equal(testTcpPort));

                    expect(manager.secondaryTransport).to(beNil());

                    // audio and video services will not start until secondary transport is established
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });
        });

        describe(@"when stopped", ^{
            it(@"should transition to Stopped state", ^{
                dispatch_sync(testStateMachineQueue, ^{
                    [manager stop];
                });

                expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                OCMVerifyAll(testStreamingProtocolDelegate);
            });
        });
    });


    describe(@"In Configured state", ^{
        describe(@"if secondary transport is iAP", ^{
            beforeEach(^{
                // in this case we assume the primary transport is TCP
                testPrimaryProtocol = [[SDLProtocol alloc] init];
                testPrimaryTransport = [[SDLTCPTransport alloc] init];
                testPrimaryProtocol.transport = testPrimaryTransport;
                dispatch_sync(testStateMachineQueue, ^{
                    [manager startWithPrimaryProtocol:testPrimaryProtocol];
                });

                manager.secondaryTransportType = SDLTransportSelectionIAP;
            });

            it(@"should transition to Connecting state", ^{
                // setToState cannot be used here, as the method will set the state after calling didEnterStateConfigured
                dispatch_sync(testStateMachineQueue, ^{
                    [manager.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
                });

                expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConnecting));
                OCMVerifyAll(testStreamingProtocolDelegate);
            });
        });
        describe(@"if secondary transport is TCP", ^{
            beforeEach(^{
                testPrimaryProtocol = [[SDLProtocol alloc] init];
                testPrimaryTransport = [[SDLIAPTransport alloc] init];
                testPrimaryProtocol.transport = testPrimaryTransport;
                dispatch_sync(testStateMachineQueue, ^{
                    [manager startWithPrimaryProtocol:testPrimaryProtocol];
                });

                manager.secondaryTransportType = SDLTransportSelectionTCP;
                manager.ipAddress = nil;
                manager.tcpPort = TCPPortUnspecified;

                dispatch_sync(testStateMachineQueue, ^{
                    [manager.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
                });
            });

            describe(@"and Transport Event Update is not received", ^{
                it(@"should stay in Configured state", ^{
                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            describe(@"and Transport Event Update is received", ^{
                __block SDLProtocolHeader *testTransportEventUpdateHeader = nil;
                __block SDLProtocolMessage *testTransportEventUpdateMessage = nil;
                __block SDLControlFramePayloadTransportEventUpdate *testTransportEventUpdatePayload = nil;
                __block NSString *testTcpIpAddress = nil;
                __block int32_t testTcpPort = TCPPortUnspecified;

                beforeEach(^{
                    testTransportEventUpdateHeader = [SDLProtocolHeader headerForVersion:5];
                    testTransportEventUpdateHeader.frameType = SDLFrameTypeControl;
                    testTransportEventUpdateHeader.serviceType = SDLServiceTypeControl;
                    testTransportEventUpdateHeader.frameData = SDLFrameInfoTransportEventUpdate;
                    testTcpIpAddress = @"10.20.30.40";
                    testTcpPort = 22222;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should transition to Connecting state", ^{
                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConnecting));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });
        });

        describe(@"when stopped", ^{
            beforeEach(^{
                testPrimaryProtocol = [[SDLProtocol alloc] init];
                testPrimaryTransport = [[SDLIAPTransport alloc] init];
                testPrimaryProtocol.transport = testPrimaryTransport;

                dispatch_sync(testStateMachineQueue, ^{
                    [manager startWithPrimaryProtocol:testPrimaryProtocol];
                    [manager.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
                });
            });

            it(@"should transition to Stopped state", ^{
                dispatch_sync(testStateMachineQueue, ^{
                    [manager stop];
                });

                expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                OCMVerifyAll(testStreamingProtocolDelegate);
            });
        });
    });


    describe(@"In Connecting state", ^{
        __block SDLProtocol *secondaryProtocol = nil;
        __block id testSecondaryProtocolMock = nil;

        beforeEach(^{
            secondaryProtocol = [[SDLProtocol alloc] init];
            testSecondaryProtocolMock = OCMPartialMock(secondaryProtocol);

            testPrimaryProtocol = [[SDLProtocol alloc] init];
            testPrimaryTransport = [[SDLIAPTransport alloc] init];
            testPrimaryProtocol.transport = testPrimaryTransport;
            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });

            [secondaryProtocol.protocolDelegateTable addObject:manager];
            manager.secondaryProtocol = secondaryProtocol;

            dispatch_sync(testStateMachineQueue, ^{
                [manager.stateMachine setToState:SDLSecondaryTransportStateConnecting fromOldState:nil callEnterTransition:NO];
            });
        });

        describe(@"when transport is opened", ^{
            it(@"should send out Register Secondary Transport frame", ^{
                OCMExpect([testSecondaryProtocolMock registerSecondaryTransport]);

                [testSecondaryProtocolMock onProtocolOpened];
                [NSThread sleepForTimeInterval:0.1];

                OCMVerifyAll(testSecondaryProtocolMock);
                OCMVerifyAll(testStreamingProtocolDelegate);

                // Note: cannot test the timeout scenario since the timer fires on main thread
            });

            describe(@"and Register Secondary Transport ACK is received", ^{
                __block SDLProtocolHeader *testRegisterSecondaryTransportAckHeader = nil;
                __block SDLProtocolMessage *testRegisterSecondaryTransportAckMessage = nil;

                beforeEach(^{
                    // assume audio and video services are allowed only on secondary transport
                    manager.transportsForAudioService = @[@(SDLTransportClassSecondary)];
                    manager.transportsForVideoService = @[@(SDLTransportClassSecondary)];
                    manager.streamingServiceTransportMap[@(SDLServiceTypeAudio)] = @(SDLTransportClassInvalid);
                    manager.streamingServiceTransportMap[@(SDLServiceTypeVideo)] = @(SDLTransportClassInvalid);

                    testRegisterSecondaryTransportAckHeader = [SDLProtocolHeader headerForVersion:5];
                    testRegisterSecondaryTransportAckHeader.frameType = SDLFrameTypeControl;
                    testRegisterSecondaryTransportAckHeader.serviceType = SDLServiceTypeControl;
                    testRegisterSecondaryTransportAckHeader.frameData = SDLFrameInfoRegisterSecondaryTransportACK;

                    testRegisterSecondaryTransportAckMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testRegisterSecondaryTransportAckHeader andPayload:nil];
                });

                it(@"should transition to Registered state", ^{
                    OCMExpect([testStreamingProtocolDelegate audioServiceProtocolDidUpdateFromOldProtocol:nil toNewProtocol:secondaryProtocol]);
                    OCMExpect([testStreamingProtocolDelegate videoServiceProtocolDidUpdateFromOldProtocol:nil toNewProtocol:secondaryProtocol]);

                    [testSecondaryProtocolMock handleBytesFromTransport:testRegisterSecondaryTransportAckMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateRegistered));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            describe(@"and Register Secondary Transport NACK is received", ^{
                __block SDLProtocolHeader *testRegisterSecondaryTransportNakHeader = nil;
                __block SDLProtocolMessage *testRegisterSecondaryTransportNakMessage = nil;
                __block SDLControlFramePayloadRegisterSecondaryTransportNak *testRegisterSecondaryTransportPayload = nil;
                __block NSString *testRegisterFailedReason = @"Unknown";

                beforeEach(^{
                    testRegisterSecondaryTransportNakHeader = [SDLProtocolHeader headerForVersion:5];
                    testRegisterSecondaryTransportNakHeader.frameType = SDLFrameTypeControl;
                    testRegisterSecondaryTransportNakHeader.serviceType = SDLServiceTypeControl;
                    testRegisterSecondaryTransportNakHeader.frameData = SDLFrameInfoRegisterSecondaryTransportNACK;

                    testRegisterSecondaryTransportPayload = [[SDLControlFramePayloadRegisterSecondaryTransportNak alloc] initWithReason:testRegisterFailedReason];
                    testRegisterSecondaryTransportNakMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testRegisterSecondaryTransportNakHeader andPayload:testRegisterSecondaryTransportPayload.data];
                });

                it(@"should transition to Reconnecting state", ^{
                    [testSecondaryProtocolMock handleBytesFromTransport:testRegisterSecondaryTransportNakMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateReconnecting));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });
        });

        describe(@"when transport is closed", ^{
            it(@"should transition to Reconnecting state", ^{
                [testSecondaryProtocolMock onProtocolClosed];
                [NSThread sleepForTimeInterval:0.1];

                expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateReconnecting));
                OCMVerifyAll(testStreamingProtocolDelegate);
            });
        });

        describe(@"when Transport Event Update is received", ^{
            __block SDLProtocolHeader *testTransportEventUpdateHeader = nil;
            __block SDLProtocolMessage *testTransportEventUpdateMessage = nil;
            __block SDLControlFramePayloadTransportEventUpdate *testTransportEventUpdatePayload = nil;
            __block NSString *testTcpIpAddress = nil;
            __block int32_t testTcpPort = TCPPortUnspecified;

            beforeEach(^{
                manager.secondaryTransportType = SDLTransportSelectionTCP;
                manager.ipAddress = @"192.168.1.1";
                manager.tcpPort = 12345;

                testTransportEventUpdateHeader = [SDLProtocolHeader headerForVersion:5];
                testTransportEventUpdateHeader.frameType = SDLFrameTypeControl;
                testTransportEventUpdateHeader.serviceType = SDLServiceTypeControl;
                testTransportEventUpdateHeader.frameData = SDLFrameInfoTransportEventUpdate;
            });

            context(@"with same IP address and port number", ^{
                beforeEach(^{
                    testTcpIpAddress = @"192.168.1.1";
                    testTcpPort = 12345;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should ignore the frame and stay in Connecting state", ^{
                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConnecting));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            context(@"with different IP address", ^{
                beforeEach(^{
                    testTcpIpAddress = @"172.16.12.34";
                    testTcpPort = 12345;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should transition to Configured state, then transition to Connecting state again", ^{
                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConnecting));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            context(@"with invalid IP address", ^{
                beforeEach(^{
                    testTcpIpAddress = @"";
                    testTcpPort = 12345;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should transition to Configured state", ^{
                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

        });

        describe(@"when stopped", ^{
            it(@"should transition to Stopped state", ^{
                dispatch_sync(testStateMachineQueue, ^{
                    [manager stop];
                });

                expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                OCMVerifyAll(testStreamingProtocolDelegate);
            });
        });
    });


    describe(@"In Registered state", ^{
        __block SDLProtocol *secondaryProtocol = nil;
        __block id testSecondaryProtocolMock = nil;

        beforeEach(^{
            secondaryProtocol = [[SDLProtocol alloc] init];
            testSecondaryProtocolMock = OCMPartialMock(secondaryProtocol);

            testPrimaryProtocol = [[SDLProtocol alloc] init];
            testPrimaryTransport = [[SDLIAPTransport alloc] init];
            testPrimaryProtocol.transport = testPrimaryTransport;
            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });

            [secondaryProtocol.protocolDelegateTable addObject:manager];
            manager.secondaryProtocol = secondaryProtocol;

            dispatch_sync(testStateMachineQueue, ^{
                [manager.stateMachine setToState:SDLSecondaryTransportStateRegistered fromOldState:nil callEnterTransition:NO];
            });
        });

        describe(@"when Transport Event Update is received", ^{
            __block SDLProtocolHeader *testTransportEventUpdateHeader = nil;
            __block SDLProtocolMessage *testTransportEventUpdateMessage = nil;
            __block SDLControlFramePayloadTransportEventUpdate *testTransportEventUpdatePayload = nil;
            __block NSString *testTcpIpAddress = nil;
            __block int32_t testTcpPort = TCPPortUnspecified;

            beforeEach(^{
                // assume audio and video services are allowed only on secondary transport
                manager.transportsForAudioService = @[@(SDLTransportClassSecondary)];
                manager.transportsForVideoService = @[@(SDLTransportClassSecondary)];
                manager.streamingServiceTransportMap[@(SDLServiceTypeAudio)] = @(SDLTransportClassSecondary);
                manager.streamingServiceTransportMap[@(SDLServiceTypeVideo)] = @(SDLTransportClassSecondary);

                manager.secondaryTransportType = SDLTransportSelectionTCP;
                manager.ipAddress = @"192.168.1.1";
                manager.tcpPort = 12345;

                testTransportEventUpdateHeader = [SDLProtocolHeader headerForVersion:5];
                testTransportEventUpdateHeader.frameType = SDLFrameTypeControl;
                testTransportEventUpdateHeader.serviceType = SDLServiceTypeControl;
                testTransportEventUpdateHeader.frameData = SDLFrameInfoTransportEventUpdate;
            });

            context(@"with same IP address and port number", ^{
                beforeEach(^{
                    testTcpIpAddress = @"192.168.1.1";
                    testTcpPort = 12345;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should ignore the frame and stay in Registered state", ^{
                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateRegistered));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            context(@"with different IP address", ^{
                beforeEach(^{
                    testTcpIpAddress = @"172.16.12.34";
                    testTcpPort = 12345;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should transition to Configured state, then transition to Connecting state again", ^{
                    OCMExpect([testStreamingProtocolDelegate audioServiceProtocolDidUpdateFromOldProtocol:secondaryProtocol toNewProtocol:nil]);
                    OCMExpect([testStreamingProtocolDelegate videoServiceProtocolDidUpdateFromOldProtocol:secondaryProtocol toNewProtocol:nil]);

                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConnecting));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            context(@"with invalid IP address", ^{
                beforeEach(^{
                    testTcpIpAddress = @"";
                    testTcpPort = 12345;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should transition to Configured state", ^{
                    OCMExpect([testStreamingProtocolDelegate audioServiceProtocolDidUpdateFromOldProtocol:secondaryProtocol toNewProtocol:nil]);
                    OCMExpect([testStreamingProtocolDelegate videoServiceProtocolDidUpdateFromOldProtocol:secondaryProtocol toNewProtocol:nil]);

                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });
        });

        describe(@"when transport is closed", ^{
            beforeEach(^{
                // assume audio and video services are allowed only on secondary transport
                manager.transportsForAudioService = @[@(SDLTransportClassSecondary)];
                manager.transportsForVideoService = @[@(SDLTransportClassSecondary)];
                manager.streamingServiceTransportMap[@(SDLServiceTypeAudio)] = @(SDLTransportClassSecondary);
                manager.streamingServiceTransportMap[@(SDLServiceTypeVideo)] = @(SDLTransportClassSecondary);
            });

            it(@"should transition to Reconnecting state", ^{
                OCMExpect([testStreamingProtocolDelegate audioServiceProtocolDidUpdateFromOldProtocol:secondaryProtocol toNewProtocol:nil]);
                OCMExpect([testStreamingProtocolDelegate videoServiceProtocolDidUpdateFromOldProtocol:secondaryProtocol toNewProtocol:nil]);

                [testSecondaryProtocolMock onProtocolClosed];
                [NSThread sleepForTimeInterval:0.1];

                expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateReconnecting));
                OCMVerifyAll(testStreamingProtocolDelegate);
            });
        });

        describe(@"when stopped", ^{
            beforeEach(^{
                // assume audio and video services are allowed only on secondary transport
                manager.transportsForAudioService = @[@(SDLTransportClassSecondary)];
                manager.transportsForVideoService = @[@(SDLTransportClassSecondary)];
                manager.streamingServiceTransportMap[@(SDLServiceTypeAudio)] = @(SDLTransportClassSecondary);
                manager.streamingServiceTransportMap[@(SDLServiceTypeVideo)] = @(SDLTransportClassSecondary);
            });

            it(@"should transition to Stopped state", ^{
                OCMExpect([testStreamingProtocolDelegate audioServiceProtocolDidUpdateFromOldProtocol:secondaryProtocol toNewProtocol:nil]);
                OCMExpect([testStreamingProtocolDelegate videoServiceProtocolDidUpdateFromOldProtocol:secondaryProtocol toNewProtocol:nil]);

                dispatch_sync(testStateMachineQueue, ^{
                    [manager stop];
                });

                expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                OCMVerifyAll(testStreamingProtocolDelegate);
            });
        });
    });


    describe(@"In Reconnecting state", ^{
        beforeEach(^{
            testPrimaryProtocol = [[SDLProtocol alloc] init];
            testPrimaryTransport = [[SDLIAPTransport alloc] init];
            testPrimaryProtocol.transport = testPrimaryTransport;
            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
                [manager.stateMachine setToState:SDLSecondaryTransportStateReconnecting fromOldState:nil callEnterTransition:NO];
            });
        });

        describe(@"when reconnecting timeout is fired", ^{
            beforeEach(^{
                manager.secondaryTransportType = SDLTransportSelectionTCP;
                manager.ipAddress = @"";
                manager.tcpPort = 12345;
            });

            it(@"should transition to Configured state", ^{
                // call didEnterStateReconnecting
                dispatch_sync(testStateMachineQueue, ^{
                    [manager.stateMachine setToState:SDLSecondaryTransportStateReconnecting fromOldState:nil callEnterTransition:YES];
                });

                // wait for the timer
                float waitTime = RetryConnectionDelay + 5.0;
                NSLog(@"Please wait for reconnection timeout ... (for %f seconds)", waitTime);
                [NSThread sleepForTimeInterval:waitTime];

                expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));
                OCMVerifyAll(testStreamingProtocolDelegate);
            });
        });

        describe(@"when Transport Event Update is received", ^{
            __block SDLProtocolHeader *testTransportEventUpdateHeader = nil;
            __block SDLProtocolMessage *testTransportEventUpdateMessage = nil;
            __block SDLControlFramePayloadTransportEventUpdate *testTransportEventUpdatePayload = nil;
            __block NSString *testTcpIpAddress = nil;
            __block int32_t testTcpPort = TCPPortUnspecified;

            beforeEach(^{
                manager.secondaryTransportType = SDLTransportSelectionTCP;
                manager.ipAddress = @"192.168.1.1";
                manager.tcpPort = 12345;

                testTransportEventUpdateHeader = [SDLProtocolHeader headerForVersion:5];
                testTransportEventUpdateHeader.frameType = SDLFrameTypeControl;
                testTransportEventUpdateHeader.serviceType = SDLServiceTypeControl;
                testTransportEventUpdateHeader.frameData = SDLFrameInfoTransportEventUpdate;
            });

            context(@"with same IP address and port number", ^{
                beforeEach(^{
                    testTcpIpAddress = @"192.168.1.1";
                    testTcpPort = 12345;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should ignore the frame and stay in Reconnecting state", ^{
                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateReconnecting));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            context(@"with different IP address", ^{
                beforeEach(^{
                    testTcpIpAddress = @"172.16.12.34";
                    testTcpPort = 12345;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should transition to Configured state before timeout, then transition to Connecting state again", ^{
                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConnecting));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });

            context(@"with invalid IP address", ^{
                beforeEach(^{
                    testTcpIpAddress = @"";
                    testTcpPort = 12345;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should transition to Configured state before timeout", ^{
                    [testPrimaryProtocol handleBytesFromTransport:testTransportEventUpdateMessage.data];
                    [NSThread sleepForTimeInterval:0.1];

                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));
                    OCMVerifyAll(testStreamingProtocolDelegate);
                });
            });
        });

        describe(@"when stopped", ^{
            it(@"should transition to Stopped state", ^{
                dispatch_sync(testStateMachineQueue, ^{
                    [manager stop];
                });

                expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                OCMVerifyAll(testStreamingProtocolDelegate);
            });
        });
    });
});

QuickSpecEnd
