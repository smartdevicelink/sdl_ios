//
//  SDLSubscribeButtonManagerSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 5/22/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLError.h"
#import "SDLOnButtonEvent.h"
#import "SDLOnButtonPress.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSubscribeButtonManager.h"
#import "SDLSubscribeButtonObserver.h"
#import "SDLSubscribeButtonResponse.h"
#import "SDLSubscribebutton.h"
#import "SDLUnsubscribeButton.h"
#import "SDLUnsubscribeButtonResponse.h"
#import "TestConnectionManager.h"
#import "TestSubscribeButtonObserver.h"

@interface SDLSubscribeButtonManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic) NSMutableDictionary<SDLButtonName, NSMutableArray<SDLSubscribeButtonObserver *> *> *subscribeButtonObservers;

@end

QuickSpecBegin(SDLSubscribeButtonManagerSpec)

describe(@"subscribe button manager", ^{
    __block SDLSubscribeButtonManager *testManager = nil;
    __block TestConnectionManager *testConnectionManager = nil;

    __block SDLSubscribeButtonResponse *testSubscribeSuccessResponse = nil;
    __block SDLSubscribeButtonResponse *testSubscribeFailureResponse = nil;
    __block SDLUnsubscribeButtonResponse *testUnSubscribeSuccessResponse = nil;
    __block SDLUnsubscribeButtonResponse *testUnSubscribeFailureResponse = nil;

    beforeEach(^{
        testSubscribeSuccessResponse = [[SDLSubscribeButtonResponse alloc] init];
        testSubscribeSuccessResponse.success = @YES;
        testUnSubscribeSuccessResponse.resultCode = SDLResultSuccess;

        testSubscribeFailureResponse = [[SDLSubscribeButtonResponse alloc] init];
        testSubscribeFailureResponse.success = @NO;
        testUnSubscribeSuccessResponse.resultCode = SDLResultDisallowed;

        testUnSubscribeSuccessResponse = [[SDLUnsubscribeButtonResponse alloc] init];
        testUnSubscribeSuccessResponse.success = @YES;
        testUnSubscribeSuccessResponse.resultCode = SDLResultSuccess;

        testUnSubscribeFailureResponse = [[SDLUnsubscribeButtonResponse alloc] init];
        testUnSubscribeFailureResponse.success = @NO;
        testUnSubscribeFailureResponse.resultCode = SDLResultDisallowed;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testManager = [[SDLSubscribeButtonManager alloc] initWithConnectionManager:testConnectionManager];
    });

    it(@"should instantiate correctly with initWithConnectionManager:", ^{
        expect(testManager.connectionManager).to(equal(testConnectionManager));
        expect(testManager.subscribeButtonObservers).toNot(beNil());
        expect(testManager.subscribeButtonObservers.count).to(equal(0));
    });

    it(@"should do nothing when Start is called", ^{
        [testManager start];

        expect(testManager.subscribeButtonObservers).toNot(beNil());
        expect(testManager.subscribeButtonObservers.count).to(equal(0));
    });

    it(@"should clear, but not destroy, the list of observers when Stop is called", ^{
        SDLSubscribeButtonUpdateHandler testUpdateBlock = ^(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error) {};
        testManager.subscribeButtonObservers[SDLButtonNameTuneUp] = [NSMutableArray arrayWithObject:[[SDLSubscribeButtonObserver alloc] initWithObserver:[[NSObject alloc] init] updateHandler:testUpdateBlock]];
        expect(testManager.subscribeButtonObservers.count).to(equal(1));

        [testManager stop];

        expect(testManager.subscribeButtonObservers).toNot(beNil());
        expect(testManager.subscribeButtonObservers.count).to(equal(0));
    });

    describe(@"should subscribe with a block handler", ^{
        __block SDLButtonName testButtonName = nil;
        __block SDLSubscribeButtonUpdateHandler testUpdateHandler1 = nil;
        __block BOOL testHandler1Called = NO;
        __block NSError *testHandle1Error = nil;
        __block SDLOnButtonPress *testHandler1OnButtonPress = nil;
        __block SDLOnButtonEvent *testHandler1OnButtonEvent = nil;

        __block SDLSubscribeButtonUpdateHandler testUpdateHandler2 = nil;
        __block BOOL testHandler2Called = NO;
        __block NSError *testHandler2Error = nil;
        __block SDLOnButtonPress *testHandler2OnButtonPress = nil;
        __block SDLOnButtonEvent *testHandler2OnButtonEvent = nil;

        beforeEach(^{
            testButtonName = SDLButtonNameTuneUp;
            testUpdateHandler1 = ^(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error) {
                testHandler1Called = YES;
                testHandle1Error = error;
                testHandler1OnButtonPress = buttonPress;
                testHandler1OnButtonEvent = buttonEvent;
            };
            testUpdateHandler2 = ^(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error) {
                testHandler2Called = YES;
                testHandler2Error = error;
                testHandler2OnButtonPress = buttonPress;
                testHandler2OnButtonEvent = buttonEvent;
            };
        });

        it(@"should send a subscription request to the module if adding the first observer for that button name but it should not send a subscription request to the module if adding a subsequent observer for the same button name", ^{
            id subscriptionID1 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

            id subscriptionID2 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler2];
            expect(subscriptionID1).toNot(beNil());
            expect(subscriptionID2).toNot(beNil());

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers.count).toEventually(equal(2));
            expect((id)observers[0].updateBlock).toEventually(equal((id)testUpdateHandler1));
            expect((id)observers[1].updateBlock).toEventually(equal((id)testUpdateHandler2));

            expect(testConnectionManager.receivedRequests.count).toEventually(equal(1));
            expect(testConnectionManager.receivedRequests[0]).toEventually(beAKindOf(SDLSubscribeButton.class));
        });

        it(@"should send two subscription request for the same button name to the module if the second request is sent before the module responds to the first request and it should add both observers if the second request fails with a result code of IGNORED", ^{
            id subscriptionID1 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];
            id subscriptionID2 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler2];
            expect(subscriptionID1).toNot(beNil());
            expect(subscriptionID2).toNot(beNil());

            // Respond to first request with a success response
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

            // Respond to second request with a failure response and a result code of `IGNORED`
            SDLSubscribeButtonResponse *testSubscribeIgnoredResponse = [[SDLSubscribeButtonResponse alloc] init];
            testSubscribeIgnoredResponse.success = @NO;
            testSubscribeIgnoredResponse.resultCode = SDLResultIgnored;
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeIgnoredResponse];

            // Both observers should be added
            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers.count).toEventually(equal(2));

            expect(testConnectionManager.receivedRequests.count).toEventually(equal(2));
            expect(testConnectionManager.receivedRequests[0]).toEventually(beAKindOf(SDLSubscribeButton.class));
            expect(testConnectionManager.receivedRequests[1]).toEventually(beAKindOf(SDLSubscribeButton.class));
        });

        it(@"should not notify the observer when a success response is received for the subscribe button request", ^{
            [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

            expect(testHandler1Called).to(beFalse());
        });

        it(@"should notify the observer with the error and remove the observer when a failure response is received for the subscribe button request", ^{
            [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];

            NSError *testError = [NSError errorWithDomain:@"errorDomain" code:9 userInfo:@{@"subscribe button error":@"error 2"}];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeFailureResponse error:testError];

            expect(testHandler1Called).to(beTrue());
            expect(testHandle1Error).to(equal(testError));

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers.count).to(equal(0));
        });
    });

    describe(@"should subscribe with an observer and selector", ^{
        __block SDLButtonName testButtonName = nil;
        __block TestSubscribeButtonObserver *testSubscribeButtonObserver1 = nil;
        __block SEL testSelector1 = @selector(buttonPressEvent);

        __block TestSubscribeButtonObserver *testSubscribeButtonObserver2 = nil;
        __block SEL testSelector2 = @selector(buttonPressEvent);

        beforeEach(^{
            testButtonName = SDLButtonNameSeekLeft;
            testSubscribeButtonObserver1 = [[TestSubscribeButtonObserver alloc] init];
            testSubscribeButtonObserver2 = [[TestSubscribeButtonObserver alloc] init];

            testSelector1 = @selector(buttonPressEvent);
            testSelector2 = @selector(buttonPressEventWithButtonName:error:);
        });

        it(@"should send a subscription request to the module if adding the first observer for that button name", ^{
            [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 selector:testSelector1];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers.count).to(equal(1));
            expect(NSStringFromSelector(observers[0].selector)).to(equal(NSStringFromSelector(testSelector1)));

            expect(testConnectionManager.receivedRequests.count).to(equal(1));
            expect([testConnectionManager.receivedRequests[0] isKindOfClass:SDLSubscribeButton.class]);
        });

        it(@"should not send a subscription request to the module if adding a subsequent observer for that button name", ^{
            [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 selector:testSelector1];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

            [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver2 selector:testSelector2];

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers.count).to(equal(2));
            expect(NSStringFromSelector(observers[0].selector)).to(equal(NSStringFromSelector(testSelector1)));
            expect(NSStringFromSelector(observers[1].selector)).to(equal(NSStringFromSelector(testSelector2)));

            expect(testConnectionManager.receivedRequests.count).to(equal(1));
            expect([testConnectionManager.receivedRequests[0] isKindOfClass:SDLSubscribeButton.class]);
        });

        it(@"should not notify the observer when a success response is received for the subscribe button request", ^{
            [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 selector:testSelector1];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

            expect(testSubscribeButtonObserver1.selectorCalledCount).to(equal(0));
        });

        it(@"should notify the observer with the error and remove the observer when a failure response is received for the subscribe button request", ^{
            [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 selector:testSelector2];
            NSError *testError = [NSError errorWithDomain:@"errorDomain" code:9 userInfo:@{@"subscribe button error":@"error 2"}];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeFailureResponse error:testError];

            expect(testSubscribeButtonObserver1.selectorCalledCount).to(equal(1));
            expect(testSubscribeButtonObserver1.buttonErrorsReceived.count).to(equal(1));
            expect(testSubscribeButtonObserver1.buttonErrorsReceived[0]).to(equal(testError));
            expect(testSubscribeButtonObserver1.buttonNamesReceived[0]).to(equal(testButtonName));

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers.count).to(equal(0));
        });

        it(@"should ignore a subscription attempt with an invalid selector (selector has too many parameters)", ^{
            SEL testInvalidSelector = @selector(buttonPressEventWithButtonName:error:buttonPress:buttonEvent:extraParameter:);
            [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 selector:testInvalidSelector];

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers).to(beNil());

            expect(testConnectionManager.receivedRequests.count).to(equal(0));
        });

        it(@"should ignore a subscription attempt with an nil observer", ^{
            SEL testValidSelector = @selector(buttonPressEventWithButtonName:error:);
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
            [testManager subscribeButton:testButtonName withObserver:nil selector:testValidSelector];
#pragma GCC diagnostic pop

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers).to(beNil());

            expect(testConnectionManager.receivedRequests.count).to(equal(0));
        });
    });

    describe(@"notifying subscribers of subscribe button presses and events", ^{
        __block SDLButtonName testButtonName = nil;
        __block SDLOnButtonPress *testButtonPress = nil;
        __block SDLOnButtonEvent *testButtonEvent = nil;
        __block SDLRPCNotificationNotification *buttonEventNotification = nil;
        __block SDLRPCNotificationNotification *buttonPressNotification = nil;

        beforeEach(^{
            testButtonName = SDLButtonNameTuneUp;

            testButtonPress = [[SDLOnButtonPress alloc] init];
            testButtonPress.buttonPressMode = SDLButtonPressModeLong;
            testButtonPress.buttonName = testButtonName;

            testButtonEvent = [[SDLOnButtonEvent alloc] init];
            testButtonEvent.buttonEventMode = SDLButtonEventModeButtonUp;
            testButtonEvent.buttonName = testButtonName;

            buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
            buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];
        });

        describe(@"all subscribers should be notified", ^{
            __block SDLSubscribeButtonUpdateHandler testUpdateHandler1 = nil;
            __block BOOL testHandler1Called = NO;
            __block NSError *testHandle1Error = nil;
            __block SDLOnButtonPress *testHandler1OnButtonPress = nil;
            __block SDLOnButtonEvent *testHandler1OnButtonEvent = nil;

            __block SDLSubscribeButtonUpdateHandler testUpdateHandler2 = nil;
            __block BOOL testHandler2Called = NO;
            __block NSError *testHandler2Error = nil;
            __block SDLOnButtonPress *testHandler2OnButtonPress = nil;
            __block SDLOnButtonEvent *testHandler2OnButtonEvent = nil;

            __block TestSubscribeButtonObserver *testObserver1 = nil;
            __block SEL testSelector1 = nil;

            __block TestSubscribeButtonObserver *testObserver2 = nil;
            __block SEL testSelector2 = nil;

            beforeEach(^{
                testUpdateHandler1 = ^(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error) {
                    testHandler1Called = YES;
                    testHandle1Error = error;
                    testHandler1OnButtonPress = buttonPress;
                    testHandler1OnButtonEvent = buttonEvent;
                };

                testUpdateHandler2 = ^(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error) {
                    testHandler2Called = YES;
                    testHandler2Error = error;
                    testHandler2OnButtonPress = buttonPress;
                    testHandler2OnButtonEvent = buttonEvent;
                };

                testObserver1 = [[TestSubscribeButtonObserver alloc] init];
                testSelector1 = @selector(buttonPressEventWithButtonName:error:buttonPress:buttonEvent:);

                testObserver2 = [[TestSubscribeButtonObserver alloc] init];
                testSelector2 = @selector(buttonPressEventWithButtonName:error:buttonPress:buttonEvent:);

                [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];
                [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler2];
                [testManager subscribeButton:testButtonName withObserver:testObserver1 selector:testSelector1];
                [testManager subscribeButton:testButtonName withObserver:testObserver2 selector:testSelector2];
            });

            it(@"should notify block handler and observer/selector subscribers when a button event notification is received", ^{
                [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];

                expect(testHandler1Called).toEventually(beTrue());
                expect(testHandle1Error).toEventually(beNil());
                expect(testHandler1OnButtonEvent).toEventually(equal(testButtonEvent));
                expect(testHandler1OnButtonPress).toEventually(beNil());

                expect(testHandler2Called).toEventually(beTrue());
                expect(testHandler2Error).toEventually(beNil());
                expect(testHandler2OnButtonEvent).toEventually(equal(testButtonEvent));
                expect(testHandler2OnButtonPress).toEventually(beNil());

                expect(testObserver1.buttonNamesReceived.count).to(equal(1));
                expect(testObserver1.buttonErrorsReceived).to(beEmpty());
                expect(testObserver1.buttonPressesReceived).to(beEmpty());
                expect(testObserver1.buttonEventsReceived[0]).to(equal(testButtonEvent));

                expect(testObserver2.buttonNamesReceived.count).to(equal(1));
                expect(testObserver2.buttonErrorsReceived).to(beEmpty());
                expect(testObserver2.buttonPressesReceived).to(beEmpty());
                expect(testObserver2.buttonEventsReceived[0]).to(equal(testButtonEvent));
            });

            it(@"should notify block handler and observer/selector subscribers when a button press notification is received", ^{
                [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];

                expect(testHandler1Called).toEventually(beTrue());
                expect(testHandle1Error).toEventually(beNil());
                expect(testHandler1OnButtonEvent).toEventually(beNil());
                expect(testHandler1OnButtonPress).toEventually(equal(testButtonPress));

                expect(testHandler2Called).toEventually(beTrue());
                expect(testHandler2Error).toEventually(beNil());
                expect(testHandler2OnButtonEvent).toEventually(beNil());
                expect(testHandler2OnButtonPress).toEventually(equal(testButtonPress));

                expect(testObserver1.buttonNamesReceived.count).to(equal(1));
                expect(testObserver1.buttonErrorsReceived).to(beEmpty());
                expect(testObserver1.buttonPressesReceived[0]).to(equal(testButtonPress));
                expect(testObserver1.buttonEventsReceived).to(beEmpty());

                expect(testObserver2.buttonNamesReceived.count).to(equal(1));
                expect(testObserver2.buttonErrorsReceived).to(beEmpty());
                expect(testObserver2.buttonPressesReceived[0]).to(equal(testButtonPress));
                expect(testObserver2.buttonEventsReceived).to(beEmpty());
            });
        });

        describe(@"All selector/observers subscribers with 0-4 parameters in the selector should be notified of button presses", ^{
            it(@"should notify the observer of a button press when the selector has no parameters", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
                SEL testSelector = @selector(buttonPressEvent);
                [testManager subscribeButton:testButtonName withObserver:testObserver selector:testSelector];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

                [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];

                expect(testObserver.selectorCalledCount).to(equal(1));
                expect(testObserver.buttonNamesReceived).to(beEmpty());
                expect(testObserver.buttonErrorsReceived).to(beEmpty());
                expect(testObserver.buttonPressesReceived).to(beEmpty());
                expect(testObserver.buttonEventsReceived).to(beEmpty());
            });

            it(@"should notify the observer of a button press when the selector has one parameter", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
                SEL testSelector = @selector(buttonPressEventWithButtonName:);
                [testManager subscribeButton:testButtonName withObserver:testObserver selector:testSelector];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

                [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];

                expect(testObserver.selectorCalledCount).to(equal(1));
                expect([testObserver.buttonNamesReceived containsObject:testButtonName]).to(beTrue());
                expect(testObserver.buttonErrorsReceived).to(beEmpty());
                expect(testObserver.buttonPressesReceived).to(beEmpty());
                expect(testObserver.buttonEventsReceived).to(beEmpty());
            });

            it(@"should notify the observer of a button press when the selector has two parameters", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
                SEL testSelector = @selector(buttonPressEventWithButtonName:error:);
                [testManager subscribeButton:testButtonName withObserver:testObserver selector:testSelector];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

                [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];

                expect(testObserver.selectorCalledCount).to(equal(1));
                expect([testObserver.buttonNamesReceived containsObject:testButtonName]).to(beTrue());
                expect(testObserver.buttonErrorsReceived).to(beEmpty());
                expect(testObserver.buttonPressesReceived).to(beEmpty());
                expect(testObserver.buttonEventsReceived).to(beEmpty());
            });

            it(@"should notify the observer of a button press when the selector has three parameters", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
                SEL testSelector = @selector(buttonPressEventWithButtonName:error:buttonPress:);
                [testManager subscribeButton:testButtonName withObserver:testObserver selector:testSelector];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

                [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];

                expect(testObserver.selectorCalledCount).to(equal(1));
                expect([testObserver.buttonNamesReceived containsObject:testButtonName]).to(beTrue());
                expect(testObserver.buttonErrorsReceived).to(beEmpty());
                expect(testObserver.buttonPressesReceived[0]).to(equal(testButtonPress));
                expect(testObserver.buttonEventsReceived).to(beEmpty());
            });

            it(@"should notify the observer of a button press when the selector has four parameters", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
                SEL testSelector = @selector(buttonPressEventWithButtonName:error:buttonPress:buttonEvent:);
                [testManager subscribeButton:testButtonName withObserver:testObserver selector:testSelector];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

                [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];

                expect(testObserver.selectorCalledCount).to(equal(1));
                expect([testObserver.buttonNamesReceived containsObject:testButtonName]).to(beTrue());
                expect(testObserver.buttonErrorsReceived).to(beEmpty());
                expect(testObserver.buttonPressesReceived[0]).to(equal(testButtonPress));
                expect(testObserver.buttonEventsReceived).to(beEmpty());
            });
        });

        describe(@"Only selector/observer subscribers with four parameters in the selector should be notified of button events", ^{
            it(@"should not notify the observer of a button event when the selector has no parameters", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
                SEL testSelector = @selector(buttonPressEvent);
                [testManager subscribeButton:testButtonName withObserver:testObserver selector:testSelector];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

                [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];

                expect(testObserver.selectorCalledCount).to(equal(0));
                expect(testObserver.buttonNamesReceived).to(beEmpty());
                expect(testObserver.buttonErrorsReceived).to(beEmpty());
                expect(testObserver.buttonPressesReceived).to(beEmpty());
                expect(testObserver.buttonEventsReceived).to(beEmpty());
            });

            it(@"should not notify the observer of a button event when the selector has one parameter", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
                SEL testSelector = @selector(buttonPressEventWithButtonName:);
                [testManager subscribeButton:testButtonName withObserver:testObserver selector:testSelector];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

                [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];

                expect(testObserver.selectorCalledCount).to(equal(0));
                expect(testObserver.buttonNamesReceived).to(beEmpty());
                expect(testObserver.buttonErrorsReceived).to(beEmpty());
                expect(testObserver.buttonPressesReceived).to(beEmpty());
                expect(testObserver.buttonEventsReceived).to(beEmpty());
            });

            it(@"should not notify the observer of a button event when the selector has two parameters", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
                SEL testSelector = @selector(buttonPressEventWithButtonName:error:);
                [testManager subscribeButton:testButtonName withObserver:testObserver selector:testSelector];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

                [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];

                expect(testObserver.selectorCalledCount).to(equal(0));
                expect(testObserver.buttonNamesReceived).to(beEmpty());
                expect(testObserver.buttonErrorsReceived).to(beEmpty());
                expect(testObserver.buttonPressesReceived).to(beEmpty());
                expect(testObserver.buttonEventsReceived).to(beEmpty());
            });

            it(@"should not notify the observer of a button event when the selector has three parameters", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
                SEL testSelector = @selector(buttonPressEventWithButtonName:error:buttonPress:);
                [testManager subscribeButton:testButtonName withObserver:testObserver selector:testSelector];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

                [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];

                expect(testObserver.selectorCalledCount).to(equal(0));
                expect(testObserver.buttonNamesReceived).to(beEmpty());
                expect(testObserver.buttonErrorsReceived).to(beEmpty());
                expect(testObserver.buttonPressesReceived).to(beEmpty());
                expect(testObserver.buttonEventsReceived).to(beEmpty());
            });

            it(@"should notify the observer of a button event when the selector has four parameters", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
                SEL testSelector = @selector(buttonPressEventWithButtonName:error:buttonPress:buttonEvent:);
                [testManager subscribeButton:testButtonName withObserver:testObserver selector:testSelector];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

                [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];

                expect(testObserver.selectorCalledCount).to(equal(1));
                expect([testObserver.buttonNamesReceived containsObject:testButtonName]).to(beTrue());
                expect(testObserver.buttonErrorsReceived).to(beEmpty());
                expect(testObserver.buttonPressesReceived).to(beEmpty());
                expect(testObserver.buttonEventsReceived[0]).to(equal(testButtonEvent));
            });
        });

        describe(@"Handling invalid selectors", ^{
        __block SDLRPCNotificationNotification *buttonPressNotification = nil;

            beforeEach(^{
                testButtonName = SDLButtonNameOk;
                testButtonPress = [[SDLOnButtonPress alloc] init];
                testButtonPress.buttonPressMode = SDLButtonPressModeLong;
                testButtonPress.buttonName = testButtonName;
                buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];
            });

            it(@"should throw an exception if the selector does not exist for the observer", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
                SEL testInvalidSelector = @selector(invalidSelector:);
#pragma GCC diagnostic pop
                [testManager subscribeButton:testButtonName withObserver:testObserver selector:testInvalidSelector];
                [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

                expectAction(^{
                    [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                }).to(raiseException().named([NSException sdl_invalidSubscribeButtonSelectorExceptionWithSelector:testInvalidSelector].name));
            });

            it(@"should throw an assert if the selector has too many parameters", ^{
                TestSubscribeButtonObserver *testObserver = [[TestSubscribeButtonObserver alloc] init];
                SEL testInvalidSelector = @selector(buttonPressEventWithButtonName:error:buttonPress:buttonEvent:extraParameter:);

                // Set the invalid selector manually as using `subscribeButton:withObserver:selector:` will not add an invalid selector to the list of `subscribeButtonObservers`
                testManager.subscribeButtonObservers[testButtonName] = [NSMutableArray arrayWithObject:[[SDLSubscribeButtonObserver alloc] initWithObserver:testObserver selector:testInvalidSelector]];

                expectAction(^{
                    [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                }).to(raiseException().named([NSException sdl_invalidSubscribeButtonSelectorExceptionWithSelector:testInvalidSelector].name));
            });

            afterEach(^{
                [testManager.subscribeButtonObservers removeAllObjects];
            });
        });
    });

    describe(@"should unsubscribe with an update handler", ^{
        __block SDLButtonName testButtonName = nil;

        __block SDLSubscribeButtonUpdateHandler testUpdateHandler1 = nil;
        __block SDLSubscribeButtonUpdateCompletionHandler testCompletionHandler1 = nil;
        __block BOOL testCompletionHandler1Called = NO;
        __block NSError *testCompletionHandler1Error = nil;

        __block SDLSubscribeButtonUpdateHandler testUpdateHandler2 = nil;
        __block SDLSubscribeButtonUpdateCompletionHandler testCompletionHandler2 = nil;
        __block BOOL testCompletionHandler2Called = NO;
        __block NSError *testCompletionHandler2Error = nil;

        beforeEach(^{
            testButtonName = SDLButtonNameTuneUp;

            testUpdateHandler1 = ^(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error) {};
            testCompletionHandler1 = ^(NSError *__nullable error) {
                testCompletionHandler1Called = YES;
                testCompletionHandler1Error = error;
            };
            testCompletionHandler1Called = NO;
            testCompletionHandler2Error = nil;

            testUpdateHandler2 = ^(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error) {};
            testCompletionHandler2 = ^(NSError *__nullable error) {
                testCompletionHandler2Called = YES;
                testCompletionHandler2Error = error;
            };
            testCompletionHandler2Called = NO;
            testCompletionHandler2Error = nil;
        });

        it(@"should unsubscribe the observer if there are multiple observers subscribed to the button", ^{
            id subscriptionID1 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];
            id subscriptionID2 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler2];

            [testManager unsubscribeButton:testButtonName withObserver:subscriptionID1 withCompletionHandler:testCompletionHandler1];

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers.count).to(equal(1));
            expect((id)observers[0].updateBlock).to(equal((id)testUpdateHandler2));
            expect(observers[0].observer).to(equal(subscriptionID2));

            expect(testCompletionHandler1Called).to(beTrue());
            expect(testCompletionHandler2Called).to(beFalse());

            expect(testConnectionManager.receivedRequests.count).to(equal(1));
            expect(testConnectionManager.receivedRequests.firstObject).to(beAKindOf(SDLSubscribeButton.class));
        });

        it(@"should send an unsubscribe button request when the last observer is removed and it should notify the observer that the unsubscribe request succeeded", ^{
            id subscriptionID1 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];
            id subscriptionID2 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler2];

            [testManager unsubscribeButton:testButtonName withObserver:subscriptionID1 withCompletionHandler:testCompletionHandler1];
            [testManager unsubscribeButton:testButtonName withObserver:subscriptionID2 withCompletionHandler:testCompletionHandler2];
            [testConnectionManager respondToLastRequestWithResponse:testUnSubscribeSuccessResponse];

            expect(testCompletionHandler1Called).to(beTrue());
            expect(testCompletionHandler1Error).to(beNil());
            expect(testCompletionHandler2Called).to(beTrue());
            expect(testCompletionHandler2Error).to(beNil());

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers).to(beEmpty());

            expect(testConnectionManager.receivedRequests.count).to(equal(2));
            expect(testConnectionManager.receivedRequests[1]).to(beAKindOf(SDLUnsubscribeButton.class));
        });

        it(@"should notify the observer with the error when a failure response is received for the unsubscribe button request and it should not remove the observer", ^{
            id subscriptionID1 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

            [testManager unsubscribeButton:testButtonName withObserver:subscriptionID1 withCompletionHandler:testCompletionHandler1];
            NSError *testError = [NSError errorWithDomain:@"errorDomain" code:9 userInfo:@{@"subscribe button error":@"error 2"}];
            [testConnectionManager respondToLastRequestWithResponse:testUnSubscribeFailureResponse error:testError];

            expect(testCompletionHandler1Called).to(beTrue());
            expect(testCompletionHandler1Error).to(equal(testError));

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers.count).to(equal(1));
            expect((id)observers[0].updateBlock).to(equal((id)testUpdateHandler1));

            expect(testConnectionManager.receivedRequests.count).to(equal(2));
            expect(testConnectionManager.receivedRequests[1]).to(beAKindOf(SDLUnsubscribeButton.class));
        });

        it(@"should return an error if the observer is not subscribed to the button", ^{
            [testManager unsubscribeButton:testButtonName withObserver:[[NSObject alloc] init] withCompletionHandler:testCompletionHandler1];

            expect(testCompletionHandler1Called).to(beTrue());
            expect(testCompletionHandler1Error).to(equal([NSError sdl_subscribeButtonManager_notSubscribed]));

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers).to(beNil());
            expect(testConnectionManager.receivedRequests).to(beEmpty());
        });
    });

    describe(@"should unsubscribe with an observer and selector", ^{
        __block SDLButtonName testButtonName = nil;

        __block TestSubscribeButtonObserver *testSubscribeButtonObserver1 = nil;
        __block SEL testSelector1 = @selector(buttonPressEvent);
        __block SDLSubscribeButtonUpdateCompletionHandler testCompletionHandler1 = nil;
        __block BOOL testCompletionHandler1Called = NO;
        __block NSError *testCompletionHandler1Error = nil;

        __block TestSubscribeButtonObserver *testSubscribeButtonObserver2 = nil;
        __block SEL testSelector2 = @selector(buttonPressEvent);
        __block SDLSubscribeButtonUpdateCompletionHandler testCompletionHandler2 = nil;
        __block BOOL testCompletionHandler2Called = NO;
        __block NSError *testCompletionHandler2Error = nil;

        beforeEach(^{
            testButtonName = SDLButtonNamePlayPause;

            testSubscribeButtonObserver1 = [[TestSubscribeButtonObserver alloc] init];
            testCompletionHandler1 = ^(NSError *__nullable error) {
                testCompletionHandler1Called = YES;
                testCompletionHandler1Error = error;
            };
            testSelector1 = @selector(buttonPressEvent);
            testCompletionHandler1Called = NO;
            testCompletionHandler2Error = nil;

            testSubscribeButtonObserver2 = [[TestSubscribeButtonObserver alloc] init];
            testSelector2 = @selector(buttonPressEventWithButtonName:error:);
            testCompletionHandler2 = ^(NSError *__nullable error) {
                testCompletionHandler2Called = YES;
                testCompletionHandler2Error = error;
            };
            testCompletionHandler2Called = NO;
            testCompletionHandler2Error = nil;
        });

        it(@"should unsubscribe the observer if there are multiple observers subscribed to the button", ^{
            [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 selector:testSelector1];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];
            [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver2 selector:testSelector2];

            [testManager unsubscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 withCompletionHandler:testCompletionHandler1];

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers.count).to(equal(1));
            expect(NSStringFromSelector(observers[0].selector)).to(equal(NSStringFromSelector(testSelector2)));
            expect((id)observers[0].observer).to(equal((id)testSubscribeButtonObserver2));

            expect(testCompletionHandler1Called).to(beTrue());
            expect(testCompletionHandler2Called).to(beFalse());

            expect(testConnectionManager.receivedRequests.count).to(equal(1));
            expect(testConnectionManager.receivedRequests.firstObject).to(beAKindOf(SDLSubscribeButton.class));
        });

        it(@"should send an unsubscribe button request when the last observer is removed and it should notify the observer that the unsubscribe request succeeded", ^{
            [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 selector:testSelector1];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];
            [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver2 selector:testSelector2];

            [testManager unsubscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 withCompletionHandler:testCompletionHandler1];
            [testManager unsubscribeButton:testButtonName withObserver:testSubscribeButtonObserver2 withCompletionHandler:testCompletionHandler2];
            [testConnectionManager respondToLastRequestWithResponse:testUnSubscribeSuccessResponse];

            expect(testCompletionHandler1Called).to(beTrue());
            expect(testCompletionHandler1Error).to(beNil());
            expect(testCompletionHandler2Called).to(beTrue());
            expect(testCompletionHandler2Error).to(beNil());

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers).to(beEmpty());

            expect(testConnectionManager.receivedRequests.count).to(equal(2));
            expect(testConnectionManager.receivedRequests[1]).to(beAKindOf(SDLUnsubscribeButton.class));
        });

        it(@"should notify the observer with the error when a failure response is received for the unsubscribe button request and it should not remove the observer", ^{
            [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 selector:testSelector1];
            [testConnectionManager respondToLastRequestWithResponse:testSubscribeSuccessResponse];

            [testManager unsubscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 withCompletionHandler:testCompletionHandler1];
            NSError *testError = [NSError errorWithDomain:@"errorDomain" code:9 userInfo:@{@"subscribe button error":@"error 2"}];
            [testConnectionManager respondToLastRequestWithResponse:testUnSubscribeFailureResponse error:testError];

            expect(testCompletionHandler1Called).to(beTrue());
            expect(testCompletionHandler1Error).to(equal(testError));

            NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
            expect(observers.count).to(equal(1));
            expect(NSStringFromSelector(observers[0].selector)).to(equal(NSStringFromSelector(testSelector1)));

            expect(testConnectionManager.receivedRequests.count).to(equal(2));
            expect([testConnectionManager.receivedRequests[1] isKindOfClass:SDLUnsubscribeButton.class]);
        });
    });
});

QuickSpecEnd
