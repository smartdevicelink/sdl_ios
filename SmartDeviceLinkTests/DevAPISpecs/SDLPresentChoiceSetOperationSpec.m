#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLPresentChoiceSetOperation.h"

#import "SDLCancelInteraction.h"
#import "SDLCancelInteractionResponse.h"
#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLChoiceSetDelegate.h"
#import "SDLError.h"
#import "SDLFunctionID.h"
#import "SDLKeyboardDelegate.h"
#import "SDLOnKeyboardInput.h"
#import "SDLKeyboardProperties.h"
#import "SDLPerformInteraction.h"
#import "SDLPerformInteractionResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLGlobals.h"
#import "SDLSetGlobalProperties.h"
#import "SDLSetGlobalPropertiesResponse.h"
#import "SDLVersion.h"
#import "TestConnectionManager.h"

@interface SDLChoiceSet()

@property (nullable, copy, nonatomic) SDLChoiceSetCanceledHandler canceledHandler;

@end

QuickSpecBegin(SDLPresentChoiceSetOperationSpec)

describe(@"present choice operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLPresentChoiceSetOperation *testOp = nil;

    __block SDLInteractionMode testInteractionMode = SDLInteractionModeBoth;
    __block SDLChoiceSet *testChoiceSet = nil;
    __block id<SDLChoiceSetDelegate> testChoiceDelegate = nil;
    __block NSArray<SDLChoiceCell *> *testChoices = nil;
    __block int testCancelID = 98;

    __block id<SDLKeyboardDelegate> testKeyboardDelegate = nil;
    __block SDLKeyboardProperties *testKeyboardProperties = nil;

    __block BOOL hasCalledOperationCompletionHandler = NO;
    __block NSError *resultError = nil;
    __block SDLWindowCapability *windowCapability = nil;

    beforeEach(^{
        resultError = nil;
        hasCalledOperationCompletionHandler = NO;

        testConnectionManager = [[TestConnectionManager alloc] init];

        testChoiceDelegate = OCMProtocolMock(@protocol(SDLChoiceSetDelegate));
        SDLChoiceCell *cell1 = [[SDLChoiceCell alloc] initWithText:@"Cell 1"];
        testChoices = @[cell1];
        testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:@"Test Title" delegate:testChoiceDelegate layout:SDLChoiceSetLayoutTiles timeout:13 initialPromptString:@"Test initial prompt" timeoutPromptString:@"Test timeout prompt" helpPromptString:@"Test help prompt" vrHelpList:nil choices:testChoices];

        windowCapability = [[SDLWindowCapability alloc] init];
        testKeyboardDelegate = OCMProtocolMock(@protocol(SDLKeyboardDelegate));
        OCMStub([testKeyboardDelegate customKeyboardConfiguration]).andReturn(nil);
        testKeyboardProperties = [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageArSa keyboardLayout:SDLKeyboardLayoutAZERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteList:nil maskInputCharacters:nil customKeys:nil];
    });

    it(@"should have a priority of 'normal'", ^{
        testOp = [[SDLPresentChoiceSetOperation alloc] init];

        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    describe(@"running a non-searchable choice set operation", ^{
        beforeEach(^{
            testOp = [[SDLPresentChoiceSetOperation alloc] initWithConnectionManager:testConnectionManager choiceSet:testChoiceSet mode:testInteractionMode keyboardProperties:nil keyboardDelegate:nil cancelID:testCancelID windowCapability:windowCapability];
            testOp.completionBlock = ^{
                hasCalledOperationCompletionHandler = YES;
            };
            [testOp start];
        });

        it(@"should not update global keyboard properties", ^{
            expect(testConnectionManager.receivedRequests.lastObject).toNot(beAnInstanceOf([SDLSetGlobalProperties class]));
        });

        describe(@"presenting the choice set", ^{
            it(@"should send the perform interaction", ^{
                expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLPerformInteraction class]));
                SDLPerformInteraction *request = testConnectionManager.receivedRequests.lastObject;
                expect(request.initialText).to(equal(testChoiceSet.title));
                expect(request.initialPrompt).to(equal(testChoiceSet.initialPrompt));
                expect(request.interactionMode).to(equal(testInteractionMode));
                expect(request.interactionLayout).to(equal(SDLLayoutModeIconOnly));
                expect(request.timeoutPrompt).to(equal(testChoiceSet.timeoutPrompt));
                expect(request.helpPrompt).to(equal(testChoiceSet.helpPrompt));
                expect(request.timeout).to(equal(testChoiceSet.timeout * 1000));
                expect(request.vrHelp).to(beNil());
                expect(request.interactionChoiceSetIDList).to(equal(@[@65535]));
                expect(request.cancelID).to(equal(testCancelID));
            });

            describe(@"after a perform interaction response", ^{
                __block UInt16 responseChoiceId = UINT16_MAX;
                __block SDLTriggerSource responseTriggerSource = SDLTriggerSourceMenu;

                beforeEach(^{
                    SDLPerformInteractionResponse *response = [[SDLPerformInteractionResponse alloc] init];
                    response.success = @YES;
                    response.choiceID = @(responseChoiceId);
                    response.triggerSource = responseTriggerSource;

                    [testConnectionManager respondToLastRequestWithResponse:response];
                });

                it(@"should not reset the keyboard properties and should be finished", ^{
                    expect(testConnectionManager.receivedRequests.lastObject).toNot(beAnInstanceOf([SDLSetGlobalProperties class]));
                    expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.selectedCell).to(equal(testChoices.firstObject));
                    expect(testOp.selectedTriggerSource).to(equal(responseTriggerSource));
                });
            });
        });

        describe(@"Canceling the choice set", ^{
            __block SDLPresentChoiceSetOperation *testCancelOp = nil;

            beforeEach(^{
                testCancelOp = [[SDLPresentChoiceSetOperation alloc] initWithConnectionManager:testConnectionManager choiceSet:testChoiceSet mode:testInteractionMode keyboardProperties:nil keyboardDelegate:nil cancelID:testCancelID windowCapability:windowCapability];
                testCancelOp.completionBlock = ^{
                    hasCalledOperationCompletionHandler = YES;
                };
            });

            context(@"Head unit supports the `CancelInteration` RPC", ^{
                beforeEach(^{
                    SDLVersion *supportedVersion = [SDLVersion versionWithMajor:6 minor:0 patch:0];
                    id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                    OCMStub([globalMock rpcVersion]).andReturn(supportedVersion);
                });

                 context(@"If the operation is executing", ^{
                     beforeEach(^{
                         [testCancelOp start];

                         expect(testCancelOp.isExecuting).to(beTrue());
                         expect(testCancelOp.isFinished).to(beFalse());
                         expect(testCancelOp.isCancelled).to(beFalse());

                         [testChoiceSet cancel];
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
                         });

                         it(@"should not error", ^{
                             expect(testCancelOp.error).to(beNil());
                         });

                         it(@"should not finish", ^{
                             expect(hasCalledOperationCompletionHandler).to(beFalse());
                             expect(testCancelOp.isExecuting).to(beTrue());
                             expect(testCancelOp.isFinished).to(beFalse());
                             expect(testCancelOp.isCancelled).to(beFalse());
                         });
                     });

                     context(@"If the cancel interaction was not successful", ^{
                         __block NSError *testError = [NSError sdl_lifecycle_notConnectedError];

                         beforeEach(^{
                             SDLCancelInteractionResponse *testCancelInteractionResponse = [[SDLCancelInteractionResponse alloc] init];
                             testCancelInteractionResponse.success = @NO;
                             [testConnectionManager respondToLastRequestWithResponse:testCancelInteractionResponse error:testError];
                         });

                         it(@"should error", ^{
                             expect(testCancelOp.error).to(equal(testError));
                         });

                         it(@"should not finish", ^{
                             expect(hasCalledOperationCompletionHandler).to(beFalse());
                             expect(testCancelOp.isExecuting).to(beTrue());
                             expect(testCancelOp.isFinished).to(beFalse());
                             expect(testCancelOp.isCancelled).to(beFalse());
                         });
                     });
                 });

                 context(@"If the operation has already finished", ^{
                     beforeEach(^{
                         [testCancelOp finishOperation];

                         expect(testCancelOp.isExecuting).to(beFalse());
                         expect(testCancelOp.isFinished).to(beTrue());
                         expect(testCancelOp.isCancelled).to(beFalse());

                         [testChoiceSet cancel];
                     });

                     it(@"should not attempt to send a cancel interaction", ^{
                         SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                         expect(lastRequest).toNot(beAnInstanceOf([SDLCancelInteraction class]));
                     });
                 });

                 context(@"If the started operation has been canceled", ^{
                     beforeEach(^{
                         [testCancelOp start];
                         [testCancelOp cancel];

                         expect(testCancelOp.isExecuting).to(beTrue());
                         expect(testCancelOp.isFinished).to(beFalse());
                         expect(testCancelOp.isCancelled).to(beTrue());

                         [testChoiceSet cancel];
                     });

                     it(@"should not attempt to send a cancel interaction", ^{
                         SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                         expect(lastRequest).toNot(beAnInstanceOf([SDLCancelInteraction class]));
                     });

                     it(@"should not finish", ^{
                         expect(hasCalledOperationCompletionHandler).toEventually(beFalse());
                         expect(testCancelOp.isExecuting).toEventually(beTrue());
                         expect(testCancelOp.isFinished).toEventually(beFalse());
                         expect(testCancelOp.isCancelled).toEventually(beTrue());
                     });
                 });

                context(@"If the operation has not started", ^{
                    beforeEach(^{
                        expect(testCancelOp.isExecuting).to(beFalse());
                        expect(testCancelOp.isFinished).to(beFalse());
                        expect(testCancelOp.isCancelled).to(beFalse());

                        [testChoiceSet cancel];
                    });

                    it(@"should not attempt to send a cancel interaction", ^{
                        SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                        expect(lastRequest).toNot(beAnInstanceOf([SDLCancelInteraction class]));
                    });

                    context(@"Once the operation has started", ^{
                        beforeEach(^{
                            [testCancelOp start];
                        });

                        it(@"should not attempt to send a cancel interaction", ^{
                            SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                            expect(lastRequest).toNot(beAnInstanceOf([SDLCancelInteraction class]));
                        });

                        it(@"should finish", ^{
                            expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                            expect(testCancelOp.isExecuting).toEventually(beFalse());
                            expect(testCancelOp.isFinished).toEventually(beTrue());
                            expect(testCancelOp.isCancelled).toEventually(beTrue());
                        });
                    });
                });
            });

            context(@"Head unit does not support the `CancelInteration` RPC", ^{
                beforeEach(^{
                    SDLVersion *unsupportedVersion = [SDLVersion versionWithMajor:5 minor:1 patch:0];
                    id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                    OCMStub([globalMock rpcVersion]).andReturn(unsupportedVersion);
                });

                it(@"should not attempt to send a cancel interaction if the operation is executing", ^{
                    [testCancelOp start];

                    expect(testCancelOp.isExecuting).to(beTrue());
                    expect(testCancelOp.isFinished).to(beFalse());
                    expect(testCancelOp.isCancelled).to(beFalse());

                    [testChoiceSet cancel];

                    SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                    expect(lastRequest).toNot(beAnInstanceOf([SDLCancelInteraction class]));
                });

                it(@"should cancel the operation if it has not yet been run", ^{
                    expect(testCancelOp.isExecuting).to(beFalse());
                    expect(testCancelOp.isFinished).to(beFalse());
                    expect(testCancelOp.isCancelled).to(beFalse());

                    [testChoiceSet cancel];

                    SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                    expect(lastRequest).toNot(beAnInstanceOf([SDLCancelInteraction class]));

                    expect(testCancelOp.isExecuting).to(beFalse());
                    expect(testCancelOp.isFinished).to(beFalse());
                    expect(testCancelOp.isCancelled).to(beTrue());
                });
            });
        });
    });

    describe(@"running a searchable choice set operation", ^{
        beforeEach(^{
            testOp = [[SDLPresentChoiceSetOperation alloc] initWithConnectionManager:testConnectionManager choiceSet:testChoiceSet mode:testInteractionMode keyboardProperties:testKeyboardProperties keyboardDelegate:testKeyboardDelegate cancelID:testCancelID windowCapability:windowCapability];

            testOp.completionBlock = ^{
                hasCalledOperationCompletionHandler = YES;
            };
            [testOp start];
        });

        it(@"should ask for custom properties", ^{
            OCMVerify([testKeyboardDelegate customKeyboardConfiguration]);
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
                expect(request.initialText).to(equal(testChoiceSet.title));
                expect(request.initialPrompt).to(equal(testChoiceSet.initialPrompt));
                expect(request.interactionMode).to(equal(testInteractionMode));
                expect(request.interactionLayout).to(equal(SDLLayoutModeIconWithSearch));
                expect(request.timeoutPrompt).to(equal(testChoiceSet.timeoutPrompt));
                expect(request.helpPrompt).to(equal(testChoiceSet.helpPrompt));
                expect(request.timeout).to(equal(testChoiceSet.timeout * 1000));
                expect(request.vrHelp).to(beNil());
                expect(request.interactionChoiceSetIDList).to(equal(@[@65535]));
                expect(request.cancelID).to(equal(testCancelID));
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

                OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventSubmitted];
                }] text:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(NSString *)obj isEqualToString:inputData];
                }]]);

                OCMVerify([testKeyboardDelegate userDidSubmitInput:[OCMArg checkWithBlock:^BOOL(id obj) {
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

                OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventVoice];
                }] text:[OCMArg isNil]]);

                OCMVerify([testKeyboardDelegate userDidSubmitInput:[OCMArg isNil] withEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
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

                OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventAborted];
                }] text:[OCMArg isNil]]);

                OCMVerify([testKeyboardDelegate keyboardDidAbortWithReason:[OCMArg checkWithBlock:^BOOL(id obj) {
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

                OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventInputKeyMaskEnabled];
                }] text:[OCMArg isNil]]);

                OCMVerify([testKeyboardDelegate keyboardDidUpdateInputMask:[OCMArg checkWithBlock:^BOOL(id obj) {
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

                OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventCancelled];
                }] text:[OCMArg isNil]]);

                OCMVerify([testKeyboardDelegate keyboardDidAbortWithReason:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventCancelled];
                }]]);
            });

            it(@"should respond to text input notification with autocomplete", ^{
                NSString *inputData = @"Test";
                SDLRPCNotificationNotification *notification = nil;

                OCMStub([testKeyboardDelegate updateAutocompleteWithInput:[OCMArg any] autoCompleteResultsHandler:([OCMArg invokeBlockWithArgs:@[inputData], nil])]);

                // Submit notification
                SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                input.event = SDLKeyboardEventKeypress;
                input.data = inputData;
                notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                [[NSNotificationCenter defaultCenter] postNotification:notification];

                OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventKeypress];
                }] text:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(NSString *)obj isEqualToString:inputData];
                }]]);

                OCMVerify([testKeyboardDelegate updateAutocompleteWithInput:[OCMArg checkWithBlock:^BOOL(id obj) {
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

                OCMStub([testKeyboardDelegate updateCharacterSetWithInput:[OCMArg any] completionHandler:([OCMArg invokeBlockWithArgs:@[inputData], nil])]);

                // Submit notification
                SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                input.event = SDLKeyboardEventKeypress;
                input.data = inputData;
                notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                [[NSNotificationCenter defaultCenter] postNotification:notification];

                OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventKeypress];
                }] text:[OCMArg checkWithBlock:^BOOL(id obj) {
                    return [(NSString *)obj isEqualToString:inputData];
                }]]);

                OCMVerify([testKeyboardDelegate updateCharacterSetWithInput:[OCMArg checkWithBlock:^BOOL(id obj) {
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
                        expect(testOp.isFinished).toEventually(beTrue());
                    });
                });
            });
        });
    });
});

QuickSpecEnd
