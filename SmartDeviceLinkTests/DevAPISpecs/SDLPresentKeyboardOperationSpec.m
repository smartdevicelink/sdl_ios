#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLPresentKeyboardOperation.h"

#import "SDLCancelInteraction.h"
#import "SDLCancelInteractionResponse.h"
#import "SDLError.h"
#import "SDLFunctionID.h"
#import "SDLGlobals.h"
#import "SDLKeyboardDelegate.h"
#import "SDLKeyboardProperties.h"
#import "SDLOnKeyboardInput.h"
#import "SDLPerformInteraction.h"
#import "SDLPerformInteractionResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSetGlobalProperties.h"
#import "SDLSetGlobalPropertiesResponse.h"
#import "TestConnectionManager.h"
#import "SDLVersion.h"

QuickSpecBegin(SDLPresentKeyboardOperationSpec)

describe(@"present keyboard operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLPresentKeyboardOperation *testOp = nil;

    __block NSString *testInitialText = @"Initial Text";
    __block id<SDLKeyboardDelegate> testDelegate = nil;
    __block SDLKeyboardProperties *testInitialProperties = nil;
    __block int testCancelID = 256;

    __block BOOL hasCalledOperationCompletionHandler = NO;
    __block NSError *resultError = nil;
    __block SDLWindowCapability *windowCapability = nil;

    beforeEach(^{
        testOp = nil;
        resultError = nil;
        hasCalledOperationCompletionHandler = NO;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testDelegate = OCMProtocolMock(@protocol(SDLKeyboardDelegate));
        OCMStub([testDelegate customKeyboardConfiguration]).andReturn(nil);

        windowCapability = [[SDLWindowCapability alloc] init];
        testInitialProperties = [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageArSa keyboardLayout:SDLKeyboardLayoutAZERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteList:nil maskInputCharacters:nil customKeys:nil];
    });

    afterEach(^{
        if (testOp) {
            // rationale: every test run creates a new operation to test, the old operation from a previous test
            // stays 'undead' undefined time and can receive notifications causing a test fail at random
            [[NSNotificationCenter defaultCenter] removeObserver:testOp];
            testOp = nil;
        }
    });

    it(@"should have a priority of 'normal'", ^{
        testOp = [[SDLPresentKeyboardOperation alloc] init];

        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    describe(@"running the operation", ^{
        beforeEach(^{
            testOp = [[SDLPresentKeyboardOperation alloc] initWithConnectionManager:testConnectionManager keyboardProperties:testInitialProperties initialText:testInitialText keyboardDelegate:testDelegate cancelID:testCancelID windowCapability:windowCapability];
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

            it(@"should respond to enabled keyboard event", ^{
                SDLRPCNotificationNotification *notification = nil;

                // Submit notification
                SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                input.event = SDLKeyboardEventInputKeyMaskEnabled;
                notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                [[NSNotificationCenter defaultCenter] postNotification:notification];

                OCMVerify([testDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventInputKeyMaskEnabled];
                }] text:[OCMArg isNil]]);

                OCMVerify([testDelegate keyboardDidUpdateInputMask:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventInputKeyMaskEnabled];
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

                OCMStub([testDelegate updateAutocompleteWithInput:[OCMArg any] autoCompleteResultsHandler:([OCMArg invokeBlockWithArgs:@[inputData], nil])]);

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
                }] autoCompleteResultsHandler:[OCMArg any]]);

                expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLSetGlobalProperties class]));

                SDLSetGlobalProperties *setProperties = testConnectionManager.receivedRequests.lastObject;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                expect(setProperties.keyboardProperties.autoCompleteText).to(equal(inputData));
