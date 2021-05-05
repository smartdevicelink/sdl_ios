#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLAddCommandResponse.h"
#import "SDLDeleteCommand.h"
#import "SDLDeleteCommandResponse.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLVoiceCommand.h"
#import "SDLVoiceCommandManager.h"
#import "SDLVoiceCommandUpdateOperation.h"
#import "TestConnectionManager.h"

@interface SDLVoiceCommand()

@property (assign, nonatomic) UInt32 commandId;

@end

@interface SDLVoiceCommandUpdateOperation()

+ (NSArray<SDLVoiceCommand *> *)sdl_voiceCommandsInArray:(NSArray<SDLVoiceCommand *> *)firstArray notInSecondArray:(NSArray<SDLVoiceCommand *> *)secondArray;

@end

QuickSpecBegin(SDLVoiceCommandUpdateOperationSpec)

__block SDLDeleteCommandResponse *successDelete = nil;
__block SDLDeleteCommandResponse *failDelete = nil;
__block SDLAddCommandResponse *successAdd = nil;
__block SDLAddCommandResponse *failAdd = nil;

__block SDLVoiceCommand *newVoiceCommand1 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"NewVC1"] handler:^{}];
__block SDLVoiceCommand *newVoiceCommand2 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"NewVC2"] handler:^{}];
__block SDLVoiceCommand *oldVoiceCommand1 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"OldVC1"] handler:^{}];
__block SDLVoiceCommand *oldVoiceCommand2 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"OldVC2"] handler:^{}];


