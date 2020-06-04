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
#import "SDLIAPConstants.h"
#import "SDLIAPTransport.h"
#import "SDLIAPSession.h"
#import "SDLTimer.h"
#import "SDLIAPControlSession.h"
#import "SDLIAPControlSessionDelegate.h"
#import "SDLIAPDataSession.h"
#import "SDLIAPDataSessionDelegate.h"

@interface SDLIAPTransport ()

@property (nullable, strong, nonatomic) SDLIAPControlSession *controlSession;
@property (nullable, strong, nonatomic) SDLIAPDataSession *dataSession;

@property (assign, nonatomic) int retryCounter;
@property (assign, nonatomic) BOOL sessionSetupInProgress;
@property (assign, nonatomic) BOOL transportDestroyed;
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
        transport = [[SDLIAPTransport alloc] init];
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

    describe(@"When checking if the data session is active ", ^{
        it(@"should return that the data session is not active if the data session is nil", ^{
            transport.dataSession = nil;

            BOOL sessionInProgress = [transport sdl_isDataSessionActive:transport.dataSession newAccessory:mockAccessory];
            expect(sessionInProgress).to(beFalse());
        });

        it(@"should return that the data session is not active if the data session is not inprogress", ^{
            SDLIAPDataSession *mockDataSession = OCMClassMock([SDLIAPDataSession class]);
            OCMStub([mockDataSession isSessionInProgress]).andReturn(NO);

            BOOL sessionInProgress = [transport sdl_isDataSessionActive:transport.dataSession newAccessory:mockAccessory];
            expect(sessionInProgress).to(beFalse());
        });

        it(@"should return that the data session is not active if the data session and the new accessory have matching connection ids", ^{
            SDLIAPDataSession *mockDataSession = OCMClassMock([SDLIAPDataSession class]);
            OCMStub([mockDataSession isSessionInProgress]).andReturn(YES);
            OCMStub([mockDataSession connectionID]).andReturn(5);

            BOOL sessionInProgress = [transport sdl_isDataSessionActive:mockDataSession newAccessory:mockAccessory];
            expect(sessionInProgress).to(beFalse());
        });

        it(@"should return that the data session is active if the data session and the new accessory have different connection ids", ^{
            SDLIAPDataSession *mockDataSession = OCMClassMock([SDLIAPDataSession class]);
            OCMStub([mockDataSession isSessionInProgress]).andReturn(YES);
            OCMStub([mockDataSession connectionID]).andReturn(96);

            BOOL sessionInProgress = [transport sdl_isDataSessionActive:mockDataSession newAccessory:mockAccessory];
            expect(sessionInProgress).to(beTrue());
        });
    });

    describe(@"When an accessory disconnects", ^{
        __block NSNotification *accessoryDisconnectedNotification = nil;

        beforeEach(^{
            accessoryDisconnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidDisconnectNotification object:nil userInfo:@{EAAccessoryKey: mockAccessory}];
        });

        context(@"If an accessory disconnects during an active session", ^{
            beforeEach(^{
                transport.accessoryConnectDuringActiveSession = YES;
                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];
            });

            it(@"should set accessoryConnectDuringActiveSession to NO when the accessory disconnects", ^{
                expect(transport.accessoryConnectDuringActiveSession).to(beFalse());
            });
        });

        context(@"If an accessory disconnects while no session is active", ^{
            beforeEach(^{
                transport.accessoryConnectDuringActiveSession = NO;
                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];
            });

            it(@"should leave accessoryConnectDuringActiveSession at NO when the accessory disconnects", ^{
                expect(transport.accessoryConnectDuringActiveSession).to(beFalse());
            });
        });

        context(@"When a neither a data or control session is open", ^{
            beforeEach(^{
                transport.dataSession = nil;
                transport.controlSession = nil;

                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];
            });

            it(@"It should cleanup on disconnect", ^{
                expect(transport.retryCounter).to(equal(0));
                expect(transport.sessionSetupInProgress).to(beFalse());
                expect(transport.transportDestroyed).to(beFalse());
            });
        });

        context(@"When a data session is open", ^{
            __block SDLIAPDataSession *mockDataSession = nil;

            beforeEach(^{
                mockDataSession = OCMStrictClassMock([SDLIAPDataSession class]);
                OCMStub([mockDataSession isSessionInProgress]).andReturn(YES);
                OCMStub([mockDataSession connectionID]).andReturn(mockAccessory.connectionID);
                transport.dataSession = mockDataSession;
                transport.controlSession = nil;
            });

            it(@"It should cleanup on disconnect, close and destroy data session, and notify the lifecycle manager that the transport disconnected", ^{
                OCMExpect([mockDataSession destroySessionWithCompletionHandler:[OCMArg invokeBlock]]);

                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];

                expect(transport.retryCounter).toEventually(equal(0));
                expect(transport.sessionSetupInProgress).toEventually(beFalse());
                expect(transport.transportDestroyed).toEventually(beTrue());

                OCMVerify([mockTransportDelegate onTransportDisconnected]);
            });
        });

        describe(@"When a control session is open", ^{
            __block SDLIAPControlSession *mockControlSession = nil;

            beforeEach(^{
                mockControlSession = OCMStrictClassMock([SDLIAPControlSession class]);
                OCMStub([mockControlSession isSessionInProgress]).andReturn(YES);
                OCMStub([mockControlSession connectionID]).andReturn(mockAccessory.connectionID);
                transport.controlSession = mockControlSession;
                transport.dataSession = nil;
            });

            it(@"It should cleanup on disconnect, close and destroy data session, and should not tell the delegate that the transport closed", ^{
                OCMExpect([mockControlSession destroySessionWithCompletionHandler:[OCMArg invokeBlock]]);

                [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];

                expect(transport.retryCounter).toEventually(equal(0));
                expect(transport.sessionSetupInProgress).toEventually(beFalse());
                expect(transport.transportDestroyed).toEventually(beFalse());

                OCMReject([mockTransportDelegate onTransportDisconnected]);
            });
        });
    });
});

QuickSpecEnd

