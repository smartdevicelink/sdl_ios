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
#import "SDLNotificationDispatcher.h"
#import "SDLProtocol.h"

@interface SDLLifecycleProtocolHandler ()

@property (weak, nonatomic) SDLNotificationDispatcher *notificationDispatcher;
@property (copy, nonatomic) NSString *appId;

@end

QuickSpecBegin(SDLLifecycleProtocolHandlerSpec)

describe(@"SDLLifecycleProtocolHandler tests", ^{
    __block SDLLifecycleProtocolHandler *testHandler = nil;
    __block id mockProtocol = nil;
    __block id mockNotificationDispatcher = nil;

    beforeEach(^{
        mockProtocol = OCMClassMock([SDLProtocol class]);
        mockNotificationDispatcher = OCMClassMock([SDLNotificationDispatcher class]);

        SDLLifecycleConfiguration *testLifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:@"test" fullAppId:@"appid"];
        SDLConfiguration *testConfig = [[SDLConfiguration alloc] initWithLifecycle:testLifecycleConfig lockScreen:nil logging:nil fileManager:nil encryption:nil];

        testHandler = [[SDLLifecycleProtocolHandler alloc] initWithProtocol:mockProtocol notificationDispatcher:mockNotificationDispatcher configuration:testConfig];
    });

    describe(@"when started", ^{
        beforeEach(^{
            OCMExpect([(SDLProtocol *)mockProtocol start]);
        });

        it(@"should start the protocol", ^{
            OCMVerifyAll(mockProtocol);
        });
    });

    describe(@"when stopped", ^{
        beforeEach(^{
            OCMExpect([(SDLProtocol *)mockProtocol stop]);
        });

        it(@"should stop the protocol", ^{
            OCMVerifyAll(mockProtocol);
        });
    });
});

QuickSpecEnd