#pragma clang diagnostic pop
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

    describe(@"Canceling the keyboard", ^{
        beforeEach(^{
            testOp = [[SDLPresentKeyboardOperation alloc] initWithConnectionManager:testConnectionManager keyboardProperties:testInitialProperties initialText:testInitialText keyboardDelegate:testDelegate cancelID:testCancelID windowCapability:windowCapability];
            testOp.completionBlock = ^{
                hasCalledOperationCompletionHandler = YES;
            };
        });

        context(@"If the operation is executing", ^{
            beforeEach(^{
                SDLVersion *supportedVersion = [SDLVersion versionWithMajor:6 minor:0 patch:0];
                id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                OCMStub([globalMock rpcVersion]).andReturn(supportedVersion);

                [testOp start];

                expect(testOp.isExecuting).to(beTrue());
                expect(testOp.isFinished).to(beFalse());
                expect(testOp.isCancelled).to(beFalse());

                [testOp dismissKeyboard];
            });

            it(@"should attempt to send a cancel interaction", ^{
                SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                expect(lastRequest).to(beAnInstanceOf([SDLCancelInteraction class]));
                expect(lastRequest.cancelID).to(equal(testCancelID));
                expect(lastRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNamePerformInteraction]));
            });

            context(@"If the cancel interaction was successful", ^{
                beforeEach(^{
                    SDLCancelInteractionResponse *testCancelInteractionResponse = [[SDLCancelInteractionResponse alloc] init];
                    testCancelInteractionResponse.success = @YES;
                    [testConnectionManager respondToLastRequestWithResponse:testCancelInteractionResponse];

                    SDLSetGlobalPropertiesResponse *response = [[SDLSetGlobalPropertiesResponse alloc] init];
                    response.success = @YES;
                    [testConnectionManager respondToLastRequestWithResponse:response];
                });

                it(@"should not error", ^{
                    expect(testOp.error).to(beNil());
                });

                it(@"should not finish", ^{
                    expect(hasCalledOperationCompletionHandler).to(beFalse());
                    expect(testOp.isExecuting).to(beTrue());
                    expect(testOp.isFinished).to(beFalse());
                    expect(testOp.isCancelled).to(beFalse());
                });
            });

            context(@"If the cancel interaction was not successful", ^{
                __block NSError *testError = [NSError sdl_lifecycle_notConnectedError];

                beforeEach(^{
                    SDLCancelInteractionResponse *testCancelInteractionResponse = [[SDLCancelInteractionResponse alloc] init];
                    testCancelInteractionResponse.success = @NO;
                    [testConnectionManager respondToLastRequestWithResponse:testCancelInteractionResponse error:testError];

                    SDLSetGlobalPropertiesResponse *response = [[SDLSetGlobalPropertiesResponse alloc] init];
                    response.success = @YES;
                    [testConnectionManager respondToLastRequestWithResponse:response];
                });

                it(@"should error", ^{
                    expect(testOp.error).to(equal(testError));
                });

                it(@"should not finish", ^{
                    expect(hasCalledOperationCompletionHandler).toEventually(beFalse());
                    expect(testOp.isExecuting).toEventually(beTrue());
                    expect(testOp.isFinished).toEventually(beFalse());
                    expect(testOp.isCancelled).toEventually(beFalse());
                });
            });
        });

        context(@"The head unit does not support the `CancelInteraction` RPC", ^{
            beforeEach(^{
                SDLVersion *unsupportedVersion = [SDLVersion versionWithMajor:4 minor:5 patch:2];
                id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                OCMStub([globalMock rpcVersion]).andReturn(unsupportedVersion);
            });

            it(@"should not attempt to send a cancel interaction if the operation is executing", ^{
                [testOp start];

                expect(testOp.isExecuting).to(beTrue());
                expect(testOp.isFinished).to(beFalse());
                expect(testOp.isCancelled).to(beFalse());

                [testOp dismissKeyboard];

                SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                expect(lastRequest).toNot(beAnInstanceOf([SDLCancelInteraction class]));
            });

            it(@"should cancel the operation if it has not yet been run", ^{
                expect(testOp.isExecuting).to(beFalse());
                expect(testOp.isFinished).to(beFalse());
                expect(testOp.isCancelled).to(beFalse());

                [testOp dismissKeyboard];

                SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                expect(lastRequest).to(beNil());

                expect(testOp.isExecuting).to(beFalse());
                expect(testOp.isFinished).to(beFalse());
                expect(testOp.isCancelled).to(beTrue());
            });
        });

        context(@"If the operation has already finished", ^{
            beforeEach(^{
                [testOp start];
                [testOp finishOperation];

                SDLSetGlobalPropertiesResponse *response = [[SDLSetGlobalPropertiesResponse alloc] init];
                response.success = @YES;
                [testConnectionManager respondToLastRequestWithResponse:response];

                [testOp dismissKeyboard];
            });

            it(@"should not attempt to send a cancel interaction", ^{
                expect(testOp.isExecuting).to(beFalse());
                expect(testOp.isFinished).to(beTrue());
                expect(testOp.isCancelled).to(beFalse());

                SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                expect(lastRequest).toNot(beAnInstanceOf([SDLCancelInteraction class]));
            });
        });

        context(@"If the started operation has been canceled", ^{
            beforeEach(^{
                [testOp start];
                [testOp cancel];

                [testOp dismissKeyboard];
            });

            it(@"should not finish or send a cancel interaction", ^{
                SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                expect(lastRequest).toNot(beAnInstanceOf([SDLCancelInteraction class]));

                expect(hasCalledOperationCompletionHandler).to(beFalse());
                expect(testOp.isExecuting).to(beTrue());
                expect(testOp.isFinished).to(beFalse());
                expect(testOp.isCancelled).to(beTrue());
            });
        });

        context(@"If the operation has not started", ^{
            beforeEach(^{
                [testOp dismissKeyboard];
            });

            it(@"should not attempt to send a cancel interaction", ^{
                expect(testOp.isExecuting).to(beFalse());
                expect(testOp.isFinished).to(beFalse());
                expect(testOp.isCancelled).to(beTrue());

                SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                expect(lastRequest).to(beNil());
            });

            context(@"Once the operation has started", ^{
                beforeEach(^{
                    [testOp start];
                });

                it(@"should not attempt to send a cancel interaction but should finish", ^{
                    expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                    expect(testOp.isExecuting).toEventually(beFalse());
                    expect(testOp.isFinished).toEventually(beTrue());
                    expect(testOp.isCancelled).toEventually(beTrue());

                    SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                    expect(lastRequest).to(beNil());
                });
            });
        });
    });
});

QuickSpecEnd
