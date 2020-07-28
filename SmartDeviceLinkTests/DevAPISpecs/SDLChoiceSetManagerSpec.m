#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLChoiceSetManager.h"

#import "SDLCheckChoiceVROptionalOperation.h"
#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLChoiceSetDelegate.h"
#import "SDLDeleteChoicesOperation.h"
#import "SDLDisplayCapability.h"
#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLHMILevel.h"
#import "SDLKeyboardDelegate.h"
#import "SDLKeyboardProperties.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLPreloadChoicesOperation.h"
#import "SDLPresentChoiceSetOperation.h"
#import "SDLPresentKeyboardOperation.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLStateMachine.h"
#import "SDLSystemContext.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLTextField.h"
#import "SDLVersion.h"
#import "SDLWindowCapability.h"

#import "TestConnectionManager.h"


@interface SDLPresentChoiceSetOperation()

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@interface SDLCheckChoiceVROptionalOperation()

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@interface SDLChoiceSetManager()

@property (strong, nonatomic, readonly) SDLStateMachine *stateMachine;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;
@property (copy, nonatomic, nullable) SDLWindowCapability *currentWindowCapability;

@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *preloadedMutableChoices;
@property (strong, nonatomic, readonly) NSSet<SDLChoiceCell *> *pendingPreloadChoices;
@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *pendingMutablePreloadChoices;
@property (strong, nonatomic, nullable) SDLChoiceSet *pendingPresentationSet;
@property (strong, nonatomic, nullable) SDLAsynchronousOperation *pendingPresentOperation;

@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification;
- (void)sdl_displayCapabilityDidUpdate:(SDLSystemCapability *)systemCapability;

@end

QuickSpecBegin(SDLChoiceSetManagerSpec)

