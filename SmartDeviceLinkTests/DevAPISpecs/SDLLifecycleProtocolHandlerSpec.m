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
#import "SDLLifecycleConfiguration.h"
#import "SDLLifecycleProtocolHandler.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLProtocol.h"
#import "SDLProtocolDelegate.h"
#import "SDLTimer.h"

@interface SDLLifecycleProtocolHandler ()

@property (weak, nonatomic) SDLNotificationDispatcher *notificationDispatcher;
@property (strong, nonatomic) SDLTimer *rpcStartServiceTimeoutTimer;
@property (copy, nonatomic) NSString *appId;

@end

QuickSpecBegin(SDLLifecycleProtocolHandlerSpec)

fdescribe(@"SDLLifecycleProtocolHandler tests", ^{
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
            OCMExpect([(SDLProtocol *)mockProtocol stop]);
            [testHandler stop];
        });

        it(@"should stop the protocol", ^{
            OCMVerifyAll(mockProtocol);
        });
    });

    describe(@"when the protocol notifies us", ^{
        context(@"of the transport opening", ^{
            beforeEach(^{
                OCMExpect([mockNotificationDispatcher postNotificationName:[OCMArg isEqual:SDLTransportDidConnect] infoObject:[OCMArg isNil]]);
                OCMExpect([mockProtocol startServiceWithType:[OCMArg any] payload:[OCMArg any]]);
                OCMExpect([(SDLTimer *)mockTimer start]);
                [testHandler onProtocolOpened];
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
                [testHandler onProtocolClosed];
            });

            it(@"should send a notification", ^{
                OCMVerifyAll(mockNotificationDispatcher);
            });
        });

        context(@"of the transport erroring", ^{
            beforeEach(^{
                OCMExpect([mockNotificationDispatcher postNotificationName:[OCMArg isEqual:SDLTransportConnectError] infoObject:[OCMArg isNil]]);
                [testHandler onProtocolClosed];
            });

            it(@"should send a notification", ^{
                OCMVerifyAll(mockNotificationDispatcher);
            });
        });
    });
});

QuickSpecEnd
