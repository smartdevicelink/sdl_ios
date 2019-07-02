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

    describe(@"Initialization", ^{
        __block SDLIAPSession *testSession = nil;

        beforeEach(^{
            mockAccessory = [EAAccessory.class sdlCoreMock];
            testSession = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:ControlProtocolString];
        });

        it(@"should init correctly", ^{
            expect(testSession.accessory).to(equal(mockAccessory));
            expect(testSession.protocolString).to(equal(ControlProtocolString));
            expect(testSession.isInputStreamOpen).to(beFalse());
            expect(testSession.isOutputStreamOpen).to(beFalse());
        });

        it(@"should get correctly", ^{
            expect(testSession.isStopped).to(beTrue());
            expect(testSession.connectionID).to(equal(0));
            expect(testSession.isSessionInProgress).to(beFalse());
        });
    });
});

QuickSpecEnd

