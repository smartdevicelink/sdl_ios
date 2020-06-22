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

#import "SDLOnButtonEvent.h"
#import "SDLOnButtonPress.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSubscribeButtonManager.h"
#import "SDLSubscribeButtonObserver.h"
#import "SDLSubscribeButtonResponse.h"
#import "SDLSubscribebutton.h"
#import "SDLUnsubscribeButton.h"
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

    context(@"lifecycle", ^{
        beforeEach(^{
            testConnectionManager = [[TestConnectionManager alloc] init];
            testManager = [[SDLSubscribeButtonManager alloc] initWithConnectionManager:testConnectionManager];
        });

        it(@"should instantiate correctly with initWithConnectionManager:", ^{
            expect(testManager.connectionManager).to(equal(testConnectionManager));
            expect(testManager.subscribeButtonObservers).toNot(beNil());
        });

        it(@"should do nothing when Start is called", ^{
            [testManager start];
        });

        it(@"should clear the list of observers when Stop is called", ^{
            [testManager stop];
            expect(testManager.subscribeButtonObservers.count).to(equal(0));
        });
    });

    context(@"subscriptions", ^{
        beforeEach(^{
            testConnectionManager = [[TestConnectionManager alloc] init];
            testManager = [[SDLSubscribeButtonManager alloc] initWithConnectionManager:testConnectionManager];
            [testManager start];
        });

        describe(@"should subscribe with an update handler", ^{
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
                SDLSubscribeButtonUpdateHandler testUpdateHandler2 = ^(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error) {};
                id subscriptionID1 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];
                id subscriptionID2 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler2];
                expect(subscriptionID1).toNot(beNil());
                expect(subscriptionID2).toNot(beNil());

                NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
                expect(observers.count).to(equal(2));
                expect((id)observers[0].updateBlock).to(equal((id)testUpdateHandler1));
                expect((id)observers[1].updateBlock).to(equal((id)testUpdateHandler2));

                expect(testConnectionManager.receivedRequests.count).to(equal(1));
                expect([testConnectionManager.receivedRequests[0] isKindOfClass:SDLSubscribeButton.class]);
            });

            it(@"should not notify the observer when a success response is recieved for the subscribe button request", ^{
                [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];

                SDLSubscribeButtonResponse *testSuccessResponse = [[SDLSubscribeButtonResponse alloc] init];
                testSuccessResponse.success = @YES;
                testSuccessResponse.info = @"test info";

                [testConnectionManager respondToLastRequestWithResponse:testSuccessResponse];

                expect(testHandler1Called).to(beFalse());
            });

            it(@"should notify the observer with the error when a failure response is recieved for the subscribe button request", ^{
                [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];

                SDLSubscribeButtonResponse *testFailureResponse = [[SDLSubscribeButtonResponse alloc] init];
                testFailureResponse.success = @NO;
                testFailureResponse.info = @"test info";

                NSError *testError = [NSError errorWithDomain:@"errorDomain" code:9 userInfo:@{@"subscribe button error":@"error 2"}];

                [testConnectionManager respondToLastRequestWithResponse:testFailureResponse error:testError];

                expect(testHandler1Called).to(beTrue());
                expect(testHandle1Error).to(equal(testError));
            });
        });

        describe(@"should subscribe with an observer/selector", ^{
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

                NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
                expect(observers.count).to(equal(1));
                expect(NSStringFromSelector(observers[0].selector)).to(equal(NSStringFromSelector(testSelector1)));

                expect(testConnectionManager.receivedRequests.count).to(equal(1));
                expect([testConnectionManager.receivedRequests[0] isKindOfClass:SDLSubscribeButton.class]);
            });

            it(@"should not send a subscription request to the module if adding a subsequent observer for that button name", ^{
                [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 selector:testSelector1];
                [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver2 selector:testSelector2];

                NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
                expect(observers.count).to(equal(2));
                expect(NSStringFromSelector(observers[0].selector)).to(equal(NSStringFromSelector(testSelector1)));
                expect(NSStringFromSelector(observers[1].selector)).to(equal(NSStringFromSelector(testSelector2)));

                expect(testConnectionManager.receivedRequests.count).to(equal(1));
                expect([testConnectionManager.receivedRequests[0] isKindOfClass:SDLSubscribeButton.class]);
            });

            it(@"should not notify the observer when a success response is recieved for the subscribe button request", ^{
                [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 selector:testSelector1];

                SDLSubscribeButtonResponse *testSuccessResponse = [[SDLSubscribeButtonResponse alloc] init];
                testSuccessResponse.success = @YES;
                testSuccessResponse.info = @"test info";

                [testConnectionManager respondToLastRequestWithResponse:testSuccessResponse];

                expect(testSubscribeButtonObserver1.selectorCalledCount).to(equal(0));
            });

            it(@"should notify the observer with the error when a failure response is recieved for the subscribe button request", ^{
                [testManager subscribeButton:testButtonName withObserver:testSubscribeButtonObserver1 selector:testSelector2];

                SDLSubscribeButtonResponse *testFailureResponse = [[SDLSubscribeButtonResponse alloc] init];
                testFailureResponse.success = @NO;
                testFailureResponse.info = @"test info";

                NSError *testError = [NSError errorWithDomain:@"errorDomain" code:9 userInfo:@{@"subscribe button error":@"error 2"}];

                [testConnectionManager respondToLastRequestWithResponse:testFailureResponse error:testError];

                expect(testSubscribeButtonObserver1.selectorCalledCount).to(equal(1));
                expect(testSubscribeButtonObserver1.buttonErrorsReceived.count).to(equal(1));
                expect(testSubscribeButtonObserver1.buttonErrorsReceived[0]).to(equal(testError));
                expect(testSubscribeButtonObserver1.buttonNamesReceived[0]).to(equal(testButtonName));
            });
        });

        describe(@"notifing subscribers of button events", ^{
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

            __block TestSubscribeButtonObserver *testObserver1 = nil;
            __block SEL testSelector1 = @selector(buttonPressEvent);

            __block TestSubscribeButtonObserver *testObserver2 = nil;
            __block SEL testSelector2 = @selector(buttonPressEvent);

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

                testObserver1 = [[TestSubscribeButtonObserver alloc] init];
                testSelector1 = @selector(buttonPressEventWithButtonName:error:buttonPress:buttonEvent:);

                testObserver2 = [[TestSubscribeButtonObserver alloc] init];
                testSelector2 = @selector(buttonPressEventWithButtonName:error:buttonPress:buttonEvent:);

                [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];
                [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler2];
                [testManager subscribeButton:testButtonName withObserver:testObserver1 selector:testSelector1];
                [testManager subscribeButton:testButtonName withObserver:testObserver2 selector:testSelector2];
            });

            it(@"should notify all observers when a button press notification is recieved", ^{
                SDLOnButtonEvent *testButtonEvent = [[SDLOnButtonEvent alloc] init];
                testButtonEvent.buttonEventMode = SDLButtonEventModeButtonUp;
                testButtonEvent.buttonName = testButtonName;

                SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
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

            it(@"should notify all observers when a button event notification is recieved", ^{
                SDLOnButtonPress *testButtonPress = [[SDLOnButtonPress alloc] init];
                testButtonPress.buttonPressMode = SDLButtonPressModeLong;
                testButtonPress.buttonName = testButtonName;

                SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];
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

                testUpdateHandler2 = ^(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error) {};
                testCompletionHandler2 = ^(NSError *__nullable error) {
                    testCompletionHandler2Called = YES;
                    testCompletionHandler2Error = error;
                };
            });

            it(@"should unsubscribe the observer if there are multiple observers subscribed to the button", ^{
                id subscriptionID1 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];
                id subscriptionID2 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler2];

                [testManager unsubscribeButton:testButtonName withObserver:subscriptionID1 withCompletionHandler:testCompletionHandler1];

                NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
                expect(observers.count).to(equal(1));
                expect((id)observers[0].updateBlock).to(equal((id)testUpdateHandler2));

                expect(testCompletionHandler1Called).to(beTrue());
                expect(testCompletionHandler2Called).to(beFalse());

                expect(testConnectionManager.receivedRequests.count).to(equal(1));
                for (SDLRPCMessage *request in testConnectionManager.receivedRequests) {
                    expect([request isKindOfClass:SDLUnsubscribeButton.class]).to(beFalse());
                }
            });


            it(@"should unsubscribe observers and send an unsubscribe request when the last observer is removed", ^{
//                SDLSubscribeButtonUpdateHandler testUpdateHandler2 = ^(SDLOnButtonPress *_Nullable buttonPress, SDLOnButtonEvent *_Nullable buttonEvent, NSError *_Nullable error) {};
//                id subscriptionID1 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler1];
//                id subscriptionID2 = [testManager subscribeButton:testButtonName withUpdateHandler:testUpdateHandler2];
//
//                [testManager unsubscribeButton:testButtonName withObserver:subscriptionID1 withCompletionHandler:testCompletionHandler1];
//                [testManager unsubscribeButton:testButtonName withObserver:subscriptionID2 withCompletionHandler:testCompletionHandler2];
//
//                NSArray<SDLSubscribeButtonObserver *> *observers = testManager.subscribeButtonObservers[testButtonName];
//                expect(observers).to(beEmpty());
//
//                expect(testCompletionHandler1Called).to(beTrue());
//                expect(testCompletionHandler2Called).to(beTrue());
//
//                expect(testConnectionManager.receivedRequests.count).to(equal(1));
//                expect([testConnectionManager.receivedRequests[0] isKindOfClass:SDLUnsubscribeButton.class]);
            });
        });

        describe(@"should unsubscribe with an observer/selector", ^{
            beforeEach(^{

            });
        });
    });
});

QuickSpecEnd