describe(@"choice set manager tests", ^{
    __block SDLChoiceSetManager *testManager = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block SDLSystemCapabilityManager *testSystemCapabilityManager = nil;

    __block SDLWindowCapability *enabledWindowCapability = nil;
    __block SDLWindowCapability *disabledWindowCapability = nil;
    __block SDLWindowCapability *blankWindowCapability = nil;

    __block SDLChoiceCell *testCell1 = nil;
    __block SDLChoiceCell *testCell2 = nil;
    __block SDLChoiceCell *testCell3 = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);
        testSystemCapabilityManager = OCMClassMock([SDLSystemCapabilityManager class]);

        testManager = [[SDLChoiceSetManager alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager systemCapabilityManager:testSystemCapabilityManager];

        testCell1 = [[SDLChoiceCell alloc] initWithText:@"test1"];
        testCell2 = [[SDLChoiceCell alloc] initWithText:@"test2"];
        testCell3 = [[SDLChoiceCell alloc] initWithText:@"test3"];

        enabledWindowCapability = [[SDLWindowCapability alloc] init];
        enabledWindowCapability.textFields = @[[[SDLTextField alloc] initWithName:SDLTextFieldNameMenuName characterSet:SDLCharacterSetUtf8 width:500 rows:1]];
        disabledWindowCapability = [[SDLWindowCapability alloc] init];
        disabledWindowCapability.textFields = @[];
        blankWindowCapability = [[SDLWindowCapability alloc] init];
        blankWindowCapability.textFields = @[];
    });

    it(@"should be in the correct startup state", ^{
        expect(testManager.currentState).to(equal(SDLChoiceManagerStateShutdown));

        SDLKeyboardProperties *defaultProperties = [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageEnUs layout:SDLKeyboardLayoutQWERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteText:nil autoCompleteList:nil];
        expect(testManager.keyboardConfiguration).to(equal(defaultProperties));
    });

    describe(@"receiving an HMI status update", ^{
        __block SDLOnHMIStatus *newStatus = nil;
        beforeEach(^{
            newStatus = [[SDLOnHMIStatus alloc] init];
        });

        context(@"when starting with the queue suspended", ^{
            beforeEach(^{
                testManager.transactionQueue.suspended = YES;
                testManager.currentHMILevel = SDLHMILevelFull;
                testManager.currentWindowCapability = enabledWindowCapability;
            });

            it(@"should enable the queue when entering HMI FULL", ^{
                testManager.currentHMILevel = SDLHMILevelNone;

                SDLOnHMIStatus *newHMIStatus = [[SDLOnHMIStatus alloc] initWithHMILevel:SDLHMILevelFull systemContext:SDLSystemContextMain audioStreamingState:SDLAudioStreamingStateNotAudible videoStreamingState:nil windowID:@0];
                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:newHMIStatus];
                [testManager sdl_hmiStatusNotification:notification];

                expect(testManager.transactionQueue.isSuspended).to(beFalse());
            });

            it(@"should enable the queue when receiving a good window capability", ^{
                testManager.currentWindowCapability = disabledWindowCapability;

                SDLDisplayCapability *displayCapability = [[SDLDisplayCapability alloc] initWithDisplayName:@"TEST" windowCapabilities:@[enabledWindowCapability] windowTypeSupported:nil];
                [testManager sdl_displayCapabilityDidUpdate:[[SDLSystemCapability alloc] initWithDisplayCapabilities:@[displayCapability]]];

                expect(testManager.transactionQueue.isSuspended).to(beFalse());
            });
        });

        context(@"when starting with the queue enabled", ^{
            beforeEach(^{
                testManager.transactionQueue.suspended = NO;
                testManager.currentHMILevel = SDLHMILevelFull;
                testManager.currentWindowCapability = enabledWindowCapability;
            });

            it(@"should suspend the queue when entering HMI NONE", ^{
                SDLOnHMIStatus *newHMIStatus = [[SDLOnHMIStatus alloc] initWithHMILevel:SDLHMILevelNone systemContext:SDLSystemContextMain audioStreamingState:SDLAudioStreamingStateNotAudible videoStreamingState:nil windowID:@0];
                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:newHMIStatus];
                [testManager sdl_hmiStatusNotification:notification];

                expect(testManager.transactionQueue.isSuspended).to(beTrue());
            });

            it(@"should suspend the queue when receiving a bad display capability", ^{
                SDLDisplayCapability *displayCapability = [[SDLDisplayCapability alloc] initWithDisplayName:@"TEST" windowCapabilities:@[disabledWindowCapability] windowTypeSupported:nil];
                [testManager sdl_displayCapabilityDidUpdate:[[SDLSystemCapability alloc] initWithDisplayCapabilities:@[displayCapability]]];

                expect(testManager.transactionQueue.isSuspended).to(beTrue());
            });

            it(@"should not suspend the queue when receiving an empty display capability", ^{
                SDLDisplayCapability *displayCapability = [[SDLDisplayCapability alloc] initWithDisplayName:@"TEST" windowCapabilities:@[blankWindowCapability] windowTypeSupported:nil];
                [testManager sdl_displayCapabilityDidUpdate:[[SDLSystemCapability alloc] initWithDisplayCapabilities:@[displayCapability]]];

                expect(testManager.transactionQueue.isSuspended).to(beTrue());
            });
        });
    });

    describe(@"once started", ^{
        beforeEach(^{
            [testManager start];
        });

        it(@"should start checking for VR Optional", ^{
            expect(testManager.currentState).to(equal(SDLChoiceManagerStateCheckingVoiceOptional));

            expect(testManager.transactionQueue.operationCount).to(equal(1)); expect(testManager.transactionQueue.operations.lastObject).to(beAnInstanceOf([SDLCheckChoiceVROptionalOperation class]));
        });

        describe(@"after the bad vr optional response", ^{
            beforeEach(^{
                SDLCheckChoiceVROptionalOperation *vrOptionalOp = testManager.transactionQueue.operations.lastObject;
                vrOptionalOp.vrOptional = NO;
                vrOptionalOp.internalError = [NSError errorWithDomain:@"test" code:0 userInfo:nil];
                vrOptionalOp.completionBlock();
            });

            it(@"should be ready", ^{
                expect(testManager.currentState).to(equal(SDLChoiceManagerStateStartupError));
            });
        });

        describe(@"after the vr optional response", ^{
            beforeEach(^{
                SDLCheckChoiceVROptionalOperation *vrOptionalOp = testManager.transactionQueue.operations.lastObject;
                vrOptionalOp.vrOptional = YES;
                vrOptionalOp.completionBlock();
            });

            it(@"should be ready", ^{
                expect(testManager.currentState).to(equal(SDLChoiceManagerStateReady));
            });
        });

        describe(@"once shutdown", ^{
            beforeEach(^{
                [testManager stop];
            });

            it(@"should shutdown", ^{
                expect(testManager.currentState).to(equal(SDLChoiceManagerStateShutdown));
                expect(testManager.vrOptional).to(beTrue());
                expect(testManager.currentHMILevel).to(equal(SDLHMILevelNone));
                expect(testManager.pendingPresentationSet).to(beNil());
                expect(testManager.preloadedMutableChoices).to(beEmpty());
                expect(testManager.pendingMutablePreloadChoices).to(beEmpty());
            });
        });
    });

    describe(@"once ready", ^{
        beforeEach(^{
            [testManager.stateMachine setToState:SDLChoiceManagerStateReady fromOldState:SDLChoiceManagerStateCheckingVoiceOptional callEnterTransition:NO];
        });

        describe(@"preloading choices", ^{
            context(@"when some choices are already uploaded", ^{
                beforeEach(^{
                    testManager.preloadedMutableChoices = [NSMutableSet setWithArray:@[testCell1]];

                    [testManager preloadChoices:@[testCell1, testCell2, testCell3] withCompletionHandler:^(NSError * _Nullable error) {
                    }];
                });

                it(@"should properly start the preload", ^{
                    expect(testManager.pendingPreloadChoices).toNot(contain(testCell1));
                    expect(testManager.pendingPreloadChoices).to(contain(testCell2));
                    expect(testManager.pendingPreloadChoices).to(contain(testCell3));
                    expect(testManager.transactionQueue.operations.firstObject).to(beAnInstanceOf([SDLPreloadChoicesOperation class]));

                    SDLPreloadChoicesOperation *testOp = testManager.transactionQueue.operations.firstObject;
                    testOp.completionBlock();

                    expect(testManager.preloadedChoices).to(contain(testCell1));
                    expect(testManager.preloadedChoices).to(contain(testCell2));
                    expect(testManager.preloadedChoices).to(contain(testCell3));
                    expect(testManager.pendingPreloadChoices).to(haveCount(0));
                });
            });

            context(@"when some choices are already pending", ^{
                beforeEach(^{
                    testManager.pendingMutablePreloadChoices = [NSMutableSet setWithArray:@[testCell1]];

                    [testManager preloadChoices:@[testCell1, testCell2, testCell3] withCompletionHandler:^(NSError * _Nullable error) {
                    }];
                });

                it(@"should properly start the preload", ^{
                    expect(testManager.pendingPreloadChoices).to(contain(testCell1));
                    expect(testManager.pendingPreloadChoices).to(contain(testCell2));
                    expect(testManager.pendingPreloadChoices).to(contain(testCell3));
                    expect(testManager.transactionQueue.operations.firstObject).to(beAnInstanceOf([SDLPreloadChoicesOperation class]));

                    SDLPreloadChoicesOperation *testOp = testManager.transactionQueue.operations.firstObject;
                    testOp.completionBlock();

                    expect(testManager.preloadedChoices).toNot(contain(testCell1));
                    expect(testManager.preloadedChoices).to(contain(testCell2));
                    expect(testManager.preloadedChoices).to(contain(testCell3));
                    expect(testManager.pendingPreloadChoices).to(haveCount(1));
                });
            });

            context(@"when the manager shuts down during preloading", ^{
                beforeEach(^{
                    testManager.pendingMutablePreloadChoices = [NSMutableSet setWithArray:@[testCell1]];

                    [testManager preloadChoices:@[testCell1, testCell2, testCell3] withCompletionHandler:^(NSError * _Nullable error) {
                    }];
                });

                it(@"should leave the list of pending and uploaded choice items empty when the operation finishes", ^{
                    expect(testManager.pendingPreloadChoices).to(contain(testCell1));
                    expect(testManager.pendingPreloadChoices).to(contain(testCell2));
                    expect(testManager.pendingPreloadChoices).to(contain(testCell3));
                    expect(testManager.transactionQueue.operations.firstObject).to(beAnInstanceOf([SDLPreloadChoicesOperation class]));

                    [testManager.stateMachine setToState:SDLChoiceManagerStateShutdown fromOldState:nil callEnterTransition:NO];
                    testManager.pendingMutablePreloadChoices = [NSMutableSet set];
                    testManager.preloadedMutableChoices = [NSMutableSet set];

                    SDLPreloadChoicesOperation *testOp = testManager.transactionQueue.operations.firstObject;
                    testOp.completionBlock();

                    expect(testManager.preloadedMutableChoices).to(beEmpty());
                    expect(testManager.preloadedChoices).to(beEmpty());
                    expect(testManager.pendingMutablePreloadChoices).to(beEmpty());
                    expect(testManager.pendingPreloadChoices).to(beEmpty());
                });
            });
        });

        describe(@"deleting choices", ^{
            context(@"used in a pending presentation", ^{
                __block SDLPresentChoiceSetOperation *pendingPresentOp = nil;
                __block id<SDLChoiceSetDelegate> choiceDelegate = nil;

                beforeEach(^{
                    choiceDelegate = OCMProtocolMock(@protocol(SDLChoiceSetDelegate));
                    pendingPresentOp = OCMClassMock([SDLPresentChoiceSetOperation class]);
                    OCMStub(pendingPresentOp.choiceSet.choices).andReturn([NSSet setWithArray:@[testCell1]]);
                    testManager.pendingPresentOperation = pendingPresentOp;
                    testManager.pendingPresentationSet = [[SDLChoiceSet alloc] initWithTitle:@"Test" delegate:choiceDelegate choices:@[testCell1]];

                    testManager.preloadedMutableChoices = [NSMutableSet setWithObject:testCell1];

                    [testManager deleteChoices:@[testCell1, testCell2, testCell3]];
                });

                it(@"should properly start the deletion", ^{
                    expect(testManager.transactionQueue.operations.lastObject).to(beAnInstanceOf([SDLDeleteChoicesOperation class]));
                    expect(testManager.pendingPresentationSet).to(beNil());
                    OCMVerify([pendingPresentOp cancel]);
                    OCMVerify([choiceDelegate choiceSet:[OCMArg any] didReceiveError:[OCMArg any]]);

                    testManager.transactionQueue.operations.lastObject.completionBlock();
                    expect(testManager.preloadedChoices).to(beEmpty());
                });
            });

            context(@"used in pending preloads", ^{
                __block SDLPreloadChoicesOperation *pendingPreloadOp = nil;

                beforeEach(^{
                    pendingPreloadOp = [[SDLPreloadChoicesOperation alloc] init];

                    [testManager.transactionQueue addOperation:pendingPreloadOp];

                    testManager.pendingMutablePreloadChoices = [NSMutableSet setWithObject:testCell1];

                    [testManager deleteChoices:@[testCell1, testCell2, testCell3]];
                });

                it(@"should properly start the deletion", ^{
                    expect(testManager.pendingPreloadChoices).to(beEmpty());
                    expect(testManager.transactionQueue.operationCount).to(equal(1)); // No delete operation
                });
            });

            context(@"when the manager shuts down during deletion", ^{
                __block SDLPresentChoiceSetOperation *pendingPresentOp = nil;
                __block id<SDLChoiceSetDelegate> choiceDelegate = nil;

                beforeEach(^{
                    choiceDelegate = OCMProtocolMock(@protocol(SDLChoiceSetDelegate));
                    pendingPresentOp = OCMClassMock([SDLPresentChoiceSetOperation class]);
                    OCMStub(pendingPresentOp.choiceSet.choices).andReturn([NSSet setWithArray:@[testCell1]]);
                    testManager.pendingPresentOperation = pendingPresentOp;
                    testManager.pendingPresentationSet = [[SDLChoiceSet alloc] initWithTitle:@"Test" delegate:choiceDelegate choices:@[testCell1]];
                    testManager.preloadedMutableChoices = [NSMutableSet setWithObject:testCell1];

                    [testManager deleteChoices:@[testCell1, testCell2, testCell3]];
                });

                it(@"should leave the list of pending and uploaded choice items empty when the operation finishes", ^{
                    expect(testManager.transactionQueue.operations.lastObject).to(beAnInstanceOf([SDLDeleteChoicesOperation class]));
                    expect(testManager.pendingPresentationSet).to(beNil());
                    OCMVerify([pendingPresentOp cancel]);
                    OCMVerify([choiceDelegate choiceSet:[OCMArg any] didReceiveError:[OCMArg any]]);

                    [testManager.stateMachine setToState:SDLChoiceManagerStateShutdown fromOldState:nil callEnterTransition:NO];
                    testManager.pendingMutablePreloadChoices = [NSMutableSet set];
                    testManager.preloadedMutableChoices = [NSMutableSet set];

                    testManager.transactionQueue.operations.lastObject.completionBlock();

                    expect(testManager.preloadedMutableChoices).to(beEmpty());
                    expect(testManager.preloadedChoices).to(beEmpty());
                    expect(testManager.pendingMutablePreloadChoices).to(beEmpty());
                    expect(testManager.pendingPreloadChoices).to(beEmpty());
                });
            });
        });

        describe(@"presenting a choice set", ^{
            __block SDLChoiceSet *testChoiceSet = nil;
            __block NSString *testTitle = @"test title";
            __block id<SDLChoiceSetDelegate> choiceDelegate = nil;
            __block id<SDLKeyboardDelegate> keyboardDelegate = nil;
            __block SDLInteractionMode testMode = SDLInteractionModeBoth;
            __block SDLPresentKeyboardOperation *pendingPresentOp = nil;

            beforeEach(^{
                keyboardDelegate = OCMProtocolMock(@protocol(SDLKeyboardDelegate));
                choiceDelegate = OCMProtocolMock(@protocol(SDLChoiceSetDelegate));
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:choiceDelegate choices:@[testCell1, testCell2, testCell3]];

                pendingPresentOp = OCMClassMock([SDLPresentKeyboardOperation class]);
                testManager.pendingPresentOperation = pendingPresentOp;
                testManager.pendingPresentationSet = [[SDLChoiceSet alloc] init];
            });

            context(@"searchable", ^{
                beforeEach(^{
                    [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];
                });

                it(@"should properly start the presentation", ^{
                    OCMVerify([pendingPresentOp cancel]);
                    expect(testManager.pendingPresentationSet).to(equal(testChoiceSet));
                    expect(testManager.transactionQueue.operations).to(haveCount(2));
                    expect(testManager.transactionQueue.operations.firstObject).to(beAnInstanceOf([SDLPreloadChoicesOperation class]));
                    expect(testManager.transactionQueue.operations.lastObject).to(beAnInstanceOf([SDLPresentChoiceSetOperation class]));
                });

                describe(@"after the completion handler is called", ^{
                    context(@"with an error", ^{
                        beforeEach(^{
                            SDLPresentChoiceSetOperation *op = testManager.transactionQueue.operations.lastObject;
                            op.internalError = [[NSError alloc] init];
                            op.completionBlock();
                        });

                        it(@"should call the error handler", ^{
                            OCMVerify([choiceDelegate choiceSet:[OCMArg any] didReceiveError:[OCMArg isNotNil]]);
                            expect(testManager.pendingPresentationSet).to(beNil());
                            expect(testManager.pendingPresentOperation).to(beNil());
                        });
                    });
                });
            });

            context(@"non-searchable", ^{
                beforeEach(^{
                    [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:nil];
                });

                it(@"should properly start the presentation", ^{
                    OCMVerify([pendingPresentOp cancel]);
                    expect(testManager.pendingPresentationSet).to(equal(testChoiceSet));
                    expect(testManager.transactionQueue.operations).to(haveCount(2));
                    expect(testManager.transactionQueue.operations.firstObject).to(beAnInstanceOf([SDLPreloadChoicesOperation class]));
                    expect(testManager.transactionQueue.operations.lastObject).to(beAnInstanceOf([SDLPresentChoiceSetOperation class]));
                });

                describe(@"after the completion handler is called", ^{
                    context(@"with an error", ^{
                        beforeEach(^{
                            SDLPresentChoiceSetOperation *op = testManager.transactionQueue.operations.lastObject;
                            op.internalError = [[NSError alloc] init];
                            op.completionBlock();
                        });

                        it(@"should call the error handler", ^{
                            OCMVerify([choiceDelegate choiceSet:[OCMArg any] didReceiveError:[OCMArg isNotNil]]);
                            expect(testManager.pendingPresentationSet).to(beNil());
                            expect(testManager.pendingPresentOperation).to(beNil());
                        });
                    });
                });
            });

            describe(@"when the manager shuts down during presentation", ^{
                beforeEach(^{
                    [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];
                });

                it(@"should leave the list of pending and uploaded choice items empty when the operation finishes", ^{
                    expect(testManager.pendingPresentationSet).to(equal(testChoiceSet));
                    expect(testManager.transactionQueue.operations).to(haveCount(2));
                    expect(testManager.transactionQueue.operations.firstObject).to(beAnInstanceOf([SDLPreloadChoicesOperation class]));
                    expect(testManager.transactionQueue.operations.lastObject).to(beAnInstanceOf([SDLPresentChoiceSetOperation class]));

                    [testManager.stateMachine setToState:SDLChoiceManagerStateShutdown fromOldState:nil callEnterTransition:NO];
                    testManager.pendingMutablePreloadChoices = [NSMutableSet set];
                    testManager.preloadedMutableChoices = [NSMutableSet set];

                    testManager.transactionQueue.operations.lastObject.completionBlock();

                    expect(testManager.preloadedMutableChoices).to(beEmpty());
                    expect(testManager.preloadedChoices).to(beEmpty());
                    expect(testManager.pendingMutablePreloadChoices).to(beEmpty());
                    expect(testManager.pendingPreloadChoices).to(beEmpty());
                });
            });
        });

        describe(@"presenting a keyboard", ^{
            __block SDLPresentChoiceSetOperation *pendingPresentOp = nil;
            __block NSString *testInitialText = @"Test text";
            __block id<SDLKeyboardDelegate> testKeyboardDelegate = nil;

            beforeEach(^{
                testKeyboardDelegate = OCMProtocolMock(@protocol(SDLKeyboardDelegate));

                pendingPresentOp = OCMClassMock([SDLPresentChoiceSetOperation class]);
                testManager.pendingPresentOperation = pendingPresentOp;
                testManager.pendingPresentationSet = [[SDLChoiceSet alloc] init];
            });

            it(@"should return a cancelID and should properly start the keyboard presentation with presentKeyboardWithInitialText:keyboardDelegate:", ^{
                NSNumber *cancelID = [testManager presentKeyboardWithInitialText:testInitialText delegate:testKeyboardDelegate];

                expect(cancelID).toNot(beNil());
                OCMVerify([pendingPresentOp cancel]);
                expect(testManager.transactionQueue.operations).to(haveCount(1));
                expect(testManager.pendingPresentOperation).to(beAnInstanceOf([SDLPresentKeyboardOperation class]));
            });

            it(@"should return nil and should not start the keyboard presentation if the the keyboard can not be sent to Core", ^{
                [testManager.stateMachine setToState:SDLChoiceManagerStateCheckingVoiceOptional fromOldState:SDLChoiceManagerStateShutdown callEnterTransition:NO];
                NSNumber *cancelID = [testManager presentKeyboardWithInitialText:testInitialText delegate:testKeyboardDelegate];

                expect(cancelID).to(beNil());
                OCMReject([pendingPresentOp cancel]);
                expect(testManager.transactionQueue.operations).to(haveCount(0));
                expect(testManager.pendingPresentOperation).toNot(beAnInstanceOf([SDLPresentKeyboardOperation class]));
            });
        });

       describe(@"dismissing the keyboard", ^{
           __block SDLPresentKeyboardOperation *mockKeyboardOp1 = nil;
           __block SDLPresentKeyboardOperation *mockKeyboardOp2 = nil;
           __block NSOperationQueue *mockQueue = nil;
           __block UInt16 testCancelId = 387;

            beforeEach(^{
                mockKeyboardOp1 = OCMPartialMock([[SDLPresentKeyboardOperation alloc] init]);
                OCMStub([mockKeyboardOp1 cancelId]).andReturn(88);

                mockKeyboardOp2 = OCMPartialMock([[SDLPresentKeyboardOperation alloc] init]);
                OCMStub([mockKeyboardOp2 cancelId]).andReturn(testCancelId);

                mockQueue = OCMPartialMock([[NSOperationQueue alloc] init]);
                NSArray<SDLAsynchronousOperation *> *keyboardOps = @[mockKeyboardOp1, mockKeyboardOp2];
                OCMStub([mockQueue operations]).andReturn(keyboardOps);

                testManager.transactionQueue = mockQueue;
            });

           it(@"should dismiss the keyboard operation with the matching cancelID if it is executing", ^{
               OCMStub([mockKeyboardOp2 isExecuting]).andReturn(true);
               [testManager dismissKeyboardWithCancelID:@(testCancelId)];

               OCMReject([mockKeyboardOp1 dismissKeyboard]);
               OCMVerify([mockKeyboardOp2 dismissKeyboard]);
           });

           it(@"should dismiss the keyboard operation with the matching cancelID if it is not executing", ^{
               OCMStub([mockKeyboardOp2 isExecuting]).andReturn(false);
               [testManager dismissKeyboardWithCancelID:@(testCancelId)];

               OCMReject([mockKeyboardOp1 dismissKeyboard]);
               OCMVerify([mockKeyboardOp2 dismissKeyboard]);
           });
        });
    });
});

QuickSpecEnd
