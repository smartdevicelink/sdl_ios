//
//  SDLIAPTransportSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 9/18/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "EAAccessory+SDLProtocols.h"
#import "EAAccessoryManager+SDLProtocols.h"
#import "SDLIAPSession.h"
#import "SDLIAPTransport.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"

NSString *const LegacyProtocolString = @"com.ford.sync.prot0";
NSString *const ControlProtocolString = @"com.smartdevicelink.prot0";
NSString *const IndexedProtocolStringPrefix = @"com.smartdevicelink.prot";
NSString *const MultiSessionProtocolString = @"com.smartdevicelink.multisession";
NSString *const BackgroundTaskName = @"com.sdl.transport.iap.backgroundTask";

@interface SDLIAPTransport ()

@property (assign, nonatomic) int retryCounter;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;

- (nullable SDLIAPSession *)sdl_createSessionWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol streamHasBytesHandler:(SDLStreamHasBytesHandler)streamHasBytesHandler streamEndHandler:(SDLStreamEndHandler)streamEndHandler streamErrorHandler:(SDLStreamErrorHandler)streamErrorHandler;

@end

QuickSpecBegin(SDLIAPTransportSpec)

describe(@"SDLIAPTransport Tests", ^{
    __block SDLIAPTransport *iapTransport;
    __block id createSessionMock;

    beforeEach(^{
        iapTransport = [[SDLIAPTransport alloc] init];
        createSessionMock = OCMPartialMock(iapTransport);
    });

    context(@"initializing", ^{
        it(@"should correctly have default properties", ^{
            SDLIAPTransport *iapTransport = [[SDLIAPTransport alloc] init];
            expect(iapTransport.session).to(beNil());
            expect(iapTransport.controlSession).to(beNil());
            expect(iapTransport.retryCounter).to(equal(1));
            expect(iapTransport.backgroundTaskId).to(equal(UIBackgroundTaskInvalid));
            expect(iapTransport.protocolIndexTimer).to(beNil());
        });
    });

    __block void (^connectAccessory)(SDLIAPTransport *iapTransport, EAAccessory *accessory) = ^(SDLIAPTransport *iapTransport, EAAccessory *accessory) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EAAccessoryDidConnectNotification object:nil userInfo:@{EAAccessoryKey:accessory}];
    };

    __block void (^disconnectAccessory)(SDLIAPTransport *iapTransport, EAAccessory *accessory) = ^(SDLIAPTransport *iapTransport, EAAccessory *accessory) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EAAccessoryDidDisconnectNotification object:nil userInfo:@{EAAccessoryKey:accessory}];
    };

    __block void (^appEnterForeground)(void) = ^(void) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];
    };

    __block void (^appEnterBackgrounded)(void) = ^(void) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidEnterBackgroundNotification object:nil];
    };

    context(@"When an accessory is connected", ^{
        __block id accessoryMock;
        __block id controlSessionMock;

        beforeEach(^{
            accessoryMock = OCMClassMock([EAAccessory class]);
            controlSessionMock = OCMClassMock([SDLIAPSession class]);
            OCMStub([accessoryMock supportsProtocol:ControlProtocolString])._andReturn(@YES);
            OCMStub([(SDLIAPSession *)controlSessionMock start])._andReturn(@YES);
        });

        it(@"should connect if the accessory protocol is ControlProtocolString", ^{
            // Replace one method on the object
            [OCMStub([createSessionMock sdl_createSessionWithAccessory:[OCMArg any] forProtocol:[OCMArg any] streamHasBytesHandler:[OCMArg any] streamEndHandler:[OCMArg any] streamErrorHandler:[OCMArg any]]) andReturn:controlSessionMock];

            // Call the code under test
            connectAccessory(iapTransport, accessoryMock);

            // Verify that the method has been called
            OCMVerify([createSessionMock sdl_createSessionWithAccessory:[OCMArg any] forProtocol:[OCMArg any] streamHasBytesHandler:[OCMArg any] streamEndHandler:[OCMArg any] streamErrorHandler:[OCMArg any]]);
        });

        afterEach(^{
            expect(iapTransport.session).toNot(beNil());
            expect(iapTransport.controlSession).to(beNil());
            expect(iapTransport.retryCounter).to(equal(1));
        });
    });

    context(@"When an accessory is disconnected", ^{
        __block id testAccessoryMock;
        __block id testDisconnectedAccessoryMock;
        __block SDLIAPSession *testIAPSession;
        __block SDLIAPSession *testExpectedIAPSession;
        __block NSString *testAccessorySerialNumber;
        __block NSString *testDisconnectedAccessorySerialNumber;

        beforeEach(^{
            testAccessoryMock = OCMClassMock([EAAccessory class]);
            testDisconnectedAccessoryMock = OCMClassMock([EAAccessory class]);
            testIAPSession = OCMClassMock([SDLIAPSession class]);
        });

        describe(@"Disconnect the accessory if it is connected", ^{
            it(@"should disconnect a connected accessory if they both have the same serial number", ^{
                testAccessorySerialNumber = @"45a2";
                testDisconnectedAccessorySerialNumber = @"45a2";
                testExpectedIAPSession = nil;
            });

            it(@"should not disconnect a accessory if they do not have the same serial number", ^{
                testAccessorySerialNumber = @"9456";
                testDisconnectedAccessorySerialNumber = @"9i9";
                testExpectedIAPSession = testIAPSession;
            });

            afterEach(^{
                [OCMStub([testAccessoryMock serialNumber]) andReturn:testAccessorySerialNumber];
                [OCMStub([testDisconnectedAccessoryMock serialNumber]) andReturn:testDisconnectedAccessorySerialNumber];
                [OCMStub([testIAPSession accessory]) andReturn:testAccessoryMock];

                iapTransport.session = testIAPSession;
                expect(iapTransport.session).toNot(beNil());

                disconnectAccessory(iapTransport, testDisconnectedAccessoryMock);
            });
        });

        afterEach(^{
            expect(iapTransport.session).to(testExpectedIAPSession ? equal(testExpectedIAPSession) : beNil());
        });
    });
});

QuickSpecEnd
