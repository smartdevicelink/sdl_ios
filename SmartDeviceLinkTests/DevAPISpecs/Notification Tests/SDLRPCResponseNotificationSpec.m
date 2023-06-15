//
//  SDLRPCResponseNotificationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 3/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLNotificationConstants.h"
#import "SDLAddCommandResponse.h"
#import "SDLRPCResponseNotification.h"

QuickSpecBegin(SDLRPCResponseNotificationSpec)

describe(@"A response notification", ^{
    __block SDLRPCResponse *testResponse = nil;
    __block NSString *testName = nil;

    beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testResponse = [[SDLAddCommandResponse alloc] initWithName:@"testResponse"];
#pragma clang diagnostic pop
        testName = SDLDidReceiveAddCommandRequest;
    });

    it(@"Should initialize correctly with initWithName:object:rpcRequest:", ^{
        SDLRPCResponseNotification *testNotification = [[SDLRPCResponseNotification alloc] initWithName:testName object:nil rpcResponse:testResponse];

        expect(testNotification.name).to(equal(testName));
        expect(testNotification.userInfo).to(equal(@{SDLNotificationUserInfoObject: testResponse}));
        expect(testNotification.object).to(beNil());
        expect(testNotification.response).to(equal(testResponse));
        expect([testNotification isResponseKindOfClass:SDLRPCResponse.class]).to(beTrue());
        expect([testNotification isResponseMemberOfClass:SDLAddCommandResponse.class]).to(beTrue());
    });
});

QuickSpecEnd