describe(@"a voice command operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLVoiceCommandUpdateOperation *testOp = nil;

    __block NSError *callbackError = nil;
    __block NSArray<SDLVoiceCommand *> *callbackCurrentVoiceCommands = nil;

    beforeEach(^{
        successDelete = [[SDLDeleteCommandResponse alloc] init];
        successDelete.success = @YES;
        successDelete.resultCode = SDLResultSuccess;

        failDelete = [[SDLDeleteCommandResponse alloc] init];
        failDelete.success = @NO;
        failDelete.resultCode = SDLResultDisallowed;

        successAdd = [[SDLAddCommandResponse alloc] init];
        successAdd.success = @YES;
        successAdd.resultCode = SDLResultSuccess;

        failAdd = [[SDLAddCommandResponse alloc] init];
        failAdd.success = @NO;
        failAdd.resultCode = SDLResultDisallowed;

        newVoiceCommand1.commandId = 1;
        newVoiceCommand2.commandId = 2;
        oldVoiceCommand1.commandId = 3;
        oldVoiceCommand2.commandId = 4;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testOp = nil;

        callbackError = nil;
        callbackCurrentVoiceCommands = nil;
    });

    // should have a priority of 'normal'
    it(@"should have a priority of 'normal'", ^{
        testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager pendingVoiceCommands:@[] oldVoiceCommands:@[] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {
        }];

        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    // initializing the operation
    describe(@"initializing the operation", ^{
        testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager pendingVoiceCommands:@[newVoiceCommand1, newVoiceCommand2] oldVoiceCommands:@[oldVoiceCommand1, oldVoiceCommand2] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {}];

        expect(testOp.oldVoiceCommands).to(equal(@[oldVoiceCommand1, oldVoiceCommand2]));
    });

    // starting the operation
    describe(@"starting the operation", ^{

        // if it starts cancelled
        context(@"if it starts cancelled", ^{
            beforeEach(^{
                testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager pendingVoiceCommands:@[newVoiceCommand1, newVoiceCommand2] oldVoiceCommands:@[oldVoiceCommand1, oldVoiceCommand2] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {
                    callbackCurrentVoiceCommands = newCurrentVoiceCommands;
                    callbackError = error;
                }];
                [testOp cancel];
                [testOp start];
            });

            it(@"should return immediately with an error", ^{
                expect(callbackError).toEventuallyNot(beNil());
            });
        });

        // if it has voice commands to delete
        context(@"if it has voice commands to delete", ^{
            beforeEach(^{
                testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager pendingVoiceCommands:@[] oldVoiceCommands:@[oldVoiceCommand1, oldVoiceCommand2] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {
                    callbackCurrentVoiceCommands = newCurrentVoiceCommands;
                    callbackError = error;
                }];
                [testOp start];
            });

            // and the delete succeeds
            context(@"and the delete succeeds", ^{
                beforeEach(^{
                    SDLDeleteCommandResponse *deleteOld1 = [[SDLDeleteCommandResponse alloc] init];
                    deleteOld1.success = @YES;
                    deleteOld1.resultCode = SDLResultSuccess;

                    SDLDeleteCommandResponse *deleteOld2 = [[SDLDeleteCommandResponse alloc] init];
                    deleteOld2.success = @YES;
                    deleteOld2.resultCode = SDLResultSuccess;

                    [testConnectionManager respondToRequestWithResponse:deleteOld1 requestNumber:0 error:nil];
                    [testConnectionManager respondToRequestWithResponse:deleteOld2 requestNumber:1 error:nil];
                    [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                });

                it(@"should update the current voice commands", ^{
                    expect(callbackCurrentVoiceCommands).to(haveCount(0));
                    expect(callbackError).to(beNil());
                    expect(testConnectionManager.receivedRequests).to(haveCount(2));
                });
            });

            // and the delete fails
            context(@"and the delete fails", ^{
                beforeEach(^{
                    [testConnectionManager respondToRequestWithResponse:failDelete requestNumber:0 error:[NSError sdl_lifecycle_failedWithBadResult:SDLResultDisallowed info:nil]];
                    [testConnectionManager respondToRequestWithResponse:failDelete requestNumber:1 error:[NSError sdl_lifecycle_failedWithBadResult:SDLResultDisallowed info:nil]];
                    [testConnectionManager respondToLastMultipleRequestsWithSuccess:NO];
                });

                it(@"should update the current voice commands and attempt to send the adds", ^{
                    expect(callbackCurrentVoiceCommands).to(haveCount(2));
                    expect(callbackError).toNot(beNil());
                    expect(testConnectionManager.receivedRequests).to(haveCount(2));
                });
            });

            // and the delete partially fails
            context(@"and the delete partially fails", ^{
                beforeEach(^{
                    [testConnectionManager respondToRequestWithResponse:failDelete requestNumber:0 error:[NSError sdl_lifecycle_failedWithBadResult:SDLResultDisallowed info:nil]];
                    [testConnectionManager respondToRequestWithResponse:successDelete requestNumber:1 error:nil];
                    [testConnectionManager respondToLastMultipleRequestsWithSuccess:NO];
                });

                it(@"should update the current voice commands and attempt to send the adds", ^{
                    expect(callbackCurrentVoiceCommands).to(haveCount(1));
                    expect(callbackError).toNot(beNil());
                    expect(testConnectionManager.receivedRequests).to(haveCount(2));
                });
            });
        });

        context(@"if it has pending voice commands identical to old voice commands", ^{
            beforeEach(^{
                testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager pendingVoiceCommands:@[oldVoiceCommand1, oldVoiceCommand2] oldVoiceCommands:@[oldVoiceCommand1, oldVoiceCommand2] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {
                    callbackCurrentVoiceCommands = newCurrentVoiceCommands;
                    callbackError = error;
                }];
                [testOp start];
            });

            it(@"Should not delete or upload the voiceCommands", ^{
                expect(testConnectionManager.receivedRequests).to(haveCount(0));
                expect(callbackCurrentVoiceCommands).to(haveCount(2));
                expect(callbackError).to(beNil());
            });
        });

        context(@"if there is some common voice commands between pending and old but with less pending", ^{
            beforeEach(^{
                testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager pendingVoiceCommands:@[newVoiceCommand1] oldVoiceCommands:@[newVoiceCommand1, newVoiceCommand2] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {
                    callbackCurrentVoiceCommands = newCurrentVoiceCommands;
                    callbackError = error;
                }];
                [testOp start];
            });

            context(@"And the delete succeeds", ^{
                beforeEach(^{
                    SDLDeleteCommandResponse *deleteOld1 = [[SDLDeleteCommandResponse alloc] init];
                    deleteOld1.success = @YES;
                    deleteOld1.resultCode = SDLResultSuccess;

                    [testConnectionManager respondToRequestWithResponse:deleteOld1 requestNumber:0 error:nil];
                    [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                });

                it(@"Should only delete voiceCommands thats not in common", ^{
                    expect(callbackCurrentVoiceCommands).to(haveCount(1));
                    expect(callbackError).to(beNil());
                    expect(testConnectionManager.receivedRequests).to(haveCount(1));
                });
            });
        });

        context(@"if there is some common voice commands between pending and old but with more pending", ^{
            beforeEach(^{
                testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager pendingVoiceCommands:@[newVoiceCommand1, newVoiceCommand2] oldVoiceCommands:@[newVoiceCommand1] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {
                    callbackCurrentVoiceCommands = newCurrentVoiceCommands;
                    callbackError = error;
                }];
                [testOp start];
            });

            context(@"And the add succeeds", ^{
                beforeEach(^{
                    SDLAddCommandResponse *addNew1 = [[SDLAddCommandResponse alloc] init];
                    addNew1.success = @YES;
                    addNew1.resultCode = SDLResultSuccess;

                    [testConnectionManager respondToRequestWithResponse:addNew1 requestNumber:0 error:nil];
                    [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                });

                it(@"Should only upload the voiceCommand thats not in common and not delete anything", ^{
                    expect(callbackCurrentVoiceCommands).to(haveCount(2));
                    expect(callbackError).to(beNil());
                    expect(testConnectionManager.receivedRequests).to(haveCount(1));
                });
            });
        });

        context(@"if it has pending voice commands completely different from old voice commands", ^{
            beforeEach(^{
                testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager pendingVoiceCommands:@[newVoiceCommand1, newVoiceCommand2] oldVoiceCommands:@[oldVoiceCommand1, oldVoiceCommand2] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {
                    callbackCurrentVoiceCommands = newCurrentVoiceCommands;
                    callbackError = error;
                }];
                [testOp start];
            });

            context(@"The delete and add commands succeeds", ^{
                beforeEach(^{
                    SDLDeleteCommandResponse *deleteOld1 = [[SDLDeleteCommandResponse alloc] init];
                    deleteOld1.success = @YES;
                    deleteOld1.resultCode = SDLResultSuccess;

                    SDLDeleteCommandResponse *deleteOld2 = [[SDLDeleteCommandResponse alloc] init];
                    deleteOld2.success = @YES;
                    deleteOld2.resultCode = SDLResultSuccess;

                    [testConnectionManager respondToRequestWithResponse:deleteOld1 requestNumber:0 error:nil];
                    [testConnectionManager respondToRequestWithResponse:deleteOld2 requestNumber:1 error:nil];
                    [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                    SDLAddCommandResponse *addNew1 = [[SDLAddCommandResponse alloc] init];
                    addNew1.success = @YES;
                    addNew1.resultCode = SDLResultSuccess;

                    SDLAddCommandResponse *addNew2 = [[SDLAddCommandResponse alloc] init];
                    addNew2.success = @YES;
                    addNew2.resultCode = SDLResultSuccess;

                    [testConnectionManager respondToRequestWithResponse:addNew1 requestNumber:2 error:nil];
                    [testConnectionManager respondToRequestWithResponse:addNew2 requestNumber:3 error:nil];
                    [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                });

                it(@"Should delete and upload the voiceCommands", ^{
                    expect(callbackCurrentVoiceCommands).to(haveCount(2));
                    expect(callbackError).to(beNil());
                    expect(testConnectionManager.receivedRequests).to(haveCount(4));
                });
            });
        });

        context(@"if it doesn't have any voice commands to delete", ^{
            beforeEach(^{
                testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager pendingVoiceCommands:@[newVoiceCommand1, newVoiceCommand2] oldVoiceCommands:@[] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {
                    callbackCurrentVoiceCommands = newCurrentVoiceCommands;
                    callbackError = error;
                }];
                [testOp start];
            });

            context(@"adding voice commands", ^{
                context(@"and the add succeeds", ^{
                    beforeEach(^{
                        SDLAddCommandResponse *addNew1 = [[SDLAddCommandResponse alloc] init];
                        addNew1.success = @YES;
                        addNew1.resultCode = SDLResultSuccess;

                        SDLAddCommandResponse *addNew2 = [[SDLAddCommandResponse alloc] init];
                        addNew2.success = @YES;
                        addNew2.resultCode = SDLResultSuccess;

                        [testConnectionManager respondToRequestWithResponse:addNew1 requestNumber:0 error:nil];
                        [testConnectionManager respondToRequestWithResponse:addNew2 requestNumber:1 error:nil];
                        [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
                    });

                    it(@"should update the current voice commands", ^{
                        expect(callbackCurrentVoiceCommands).to(haveCount(2));
                        expect(callbackError).to(beNil());
                        expect(testConnectionManager.receivedRequests).to(haveCount(2));
                    });
                });

                context(@"and the add fails", ^{
                    beforeEach(^{
                        SDLAddCommandResponse *addNew1 = [[SDLAddCommandResponse alloc] init];
                        addNew1.success = @NO;
                        addNew1.resultCode = SDLResultDisallowed;

                        SDLAddCommandResponse *addNew2 = [[SDLAddCommandResponse alloc] init];
                        addNew2.success = @NO;
                        addNew2.resultCode = SDLResultDisallowed;

                        [testConnectionManager respondToRequestWithResponse:addNew1 requestNumber:0 error:[NSError sdl_lifecycle_failedWithBadResult:SDLResultDisallowed info:nil]];
                        [testConnectionManager respondToRequestWithResponse:addNew2 requestNumber:1 error:[NSError sdl_lifecycle_failedWithBadResult:SDLResultDisallowed info:nil]];
                        [testConnectionManager respondToLastMultipleRequestsWithSuccess:NO];
                    });

                    it(@"should update the current voice commands", ^{
                        expect(callbackCurrentVoiceCommands).to(haveCount(0));
                        expect(callbackError).toNot(beNil());
                        expect(testConnectionManager.receivedRequests).to(haveCount(2));
                    });
                });

                context(@"and the add partially fails", ^{
                    beforeEach(^{
                        SDLAddCommandResponse *addNew1 = [[SDLAddCommandResponse alloc] init];
                        addNew1.success = @NO;
                        addNew1.resultCode = SDLResultDisallowed;

                        SDLAddCommandResponse *addNew2 = [[SDLAddCommandResponse alloc] init];
                        addNew2.success = @YES;
                        addNew2.resultCode = SDLResultSuccess;

                        [testConnectionManager respondToRequestWithResponse:addNew1 requestNumber:0 error:[NSError sdl_lifecycle_failedWithBadResult:SDLResultDisallowed info:nil]];
                        [testConnectionManager respondToRequestWithResponse:addNew2 requestNumber:1 error:nil];
                        [testConnectionManager respondToLastMultipleRequestsWithSuccess:NO];
                    });

                    it(@"should update the current voice commands", ^{
                        expect(callbackCurrentVoiceCommands).to(haveCount(1));
                        expect(callbackError).toNot(beNil());
                        expect(testConnectionManager.receivedRequests).to(haveCount(2));
                    });
                });
            });
        });
    });

    // should test voiceCommandsInArray with pendingVoiceCommands being the same as oldVoiceCommands but fewer so that it should only delete
    it(@"should test voiceCommandsInArray with pendingVoiceCommands being the same as oldVoiceCommands but fewer so that it should only delete", ^{
        testOp = [[SDLVoiceCommandUpdateOperation alloc] init];
        NSArray<SDLVoiceCommand *> *voiceCommandsToDelete = [testOp.class sdl_voiceCommandsInArray:@[newVoiceCommand1, newVoiceCommand2] notInSecondArray:@[newVoiceCommand1]];

        NSArray<SDLVoiceCommand *> *voiceCommandsToAppend = [testOp.class sdl_voiceCommandsInArray:@[newVoiceCommand1] notInSecondArray:@[newVoiceCommand1, newVoiceCommand2]];

        expect(voiceCommandsToDelete).to(haveCount(1));
        expect(voiceCommandsToDelete.firstObject).to(equal(newVoiceCommand2));
        expect(voiceCommandsToAppend).to(haveCount(0));
    });

    // should test voiceCommandsInArray with identical pendingVoiceCommands and oldVoiceCommands
    it(@"should test voiceCommandsInArray with identical pendingVoiceCommands and oldVoiceCommands", ^{
        testOp = [[SDLVoiceCommandUpdateOperation alloc] init];
        NSArray<SDLVoiceCommand *> *voiceCommandsToDelete = [testOp.class sdl_voiceCommandsInArray:@[newVoiceCommand1, newVoiceCommand2] notInSecondArray:@[newVoiceCommand1, newVoiceCommand2]];

        expect(voiceCommandsToDelete).to(haveCount(0));
    });

    // should test voiceCommandsInArray with the pending voice commands being the same and a few more so that it should only add
    it(@"should test voiceCommandsInArray with the pending voice commands being the same and a few more so that it should only add", ^{
        testOp = [[SDLVoiceCommandUpdateOperation alloc] init];
        NSArray<SDLVoiceCommand *> *voiceCommandsToDelete = [testOp.class sdl_voiceCommandsInArray:@[newVoiceCommand1] notInSecondArray:@[newVoiceCommand1, newVoiceCommand2]];
        NSArray<SDLVoiceCommand *> *voiceCommandsToAppend = [testOp.class sdl_voiceCommandsInArray:@[newVoiceCommand1, newVoiceCommand2] notInSecondArray:@[newVoiceCommand1]];

        expect(voiceCommandsToDelete).to(haveCount(0));
        expect(voiceCommandsToAppend).to(haveCount(1));
    });

    // should delete all previous voice commands and upload all sent voice commands
    it(@"should delete all previous voice commands and upload all sent voice commands", ^{
        testOp = [[SDLVoiceCommandUpdateOperation alloc] init];
        NSArray<SDLVoiceCommand *> *voiceCommandsToDelete = [testOp.class sdl_voiceCommandsInArray:@[oldVoiceCommand1, oldVoiceCommand2] notInSecondArray:@[newVoiceCommand1, newVoiceCommand2]];
        NSArray<SDLVoiceCommand *> *voiceCommandsToAppend = [testOp.class sdl_voiceCommandsInArray:@[newVoiceCommand1, newVoiceCommand2] notInSecondArray:@[oldVoiceCommand1, oldVoiceCommand2]];

        expect(voiceCommandsToDelete).to(haveCount(2));
        expect(voiceCommandsToAppend).to(haveCount(2));
    });
});

QuickSpecEnd
