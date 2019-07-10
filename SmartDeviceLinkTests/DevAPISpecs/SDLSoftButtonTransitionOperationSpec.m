#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLSoftButtonTransitionOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLFileManager.h"
#import "SDLLogMacros.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLShow.h"
#import "SDLShowResponse.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLSoftButtonTransitionOperationSpec)

describe(@"a soft button transition operation", ^{
    __block SDLSoftButtonTransitionOperation *testOp = nil;

    __block TestConnectionManager *testConnectionManager = nil;

    __block BOOL hasCalledOperationCompletionHandler = NO;
    __block NSError *resultError = nil;

    __block NSArray<SDLSoftButtonObject *> *testSoftButtonObjects = nil;
    __block NSString *button1Text = @"Text text 1";
    __block NSString *button2Text = @"Text text 2";
    __block NSString *testMainField1 = @"Test 1";

    beforeEach(^{
        resultError = nil;
        hasCalledOperationCompletionHandler = NO;

        testConnectionManager = [[TestConnectionManager alloc] init];

        SDLSoftButtonState *object1State1 = [[SDLSoftButtonState alloc] initWithStateName:@"State 1" text:button1Text artwork:nil];
        SDLSoftButtonObject *button1 = [[SDLSoftButtonObject alloc] initWithName:@"Button 1" state:object1State1 handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        SDLSoftButtonState *object2State1 = [[SDLSoftButtonState alloc] initWithStateName:@"State 2" text:button2Text image:nil];
        SDLSoftButtonObject *button2 = [[SDLSoftButtonObject alloc] initWithName:@"Button 2" state:object2State1 handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        testSoftButtonObjects = @[button1, button2];
    });

    it(@"should have a priority of 'normal'", ^{
        testOp = [[SDLSoftButtonTransitionOperation alloc] init];

        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    describe(@"running the operation", ^{
        beforeEach(^{
            SDLSoftButtonCapabilities *capabilities = [[SDLSoftButtonCapabilities alloc] init];
            capabilities.imageSupported = @YES;

            testOp = [[SDLSoftButtonTransitionOperation alloc] initWithConnectionManager:testConnectionManager capabilities:capabilities softButtons:testSoftButtonObjects mainField1:testMainField1];
            [testOp start];
        });

        it(@"should send the correct RPCs", ^{
            NSArray<SDLShow *> *sentRequests = testConnectionManager.receivedRequests;
            expect(sentRequests).to(haveCount(1));
            expect(sentRequests.firstObject.mainField1).to(equal(testMainField1));
            expect(sentRequests.firstObject.mainField2).to(beNil());
            expect(sentRequests.firstObject.softButtons).to(haveCount(2));
            expect(sentRequests.firstObject.softButtons.firstObject.text).to(equal(button1Text));
            expect(sentRequests.firstObject.softButtons.firstObject.image).to(beNil());
            expect(sentRequests.firstObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeText));
            expect(sentRequests.firstObject.softButtons.lastObject.text).to(equal(button2Text));
            expect(sentRequests.firstObject.softButtons.lastObject.image).to(beNil());
            expect(sentRequests.firstObject.softButtons.lastObject.type).to(equal(SDLSoftButtonTypeText));
        });

        context(@"if it returns correctly", ^{
            beforeEach(^{
                SDLShowResponse *response = [[SDLShowResponse alloc] init];
                response.success = @YES;

                [testConnectionManager respondToLastRequestWithResponse:response];
            });

            it(@"should finish the operation", ^{
                expect(testOp.isFinished).to(beTrue());
                expect(testOp.error).to(beNil());
            });
        });

        context(@"if it returns an error", ^{
            beforeEach(^{
                SDLShowResponse *response = [[SDLShowResponse alloc] init];
                response.success = @NO;

                [testConnectionManager respondToLastRequestWithResponse:response];
            });

            it(@"should finish the operation", ^{
                expect(testOp.isFinished).to(beTrue());
                expect(testOp.error).toNot(beNil());
            });
        });
    });
});

QuickSpecEnd
