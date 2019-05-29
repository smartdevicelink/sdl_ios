//
//  SDLIAPControlSessionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 4/16/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLIAPControlSession.h"

#import "EAAccessory+OCMock.m"
#import "SDLIAPConstants.h"
#import "SDLIAPControlSessionDelegate.h"
#import "SDLIAPSession.h"
#import "SDLTimer.h"


@interface SDLIAPControlSession()
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;
@property (weak, nonatomic) id<SDLIAPControlSessionDelegate> delegate;
@end

QuickSpecBegin(SDLIAPControlSessionSpec)

describe(@"SDLIAPControlSession", ^{
    __block SDLIAPControlSession *controlSession = nil;
    __block EAAccessory *mockAccessory = nil;
    __block id<SDLIAPControlSessionDelegate> mockDelegate = nil;

    beforeEach(^{
        mockDelegate = OCMProtocolMock(@protocol(SDLIAPControlSessionDelegate));
        mockAccessory = [EAAccessory.class sdlCoreMock];
    });

    describe(@"init", ^{
        beforeEach(^{
            controlSession = [[SDLIAPControlSession alloc] initWithAccessory:mockAccessory delegate:mockDelegate];
        });

        it(@"Should get/set correctly", ^{
            expect(controlSession.accessory).to(equal(mockAccessory));
            expect(controlSession.protocolString).to(equal(ControlProtocolString));
            expect(controlSession.protocolIndexTimer).to(beNil());
            expect(controlSession.delegate).to(equal(mockDelegate));
        });
    });

    describe(@"starting a session", ^{
        context(@"it should attempt to retry the session", ^{
            beforeEach(^{
                controlSession = [[SDLIAPControlSession alloc] initWithAccessory:nil delegate:mockDelegate];
            });

            it(@"Should start correctly", ^{
                [controlSession startSession];
                OCMExpect([mockDelegate controlSessionShouldRetry]);
            });
        });
    });
});

QuickSpecEnd
