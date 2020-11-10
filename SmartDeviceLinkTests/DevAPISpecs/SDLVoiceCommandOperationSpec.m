#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLAddCommand.h"
#import "SDLAddCommandResponse.h"
#import "SDLDeleteCommand.h"
#import "SDLDeleteCommandResponse.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLVoiceCommand.h"
#import "SDLVoiceCommandManager.h"
#import "SDLVoiceCommandUpdateOperation.h"
#import "TestConnectionManager.h"

@interface SDLVoiceCommand()

@property (assign, nonatomic) UInt32 commandId;

@end

QuickSpecBegin(SDLVoiceCommandOperationSpec)

describe(@"a voice command operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLVoiceCommandUpdateOperation *testOp = nil;

    __block SDLVoiceCommand *newVoiceCommand1 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"NewVC1"] handler:^{}];
    __block SDLVoiceCommand *newVoiceCommand2 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"NewVC2"] handler:^{}];
    __block SDLVoiceCommand *oldVoiceCommand1 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"OldVC1"] handler:^{}];
    __block SDLVoiceCommand *oldVoiceCommand2 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"OldVC2"] handler:^{}];

    __block NSError *callbackError = nil;
    __block NSArray<SDLVoiceCommand *> *callbackCurrentVoiceCommands = nil;

    beforeEach(^{
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
        testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager newVoiceCommands:@[] oldVoiceCommands:@[] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {
        }];

        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    // initializing the operation
    describe(@"initializing the operation", ^{
        testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager newVoiceCommands:@[newVoiceCommand1, newVoiceCommand2] oldVoiceCommands:@[oldVoiceCommand1, oldVoiceCommand2] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {}];

        expect(testOp.currentVoiceCommands).to(equal(@[oldVoiceCommand1, oldVoiceCommand2]));
    });

    // starting the operation
    describe(@"starting the operation", ^{

        // if it starts cancelled
        context(@"if it starts cancelled", ^{
            beforeEach(^{
                testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager newVoiceCommands:@[newVoiceCommand1, newVoiceCommand2] oldVoiceCommands:@[oldVoiceCommand1, oldVoiceCommand2] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {
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

        context(@"if it has voice commands to delete", ^{
            beforeEach(^{
                testOp = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:testConnectionManager newVoiceCommands:@[newVoiceCommand1, newVoiceCommand2] oldVoiceCommands:@[oldVoiceCommand1, oldVoiceCommand2] updateCompletionHandler:^(NSArray<SDLVoiceCommand *> * _Nonnull newCurrentVoiceCommands, NSError * _Nullable error) {
                    callbackCurrentVoiceCommands = newCurrentVoiceCommands;
                    callbackError = error;
                }];
                [testOp start];
            });

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
                });

                fit(@"should update the current voice commands and attempt to send the adds", ^{
                    expect(testOp.currentVoiceCommands).to(haveCount(0));
                    expect(testConnectionManager.receivedRequests).to(haveCount(4));
                });
            });

            context(@"and the delete fails", ^{

            });

            context(@"and the delete partially fails", ^{

            });
        });

        context(@"if it doesn't have any voice commands to delete", ^{
            context(@"adding voice commands", ^{
                context(@"and the add succeeds", ^{

                });

                context(@"and the add fails", ^{

                });

                context(@"and the add partially fails", ^{

                });
            });
        });
    });
});

QuickSpecEnd
