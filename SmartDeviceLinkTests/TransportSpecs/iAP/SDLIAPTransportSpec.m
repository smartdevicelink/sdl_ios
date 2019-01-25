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

- (void)sdl_accessoryConnected:(NSNotification *)notification;
- (void)sdl_startEventListening;
- (void)sdl_stopEventListening;
- (void)sdl_connect:(nullable EAAccessory *)accessory;
@end

QuickSpecBegin(SDLIAPTransportSpec)

describe(@"SDLIAPTransport", ^{
    __block SDLIAPTransport *transport = nil;
    __block id mockTransportDelegate = nil;

    __block NSNotification *accessoryConnectedNotification = nil;
    __block NSNotification *accessoryDisconnectedNotification = nil;

    __block EAAccessory *mockAccessory = nil;

    beforeEach(^{
        transport = [SDLIAPTransport new];
        mockTransportDelegate = OCMProtocolMock(@protocol(SDLTransportDelegate));
        transport.delegate = mockTransportDelegate;
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
            OCMVerify([transport sdl_startEventListening]);
        });

        afterEach(^{
            [transport disconnect];
            transport = nil;

            expect(transport).to(beNil());
            OCMVerify([transport sdl_stopEventListening]);
        });
    });

    describe(@"When an accessory connects while a session is not open", ^{
        beforeEach(^{
            transport.session = nil;
            mockAccessory = [EAAccessory.class sdlCoreMock];
            NSDictionary *userInfoDict = @{EAAccessoryKey: mockAccessory};
            accessoryConnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidConnectNotification object:nil userInfo:userInfoDict];
        });

        it(@"If no session is open, it should create a session when an accessory connects", ^{
            transport.accessoryConnectDuringActiveSession = YES;
            
            [[NSNotificationCenter defaultCenter] postNotification:accessoryConnectedNotification];

            expect(transport.session).to(beNil());
            expect(transport.retryCounter).to(equal(0));
            expect(transport.accessoryConnectDuringActiveSession).to(beFalse());
            expect(transport.sessionSetupInProgress).to(beFalse());

            expect(transport.backgroundTaskId).to(equal(UIBackgroundTaskInvalid));
        });
    });

    describe(@"When an accessory connects when a session is already open", ^{
        beforeEach(^{
            transport.session = OCMClassMock([SDLIAPSession class]);
            accessoryConnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidConnectNotification object:nil userInfo:nil];
        });

        it(@"If a session is in progress", ^{
            [[NSNotificationCenter defaultCenter] postNotification:accessoryConnectedNotification];

            expect(transport.session).toNot(beNil());
            expect(transport.retryCounter).to(equal(0));
            expect(transport.accessoryConnectDuringActiveSession).to(beTrue());
            expect(transport.backgroundTaskId).to(equal(UIBackgroundTaskInvalid));
        });
    });


    describe(@"When an accessory disconnects when a session is already open", ^{
        beforeEach(^{
            transport.session = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:@"com.smartdevicelink.multisession"];
            transport.accessoryConnectDuringActiveSession = YES;

            mockAccessory = [EAAccessory.class sdlCoreMock];
            NSDictionary *userInfoDict = @{EAAccessoryKey: mockAccessory};
            accessoryDisconnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidDisconnectNotification object:nil userInfo:userInfoDict];
        });

        it(@"If a session is in progress", ^{
            [[NSNotificationCenter defaultCenter] postNotification:accessoryDisconnectedNotification];

            expect(transport.session).toNot(beNil());
            expect(transport.retryCounter).to(equal(0));
            expect(transport.accessoryConnectDuringActiveSession).to(beFalse());
            expect(transport.backgroundTaskId).to(equal(UIBackgroundTaskInvalid));
        });
    });
});

QuickSpecEnd
