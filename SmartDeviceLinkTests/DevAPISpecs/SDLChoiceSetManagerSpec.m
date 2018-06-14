#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLChoiceSetManager.h"

#import "SDLCheckChoiceVROptionalOperation.h"
#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLChoiceSetDelegate.h"
#import "SDLDeleteChoicesOperation.h"
#import "SDLDisplayCapabilities.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLKeyboardDelegate.h"
#import "SDLKeyboardProperties.h"
#import "SDLPreloadChoicesOperation.h"
#import "SDLPresentChoiceSetOperation.h"
#import "SDLPresentKeyboardOperation.h"
#import "SDLStateMachine.h"
#import "SDLSystemContext.h"
#import "TestConnectionManager.h"

@interface SDLCheckChoiceVROptionalOperation()

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@interface SDLChoiceSetManager()

@property (strong, nonatomic, readonly) SDLStateMachine *stateMachine;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (copy, nonatomic, nullable) SDLSystemContext currentSystemContext;
@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *preloadedMutableChoices;
@property (strong, nonatomic, readonly) NSSet<SDLChoiceCell *> *pendingPreloadChoices;
@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *pendingMutablePreloadChoices;
@property (strong, nonatomic, nullable) SDLChoiceSet *pendingPresentationSet;
@property (strong, nonatomic, nullable) SDLAsynchronousOperation *pendingPresentOperation;

@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;

@end

QuickSpecBegin(SDLChoiceSetManagerSpec)

describe(@"choice set manager tests", ^{
    __block SDLChoiceSetManager *testManager = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;

    __block SDLChoiceCell *testCell1 = nil;
    __block SDLChoiceCell *testCell2 = nil;
    __block SDLChoiceCell *testCell3 = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);

        testManager = [[SDLChoiceSetManager alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager];

        testCell1 = [[SDLChoiceCell alloc] initWithText:@"test1"];
        testCell2 = [[SDLChoiceCell alloc] initWithText:@"test2"];
        testCell3 = [[SDLChoiceCell alloc] initWithText:@"test3"];
    });

    it(@"should be in the correct startup state", ^{
        expect(testManager.currentState).to(equal(SDLChoiceManagerStateShutdown));

        SDLKeyboardProperties *defaultProperties = [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageEnUs layout:SDLKeyboardLayoutQWERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteText:nil];
        expect(testManager.keyboardConfiguration).to(equal(defaultProperties));
    });

    describe(@"once started", ^{
        beforeEach(^{
            [testManager start];
            testManager.transactionQueue.suspended = YES;
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
                    OCMPartialMock(pendingPreloadOp);
                    OCMStub([pendingPreloadOp removeChoicesFromUpload:[OCMArg any]]);
                    [testManager.transactionQueue addOperation:pendingPreloadOp];

                    testManager.pendingMutablePreloadChoices = [NSMutableSet setWithObject:testCell1];

                    [testManager deleteChoices:@[testCell1, testCell2, testCell3]];
                });

                it(@"should properly start the deletion", ^{
                    OCMStub([pendingPreloadOp removeChoicesFromUpload:[OCMArg checkWithBlock:^BOOL(id obj) {
                        NSArray<SDLChoiceCell *> *choices = (NSArray<SDLChoiceCell *> *)obj;
                        return (choices.count == 1) && ([choices.firstObject isEqual:testCell1]);
                    }]]);

                    expect(testManager.pendingPreloadChoices).to(beEmpty());
                    expect(testManager.transactionQueue.operationCount).to(equal(1)); // No delete operation
                });
            });
        });

        describe(@"presenting a choice set", ^{
            context(@"searchable", ^{

            });

            context(@"non-searchable", ^{

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

                [testManager presentKeyboardWithInitialText:testInitialText delegate:testKeyboardDelegate];
            });

            it(@"should properly start the keyboard presentation", ^{
                OCMVerify([pendingPresentOp cancel]);
                expect(testManager.transactionQueue.operations).to(haveCount(1));
            });
        });
    });
});

QuickSpecEnd
