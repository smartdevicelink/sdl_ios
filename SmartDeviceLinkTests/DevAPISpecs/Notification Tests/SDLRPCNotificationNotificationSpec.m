//
//  SDLRPCNotificationNotificationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 3/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLNotificationConstants.h"
#import "SDLOnCommand.h"
#import "SDLRPCNotification.h"
#import "SDLRPCNotificationNotification.h"

QuickSpecBegin(SDLRPCNotificationNotificationSpec)

describe(@"A request notification notification", ^{
    __block SDLRPCNotification *testNotification = nil;
    __block NSString *testName = nil;

    beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testNotification = [[SDLOnCommand alloc] initWithName:@"testNotification"];
#pragma clang diagnostic pop
        testName = SDLDidReceiveCommandNotification;
    });

    it(@"Should initialize correctly with initWithName:object:rpcRequest:", ^{
        SDLRPCNotificationNotification *testRequestNotification = [[SDLRPCNotificationNotification alloc] initWithName:testName object:nil rpcNotification:testNotification];

        expect(testRequestNotification.name).to(equal(testName));
        expect(testRequestNotification.userInfo).to(equal(@{SDLNotificationUserInfoObject: testNotification}));
        expect(testRequestNotification.object).to(beNil());
        expect(testRequestNotification.notification).to(equal(testNotification));
        expect([testRequestNotification isNotificationKindOfClass:SDLRPCNotification.class]).to(beTrue());
        expect([testRequestNotification isNotificationMemberOfClass:SDLOnCommand.class]).to(beTrue());
    });
});

QuickSpecEnd

