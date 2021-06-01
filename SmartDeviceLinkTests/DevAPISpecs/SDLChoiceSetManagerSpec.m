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
#import "SDLError.h"
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

@interface SDLPreloadChoicesOperation()

@property (copy, nonatomic, nullable) NSError *internalError;
@property (strong, nonatomic, nullable) NSMutableArray<NSNumber *> *failedChoiceUploadIDs;

@end

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLPresentChoiceSetOperation()

@property (copy, nonatomic, nullable) NSError *internalError;
@property (assign, nonatomic) UInt16 cancelId;
@property (strong, nonatomic, readwrite, nullable) SDLChoiceCell *selectedCell;
@property (strong, nonatomic, readwrite, nullable) SDLTriggerSource selectedTriggerSource;
@property (assign, nonatomic, readwrite) NSUInteger selectedCellRow;

@end

@interface SDLCheckChoiceVROptionalOperation()

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@interface SDLChoiceSetManager()

@property (strong, nonatomic, readonly) SDLStateMachine *stateMachine;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (assign, nonatomic) UInt16 nextCancelId;

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
- (void)sdl_displayCapabilityDidUpdate;
- (void)sdl_addUniqueNamesToCells:(NSMutableSet<SDLChoiceCell *> *)choices;

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
    __block SDLChoiceCell *testCell4 = nil;
    __block SDLChoiceCell *testCellDuplicate = nil;
    __block SDLVersion *choiceSetUniquenessActiveVersion = nil;
    __block SDLArtwork *testArtwork = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);
        testSystemCapabilityManager = OCMClassMock([SDLSystemCapabilityManager class]);

        testManager = [[SDLChoiceSetManager alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager systemCapabilityManager:testSystemCapabilityManager];

        testArtwork = [[SDLArtwork alloc] initWithStaticIcon:SDLStaticIconNameKey];
        testCell1 = [[SDLChoiceCell alloc] initWithText:@"test1"];
        testCell2 = [[SDLChoiceCell alloc] initWithText:@"test2"];
        testCell3 = [[SDLChoiceCell alloc] initWithText:@"test3"];
        testCell4 = [[SDLChoiceCell alloc] initWithText:@"test4"];
        testCellDuplicate = [[SDLChoiceCell alloc] initWithText:@"test1" artwork:nil voiceCommands:nil];

        enabledWindowCapability = [[SDLWindowCapability alloc] init];
        enabledWindowCapability.textFields = @[[[SDLTextField alloc] initWithName:SDLTextFieldNameMenuName characterSet:SDLCharacterSetUtf8 width:500 rows:1]];
        disabledWindowCapability = [[SDLWindowCapability alloc] init];
        disabledWindowCapability.textFields = @[];
        blankWindowCapability = [[SDLWindowCapability alloc] init];
        blankWindowCapability.textFields = @[];
        choiceSetUniquenessActiveVersion = [[SDLVersion alloc] initWithMajor:7 minor:1 patch:0];
    });

    it(@"should be in the correct startup state", ^{
        expect(testManager.currentState).to(equal(SDLChoiceManagerStateShutdown));

        SDLKeyboardProperties *defaultProperties = [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageEnUs keyboardLayout:SDLKeyboardLayoutQWERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteList:nil maskInputCharacters:nil customKeys:nil];
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
                OCMStub([testSystemCapabilityManager defaultMainWindowCapability]).andReturn(enabledWindowCapability);
                [testManager sdl_displayCapabilityDidUpdate];

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
                OCMStub([testSystemCapabilityManager defaultMainWindowCapability]).andReturn(disabledWindowCapability);
                [testManager sdl_displayCapabilityDidUpdate];

                expect(testManager.transactionQueue.isSuspended).to(beTrue());
            });

            it(@"should not suspend the queue when receiving an empty display capability", ^{
                OCMStub([testSystemCapabilityManager defaultMainWindowCapability]).andReturn(blankWindowCapability);
                [testManager sdl_displayCapabilityDidUpdate];

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
                    [testOp finishOperation];

                    expect(testManager.preloadedChoices).to(contain(testCell1));
                    expect(testManager.preloadedChoices).to(contain(testCell2));
                    expect(testManager.preloadedChoices).to(contain(testCell3));
                    expect(testManager.pendingPreloadChoices).to(haveCount(0));
                });
            });

            context(@"when some choices are already uploaded with duplicate titles version >= 7.1.0", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = choiceSetUniquenessActiveVersion;
                    [testManager preloadChoices:@[testCell1, testCellDuplicate] withCompletionHandler:^(NSError * _Nullable error) { }];
                });

                it(@"should not update the choiceCells' unique title", ^{
                    SDLPreloadChoicesOperation *testOp = testManager.transactionQueue.operations.firstObject;
                    [testOp finishOperation];
                    NSArray <SDLChoiceCell *> *testArrays = testManager.preloadedChoices.allObjects;
                    for (SDLChoiceCell *choiceCell in testArrays) {
                        expect(choiceCell.uniqueText).to(equal("test1"));
                    }
                    expect(testManager.preloadedChoices).to(contain(testCell1));
                    expect(testManager.preloadedChoices).to(contain(testCellDuplicate));
                });
            });

            context(@"when some choices are already uploaded with duplicate titles version <= 7.1.0", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = [[SDLVersion alloc] initWithMajor:7 minor:0 patch:0];
                    [testManager preloadChoices:@[testCell1, testCellDuplicate] withCompletionHandler:^(NSError * _Nullable error) { }];
                });

                it(@"append a number to the unique text for choice set cells", ^{
                    SDLPreloadChoicesOperation *testOp = testManager.transactionQueue.operations.firstObject;
                    [testOp finishOperation];
                    NSArray <SDLChoiceCell *> *testArrays = testManager.preloadedChoices.allObjects;
                    for (SDLChoiceCell *choiceCell in testArrays) {
                        if (choiceCell.artwork) {
                            expect(choiceCell.uniqueText).to(equal("test1 (2)"));
                        } else {
                            expect(choiceCell.uniqueText).to(equal("test1"));
                        }
                    }
                    expect(testManager.preloadedChoices).to(contain(testCell1));
                    expect(testManager.preloadedChoices).to(contain(testCellDuplicate));
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
                    [testOp finishOperation];

                    expect(testManager.preloadedChoices).toNot(contain(testCell1));
                    expect(testManager.preloadedChoices).to(contain(testCell2));
                    expect(testManager.preloadedChoices).to(contain(testCell3));
                    expect(testManager.pendingPreloadChoices).to(haveCount(1));
                });
            });

            context(@"when the manager shuts down during preloading", ^{
                beforeEach(^{
                    testManager.pendingMutablePreloadChoices = [NSMutableSet setWithArray:@[testCell1]];

                    [testManager preloadChoices:@[testCell1, testCell2, testCell3] withCompletionHandler:^(NSError * _Nullable error) {}];
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
                    [testOp finishOperation];

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
            __block SDLChoiceSet *testFailedChoiceSet = nil;
            __block NSString *testTitle = @"test title";
            __block id<SDLChoiceSetDelegate> choiceDelegate = nil;
            __block id<SDLKeyboardDelegate> keyboardDelegate = nil;
            __block SDLInteractionMode testMode = SDLInteractionModeBoth;
            __block SDLPresentKeyboardOperation *pendingPresentOp = nil;
            __block id strickMockOperationQueue = nil;
            __block SDLChoiceCell *testSelectedCell = nil;
            __block NSError *testError = nil;
            NSUInteger testSelectedCellRow = 1;

            beforeEach(^{
                keyboardDelegate = OCMProtocolMock(@protocol(SDLKeyboardDelegate));
                choiceDelegate = OCMProtocolMock(@protocol(SDLChoiceSetDelegate));
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:choiceDelegate choices:@[testCell1, testCell2, testCell3]];
                testFailedChoiceSet = [[SDLChoiceSet alloc] initWithTitle:testTitle delegate:choiceDelegate choices:@[testCell1, testCell2, testCell3, testCell4]];
                testSelectedCell = testChoiceSet.choices[1];
                testError = [NSError sdl_choiceSetManager_failedToCreateMenuItems];

                pendingPresentOp = OCMClassMock([SDLPresentKeyboardOperation class]);
                testManager.pendingPresentOperation = pendingPresentOp;
                testManager.pendingPresentationSet = [[SDLChoiceSet alloc] init];

                strickMockOperationQueue = OCMStrictClassMock([NSOperationQueue class]);
                testManager.transactionQueue = strickMockOperationQueue;
            });

            context(@"searchable", ^{
                it(@"should notify the choice delegate when a choice item is selected", ^{
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                        expect(testManager.pendingPresentationSet).to(equal(testChoiceSet));
                        [preloadChoicesOperation finishOperation];
                        return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                    }]]);
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLPresentChoiceSetOperation *presentChoicesOperation = (SDLPresentChoiceSetOperation *)value;
                        presentChoicesOperation.selectedCell = testSelectedCell;
                        presentChoicesOperation.selectedTriggerSource = testMode;
                        presentChoicesOperation.selectedCellRow = testSelectedCellRow;
                        presentChoicesOperation.internalError = nil;
                        presentChoicesOperation.completionBlock();
                        return [value isKindOfClass:[SDLPresentChoiceSetOperation class]];
                    }]]);
                    OCMExpect([choiceDelegate choiceSet:testChoiceSet didSelectChoice:testSelectedCell withSource:testMode atRowIndex:testSelectedCellRow]);

                    [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];

                    OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);
                    OCMVerifyAllWithDelay(choiceDelegate, 0.5);

                    expect(testManager.pendingPresentationSet).to(beNil());
                    expect(testManager.pendingPresentOperation).to(beNil());

                    expect(testManager.preloadedMutableChoices.count).to(equal(3));
                    expect(testManager.preloadedMutableChoices).to(contain(testChoiceSet.choices[0]));
                    expect(testManager.preloadedMutableChoices).to(contain(testChoiceSet.choices[1]));
                    expect(testManager.preloadedMutableChoices).to(contain(testChoiceSet.choices[2]));
                    expect(testManager.pendingMutablePreloadChoices).to(beEmpty());
                });

                it(@"should notify the choice delegate if an error occured during presentation", ^{
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                        expect(testManager.pendingPresentationSet).to(equal(testChoiceSet));
                        [preloadChoicesOperation finishOperation];
                        return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                    }]]);
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLPresentChoiceSetOperation *presentChoicesOperation = (SDLPresentChoiceSetOperation *)value;
                        presentChoicesOperation.internalError = testError;
                        presentChoicesOperation.completionBlock();
                        return [value isKindOfClass:[SDLPresentChoiceSetOperation class]];
                    }]]);
                    OCMExpect([choiceDelegate choiceSet:[OCMArg any] didReceiveError:testError]);

                    [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];

                    OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);
                    OCMVerifyAllWithDelay(choiceDelegate, 0.5);

                    expect(testManager.pendingPresentationSet).to(beNil());
                    expect(testManager.pendingPresentOperation).to(beNil());

                    expect(testManager.preloadedMutableChoices.count).to(equal(3));
                    expect(testManager.preloadedMutableChoices).to(contain(testChoiceSet.choices[0]));
                    expect(testManager.preloadedMutableChoices).to(contain(testChoiceSet.choices[1]));
                    expect(testManager.preloadedMutableChoices).to(contain(testChoiceSet.choices[2]));
                    expect(testManager.pendingMutablePreloadChoices).to(beEmpty());
                });

                it(@"should not add a choice item that fails to the list of preloaded choices", ^{
                    NSMutableDictionary<SDLRPCRequest *, NSError *> *testErrors = [NSMutableDictionary dictionary];
                    SDLCreateInteractionChoiceSet *failedChoiceSet = [[SDLCreateInteractionChoiceSet alloc] initWithId:0 choiceSet:@[[[SDLChoice alloc] initWithId:1 menuName:@"1" vrCommands:nil]]];
                    testErrors[failedChoiceSet] = [NSError sdl_choiceSetManager_choiceUploadFailed:[NSDictionary dictionary]];
                    NSError *testInternalError = [NSError sdl_choiceSetManager_choiceUploadFailed:testErrors];

                    OCMExpect([strickMockOperationQueue operations]).andReturn(nil);
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                        expect(testManager.pendingMutablePreloadChoices.count).to(equal(4));
                        expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[0]));
                        expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[1]));
                        expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[2]));
                        expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[3]));
                        preloadChoicesOperation.internalError = testInternalError;
                        preloadChoicesOperation.failedChoiceUploadIDs = [[NSMutableArray alloc] initWithArray:(@[@1])];
                        [preloadChoicesOperation finishOperation];
                        return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                    }]]);
                    OCMReject([strickMockOperationQueue addOperation:[OCMArg isKindOfClass:SDLPresentChoiceSetOperation.class]]);
                    OCMExpect([choiceDelegate choiceSet:[OCMArg any] didReceiveError:testInternalError]);

                    [testManager presentChoiceSet:testFailedChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];

                    OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);
                    OCMVerifyAllWithDelay(choiceDelegate, 0.5);

                    expect(testManager.pendingPresentationSet).toNot(beNil());
                    expect(testManager.pendingPresentOperation).toNot(beNil());

                    expect(testManager.preloadedMutableChoices.count).to(equal(3));
                    expect(testManager.preloadedMutableChoices).toNot(contain(testFailedChoiceSet.choices[0]));
                    expect(testManager.preloadedMutableChoices).to(contain(testFailedChoiceSet.choices[1]));
                    expect(testManager.preloadedMutableChoices).to(contain(testFailedChoiceSet.choices[2]));
                    expect(testManager.preloadedMutableChoices).to(contain(testFailedChoiceSet.choices[3]));

                    expect(testManager.pendingMutablePreloadChoices).to(beEmpty());
                });

                it(@"should not add any of choice items if they all fail to upload to the list of preloaded choices", ^{
                    NSMutableDictionary<SDLRPCRequest *, NSError *> *testErrors = [NSMutableDictionary dictionary];
                    SDLCreateInteractionChoiceSet *failedChoiceSet1 = [[SDLCreateInteractionChoiceSet alloc] initWithId:0 choiceSet:@[[[SDLChoice alloc] initWithId:1 menuName:@"1" vrCommands:nil]]];
                    SDLCreateInteractionChoiceSet *failedChoiceSet2 = [[SDLCreateInteractionChoiceSet alloc] initWithId:0 choiceSet:@[[[SDLChoice alloc] initWithId:2 menuName:@"2" vrCommands:nil]]];
                    SDLCreateInteractionChoiceSet *failedChoiceSet3 = [[SDLCreateInteractionChoiceSet alloc] initWithId:0 choiceSet:@[[[SDLChoice alloc] initWithId:3 menuName:@"3" vrCommands:nil]]];
                    SDLCreateInteractionChoiceSet *failedChoiceSet4 = [[SDLCreateInteractionChoiceSet alloc] initWithId:0 choiceSet:@[[[SDLChoice alloc] initWithId:4 menuName:@"4" vrCommands:nil]]];
                    testErrors[failedChoiceSet1] = [NSError sdl_choiceSetManager_choiceUploadFailed:[NSDictionary dictionary]];
                    testErrors[failedChoiceSet2] = [NSError sdl_choiceSetManager_choiceUploadFailed:[NSDictionary dictionary]];
                    testErrors[failedChoiceSet3] = [NSError sdl_choiceSetManager_choiceUploadFailed:[NSDictionary dictionary]];
                    testErrors[failedChoiceSet4] = [NSError sdl_choiceSetManager_choiceUploadFailed:[NSDictionary dictionary]];
                    NSError *testInternalError = [NSError sdl_choiceSetManager_choiceUploadFailed:testErrors];

                    OCMExpect([strickMockOperationQueue operations]).andReturn(nil);
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                        expect(testManager.pendingMutablePreloadChoices.count).to(equal(4));
                        expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[0]));
                        expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[1]));
                        expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[2]));
                        expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[3]));
                        preloadChoicesOperation.internalError = testInternalError;
                        preloadChoicesOperation.failedChoiceUploadIDs = [[NSMutableArray alloc] initWithArray:(@[@1, @2, @3, @4])];
                        [preloadChoicesOperation finishOperation];
                        return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                    }]]);
                    OCMReject([strickMockOperationQueue addOperation:[OCMArg isKindOfClass:SDLPresentChoiceSetOperation.class]]);
                    OCMExpect([choiceDelegate choiceSet:[OCMArg any] didReceiveError:testInternalError]);

                    [testManager presentChoiceSet:testFailedChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];

                    OCMVerifyAllWithDelay(strickMockOperationQueue, 1.0);
                    OCMVerifyAllWithDelay(choiceDelegate, 0.5);

                    expect(testManager.pendingPresentationSet).toNot(beNil());
                    expect(testManager.pendingPresentOperation).toNot(beNil());

                    expect(testManager.preloadedMutableChoices).to(beEmpty());
                    expect(testManager.pendingMutablePreloadChoices).to(beEmpty());
                });
            });

            it(@"It should skip preloading the choices if all choice items have already been uploaded", ^{
                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                    expect(testManager.pendingMutablePreloadChoices.count).to(equal(3));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testChoiceSet.choices[0]));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testChoiceSet.choices[1]));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testChoiceSet.choices[2]));
                    [preloadChoicesOperation finishOperation];
                    return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                }]]);
                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPresentChoiceSetOperation *presentChoicesOperation = (SDLPresentChoiceSetOperation *)value;
                    presentChoicesOperation.selectedCell = testSelectedCell;
                    presentChoicesOperation.selectedTriggerSource = testMode;
                    presentChoicesOperation.selectedCellRow = testSelectedCellRow;
                    presentChoicesOperation.internalError = nil;
                    presentChoicesOperation.completionBlock();
                    return [value isKindOfClass:[SDLPresentChoiceSetOperation class]];
                }]]);
                OCMExpect([choiceDelegate choiceSet:testChoiceSet didSelectChoice:testSelectedCell withSource:testMode atRowIndex:testSelectedCellRow]);

                [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];

                OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);
                OCMVerifyAllWithDelay(choiceDelegate, 0.5);

                expect(testManager.pendingPresentationSet).to(beNil());
                expect(testManager.pendingPresentOperation).to(beNil());

                expect(testManager.preloadedMutableChoices.count).to(equal(3));
                expect(testManager.pendingMutablePreloadChoices).to(beEmpty());

                // Present the exact same choices again
                OCMReject([strickMockOperationQueue addOperation:[OCMArg isKindOfClass:SDLPreloadChoicesOperation.class]]);
                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPresentChoiceSetOperation *presentChoicesOperation = (SDLPresentChoiceSetOperation *)value;
                    presentChoicesOperation.selectedCell = testSelectedCell;
                    presentChoicesOperation.selectedTriggerSource = testMode;
                    presentChoicesOperation.selectedCellRow = testSelectedCellRow;
                    presentChoicesOperation.internalError = nil;
                    presentChoicesOperation.completionBlock();
                    return [value isKindOfClass:[SDLPresentChoiceSetOperation class]];
                }]]);
                OCMExpect([choiceDelegate choiceSet:testChoiceSet didSelectChoice:testSelectedCell withSource:testMode atRowIndex:testSelectedCellRow]);

                [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];

                OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);
                OCMVerifyAllWithDelay(choiceDelegate, 0.5);
            });

            it(@"It should upload choices that failed to upload in previous presentations", ^{
                NSMutableDictionary<SDLRPCRequest *, NSError *> *testErrors = [NSMutableDictionary dictionary];
                SDLCreateInteractionChoiceSet *failedChoiceSet = [[SDLCreateInteractionChoiceSet alloc] initWithId:0 choiceSet:@[[[SDLChoice alloc] initWithId:1 menuName:@"1" vrCommands:nil]]];
                testErrors[failedChoiceSet] = [NSError sdl_choiceSetManager_choiceUploadFailed:[NSDictionary dictionary]];
                NSError *testInternalError = [NSError sdl_choiceSetManager_choiceUploadFailed:testErrors];

                OCMExpect([strickMockOperationQueue operations]).andReturn(nil);
                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                    expect(testManager.pendingMutablePreloadChoices.count).to(equal(4));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[0]));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[1]));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[2]));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[3]));
                    expect(testManager.pendingPresentationSet).to(equal(testFailedChoiceSet));
                    preloadChoicesOperation.internalError = testInternalError;
                    preloadChoicesOperation.failedChoiceUploadIDs = [[NSMutableArray alloc] initWithArray:(@[@1])];
                    [preloadChoicesOperation finishOperation];
                    return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                }]]);
                OCMExpect([choiceDelegate choiceSet:[OCMArg any] didReceiveError:testInternalError]);

                [testManager presentChoiceSet:testFailedChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];

                OCMVerifyAllWithDelay(strickMockOperationQueue, 1.0);
                OCMVerifyAllWithDelay(choiceDelegate, 0.5);

                expect(testManager.pendingPresentationSet).toNot(beNil());
                expect(testManager.pendingPresentOperation).toNot(beNil());

                expect(testManager.preloadedMutableChoices.count).to(equal(3));
                expect(testManager.preloadedMutableChoices).toNot(contain(testFailedChoiceSet.choices[0]));
                expect(testManager.preloadedMutableChoices).to(contain(testFailedChoiceSet.choices[1]));
                expect(testManager.preloadedMutableChoices).to(contain(testFailedChoiceSet.choices[2]));
                expect(testManager.preloadedMutableChoices).to(contain(testFailedChoiceSet.choices[3]));
                expect(testManager.pendingMutablePreloadChoices).to(beEmpty());

                // Present the exact same choices again
                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                    expect(testManager.pendingMutablePreloadChoices.count).to(equal(1));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[0]));
                    [preloadChoicesOperation finishOperation];
                    return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                }]]);
                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPresentChoiceSetOperation *presentChoicesOperation = (SDLPresentChoiceSetOperation *)value;
                    presentChoicesOperation.selectedCell = testSelectedCell;
                    presentChoicesOperation.selectedTriggerSource = testMode;
                    presentChoicesOperation.selectedCellRow = testSelectedCellRow;
                    presentChoicesOperation.internalError = nil;
                    presentChoicesOperation.completionBlock();
                    return [value isKindOfClass:[SDLPresentChoiceSetOperation class]];
                }]]);
                OCMExpect([choiceDelegate choiceSet:testChoiceSet didSelectChoice:testSelectedCell withSource:testMode atRowIndex:testSelectedCellRow]);

                [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];

                OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);
                OCMVerifyAllWithDelay(choiceDelegate, 0.5);

                expect(testManager.pendingPresentationSet).to(beNil());
                expect(testManager.pendingPresentOperation).to(beNil());

                expect(testManager.preloadedMutableChoices.count).to(equal(4));
                expect(testManager.preloadedMutableChoices).to(contain(testFailedChoiceSet.choices[0]));
                expect(testManager.preloadedMutableChoices).to(contain(testFailedChoiceSet.choices[1]));
                expect(testManager.preloadedMutableChoices).to(contain(testFailedChoiceSet.choices[2]));
                expect(testManager.preloadedMutableChoices).to(contain(testFailedChoiceSet.choices[3]));
                expect(testManager.pendingMutablePreloadChoices).to(beEmpty());
            });

            it(@"It should update pending choice uploads operations with the choice items that failed to upload", ^{
                NSMutableDictionary<SDLRPCRequest *, NSError *> *testErrors = [NSMutableDictionary dictionary];
                SDLCreateInteractionChoiceSet *failedChoiceSet1 = [[SDLCreateInteractionChoiceSet alloc] initWithId:0 choiceSet:@[[[SDLChoice alloc] initWithId:1 menuName:@"1" vrCommands:nil]]];
                SDLCreateInteractionChoiceSet *failedChoiceSet2 = [[SDLCreateInteractionChoiceSet alloc] initWithId:0 choiceSet:@[[[SDLChoice alloc] initWithId:2 menuName:@"2" vrCommands:nil]]];
                testErrors[failedChoiceSet1] = [NSError sdl_choiceSetManager_choiceUploadFailed:[NSDictionary dictionary]];
                testErrors[failedChoiceSet2] = [NSError sdl_choiceSetManager_choiceUploadFailed:[NSDictionary dictionary]];
                NSError *testInternalError = [NSError sdl_choiceSetManager_choiceUploadFailed:testErrors];

                SDLPreloadChoicesOperation *mockPreloadChoicesOp = OCMClassMock([SDLPreloadChoicesOperation class]);
                OCMExpect([mockPreloadChoicesOp isExecuting]).andReturn(NO);
                OCMExpect([strickMockOperationQueue operations]).andReturn(@[mockPreloadChoicesOp]);

                OCMExpect([mockPreloadChoicesOp addChoicesToUpload:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLChoiceCell *> *choices = (NSArray<SDLChoiceCell *> *)value;
                    expect(choices).to(contain(testFailedChoiceSet.choices[0]));
                    expect(choices).to(contain(testFailedChoiceSet.choices[1]));
                    return (choices.count == 2);
                }]]);

                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                    expect(testManager.pendingMutablePreloadChoices.count).to(equal(4));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[0]));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[1]));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[2]));
                    expect(testManager.pendingMutablePreloadChoices).to(contain(testFailedChoiceSet.choices[3]));
                    expect(testManager.pendingPresentationSet).to(equal(testFailedChoiceSet));
                    preloadChoicesOperation.internalError = testInternalError;
                    preloadChoicesOperation.failedChoiceUploadIDs = [[NSMutableArray alloc] initWithArray:(@[@1, @2])];
                    [preloadChoicesOperation finishOperation];
                    return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                }]]);
                OCMExpect([choiceDelegate choiceSet:[OCMArg any] didReceiveError:testInternalError]);

                [testManager presentChoiceSet:testFailedChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];

                OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);
                OCMVerifyAllWithDelay(mockPreloadChoicesOp, 0.5);
                OCMVerifyAllWithDelay(choiceDelegate, 0.5);
            });

            context(@"non-searchable", ^{
                it(@"should notify the choice delegate when a choice item is selected", ^{
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                        expect(testManager.pendingPresentationSet).to(equal(testChoiceSet));
                        [preloadChoicesOperation finishOperation];
                        return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                    }]]);
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLPresentChoiceSetOperation *presentChoicesOperation = (SDLPresentChoiceSetOperation *)value;
                        presentChoicesOperation.selectedCell = testSelectedCell;
                        presentChoicesOperation.selectedTriggerSource = testMode;
                        presentChoicesOperation.selectedCellRow = testSelectedCellRow;
                        presentChoicesOperation.internalError = nil;
                        presentChoicesOperation.completionBlock();
                        return [value isKindOfClass:[SDLPresentChoiceSetOperation class]];
                    }]]);
                    OCMExpect([choiceDelegate choiceSet:testChoiceSet didSelectChoice:testSelectedCell withSource:testMode atRowIndex:testSelectedCellRow]);

                    [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:nil];

                    OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);
                    OCMVerifyAllWithDelay(choiceDelegate, 0.5);

                    expect(testManager.pendingPresentationSet).to(beNil());
                    expect(testManager.pendingPresentOperation).to(beNil());
                });

                it(@"should notify the choice delegate if an error occured during presentation", ^{
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                        expect(testManager.pendingPresentationSet).to(equal(testChoiceSet));
                        [preloadChoicesOperation finishOperation];
                        return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                    }]]);
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLPresentChoiceSetOperation *presentChoicesOperation = (SDLPresentChoiceSetOperation *)value;
                        presentChoicesOperation.internalError = testError;
                        presentChoicesOperation.completionBlock();
                        return [value isKindOfClass:[SDLPresentChoiceSetOperation class]];
                    }]]);
                    OCMExpect([choiceDelegate choiceSet:[OCMArg any] didReceiveError:testError]);

                    [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:nil];

                    OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);
                    OCMVerifyAllWithDelay(choiceDelegate, 0.5);

                    expect(testManager.pendingPresentationSet).to(beNil());
                    expect(testManager.pendingPresentOperation).to(beNil());
                });
            });

            describe(@"when the manager shuts down during presentation", ^{
                __block SDLPresentChoiceSetOperation *presentChoicesOperation = nil;

                it(@"should leave the list of pending and uploaded choice items empty when the operation finishes", ^{
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                        expect(testManager.pendingPresentationSet).to(equal(testChoiceSet));
                        [preloadChoicesOperation finishOperation];
                        return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                    }]]);
                    OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                        presentChoicesOperation = (SDLPresentChoiceSetOperation *)value;
                        presentChoicesOperation.internalError = nil;
                        testManager.pendingMutablePreloadChoices = [NSMutableSet set];
                        testManager.preloadedMutableChoices = [NSMutableSet set];

                        [testManager.stateMachine setToState:SDLChoiceManagerStateShutdown fromOldState:nil callEnterTransition:NO];
                        presentChoicesOperation.completionBlock();
                        return [value isKindOfClass:[SDLPresentChoiceSetOperation class]];
                    }]]);

                    [testManager presentChoiceSet:testChoiceSet mode:testMode withKeyboardDelegate:keyboardDelegate];
                    OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);

                    expect(testManager.preloadedMutableChoices).to(beEmpty());
                    expect(testManager.preloadedChoices).to(beEmpty());
                    expect(testManager.pendingMutablePreloadChoices).to(beEmpty());
                    expect(testManager.pendingPreloadChoices).to(beEmpty());
                });
            });

            afterEach(^{
                [strickMockOperationQueue stopMocking];
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

        describe(@"generating a cancel id", ^{
            __block SDLChoiceSet *testChoiceSet = nil;
            __block SDLChoiceSet *testChoiceSet2 = nil;
            __block id<SDLChoiceSetDelegate> testChoiceDelegate = nil;
            __block id strickMockOperationQueue = nil;

            beforeEach(^{
                testChoiceDelegate = OCMProtocolMock(@protocol(SDLChoiceSetDelegate));
                testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:@"choice set 1" delegate:testChoiceDelegate choices:@[testCell1]];
                testChoiceSet2 = [[SDLChoiceSet alloc] initWithTitle:@"choice set 2" delegate:testChoiceDelegate choices:@[testCell2]];
                testManager = [[SDLChoiceSetManager alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager systemCapabilityManager:testSystemCapabilityManager];
                [testManager.stateMachine setToState:SDLChoiceManagerStateReady fromOldState:SDLChoiceManagerStateCheckingVoiceOptional callEnterTransition:NO];
                strickMockOperationQueue = OCMStrictClassMock([NSOperationQueue class]);
                testManager.transactionQueue = strickMockOperationQueue;
            });

            it(@"should set the first cancelID correctly", ^{
                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                    [preloadChoicesOperation finishOperation];
                    return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                }]]);

                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPresentChoiceSetOperation *presentChoicesOperation = (SDLPresentChoiceSetOperation *)value;
                    expect(@(presentChoicesOperation.cancelId)).to(equal(101));
                    presentChoicesOperation.completionBlock();
                    return [value isKindOfClass:[SDLPresentChoiceSetOperation class]];
                }]]);

                [testManager presentChoiceSet:testChoiceSet mode:SDLInteractionModeBoth withKeyboardDelegate:nil];

                OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);
            });

            it(@"should reset the cancelID correctly once the max has been reached", ^{
                testManager.nextCancelId = 200;  // set the max cancelID

                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                    [preloadChoicesOperation finishOperation];
                    return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                }]]);
                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPresentChoiceSetOperation *presentChoicesOperation = (SDLPresentChoiceSetOperation *)value;
                    expect(@(presentChoicesOperation.cancelId)).to(equal(200));
                    presentChoicesOperation.completionBlock();
                    return [value isKindOfClass:[SDLPresentChoiceSetOperation class]];
                }]]);

                [testManager presentChoiceSet:testChoiceSet mode:SDLInteractionModeBoth withKeyboardDelegate:nil];

                OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);

                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPreloadChoicesOperation *preloadChoicesOperation = (SDLPreloadChoicesOperation *)value;
                    [preloadChoicesOperation finishOperation];
                    return [value isKindOfClass:[SDLPreloadChoicesOperation class]];
                }]]);
                OCMExpect([strickMockOperationQueue addOperation:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLPresentChoiceSetOperation *presentChoicesOperation = (SDLPresentChoiceSetOperation *)value;
                    expect(@(presentChoicesOperation.cancelId)).to(equal(101));
                    presentChoicesOperation.completionBlock();
                    return [value isKindOfClass:[SDLPresentChoiceSetOperation class]];
                }]]);

                [testManager presentChoiceSet:testChoiceSet2 mode:SDLInteractionModeBoth withKeyboardDelegate:nil];

                OCMVerifyAllWithDelay(strickMockOperationQueue, 0.5);
            });

            afterEach(^{
                [strickMockOperationQueue stopMocking];
            });
        });

       describe(@"dismissing the keyboard", ^{
           __block id mockKeyboardOp1 = nil;
           __block id mockKeyboardOp2 = nil;
           __block NSOperationQueue *mockQueue = nil;
           __block UInt16 testCancelId = 387;

            beforeEach(^{
                mockKeyboardOp1 = OCMStrictClassMock([SDLPresentKeyboardOperation class]);
                OCMStub([mockKeyboardOp1 cancelId]).andReturn(88);

                mockKeyboardOp2 = OCMStrictClassMock([SDLPresentKeyboardOperation class]);
                OCMStub([mockKeyboardOp2 cancelId]).andReturn(testCancelId);

                mockQueue = OCMPartialMock([[NSOperationQueue alloc] init]);
                NSArray<SDLAsynchronousOperation *> *keyboardOps = @[mockKeyboardOp1, mockKeyboardOp2];
                OCMStub([mockQueue operations]).andReturn(keyboardOps);

                testManager.transactionQueue = mockQueue;
            });

           it(@"should dismiss the keyboard operation with the matching cancelID if it is executing", ^{
               OCMStub([mockKeyboardOp1 isExecuting]).andReturn(true);
               OCMStub([mockKeyboardOp2 isExecuting]).andReturn(true);

               OCMReject([mockKeyboardOp1 dismissKeyboard]);
               OCMExpect([mockKeyboardOp2 dismissKeyboard]);

               [testManager dismissKeyboardWithCancelID:@(testCancelId)];

               OCMVerifyAllWithDelay(mockKeyboardOp1, 0.5);
               OCMVerifyAllWithDelay(mockKeyboardOp2, 0.5);
           });

           it(@"should dismiss the keyboard operation with the matching cancelID if it is not executing", ^{
               OCMStub([mockKeyboardOp1 isExecuting]).andReturn(false);
               OCMStub([mockKeyboardOp2 isExecuting]).andReturn(false);

               OCMReject([mockKeyboardOp1 dismissKeyboard]);
               OCMExpect([mockKeyboardOp2 dismissKeyboard]);

               [testManager dismissKeyboardWithCancelID:@(testCancelId)];

               OCMVerifyAllWithDelay(mockKeyboardOp1, 0.5);
               OCMVerifyAllWithDelay(mockKeyboardOp2, 0.5);
           });
        });
    });
});

QuickSpecEnd
