#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteChoicesOperation.h"

#import "SDLChoiceCell.h"
#import "SDLDeleteInteractionChoiceSet.h"
#import "SDLDeleteInteractionChoiceSetResponse.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLDeleteChoicesOperationSpec)

fdescribe(@"delete choices operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLDeleteChoicesOperation *testOp = nil;
    __block NSSet<SDLChoiceCell *> *testCellsToDelete = nil;

    __block BOOL hasCalledOperationCompletionHandler = NO;
    __block NSError *resultError = nil;

    beforeEach(^{
        hasCalledOperationCompletionHandler = NO;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testCellsToDelete = [NSSet setWithArray:@[[[SDLChoiceCell alloc] initWithText:@"Text"], [[SDLChoiceCell alloc] initWithText:@"Text 2"]]];
        testOp = [[SDLDeleteChoicesOperation alloc] initWithConnectionManager:testConnectionManager cellsToDelete:testCellsToDelete];
        testOp.completionBlock = ^{
            hasCalledOperationCompletionHandler = YES;
            resultError = testOp.error;
        };
    });

    it(@"should have priority of 'normal'", ^{
        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    describe(@"running the operation", ^{
        beforeEach(^{
            [testOp start];
        });

        it(@"should send a deletion for each choice", ^{
            expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLDeleteInteractionChoiceSet class]));
            expect(testConnectionManager.receivedRequests).to(haveCount(2));

            SDLDeleteInteractionChoiceSet *delete1 = testConnectionManager.receivedRequests.firstObject;
            expect(delete1.interactionChoiceSetID).to(equal(@(UINT16_MAX)));

            SDLDeleteInteractionChoiceSet *delete2 = testConnectionManager.receivedRequests.lastObject;
            expect(delete2.interactionChoiceSetID).to(equal(@(UINT16_MAX)));
        });

        context(@"when good responses comes back", ^{
            __block SDLDeleteInteractionChoiceSetResponse *response1 = nil;
            __block SDLDeleteInteractionChoiceSetResponse *response2 = nil;

            beforeEach(^{
                response1 = [[SDLDeleteInteractionChoiceSetResponse alloc] init];
                response1.success = @YES;

                response2 = [[SDLDeleteInteractionChoiceSetResponse alloc] init];
                response2.success = @YES;

                [testConnectionManager respondToRequestWithResponse:response1 requestNumber:0 error:nil];
                [testConnectionManager respondToRequestWithResponse:response2 requestNumber:1 error:nil];
            });

            it(@"should finish with success", ^{
                expect(hasCalledOperationCompletionHandler).to(beTrue());
                expect(resultError).to(beNil());
            });
        });

        context(@"when bad responses comes back", ^{
            __block SDLDeleteInteractionChoiceSetResponse *response1 = nil;
            __block SDLDeleteInteractionChoiceSetResponse *response2 = nil;

            beforeEach(^{
                response1 = [[SDLDeleteInteractionChoiceSetResponse alloc] init];
                response1.success = @NO;

                response2 = [[SDLDeleteInteractionChoiceSetResponse alloc] init];
                response2.success = @NO;

                [testConnectionManager respondToRequestWithResponse:response1 requestNumber:0 error:nil];
                [testConnectionManager respondToRequestWithResponse:response2 requestNumber:1 error:nil];
            });

            it(@"should finish with success", ^{
                expect(hasCalledOperationCompletionHandler).to(beTrue());
                expect(resultError).toNot(beNil());
            });
        });
    });
});

QuickSpecEnd
