//
//  SDLIAPTransportSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "EAAccessory+OCMock.m"
#import "SDLIAPTransport.h"
#import "SDLIAPSession.h"
#import "SDLTimer.h"
#import "SDLIAPControlSession.h"
#import "SDLIAPDataSession.h"

@interface SDLIAPTransport ()

@property (nullable, strong, nonatomic) SDLIAPControlSession *controlSession;
@property (nullable, strong, nonatomic) SDLIAPDataSession *dataSession;

@property (assign, nonatomic) int retryCounter;
@property (assign, nonatomic) BOOL sessionSetupInProgress;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;
@property (assign, nonatomic) BOOL accessoryConnectDuringActiveSession;
- (BOOL)sdl_isDataSessionActive:(nullable SDLIAPDataSession *)dataSession newAccessory:(EAAccessory *)newAccessory;

@end

QuickSpecBegin(SDLIAPTransportSpec)

describe(@"SDLIAPTransport", ^{
    __block SDLIAPTransport *transport = nil;
    __block id mockTransportDelegate = nil;
    __block EAAccessory *mockAccessory = nil;

    beforeEach(^{
        transport = [SDLIAPTransport new];
        mockTransportDelegate = OCMProtocolMock(@protocol(SDLTransportDelegate));
        transport.delegate = mockTransportDelegate;
        mockAccessory = [EAAccessory.class sdlCoreMock];
    });

    describe(@"Initialization", ^{
        it(@"Should init correctly", ^{
            expect(transport.delegate).toNot(beNil());
            expect(transport.controlSession).to(beNil());
            expect(transport.dataSession).to(beNil());
            expect(transport.sessionSetupInProgress).to(beFalse());
            expect(transport.retryCounter).to(equal(0));
            expect(transport.accessoryConnectDuringActiveSession).to(beFalse());
        });
    });

    describe(@"When an accessory connects while a data session has been created but not open", ^{
        beforeEach(^{
            transport.dataSession = OCMClassMock([SDLIAPDataSession class]);
            OCMStub([transport.dataSession isSessionInProgress]).andReturn(NO);

            expect(transport.controlSession.session).to(beNil());
        });

        it(@"should return that a session is not active", ^{
            BOOL sessionInProgress = [transport sdl_isDataSessionActive:transport.dataSession newAccessory:mockAccessory];
            expect(sessionInProgress).to(beFalse());
        });
    });

    describe(@"When an accessory connects when a data session is already open", ^{
        beforeEach(^{
            transport.dataSession = OCMClassMock([SDLIAPDataSession class]);
            OCMStub([transport.dataSession isSessionInProgress]).andReturn(YES);

            expect(transport.controlSession.session).to(beNil());
        });

        it(@"should return that a session is active", ^{
            BOOL sessionInProgress = [transport sdl_isDataSessionActive:transport.dataSession newAccessory:mockAccessory];
            expect(sessionInProgress).to(beTrue());
        });
    });

    describe(@"When an accessory connects when a data session has not been created", ^{
        beforeEach(^{
            transport.dataSession = nil;

            expect(transport.controlSession.session).to(beNil());
        });

        it(@"should return that a session is active", ^{
            BOOL sessionInProgress = [transport sdl_isDataSessionActive:transport.dataSession newAccessory:mockAccessory];
            expect(sessionInProgress).to(beFalse());
        });
    });

    describe(@"When an accessory disconnects", ^{
        __block SDLIAPSession *mockSession = nil;
        __block NSNotification *accessoryDisconnectedNotification = nil;

        beforeEach(^{
            transport.controlSession = nil;
            mockSession = OCMClassMock([SDLIAPSession class]);
            OCMStub([mockSession accessory]).andReturn(mockAccessory);
            transport.dataSession = [[SDLIAPDataSession alloc] initWithSession:mockSession retrySessionCompletionHandler:^{
            } dataReceivedCompletionHandler:^(NSData * _Nonnull dataIn) {
            }];

            accessoryDisconnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidDisconnectNotification object:nil userInfo:@{EAAccessoryKey: mockAccessory}];
        });

        describe(@"If an accessory connected during an active session", ^{
            beforeEach(^{
                transport.accessoryConnectDuringActiveSession = YES;
                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];
            });

            it(@"should set accessoryConnectDuringActiveSession to NO when the accessory disconnects", ^{
                expect(transport.accessoryConnectDuringActiveSession).to(beFalse());
            });
        });

        describe(@"If no accessory connected during an active session", ^{
            beforeEach(^{
                transport.accessoryConnectDuringActiveSession = NO;
                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];
            });

            it(@"should leave accessoryConnectDuringActiveSession at NO when the accessory disconnects", ^{
                expect(transport.accessoryConnectDuringActiveSession).to(beFalse());
            });
        });

        describe(@"When a data session is open", ^{
            beforeEach(^{
                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];
            });

            it(@"It should close, but not destroy, the open data session", ^{
                expect(transport.dataSession).toNot(beNil());
                expect(transport.dataSession.session).toNot(beNil());
                expect(transport.dataSession.session.delegate).to(beNil());

                expect(transport.sessionSetupInProgress).to(beFalse());
                expect(transport.retryCounter).to(equal(0));
                expect(transport.controlSession).to(beNil());

                OCMVerify([mockTransportDelegate onTransportDisconnected]);
                OCMVerify([mockSession stop]);
            });
        });

        describe(@"When a control session is open", ^{
            __block SDLIAPSession *mockControlSession = nil;
            __block NSNotification *accessoryDisconnectedNotification = nil;

            beforeEach(^{
                mockControlSession = OCMClassMock([SDLIAPSession class]);
                OCMStub([mockControlSession accessory]).andReturn(mockAccessory);
                transport.controlSession = [[SDLIAPControlSession alloc] initWithSession:mockControlSession retrySessionCompletionHandler:^{
                } createDataSessionCompletionHandler:^(EAAccessory * _Nonnull connectedaccessory, NSString * _Nonnull indexedProtocolString) {
                }];

                transport.dataSession = nil;
                transport.sessionSetupInProgress = YES;
                transport.retryCounter = 1;
                accessoryDisconnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidDisconnectNotification object:nil userInfo:@{EAAccessoryKey: mockAccessory}];
            });

            it(@"Should not tell the delegate that the transport closed", ^{
                OCMReject([mockTransportDelegate onTransportDisconnected]);
                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];
            });

            it(@"It should reset the setup helpers", ^{
                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];

                expect(transport.retryCounter).to(equal(0));
                expect(transport.sessionSetupInProgress).to(beFalse());
            });

            it(@"It should close the open control session", ^{
                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];

                OCMVerify([mockControlSession stop]);

                expect(transport.controlSession).toNot(beNil());
                expect(transport.controlSession.session).toNot(beNil());
                expect(transport.dataSession).to(beNil());
            });
        });

        describe(@"When neither a control or data session has been established/opened", ^{
            __block NSNotification *accessoryDisconnectedNotification = nil;
            __block SDLIAPControlSession *mockControlSession;
            __block SDLIAPDataSession *mockDataSession;

            beforeEach(^{
                mockControlSession = OCMClassMock([SDLIAPControlSession class]);
                OCMStub([mockControlSession isSessionInProgress]).andReturn(NO);
                transport.controlSession = mockControlSession;

                mockDataSession = OCMClassMock([SDLIAPDataSession class]);
                OCMStub([mockDataSession isSessionInProgress]).andReturn(NO);
                transport.dataSession = mockDataSession;

                transport.sessionSetupInProgress = YES;
                transport.retryCounter = 1;
                accessoryDisconnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidDisconnectNotification object:nil userInfo:@{EAAccessoryKey: mockAccessory}];
            });

            it(@"Should not tell the delegate that the transport closed", ^{
                OCMReject([mockTransportDelegate onTransportDisconnected]);
                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];
            });

            it(@"It should reset the setup helpers", ^{
                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];

                expect(transport.retryCounter).to(equal(0));
                expect(transport.sessionSetupInProgress).to(beFalse());
            });
        });
    });
});

QuickSpecEnd

