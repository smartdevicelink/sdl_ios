//
//  SDLSubscribeButtonObserverSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 5/22/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSubscribeButtonObserver.h"
#import "TestSubscribeButtonObserver.h"

QuickSpecBegin(SDLSubscribeButtonObserverSpec)

describe(@"subscribe button observer", ^{
    __block TestSubscribeButtonObserver *testObserver = nil;
    __block SEL testSelector = nil;
    __block SDLSubscribeButtonUpdateHandler testUpdateBlock = nil;

    beforeEach(^{
        testObserver = [[TestSubscribeButtonObserver alloc] init];
        testSelector = @selector(buttonPressEvent);
        testUpdateBlock = ^(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error) {};
    });

    it(@"Should set and get correctly", ^{
        SDLSubscribeButtonObserver *testSubscribeButtonObserver = [[SDLSubscribeButtonObserver alloc] init];
        testSubscribeButtonObserver.observer = testObserver;
        testSubscribeButtonObserver.selector = testSelector;
        testSubscribeButtonObserver.updateBlock = testUpdateBlock;

        expect(testSubscribeButtonObserver.observer).to(equal(testObserver));
        expect(NSStringFromSelector(testSubscribeButtonObserver.selector)).to(equal(NSStringFromSelector(testSelector)));
        expect((id)testSubscribeButtonObserver.updateBlock).to(equal((id)testUpdateBlock));
    });

    it(@"Should initialize correctly with initWithObserver:selector:", ^{
        SDLSubscribeButtonObserver *testSubscribeButtonObserver = [[SDLSubscribeButtonObserver alloc] initWithObserver:testObserver selector:testSelector];

        expect(testSubscribeButtonObserver.observer).to(equal(testObserver));
        expect(NSStringFromSelector(testSubscribeButtonObserver.selector)).to(equal(NSStringFromSelector(testSelector)));
        expect((id)testSubscribeButtonObserver.updateBlock).to(beNil());
    });

    it(@"Should initialize correctly with initWithObserver:updateHandler:", ^{
        SDLSubscribeButtonObserver *testSubscribeButtonObserver = [[SDLSubscribeButtonObserver alloc] initWithObserver:testObserver updateHandler:testUpdateBlock];

        expect(testSubscribeButtonObserver.observer).to(equal(testObserver));
        expect(NSStringFromSelector(testSubscribeButtonObserver.selector)).to(beNil());
        expect((id)testSubscribeButtonObserver.updateBlock).to(equal((id)testUpdateBlock));
    });

    it(@"Should return nil if not set", ^{
        SDLSubscribeButtonObserver *testSubscribeButtonObserver = [[SDLSubscribeButtonObserver alloc] init];

        expect(testSubscribeButtonObserver.observer).to(beNil());
        expect(NSStringFromSelector(testSubscribeButtonObserver.selector)).to(beNil());
        expect((id)testSubscribeButtonObserver.updateBlock).to(beNil());
    });
});

QuickSpecEnd
