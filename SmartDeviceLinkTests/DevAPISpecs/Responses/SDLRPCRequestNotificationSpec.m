//
//  SDLRPCRequestNotificationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/14/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNotificationConstants.h"
#import "SDLAddCommand.h"
#import "SDLRPCRequestNotification.h"


QuickSpecBegin(SDLRPCRequestNotificationSpec)

describe(@"A request notification", ^{
    __block SDLRPCRequest *testRequest = nil;
    __block NSString *testName = nil;

    beforeEach(^{
        testRequest = [[SDLAddCommand alloc] initWithName:@"testRequest"];
        testName = SDLDidReceiveAddCommandResponse;
    });

    it(@"Should initialize correctly with initWithName:object:rpcRequest:", ^{
        SDLRPCRequestNotification *testNotification = [[SDLRPCRequestNotification alloc] initWithName:testName object:nil rpcRequest:testRequest];

        expect(testNotification.name).to(equal(testName));
        expect(testNotification.userInfo).to(equal(@{SDLNotificationUserInfoObject: testRequest}));
        expect(testNotification.object).to(beNil());
        expect(testNotification.request).to(equal(testRequest));
        expect([testNotification isRequestKindOfClass:SDLRPCRequest.class]).to(beTrue());
        expect([testNotification isRequestMemberOfClass:SDLAddCommand.class]).to(beTrue());
    });
});

QuickSpecEnd

