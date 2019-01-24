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
@end

QuickSpecBegin(SDLIAPTransportSpec)

describe(@"SDLIAPTransport", ^{
    __block SDLIAPTransport *transport = nil;
    __block id mockTransportDelegate = nil;

    __block NSNotification *accessoryConnectedNotification = nil;
    __block NSNotification *accessoryDisconnectedNotification = nil;

    beforeEach(^{
        transport = [SDLIAPTransport new];
        mockTransportDelegate = OCMProtocolMock(@protocol(SDLTransportDelegate));
        transport.delegate = mockTransportDelegate;

        accessoryConnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidConnectNotification object:nil userInfo:nil];
        accessoryDisconnectedNotification= [[NSNotification alloc] initWithName:EAAccessoryDidDisconnectNotification object:nil userInfo:nil];
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

        afterEach(^{
            [transport disconnect];
            transport = nil;
        });
    });

    describe(@"If no session is open, it should create a session when an accessory connects", ^{
        beforeEach(^{
            transport.session = nil;
            accessoryConnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidConnectNotification object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:accessoryConnectedNotification];
        });

        it(@"If no session is in progress", ^{
            OCMVerify([transport sdl_accessoryConnected:accessoryConnectedNotification]);
            expect(transport.session).to(beNil());
            expect(transport.retryCounter).to(equal(0));
            expect(transport.accessoryConnectDuringActiveSession).to(beFalse());

            OCMExpect([mockTransportDelegate onTransportConnected]);
            // OCMVerifyAllWithDelay(mockTransportDelegate, 8.0);
        });
    });

    describe(@"If a session is open, it should wait for the accessory to disconnect", ^{
        beforeEach(^{
            transport.session = OCMClassMock([SDLIAPSession class]);
            accessoryConnectedNotification = [[NSNotification alloc] initWithName:EAAccessoryDidConnectNotification object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:accessoryConnectedNotification];
        });

        it(@"If a session is in progress", ^{
            OCMVerify([transport sdl_accessoryConnected:accessoryConnectedNotification]);
            expect(transport.session).toNot(beNil());
            expect(transport.retryCounter).to(equal(0));
            expect(transport.accessoryConnectDuringActiveSession).to(beTrue());
        });
    });


    xdescribe(@"Should destroy a session when an accessory disconnects", ^{

    });
});

QuickSpecEnd
