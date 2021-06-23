#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLAddCommandResponse.h"
#import "SDLDeleteCommand.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLOnHMIStatus.h"
#import "SDLPredefinedWindows.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLVoiceCommand.h"
#import "SDLVoiceCommandManager.h"
#import "SDLVoiceCommandUpdateOperation.h"
#import "TestConnectionManager.h"

@interface SDLVoiceCommandUpdateOperation ()

@property (strong, nonatomic) NSMutableArray<SDLVoiceCommand *> *currentVoiceCommands;

@end

@interface SDLVoiceCommand()

@property (assign, nonatomic) UInt32 commandId;

@end

@interface SDLVoiceCommandManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (copy, nonatomic, nullable) SDLHMILevel currentLevel;

@property (assign, nonatomic) UInt32 lastVoiceCommandId;
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *currentVoiceCommands;

+ (BOOL)sdl_arePendingVoiceCommandsUnique:(NSArray<SDLVoiceCommand *> *)voiceCommands;

@end

UInt32 const VoiceCommandIdMin = 1900000000;

QuickSpecBegin(SDLVoiceCommandManagerSpec)

describe(@"voice command manager", ^{
    __block SDLVoiceCommandManager *testManager = nil;
    __block TestConnectionManager *mockConnectionManager = nil;

    __block SDLVoiceCommand *testVoiceCommand = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"Test 1"] handler:^{}];
    __block SDLVoiceCommand *testVoiceCommand2 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"Test 2"] handler:^{}];
    __block SDLVoiceCommand *testVoiceCommand3 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"Test 3", @" ", @"Test 4", @"\t"] handler:^{}];
    __block SDLVoiceCommand *testVoiceCommand4 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"\t"] handler:^{}];
    __block SDLVoiceCommand *testVoiceCommand5 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@""] handler:^{}];
    __block SDLVoiceCommand *testVoiceCommand6 = [[SDLVoiceCommand alloc] init];
    __block SDLVoiceCommand *testVoiceCommand7 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"Test 1", @"Test 2"] handler:^{}];
    __block SDLOnHMIStatus *newHMIStatus = [[SDLOnHMIStatus alloc] init];
    __block NSArray<SDLVoiceCommand *> *testVCArray = nil;

    beforeEach(^{
        testVCArray = @[testVoiceCommand];
        mockConnectionManager = [[TestConnectionManager alloc] init];
        testManager = [[SDLVoiceCommandManager alloc] initWithConnectionManager:mockConnectionManager];
    });

    // should instantiate correctly
    it(@"should instantiate correctly", ^{
        expect(testManager.connectionManager).to(equal(mockConnectionManager));
        expect(testManager.currentLevel).to(beNil());
        expect(testManager.voiceCommands).to(beEmpty());
        expect(testManager.lastVoiceCommandId).to(equal(VoiceCommandIdMin));
        expect(testManager.currentVoiceCommands).to(beEmpty());
        expect(testManager.transactionQueue).toNot(beNil());
    });

    // updating voice commands before HMI is ready
    describe(@"updating voice commands before HMI is ready", ^{

        // when in HMI NONE
        context(@"when in HMI NONE", ^{
            beforeEach(^{
                newHMIStatus.hmiLevel = SDLHMILevelNone;
                newHMIStatus.windowID = @(SDLPredefinedWindowsDefaultWindow);

                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:newHMIStatus];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should not update", ^{
                testManager.voiceCommands = @[testVoiceCommand];
                expect(testManager.transactionQueue.isSuspended).to(beTrue());
                expect(testManager.transactionQueue.operationCount).to(equal(1));
            });
        });

        // when no HMI level has been received
        context(@"when no HMI level has been received", ^{
            it(@"should not update", ^{
                testManager.voiceCommands = @[testVoiceCommand];
                expect(testManager.transactionQueue.isSuspended).to(beTrue());
                expect(testManager.transactionQueue.operationCount).to(equal(1));
            });
        });
    });

    // when the hmi is ready
    describe(@"when the hmi is ready", ^{
        beforeEach(^{
            newHMIStatus.hmiLevel = SDLHMILevelFull;
            newHMIStatus.windowID = @(SDLPredefinedWindowsDefaultWindow);

            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:newHMIStatus];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });

        // should update the transactionQueue's suspension to false
        it(@"should update the transactionQueue's suspension to false", ^{
            expect(testManager.transactionQueue.isSuspended).to(beFalse());
        });

        // when setting voiceCommands
        describe(@"when setting voiceCommands", ^{
            beforeEach(^{
                testManager.transactionQueue.suspended = YES;
                testManager.voiceCommands = testVCArray;
            });

            // should properly update a command
            it(@"should properly update a command", ^{
                expect(testManager.voiceCommands.firstObject.commandId).to(equal(VoiceCommandIdMin));
                expect(testManager.transactionQueue.operations).to(haveCount(1));
                expect(testManager.transactionQueue.operations.firstObject.isExecuting).to(beFalse());
            });

            // when new voice commands are identical to the existing ones
            describe(@"when new voice commands are identical to the existing ones", ^{
                beforeEach(^{
                    testManager.voiceCommands = testVCArray;
                });

                // should only have one operation
                it(@"should only have one operation", ^{
                    expect(testManager.transactionQueue.operations).to(haveCount(1));
                });
            });

            // when new voice commands are different from the existing ones
            describe(@"when new voice commands are different from the existing ones", ^{
                beforeEach(^{
                    testManager.voiceCommands = @[testVoiceCommand2];
                });

                it(@"should queue another operation", ^{
                    expect(testManager.transactionQueue.operations).to(haveCount(2));
                });

                // when the first operation finishes and updates the current voice commands
                describe(@"when the first operation finishes and updates the current voice commands", ^{
                    beforeEach(^{
                        testManager.transactionQueue.suspended = NO;

                        SDLVoiceCommandUpdateOperation *firstOp = testManager.transactionQueue.operations[0];
                        firstOp.currentVoiceCommands = [@[testVoiceCommand2] mutableCopy];
                        [firstOp finishOperation];
                    });

                    it(@"should update the second operation", ^{
                        expect(((SDLVoiceCommandUpdateOperation *)testManager.transactionQueue.operations.firstObject).oldVoiceCommands.firstObject).to(equal(testVoiceCommand2));
                    });
                });
            });

            // if any of the voice commands contains an empty string
            context(@"if any of the voice commands contains an empty string", ^{
                // should remove the empty strings and queue another operation
                it(@"should remove the empty strings and queue another operation", ^{
                    testManager.voiceCommands = @[testVoiceCommand2, testVoiceCommand3, testVoiceCommand4, testVoiceCommand5, testVoiceCommand6];
                    expect(testManager.transactionQueue.operations).to(haveCount(2));
                    expect(testManager.voiceCommands).to(haveCount(2));
                    expect(testManager.voiceCommands[0].voiceCommands).to(haveCount(1));
                    expect(testManager.voiceCommands[0].voiceCommands).to(equal(@[@"Test 2"]));
                    expect(testManager.voiceCommands[1].voiceCommands).to(haveCount(2));
                    expect(testManager.voiceCommands[1].voiceCommands).to(equal(@[@"Test 3", @"Test 4"]));
                });

                // should not queue another operation if all the voice command strings are empty strings
                it(@"should not queue another operation if all the voice command strings are empty strings", ^{
                    testManager.voiceCommands = @[testVoiceCommand4, testVoiceCommand5];
                    expect(testManager.transactionQueue.operations).to(haveCount(1));
                    expect(testManager.voiceCommands).to(haveCount(1));
                    expect(testManager.voiceCommands.firstObject.voiceCommands).to(haveCount(1));
                    expect(testManager.voiceCommands.firstObject.voiceCommands).to(equal(@[@"Test 1"]));
                });
            });

            // updating voice commands with duplicate string in different voice commands
            describe(@"when new voice commands are set and have duplicate strings in different voice commands", ^{
                beforeEach(^{
                    testManager.voiceCommands = @[testVoiceCommand2, testVoiceCommand7];
                });

                it(@"should only have one operation", ^{
                    expect(testManager.transactionQueue.operations).to(haveCount(1));
                    expect([testManager.class sdl_arePendingVoiceCommandsUnique:@[testVoiceCommand2, testVoiceCommand7]]).to(equal(NO));
                });
            });
        });
    });

    // on disconnect
    context(@"on disconnect", ^{
        beforeEach(^{
            [testManager stop];
        });

        // should reset correctly
        it(@"should reset correctly", ^{
            expect(testManager.connectionManager).to(equal(mockConnectionManager));
            expect(testManager.voiceCommands).to(beEmpty());
            expect(testManager.currentLevel).to(beNil());
            expect(testManager.lastVoiceCommandId).to(equal(VoiceCommandIdMin));
            expect(testManager.currentVoiceCommands).to(beEmpty());
        });
    });
});

QuickSpecEnd
