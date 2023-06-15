@import Quick;
@import Nimble;

#import "SDLDeleteChoicesOperation.h"

#import "SDLChoiceCell.h"
#import "SDLDeleteInteractionChoiceSet.h"
#import "SDLDeleteInteractionChoiceSetResponse.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLDeleteChoicesOperationSpec)

describe(@"delete choices operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLDeleteChoicesOperation *testOp = nil;
    __block NSSet<SDLChoiceCell *> *testCellsToDelete = nil;
    __block NSSet<SDLChoiceCell *> *testLoadedCells = nil;

    __block NSError *resultError = nil;
    __block NSSet<SDLChoiceCell *> *resultLoadedCells;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testCellsToDelete = [NSSet setWithArray:@[[[SDLChoiceCell alloc] initWithText:@"Text"], [[SDLChoiceCell alloc] initWithText:@"Text 2"]]];
        testLoadedCells = testCellsToDelete;

        resultError = nil;
        resultLoadedCells = nil;

        testOp = [[SDLDeleteChoicesOperation alloc] initWithConnectionManager:testConnectionManager cellsToDelete:testCellsToDelete loadedCells:testLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
            resultLoadedCells = updatedLoadedCells;
            resultError = error;
        }];
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
            beforeEach(^{
                [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
            });

            it(@"should finish with success", ^{
                expect(resultLoadedCells).toEventuallyNot(beNil());
                expect(resultError).to(beNil());
            });
        });

        context(@"when bad responses comes back", ^{
            beforeEach(^{
                [testConnectionManager respondToLastMultipleRequestsWithSuccess:NO];
            });

            it(@"should finish with a failure", ^{
                expect(resultLoadedCells).toEventuallyNot(beNil());
                expect(resultError).toNot(beNil());
            });
        });
    });
});

QuickSpecEnd
