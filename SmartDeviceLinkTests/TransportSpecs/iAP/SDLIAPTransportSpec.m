//
//  SDLIAPTransportSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "EAAccessory+OCMock.m"
#import "SDLIAPTransport.h"
#import "SDLIAPSession.h"
#import "SDLTimer.h"

@interface SDLIAPTransport ()
@property (assign, nonatomic) int retryCounter;
@property (assign, nonatomic) BOOL sessionSetupInProgress;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
@property (assign, nonatomic) BOOL accessoryConnectDuringActiveSession;
- (BOOL)sdl_isSessionActive:(SDLIAPSession *)session newAccessory:(EAAccessory *)newAccessory;
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
            expect(transport.session).to(beNil());
            expect(transport.sessionSetupInProgress).to(beFalse());
            expect(transport.session).to(beNil());
            expect(transport.controlSession).to(beNil());
            expect(transport.retryCounter).to(equal(0));
            expect(transport.protocolIndexTimer).to(beNil());
            expect(transport.accessoryConnectDuringActiveSession).to(beFalse());
        });
    });

    describe(@"When an accessory connects while a session is not open", ^{
        beforeEach(^{
            transport.session = nil;
        });

        it(@"If no session is open, it should create a session when an accessory connects", ^{
            BOOL sessionInProgress = [transport sdl_isSessionActive:transport.session newAccessory:mockAccessory];
            expect(sessionInProgress).to(beFalse());
        });
    });

    describe(@"When an accessory connects when a session is already open", ^{
        beforeEach(^{
            transport.session = OCMClassMock([SDLIAPSession class]);
        });

        it(@"If a session is in progress", ^{
            BOOL sessionInProgress = [transport sdl_isSessionActive:transport.session newAccessory:mockAccessory];
            expect(sessionInProgress).to(beTrue());
        });
    });

    describe(@"When an accessory disconnects while a data session is open", ^{
        beforeEach(^{
            transport.controlSession = nil;
            transport.session = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:@"com.smartdevicelink.multisession"];
            transport.accessoryConnectDuringActiveSession = YES;
            NSNotification *accessoryDisconnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidDisconnectNotification object:nil userInfo:@{EAAccessoryKey: mockAccessory}];
            [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];
        });

        it(@"It should close the open data session", ^{
            expect(transport.session).to(beNil());
            expect(transport.controlSession).to(beNil());
            expect(transport.retryCounter).to(equal(0));
            expect(transport.accessoryConnectDuringActiveSession).to(beFalse());
            expect(transport.sessionSetupInProgress).to(beFalse());
        });
    });

    describe(@"When an accessory disconnects while a control session is open", ^{
        beforeEach(^{
            transport.controlSession = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:@"com.smartdevicelink.prot0"];;
            transport.session = nil;
            transport.accessoryConnectDuringActiveSession = NO;
            transport.sessionSetupInProgress = YES;
            transport.retryCounter = 1;
            NSNotification *accessoryDisconnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidDisconnectNotification object:nil userInfo:@{EAAccessoryKey: mockAccessory}];
            [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];
        });

        it(@"It should close the open control session", ^{
            expect(transport.session).to(beNil());
            expect(transport.controlSession).to(beNil());
            expect(transport.retryCounter).to(equal(0));
            expect(transport.accessoryConnectDuringActiveSession).to(beFalse());
            expect(transport.sessionSetupInProgress).to(beFalse());
        });
    });
});

QuickSpecEnd

