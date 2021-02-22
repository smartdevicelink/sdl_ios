//
//  SDLIAPSessionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "EAAccessory+OCMock.m"
#import "SDLIAPSession.h"
#import "SDLIAPConstants.h"

QuickSpecBegin(SDLIAPSessionSpec)

describe(@"SDLIAPSession", ^{
    __block EAAccessory *mockAccessory = nil;
    __block id<SDLIAPSessionDelegate> mockDelegate = nil;

    describe(@"Initialization", ^{
        __block SDLIAPSession *testSession = nil;

        beforeEach(^{
            mockAccessory = [EAAccessory.class sdlCoreMock];
            mockDelegate = OCMProtocolMock(@protocol(SDLIAPSessionDelegate));
            testSession = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:ControlProtocolString iAPSessionDelegate:mockDelegate];
        });

        it(@"should init correctly", ^{
            expect(testSession.accessory).to(equal(mockAccessory));
            expect(testSession.bothStreamsOpen).to(beFalse());
            expect(testSession.hasSpaceAvailable).to(beFalse());
            expect(testSession.isSessionInProgress).to(beFalse());
        });
    });
});

QuickSpecEnd


