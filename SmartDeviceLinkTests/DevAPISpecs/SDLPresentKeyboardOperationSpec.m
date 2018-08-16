#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLPresentKeyboardOperation.h"

#import "SDLKeyboardDelegate.h"
#import "SDLOnKeyboardInput.h"
#import "SDLKeyboardProperties.h"
#import "SDLPerformInteraction.h"
#import "SDLPerformInteractionResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSetGlobalProperties.h"
#import "SDLSetGlobalPropertiesResponse.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLPresentKeyboardOperationSpec)

describe(@"present keyboard operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLPresentKeyboardOperation *testOp = nil;

    __block NSString *testInitialText = @"Initial Text";
    __block id<SDLKeyboardDelegate> testDelegate = nil;
    __block SDLKeyboardProperties *testInitialProperties = nil;

    __block BOOL hasCalledOperationCompletionHandler = NO;
    __block NSError *resultError = nil;

    beforeEach(^{
        resultError = nil;
        hasCalledOperationCompletionHandler = NO;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testDelegate = OCMProtocolMock(@protocol(SDLKeyboardDelegate));
        OCMStub([testDelegate customKeyboardConfiguration]).andReturn(nil);

        testInitialProperties = [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageArSa layout:SDLKeyboardLayoutAZERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteText:nil];
    });

    it(@"should have a priority of 'normal'", ^{
        testOp = [[SDLPresentKeyboardOperation alloc] init];

        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    describe(@"running the operation", ^{
        beforeEach(^{
            testOp = [[SDLPresentKeyboardOperation alloc] initWithConnectionManager:testConnectionManager keyboardProperties:testInitialProperties initialText:testInitialText keyboardDelegate:testDelegate];
            testOp.completionBlock = ^{
                hasCalledOperationCompletionHandler = YES;
            };
            [testOp start];
        });

        it(@"should ask for custom properties", ^{
            OCMVerify([testDelegate customKeyboardConfiguration]);
        });

        it(@"should update global keyboard properties", ^{
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLSetGlobalProperties class]));
        });

        describe(@"presenting the keyboard", ^{
            beforeEach(^{
                SDLSetGlobalPropertiesResponse *response = [[SDLSetGlobalPropertiesResponse alloc] init];
                response.success = @YES;
                [testConnectionManager respondToLastRequestWithResponse:response];
            });

            it(@"should send the perform interaction", ^{
                expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLPerformInteraction class]));
                SDLPerformInteraction *request = testConnectionManager.receivedRequests.lastObject;
                expect(request.initialText).to(equal(testInitialText));
                expect(request.interactionMode).to(equal(SDLInteractionModeManualOnly));
                expect(request.interactionChoiceSetIDList).to(beEmpty());
                expect(request.interactionLayout).to(equal(SDLLayoutModeKeyboard));
            });

            it(@"should respond to submitted notifications", ^{
                NSString *inputData = @"Test";
                SDLRPCNotificationNotification *notification = nil;

                // Submit notification
                SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                input.event = SDLKeyboardEventSubmitted;
                input.data = inputData;
                notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                [[NSNotificationCenter defaultCenter] postNotification:notification];

                OCMVerify([testDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventSubmitted];
                }] text:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(NSString *)obj isEqualToString:inputData];
                }]]);

                OCMVerify([testDelegate userDidSubmitInput:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(NSString *)obj isEqualToString:inputData];
                }] withEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventSubmitted];
                }]]);
            });

            it(@"should respond to voice request notifications", ^{
                SDLRPCNotificationNotification *notification = nil;

                // Submit notification
                SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                input.event = SDLKeyboardEventVoice;
                notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                [[NSNotificationCenter defaultCenter] postNotification:notification];

                OCMVerify([testDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventVoice];
                }] text:[OCMArg isNil]]);

                OCMVerify([testDelegate userDidSubmitInput:[OCMArg isNil] withEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventVoice];
                }]]);
            });

            it(@"should respond to abort notifications", ^{
                SDLRPCNotificationNotification *notification = nil;

                // Submit notification
                SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                input.event = SDLKeyboardEventAborted;
                notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                [[NSNotificationCenter defaultCenter] postNotification:notification];

                OCMVerify([testDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventAborted];
                }] text:[OCMArg isNil]]);

                OCMVerify([testDelegate keyboardDidAbortWithReason:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventAborted];
                }]]);
            });

            it(@"should respond to cancellation notifications", ^{
                SDLRPCNotificationNotification *notification = nil;

                // Submit notification
                SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                input.event = SDLKeyboardEventCancelled;
                notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                [[NSNotificationCenter defaultCenter] postNotification:notification];

                OCMVerify([testDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventCancelled];
                }] text:[OCMArg isNil]]);

                OCMVerify([testDelegate keyboardDidAbortWithReason:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventCancelled];
                }]]);
            });

            it(@"should respond to text input notification with autocomplete", ^{
                NSString *inputData = @"Test";
                SDLRPCNotificationNotification *notification = nil;

                OCMStub([testDelegate updateAutocompleteWithInput:[OCMArg any] completionHandler:([OCMArg invokeBlockWithArgs:inputData, nil])]);

                // Submit notification
                SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                input.event = SDLKeyboardEventKeypress;
                input.data = inputData;
                notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                [[NSNotificationCenter defaultCenter] postNotification:notification];

                OCMVerify([testDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventKeypress];
                }] text:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(NSString *)obj isEqualToString:inputData];
                }]]);

                OCMVerify([testDelegate updateAutocompleteWithInput:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(NSString *)obj isEqualToString:inputData];
                }] completionHandler:[OCMArg any]]);

                expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLSetGlobalProperties class]));

                SDLSetGlobalProperties *setProperties = testConnectionManager.receivedRequests.lastObject;
                expect(setProperties.keyboardProperties.autoCompleteText).to(equal(inputData));
            });

            it(@"should respond to text input notification with character set", ^{
                NSString *inputData = @"Test";
                SDLRPCNotificationNotification *notification = nil;

                OCMStub([testDelegate updateCharacterSetWithInput:[OCMArg any] completionHandler:([OCMArg invokeBlockWithArgs:@[inputData], nil])]);

                // Submit notification
                SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                input.event = SDLKeyboardEventKeypress;
                input.data = inputData;
                notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                [[NSNotificationCenter defaultCenter] postNotification:notification];

                OCMVerify([testDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventKeypress];
                }] text:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(NSString *)obj isEqualToString:inputData];
                }]]);

                OCMVerify([testDelegate updateCharacterSetWithInput:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(NSString *)obj isEqualToString:inputData];
                }] completionHandler:[OCMArg any]]);

                expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLSetGlobalProperties class]));

                SDLSetGlobalProperties *setProperties = testConnectionManager.receivedRequests.lastObject;
                expect(setProperties.keyboardProperties.limitedCharacterList).to(equal(@[inputData]));
            });

            describe(@"after a perform interaction response", ^{
                beforeEach(^{
                    SDLPerformInteractionResponse *response = [[SDLPerformInteractionResponse alloc] init];
                    response.success = @YES;

                    [testConnectionManager respondToLastRequestWithResponse:response];
                });

                it(@"should reset the keyboard properties", ^{
                    expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLSetGlobalProperties class]));
                });

                describe(@"after the reset response", ^{
                    beforeEach(^{
                        SDLSetGlobalPropertiesResponse *response = [[SDLSetGlobalPropertiesResponse alloc] init];
                        response.success = @YES;
                        [testConnectionManager respondToLastRequestWithResponse:response];
                    });

                    it(@"should be finished", ^{
                        expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                        expect(testOp.isFinished).to(beTrue());
                    });
                });
            });
        });
    });
});

QuickSpecEnd
