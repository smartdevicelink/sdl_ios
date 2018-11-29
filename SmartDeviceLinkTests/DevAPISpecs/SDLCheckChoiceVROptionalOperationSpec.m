#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCheckChoiceVROptionalOperation.h"

#import "SDLChoice.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLCreateInteractionChoiceSetResponse.h"
#import "SDLDeleteInteractionChoiceSet.h"
#import "SDLDeleteInteractionChoiceSetResponse.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLCheckChoiceVROptionalOperationSpec)

describe(@"check choice VR optional operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLCheckChoiceVROptionalOperation *testOp = nil;

    __block BOOL resultVROptional = NO;
    __block BOOL hasCalledOperationCompletionHandler = NO;
    __block NSError *resultError = nil;

    beforeEach(^{
        resultVROptional = NO;
        hasCalledOperationCompletionHandler = NO;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testOp = [[SDLCheckChoiceVROptionalOperation alloc] initWithConnectionManager:testConnectionManager];
        testOp.completionBlock = ^{
            hasCalledOperationCompletionHandler = YES;
            resultVROptional = testOp.vrOptional;
            resultError = testOp.error;
        };
    });

    it(@"should have priority of 'very high'", ^{
        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityVeryHigh)));
    });

    describe(@"running the operation", ^{
        __block SDLCreateInteractionChoiceSetResponse *testResponse;

        beforeEach(^{
            [testOp start];
        });

        it(@"should send a create choice set request with no VR", ^{
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLCreateInteractionChoiceSet class]));

            SDLCreateInteractionChoiceSet *receivedRequest = testConnectionManager.receivedRequests.lastObject;
            expect(receivedRequest.interactionChoiceSetID).to(equal(@0));
            expect(receivedRequest.choiceSet).to(haveCount(1));

            SDLChoice *receivedChoice = receivedRequest.choiceSet.firstObject;
            expect(receivedChoice.choiceID).to(equal(@0));
            expect(receivedChoice.menuName).to(equal(@"Test Cell"));
            expect(receivedChoice.vrCommands).to(beNil());
        });

        context(@"when a good response comes back", ^{
            beforeEach(^{
                testResponse = [[SDLCreateInteractionChoiceSetResponse alloc] init];
                testResponse.success = @YES;
                testResponse.resultCode = SDLResultSuccess;

                [testConnectionManager respondToLastRequestWithResponse:testResponse];
            });

            it(@"should have sent a DeleteChoiceSet request", ^{
                expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLDeleteInteractionChoiceSet class]));
            });

            describe(@"after the DeleteChoiceSet response", ^{
                beforeEach(^{
                    SDLDeleteInteractionChoiceSetResponse *testDeleteResponse = [[SDLDeleteInteractionChoiceSetResponse alloc] init];
                    testDeleteResponse.success = @YES;
                    testDeleteResponse.resultCode = SDLResultSuccess;

                    [testConnectionManager respondToLastRequestWithResponse:testDeleteResponse];
                });

                it(@"should have called the completion handler with proper data and finish", ^{
                    expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                    expect(resultVROptional).to(beTrue());
                    expect(resultError).to(beNil());
                    expect(@(testOp.finished)).to(equal(@YES));
                    expect(@(testOp.executing)).to(equal(@NO));
                });
            });
        });

        context(@"when a bad response comes back", ^{
            beforeEach(^{
                testResponse = [[SDLCreateInteractionChoiceSetResponse alloc] init];
                testResponse.success = @NO;
                testResponse.resultCode = SDLResultRejected;

                [testConnectionManager respondToLastRequestWithResponse:testResponse];
            });

            it(@"should have sent out a new request", ^{
                expect(hasCalledOperationCompletionHandler).to(beFalse());

                expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLCreateInteractionChoiceSet class]));

                SDLCreateInteractionChoiceSet *receivedRequest = testConnectionManager.receivedRequests.lastObject;
                expect(receivedRequest.interactionChoiceSetID).to(equal(@0));
                expect(receivedRequest.choiceSet).to(haveCount(1));

                SDLChoice *receivedChoice = receivedRequest.choiceSet.firstObject;
                expect(receivedChoice.choiceID).to(equal(@0));
                expect(receivedChoice.menuName).to(equal(@"Test Cell"));
                expect(receivedChoice.vrCommands).to(equal(@[@"Test VR"]));
            });

            context(@"when a good response comes back", ^{
                beforeEach(^{
                    testResponse = [[SDLCreateInteractionChoiceSetResponse alloc] init];
                    testResponse.success = @YES;
                    testResponse.resultCode = SDLResultSuccess;

                    [testConnectionManager respondToLastRequestWithResponse:testResponse];
                });

                describe(@"after the DeleteChoiceSet response", ^{
                    beforeEach(^{
                        SDLDeleteInteractionChoiceSetResponse *testDeleteResponse = [[SDLDeleteInteractionChoiceSetResponse alloc] init];
                        testDeleteResponse.success = @YES;
                        testDeleteResponse.resultCode = SDLResultSuccess;

                        [testConnectionManager respondToLastRequestWithResponse:testDeleteResponse];
                    });

                    it(@"should have called the completion handler with proper data and finish", ^{
                        expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                        expect(resultVROptional).to(beFalse());
                        expect(resultError).to(beNil());
                        expect(@(testOp.finished)).to(equal(@YES));
                        expect(@(testOp.executing)).to(equal(@NO));
                    });
                });
            });

            context(@"when a bad response comes back", ^{
                beforeEach(^{
                    testResponse = [[SDLCreateInteractionChoiceSetResponse alloc] init];
                    testResponse.success = @NO;
                    testResponse.resultCode = SDLResultRejected;

                    [testConnectionManager respondToLastRequestWithResponse:testResponse];
                });

                it(@"should return a failure", ^{
                    expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                    expect(resultVROptional).to(beFalse());
                    expect(resultError).toNot(beNil());
                });
            });
        });
    });
});

QuickSpecEnd
