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

#import "SDLBackgroundTaskManager.h"
#import "SDLControlFramePayloadRegisterSecondaryTransportNak.h"
#import "SDLControlFramePayloadRPCStartServiceAck.h"
#import "SDLControlFramePayloadTransportEventUpdate.h"
#import "SDLFakeSecurityManager.h"
#import "SDLHMILevel.h"
#import "SDLIAPTransport.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLProtocol.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSecondaryTransportManager.h"
#import "SDLStateMachine.h"
#import "SDLTCPTransport.h"
#import "SDLTimer.h"
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
static const float RetryConnectionDelay = 5.25;
static const float RegisterTransportTime = 10.25;
static const int TCPPortUnspecified = -1;


@interface SDLSecondaryTransportManager ()

// we need to reach to private properties for the tests
@property (strong, nonatomic) SDLStateMachine *stateMachine;
@property (assign, nonatomic) SDLSecondaryTransportType secondaryTransportType;
@property (nullable, strong, nonatomic) SDLProtocol *primaryProtocol;
@property (nullable, strong, nonatomic) id<SDLTransportType> secondaryTransport;
@property (nullable, strong, nonatomic) SDLProtocol *secondaryProtocol;
@property (strong, nonatomic, nonnull) NSArray<SDLTransportClassBox *> *transportsForAudioService;
@property (strong, nonatomic, nonnull) NSArray<SDLTransportClassBox *> *transportsForVideoService;
@property (strong, nonatomic) NSMutableDictionary<SDLServiceTypeBox *, SDLTransportClassBox *> *streamingServiceTransportMap;
@property (strong, nonatomic, nullable) NSString *ipAddress;
@property (assign, nonatomic) int tcpPort;
@property (strong, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (assign, nonatomic) UIApplicationState currentApplicationState;
@property (strong, nonatomic) SDLBackgroundTaskManager *backgroundTaskManager;
@property (strong, nonatomic, nullable) SDLTimer *registerTransportTimer;

- (nullable BOOL (^)(void))sdl_backgroundTaskEndedHandler;

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

    from = class_getInstanceMethod(self, @selector(disconnectWithCompletionHandler:));
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

    from = class_getInstanceMethod(self, @selector(disconnectWithCompletionHandler:));
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

    __block void (^sendNotificationForHMILevel)(SDLHMILevel hmiLevel) = ^(SDLHMILevel hmiLevel) {
         SDLOnHMIStatus *hmiStatus = [[SDLOnHMIStatus alloc] init];
         hmiStatus.hmiLevel = hmiLevel;
         SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:self rpcNotification:hmiStatus];
         [[NSNotificationCenter defaultCenter] postNotification:notification];
    };

    beforeEach(^{
        [SDLTCPTransport swapConnectionMethods];
        [SDLIAPTransport swapConnectionMethods];

        // "strict" mock. If one of the delegate methods is called without prior expectation, it will throw an exception
        testStreamingProtocolDelegate = OCMStrictProtocolMock(@protocol(SDLStreamingProtocolDelegate));
        testStateMachineQueue = dispatch_queue_create("com.sdl.testsecondarytransportmanager", DISPATCH_QUEUE_SERIAL);
        manager = [[SDLSecondaryTransportManager alloc] initWithStreamingProtocolDelegate:testStreamingProtocolDelegate serialQueue:testStateMachineQueue];

        manager.currentApplicationState = UIApplicationStateActive;
    });

    afterEach(^{
        // it is possible that manager calls methods of SDLStreamingProtocolDelegate while stopping, so accept them
        // (Don't put OCMVerifyAll() after calling stop.)
        OCMExpect([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:OCMOCK_ANY toNewVideoProtocol:nil fromOldAudioProtocol:OCMOCK_ANY toNewAudioProtocol:nil]);

        manager = nil;

        [SDLIAPTransport swapConnectionMethods];
        [SDLTCPTransport swapConnectionMethods];
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
            testPrimaryTransport = [[SDLIAPTransport alloc] init];
            testPrimaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
        });

        it(@"if in the stopped state, it should transition to state started", ^{
             [manager.stateMachine setToState:SDLSecondaryTransportStateStopped fromOldState:nil callEnterTransition:YES];

            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });

            expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStarted));
        });

        it(@"if not in the stopped state, it should stay in the same state", ^{
            [manager.stateMachine setToState:SDLSecondaryTransportStateConfigured fromOldState:nil callEnterTransition:YES];

            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });

            expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));
        });
    });

    describe(@"In Started state", ^{
        beforeEach(^{
            // In the tests, we assume primary transport is iAP
            testPrimaryTransport = [[SDLIAPTransport alloc] init];
            testPrimaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];

            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });
        });

        it(@"should ignore the primary transport being opened before the secondary transport is established", ^{
            manager.secondaryProtocol = nil;

            [testPrimaryProtocol onTransportConnected];

            expect(manager.registerTransportTimer).to(beNil());
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

                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu authToken:nil protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];
                });

                it(@"should configure its properties and transition to Configured state", ^{
                    // in this configuration, only audio service is allowed on primary transport
                    OCMExpect([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:nil toNewVideoProtocol:nil fromOldAudioProtocol:nil toNewAudioProtocol:testPrimaryProtocol]);

                    [testPrimaryProtocol onDataReceived:testStartServiceACKMessage.data];
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));

                    expect((NSInteger)manager.secondaryTransportType).toEventually(equal(SDLTransportSelectionTCP));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForAudioService = @[@(SDLTransportClassSecondary), @(SDLTransportClassPrimary)];
                    expect(manager.transportsForAudioService).toEventually(equal(expectedTransportsForAudioService));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForVideoService = @[@(SDLTransportClassSecondary)];
                    expect(manager.transportsForVideoService).toEventually(equal(expectedTransportsForVideoService));

                    OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
                });
            });

            context(@"with only secondary transports parameter for TCP", ^{
                beforeEach(^{
                    // Note: this is not allowed for now. It should contain only one element.
                    testSecondaryTransports = @[@"TCP_WIFI", @"IAP_USB_HOST_MODE"];

                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu authToken:nil protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];
                });

                it(@"should configure its properties and transition to Configured state", ^{
                    // in this case, audio and video services start on primary transport (for compatibility)
                    OCMExpect([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:nil toNewVideoProtocol:testPrimaryProtocol fromOldAudioProtocol:nil toNewAudioProtocol:testPrimaryProtocol]);

                    [testPrimaryProtocol onDataReceived:testStartServiceACKMessage.data];

                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));
                    expect((NSInteger)manager.secondaryTransportType).toEventually(equal(SDLTransportSelectionTCP));
                    expect(manager.transportsForAudioService).toEventually(equal(@[@(SDLTransportClassPrimary)]));
                    expect(manager.transportsForVideoService).toEventually(equal(@[@(SDLTransportClassPrimary)]));

                    OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
                });
            });

            context(@"with parameters for iAP secondary transport", ^{
                beforeEach(^{
                    testSecondaryTransports = @[@"IAP_USB_HOST_MODE"];
                    testAudioServiceTransports = @[@(2)];
                    testVideoServiceTransports = @[@(2)];

                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu authToken:nil protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];
                });

                it(@"should transition to Configured state with transport type disabled", ^{
                    // Since primary transport is iAP, we cannot use iAP for secondary transport. This means both services run on primary transport.
                    OCMExpect([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:nil toNewVideoProtocol:testPrimaryProtocol fromOldAudioProtocol:nil toNewAudioProtocol:testPrimaryProtocol]);

                    [testPrimaryProtocol onDataReceived:testStartServiceACKMessage.data];

                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));
                    expect((NSInteger)manager.secondaryTransportType).toEventually(equal(SDLTransportSelectionDisabled));
                    expect(manager.transportsForAudioService).toEventually(equal(@[@(SDLTransportClassPrimary)]));
                    expect(manager.transportsForVideoService).toEventually(equal(@[@(SDLTransportClassPrimary)]));

                    OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
                });
            });

            context(@"without secondary transport related parameter", ^{
                beforeEach(^{
                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu authToken:nil protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];
                });

                it(@"should transition to Configured state with transport type disabled", ^{
                    // both services run on primary transport
                    OCMExpect([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:nil toNewVideoProtocol:testPrimaryProtocol fromOldAudioProtocol:nil toNewAudioProtocol:testPrimaryProtocol]);

                    [testPrimaryProtocol onDataReceived:testStartServiceACKMessage.data];

                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));
                    expect((NSInteger)manager.secondaryTransportType).toEventually(equal(SDLTransportSelectionDisabled));
                    expect(manager.transportsForAudioService).toEventually(equal(@[@(SDLTransportClassPrimary)]));
                    expect(manager.transportsForVideoService).toEventually(equal(@[@(SDLTransportClassPrimary)]));

                    OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
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
                OCMReject([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:[OCMArg any] toNewVideoProtocol:[OCMArg any] fromOldAudioProtocol:[OCMArg any] toNewAudioProtocol:[OCMArg any]]);

                [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];

                expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateStarted));
                expect((NSInteger)manager.secondaryTransportType).toEventually(equal(SDLTransportSelectionDisabled));
                expect(manager.transportsForAudioService).toEventually(equal(@[]));
                expect(manager.transportsForVideoService).toEventually(equal(@[]));
                expect(manager.ipAddress).toEventually(equal(testTcpIpAddress));
                expect(manager.tcpPort).toEventually(equal(testTcpPort));

                OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
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

                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu authToken:nil protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];
                    manager.currentHMILevel = SDLHMILevelFull;
                    manager.currentApplicationState = UIApplicationStateActive;
                });

                it(@"should configure its properties and immediately transition to Connecting state", ^{
                    // audio and video services will not start until secondary transport is established
                    OCMReject([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:[OCMArg any] toNewVideoProtocol:[OCMArg any] fromOldAudioProtocol:[OCMArg any] toNewAudioProtocol:[OCMArg any]]);

                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                    [testPrimaryProtocol onDataReceived:testStartServiceACKMessage.data];

                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConnecting));
                    expect((NSInteger)manager.secondaryTransportType).toEventually(equal(SDLTransportSelectionTCP));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForAudioService = @[@(SDLTransportClassSecondary)];
                    expect(manager.transportsForAudioService).toEventually(equal(expectedTransportsForAudioService));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForVideoService = @[@(SDLTransportClassSecondary)];
                    expect(manager.transportsForVideoService).toEventually(equal(expectedTransportsForVideoService));
                    expect(manager.ipAddress).toEventually(equal(testTcpIpAddress));
                    expect(manager.tcpPort).toEventually(equal(testTcpPort));

                    SDLTCPTransport *secondaryTransport = (SDLTCPTransport *)manager.secondaryTransport;
                    expect(secondaryTransport.hostName).toEventually(equal(testTcpIpAddress));
                    NSString *portNumberString = [NSString stringWithFormat:@"%d", testTcpPort];
                    expect(secondaryTransport.portNumber).toEventually(equal(portNumberString));

                    OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
                });
            });

            context(@"and if TCP configuration is invalid", ^{
                beforeEach(^{
                    testTcpIpAddress = @"";
                    testTcpPort = 5678;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];

                    testStartServiceACKPayload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithHashId:testHashId mtu:testMtu authToken:nil protocolVersion:testProtocolVersion secondaryTransports:testSecondaryTransports audioServiceTransports:testAudioServiceTransports videoServiceTransports:testVideoServiceTransports];
                    testStartServiceACKMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testStartServiceACKHeader andPayload:testStartServiceACKPayload.data];
                });

                it(@"should configure its properties and transition to Configured state", ^{
                    // audio and video services will not start until secondary transport is established
                    OCMReject([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:[OCMArg any] toNewVideoProtocol:[OCMArg any] fromOldAudioProtocol:[OCMArg any] toNewAudioProtocol:[OCMArg any]]);

                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                    [testPrimaryProtocol onDataReceived:testStartServiceACKMessage.data];

                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));
                    expect((NSInteger)manager.secondaryTransportType).toEventually(equal(SDLTransportSelectionTCP));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForAudioService = @[@(SDLTransportClassSecondary)];
                    expect(manager.transportsForAudioService).toEventually(equal(expectedTransportsForAudioService));
                    NSArray<SDLTransportClassBox *> *expectedTransportsForVideoService = @[@(SDLTransportClassSecondary)];
                    expect(manager.transportsForVideoService).toEventually(equal(expectedTransportsForVideoService));
                    expect(manager.ipAddress).toEventually(equal(testTcpIpAddress));
                    expect(manager.tcpPort).toEventually(equal(testTcpPort));
                    expect(manager.secondaryTransport).toEventually(beNil());

                    OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
                });
            });
        });

        describe(@"when stopped", ^{
            it(@"should transition to the Stopped state", ^{
                waitUntilTimeout(1, ^(void (^done)(void)){
                    dispatch_sync(testStateMachineQueue, ^{
                        [manager stopWithCompletionHandler:^{
                            expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                            done();
                        }];
                    });
                });
            });
        });
    });

    describe(@"In Configured state", ^{
        describe(@"if secondary transport is iAP", ^{
            beforeEach(^{
                // in this case we assume the primary transport is TCP
                testPrimaryTransport = [[SDLTCPTransport alloc] init];
                testPrimaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
                testPrimaryProtocol.securityManager = OCMClassMock([SDLFakeSecurityManager class]);

                dispatch_sync(testStateMachineQueue, ^{
                    [manager startWithPrimaryProtocol:testPrimaryProtocol];
                });

                manager.secondaryTransportType = SDLTransportSelectionIAP;

                dispatch_sync(testStateMachineQueue, ^{
                    [manager.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
                });
            });

            context(@"before the app context is HMI FULL", ^{
                it(@"should stay in state Configured", ^{
                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));
                    expect(manager.currentHMILevel).to(beNil());
                    expect(manager.secondaryProtocol.securityManager).to(beNil());
                });
            });

            context(@"app becomes HMI FULL", ^{
                beforeEach(^{
                    sendNotificationForHMILevel(SDLHMILevelFull);
                });

                it(@"should transition to Connecting state", ^{
                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConnecting));
                    expect(manager.currentHMILevel).to(equal(SDLHMILevelFull));
                    expect(manager.secondaryProtocol.securityManager).to(equal(testPrimaryProtocol.securityManager));
                });
            });
        });

        describe(@"if secondary transport is TCP", ^{
            beforeEach(^{
                testPrimaryTransport = [[SDLIAPTransport alloc] init];
                testPrimaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
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
                });
            });

            describe(@"and a Transport Event Update has been received", ^{
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

                    testPrimaryProtocol.securityManager = OCMClassMock([SDLFakeSecurityManager class]);
                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                });

                context(@"before the app context is HMI FULL", ^{
                    it(@"should stay in Configured state", ^{
                        expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));
                        expect(manager.currentHMILevel).toEventually(beNil());
                        expect(manager.secondaryProtocol.securityManager).toEventually(beNil());
                    });
                });

                context(@"app becomes HMI FULL", ^{
                    beforeEach(^{
                        sendNotificationForHMILevel(SDLHMILevelFull);
                    });
                    
                    it(@"should transition to Connecting", ^{
                        expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConnecting));
                        expect(manager.currentHMILevel).toEventually(equal(SDLHMILevelFull));
                        expect(manager.secondaryProtocol.securityManager).toEventually(equal(testPrimaryProtocol.securityManager));
                    });
                });
            });
        });

        describe(@"when stopped", ^{
            beforeEach(^{
                testPrimaryTransport = [[SDLIAPTransport alloc] init];
                testPrimaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
                testPrimaryProtocol.transport = testPrimaryTransport;

                dispatch_sync(testStateMachineQueue, ^{
                    [manager startWithPrimaryProtocol:testPrimaryProtocol];
                    [manager.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
                });
            });

            it(@"should transition to Stopped state", ^{
                waitUntilTimeout(1, ^(void (^done)(void)){
                    dispatch_sync(testStateMachineQueue, ^{
                        [manager stopWithCompletionHandler:^{
                            expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                            done();
                        }];
                    });
                });
            });
        });
    });

    describe(@"In Connecting state", ^{
        __block SDLProtocol *secondaryProtocol = nil;
        __block id testSecondaryProtocolMock = nil;

        beforeEach(^{
            secondaryProtocol = [[SDLProtocol alloc] initWithTransport:[[SDLTCPTransport alloc] init] encryptionManager:nil];
            testSecondaryProtocolMock = OCMPartialMock(secondaryProtocol);

            testPrimaryTransport = [[SDLIAPTransport alloc] init];
            testPrimaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
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

                [testSecondaryProtocolMock onTransportConnected];

                OCMVerifyAllWithDelay(testSecondaryProtocolMock, 0.5);

                expect(manager.registerTransportTimer).toNot(beNil());
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
                    OCMExpect([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:nil toNewVideoProtocol:secondaryProtocol fromOldAudioProtocol:nil toNewAudioProtocol:secondaryProtocol]);

                    [testSecondaryProtocolMock onDataReceived:testRegisterSecondaryTransportAckMessage.data];

                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateRegistered));
                    OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
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
                    [testSecondaryProtocolMock onDataReceived:testRegisterSecondaryTransportNakMessage.data];
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateReconnecting));
                });
            });

            describe(@"and timeout occurs while waiting for the module to respond to the Register Secondary Transport request", ^{
                beforeEach(^{
                    // assume audio and video services are allowed only on secondary transport
                    manager.transportsForAudioService = @[@(SDLTransportClassSecondary)];
                    manager.transportsForVideoService = @[@(SDLTransportClassSecondary)];
                    manager.streamingServiceTransportMap[@(SDLServiceTypeAudio)] = @(SDLTransportClassSecondary);
                    manager.streamingServiceTransportMap[@(SDLServiceTypeVideo)] = @(SDLTransportClassSecondary);
                });

                it(@"if in the Connecting state it should transition to Reconnecting state", ^{
                    dispatch_sync(testStateMachineQueue, ^{
                        [manager.stateMachine setToState:SDLSecondaryTransportStateConnecting fromOldState:nil callEnterTransition:NO];
                    });

                    [testSecondaryProtocolMock onTransportConnected];

                    OCMExpect([testStreamingProtocolDelegate transportClosed]);

                    // Wait for the timer to elapse
                    float waitTime = RegisterTransportTime;
                    NSLog(@"Please wait for register transport timer to elapse... (for %.02f seconds)", waitTime);
                    [NSThread sleepForTimeInterval:waitTime];

                    OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);

                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateReconnecting));
                });

                it(@"if not in the Connecting state it should not try to reconnect", ^{
                    dispatch_sync(testStateMachineQueue, ^{
                        [manager.stateMachine setToState:SDLSecondaryTransportStateReconnecting fromOldState:nil callEnterTransition:NO];
                    });

                    [testSecondaryProtocolMock onTransportConnected];

                    // Wait for the timer to elapse
                    float waitTime = RegisterTransportTime;
                    NSLog(@"Please wait for register transport timer to elapse... (for %.02f seconds)", waitTime);
                    [NSThread sleepForTimeInterval:waitTime];

                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateReconnecting));
                });
            });
        });

        describe(@"when transport is closed", ^{
            it(@"should transition to Reconnecting state", ^{
                OCMExpect([testStreamingProtocolDelegate transportClosed]);

                [testSecondaryProtocolMock onTransportDisconnected];

                expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateReconnecting));
                OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
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
                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConnecting));
                });
            });

            context(@"with different IP address", ^{
                beforeEach(^{
                    testTcpIpAddress = @"172.16.12.34";
                    testTcpPort = 12345;
                    manager.currentHMILevel = SDLHMILevelFull;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should transition to Configured state, then transition to Connecting state again", ^{
                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConnecting));
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
                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));
                });
            });

        });

        describe(@"when stopped", ^{
            it(@"should transition to Stopped state", ^{
                waitUntilTimeout(1, ^(void (^done)(void)){
                    dispatch_sync(testStateMachineQueue, ^{
                        [manager stopWithCompletionHandler:^{
                            expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                            done();
                        }];
                    });
                });
            });
        });
    });

    describe(@"In Registered state", ^{
        __block SDLProtocol *secondaryProtocol = nil;
        __block id testSecondaryProtocolMock = nil;

        beforeEach(^{
            secondaryProtocol = [[SDLProtocol alloc] initWithTransport:[[SDLTCPTransport alloc] init] encryptionManager:nil];
            testSecondaryProtocolMock = OCMPartialMock(secondaryProtocol);

            testPrimaryTransport = [[SDLIAPTransport alloc] init];
            testPrimaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
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
                manager.currentHMILevel = SDLHMILevelFull;

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
                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateRegistered));
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
                    OCMExpect([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:secondaryProtocol toNewVideoProtocol:nil fromOldAudioProtocol:secondaryProtocol toNewAudioProtocol:nil]);

                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConnecting));
                    OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
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
                    OCMExpect([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:secondaryProtocol toNewVideoProtocol:nil fromOldAudioProtocol:secondaryProtocol toNewAudioProtocol:nil]);

                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));
                    OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
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
                OCMExpect([testStreamingProtocolDelegate transportClosed]);

                [testSecondaryProtocolMock onTransportDisconnected];

                expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateReconnecting));
                OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
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
                OCMExpect([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:secondaryProtocol toNewVideoProtocol:nil fromOldAudioProtocol:secondaryProtocol toNewAudioProtocol:nil]);

                waitUntilTimeout(1, ^(void (^done)(void)){
                    dispatch_sync(testStateMachineQueue, ^{
                        [manager stopWithCompletionHandler:^{
                            expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                            done();
                        }];
                    });
                });
            });
        });
    });

    describe(@"In Reconnecting state", ^{
        beforeEach(^{
            testPrimaryTransport = [[SDLIAPTransport alloc] init];
            testPrimaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
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
                float waitTime = RetryConnectionDelay;
                NSLog(@"Please wait for reconnection timeout... (for %.02f seconds)", waitTime);
                [NSThread sleepForTimeInterval:waitTime];

                expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));
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
                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateReconnecting));
                });
            });

            context(@"with different IP address", ^{
                beforeEach(^{
                    testTcpIpAddress = @"172.16.12.34";
                    testTcpPort = 12345;
                    manager.currentHMILevel = SDLHMILevelFull;

                    testTransportEventUpdatePayload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithTcpIpAddress:testTcpIpAddress tcpPort:testTcpPort];
                    testTransportEventUpdateMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testTransportEventUpdateHeader andPayload:testTransportEventUpdatePayload.data];
                });

                it(@"should transition to Configured state before timeout, then transition to Connecting state again", ^{
                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConnecting));
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
                    [testPrimaryProtocol onDataReceived:testTransportEventUpdateMessage.data];
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));
                });
            });
        });

        describe(@"when stopped", ^{
            it(@"should transition to Stopped state", ^{
                waitUntilTimeout(1, ^(void (^done)(void)){
                    dispatch_sync(testStateMachineQueue, ^{
                        [manager stopWithCompletionHandler:^{
                            expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                            done();
                        }];
                    });
                });
            });
        });
    });

    describe(@"app lifecycle state change", ^{
        __block id mockBackgroundTaskManager = nil;

        beforeEach(^{
            // In the tests, we assume primary transport is iAP
            testPrimaryTransport = [[SDLIAPTransport alloc] init];
            testPrimaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
            testPrimaryProtocol.transport = testPrimaryTransport;

            mockBackgroundTaskManager = OCMClassMock([SDLBackgroundTaskManager class]);
            manager.backgroundTaskManager = mockBackgroundTaskManager;

            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });
        });

        context(@"app enters the background", ^{
            beforeEach(^{
                manager.secondaryTransportType = SDLTransportSelectionTCP;
            });

            describe(@"if the secondary transport is connected", ^{
                beforeEach(^{
                    [manager.stateMachine setToState:SDLSecondaryTransportStateRegistered fromOldState:nil callEnterTransition:NO];
                });

                it(@"should start a background task and stay connected", ^{
                    OCMExpect([mockBackgroundTaskManager startBackgroundTask]);

                    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillResignActiveNotification object:nil];

                    OCMVerifyAllWithDelay(mockBackgroundTaskManager, 0.5);
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateRegistered));

                });
            });

            describe(@"if the secondary transport has not yet connected", ^{
                beforeEach(^{
                    [manager.stateMachine setToState:SDLSecondaryTransportStateConfigured fromOldState:nil callEnterTransition:NO];
                });

                it(@"should ignore the state change notification", ^{
                    OCMReject([mockBackgroundTaskManager startBackgroundTask]);

                    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillResignActiveNotification object:nil];

                    OCMVerifyAllWithDelay(mockBackgroundTaskManager, 0.5);
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));

                });
            });
        });

        context(@"app enters the foreground", ^{
            describe(@"if the secondary transport is still connected", ^{
                beforeEach(^{
                    [manager.stateMachine setToState:SDLSecondaryTransportStateRegistered fromOldState:nil callEnterTransition:NO];
                });

                it(@"should end the background task and stay in the connected state", ^{
                    OCMExpect([mockBackgroundTaskManager endBackgroundTask]);

                    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];

                    OCMVerifyAllWithDelay(mockBackgroundTaskManager, 0.5);
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateRegistered));

                });
            });

            describe(@"if the secondary transport is not connected but is configured", ^{
                beforeEach(^{
                    manager.ipAddress = @"192.555.23.1";
                    manager.tcpPort = 54321;
                    manager.currentHMILevel = SDLHMILevelFull;

                    manager.secondaryTransportType = SDLTransportSelectionTCP;
                    [manager.stateMachine setToState:SDLSecondaryTransportStateConfigured fromOldState:nil callEnterTransition:NO];
                });

                it(@"should end the background task and try to restart the TCP transport", ^{
                    OCMExpect([mockBackgroundTaskManager endBackgroundTask]);

                    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];

                    OCMVerifyAllWithDelay(mockBackgroundTaskManager, 0.5);
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConnecting));
                });
            });

            describe(@"if the secondary transport not connected and is not configured", ^{
                beforeEach(^{
                    [manager.stateMachine setToState:SDLSecondaryTransportStateConnecting fromOldState:nil callEnterTransition:NO];
                });

                it(@"should ignore the state change notification", ^{
                    OCMReject([mockBackgroundTaskManager endBackgroundTask]);

                    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];

                    OCMVerifyAllWithDelay(mockBackgroundTaskManager, 0.5);
                    expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConnecting));
                });
            });
        });

        describe(@"When the background task expires", ^{
            context(@"If the app is still in the background", ^{
                beforeEach(^{
                    manager.currentApplicationState = UIApplicationStateBackground;
                });
                
                it(@"should stop the TCP transport if the app is still in the background and perform cleanup before ending the background task", ^{
                    [manager.stateMachine setToState:SDLSecondaryTransportStateRegistered fromOldState:nil callEnterTransition:NO];
                    
                    BOOL waitForCleanupToFinish = manager.sdl_backgroundTaskEndedHandler();
                    
                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateConfigured));
                    expect(waitForCleanupToFinish).to(beTrue());
                });
                
                it(@"should ignore the notification if the manager has stopped before the background task ended and immediately end the background task", ^{
                    [manager.stateMachine setToState:SDLSecondaryTransportStateStopped fromOldState:nil callEnterTransition:NO];
                    
                    BOOL waitForCleanupToFinish = manager.sdl_backgroundTaskEndedHandler();
                    
                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                    expect(waitForCleanupToFinish).to(beFalse());
                });
                
                afterEach(^{
                    manager.currentApplicationState = UIApplicationStateActive;
                });
            });
            
            context(@"If the app is has entered the foreground", ^{
                it(@"should ignore the notification if the app has returned to the foreground and immediately end the background task", ^{
                    [manager.stateMachine setToState:SDLSecondaryTransportStateRegistered fromOldState:nil callEnterTransition:NO];
                    
                    BOOL waitForCleanupToFinish = manager.sdl_backgroundTaskEndedHandler();
                    
                    expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateRegistered));
                    expect(waitForCleanupToFinish).to(beFalse());
                });
            });
        });
    });

    describe(@"when the secondary transport is closed", ^{
        __block SDLProtocol *secondaryProtocol = nil;
        __block id testSecondaryProtocolMock = nil;

        beforeEach(^{
            testPrimaryTransport = [[SDLIAPTransport alloc] init];
            testPrimaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
            secondaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
            testSecondaryProtocolMock = OCMPartialMock(secondaryProtocol);

            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });

            [secondaryProtocol.protocolDelegateTable addObject:manager];
            manager.secondaryProtocol = secondaryProtocol;
        });

        it(@"should transition to Reconnecting state if in state connecting", ^{
            dispatch_sync(testStateMachineQueue, ^{
                [manager.stateMachine setToState:SDLSecondaryTransportStateConnecting fromOldState:nil callEnterTransition:NO];
            });

            OCMExpect([testStreamingProtocolDelegate transportClosed]);
            
            [testSecondaryProtocolMock onTransportDisconnected];
            
            OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
            expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateReconnecting));
        });
        
        it(@"should transition to Reconnecting state if in state registered", ^{
            dispatch_sync(testStateMachineQueue, ^{
                [manager.stateMachine setToState:SDLSecondaryTransportStateRegistered fromOldState:nil callEnterTransition:NO];
            });

            OCMExpect([testStreamingProtocolDelegate transportClosed]);
            
            [testSecondaryProtocolMock onTransportDisconnected];
            
            OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
            expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateReconnecting));
        });

        it(@"should stay in the same state if not in the connecting or registered states", ^{
            dispatch_sync(testStateMachineQueue, ^{
                [manager.stateMachine setToState:SDLSecondaryTransportStateConfigured fromOldState:nil callEnterTransition:NO];
            });

            OCMReject([testStreamingProtocolDelegate transportClosed]);

            [testSecondaryProtocolMock onTransportDisconnected];

            OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
            expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));
        });
    });

    describe(@"when the secondary transport errors (wifi turned off or socket breaks)", ^{
        __block SDLProtocol *secondaryProtocol = nil;
        __block id testSecondaryProtocolMock = nil;

        beforeEach(^{
            secondaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
            testSecondaryProtocolMock = OCMPartialMock(secondaryProtocol);
            testPrimaryProtocol = [[SDLProtocol alloc] initWithTransport:testPrimaryTransport encryptionManager:nil];
            testPrimaryTransport = [[SDLIAPTransport alloc] init];

            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });

            [secondaryProtocol.protocolDelegateTable addObject:manager];
            manager.secondaryProtocol = secondaryProtocol;
        });

        it(@"should transition to Reconnecting state if in state connecting", ^{
            dispatch_sync(testStateMachineQueue, ^{
                [manager.stateMachine setToState:SDLSecondaryTransportStateConnecting fromOldState:nil callEnterTransition:NO];
            });

            OCMExpect([testStreamingProtocolDelegate transportClosed]);

            [testSecondaryProtocolMock onError:[OCMArg any]];

            OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
            expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateReconnecting));
        });

        it(@"should transition to Reconnecting state if in state registered", ^{
            dispatch_sync(testStateMachineQueue, ^{
                [manager.stateMachine setToState:SDLSecondaryTransportStateRegistered fromOldState:nil callEnterTransition:NO];
            });

            OCMExpect([testStreamingProtocolDelegate transportClosed]);

            [testSecondaryProtocolMock onError:[OCMArg any]];

            OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
            expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateReconnecting));
        });

        it(@"should stay in the same state if not in the connecting or registered states", ^{
            dispatch_sync(testStateMachineQueue, ^{
                [manager.stateMachine setToState:SDLSecondaryTransportStateConfigured fromOldState:nil callEnterTransition:NO];
            });

            OCMReject([testStreamingProtocolDelegate transportClosed]);

            [testSecondaryProtocolMock onError:[OCMArg any]];

            OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
            expect(manager.stateMachine.currentState).toEventually(equal(SDLSecondaryTransportStateConfigured));
        });
    });

    describe(@"when the secondary transport is disconnected", ^{
        __block id mockSecondaryTransport = nil;
        __block id mockBackgroundTaskManager = nil;

        beforeEach(^{
            mockSecondaryTransport = OCMProtocolMock(@protocol(SDLTransportType));
            mockBackgroundTaskManager = OCMClassMock([SDLBackgroundTaskManager class]);

            manager.backgroundTaskManager = mockBackgroundTaskManager;
            manager.transportsForAudioService = @[@(SDLTransportClassSecondary)];
            manager.transportsForVideoService = @[@(SDLTransportClassSecondary)];
            manager.streamingServiceTransportMap[@(SDLServiceTypeAudio)] = @(2);
            manager.streamingServiceTransportMap[@(SDLServiceTypeVideo)] = @(2);

            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });
        });

        it(@"should return early if the secondary transport has not yet been established", ^{
            manager.secondaryTransport = nil;

            waitUntilTimeout(1, ^(void (^done)(void)){
                dispatch_sync(testStateMachineQueue, ^{
                    [manager disconnectSecondaryTransportWithCompletionHandler:^{
                        done();
                    }];
                });
            });
        });

        it(@"should shutdown the secondary transport", ^{
            manager.secondaryTransport = mockSecondaryTransport;
            OCMExpect([mockSecondaryTransport disconnectWithCompletionHandler:[OCMArg invokeBlock]]);

            waitUntilTimeout(1, ^(void (^done)(void)){
                dispatch_sync(testStateMachineQueue, ^{
                    [manager disconnectSecondaryTransportWithCompletionHandler:^{\
                        expect(manager.secondaryTransport).to(beNil());
                        expect(manager.secondaryProtocol).to(beNil());
                        expect(manager.streamingServiceTransportMap).to(beEmpty());
                        OCMVerify([manager.backgroundTaskManager endBackgroundTask]);
                        done();
                    }];
                });
            });

            OCMVerifyAllWithDelay(mockSecondaryTransport, 0.5);
        });
    });

    describe(@"when stopped", ^{
        __block SDLProtocol *testSecondaryProtocol = nil;

        beforeEach(^{
            testSecondaryProtocol = OCMClassMock([SDLProtocol class]);
            manager.secondaryProtocol = testSecondaryProtocol;

            manager.transportsForAudioService = @[@(SDLTransportClassSecondary)];
            manager.transportsForVideoService = @[@(SDLTransportClassSecondary)];
            manager.streamingServiceTransportMap[@(SDLServiceTypeAudio)] = @(2);
            manager.streamingServiceTransportMap[@(SDLServiceTypeVideo)] = @(2);

            dispatch_sync(testStateMachineQueue, ^{
                [manager startWithPrimaryProtocol:testPrimaryProtocol];
            });
        });

        it(@"if not in the stopped state, it should transition to stopped state", ^{
            [manager.stateMachine setToState:SDLSecondaryTransportStateRegistered fromOldState:nil callEnterTransition:NO];
            OCMExpect([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:testSecondaryProtocol toNewVideoProtocol:nil fromOldAudioProtocol:testSecondaryProtocol toNewAudioProtocol:nil]);

            waitUntilTimeout(1, ^(void (^done)(void)){
                dispatch_sync(testStateMachineQueue, ^{
                    [manager stopWithCompletionHandler:^{
                        expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                        done();
                    }];
                });
            });

            OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
        });

        it(@"if already in the stopped state, it should stay in the stopped state", ^{
            [manager.stateMachine setToState:SDLSecondaryTransportStateStopped fromOldState:nil callEnterTransition:NO];
            OCMExpect([testStreamingProtocolDelegate didUpdateFromOldVideoProtocol:[OCMArg any] toNewVideoProtocol:nil fromOldAudioProtocol:[OCMArg any] toNewAudioProtocol:nil]);

            waitUntilTimeout(1, ^(void (^done)(void)){
                dispatch_sync(testStateMachineQueue, ^{
                    [manager stopWithCompletionHandler:^{
                        expect(manager.stateMachine.currentState).to(equal(SDLSecondaryTransportStateStopped));
                        done();
                    }];
                });
            });

            OCMVerifyAllWithDelay(testStreamingProtocolDelegate, 0.5);
        });
    });
});

QuickSpecEnd
