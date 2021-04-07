#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

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

- (BOOL)sdl_arePendingVoiceCommandsUnique:(NSArray<SDLVoiceCommand *> *)voiceCommands;

@end

UInt32 const VoiceCommandIdMin = 1900000000;

QuickSpecBegin(SDLVoiceCommandManagerSpec)

describe(@"voice command manager", ^{
    __block SDLVoiceCommandManager *testManager = nil;
    __block TestConnectionManager *mockConnectionManager = nil;

    __block SDLVoiceCommand *testVoiceCommand = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"Test 1"] handler:^{}];
    __block SDLVoiceCommand *testVoiceCommand2 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"Test 2"] handler:^{}];
    __block SDLVoiceCommand *testVoiceCommand3 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"Test 1", @"Test 2"] handler:^{}];
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

    // updating voice commands
    describe(@"when voice commands are set", ^{
        beforeEach(^{
            newHMIStatus.hmiLevel = SDLHMILevelFull;
            newHMIStatus.windowID = @(SDLPredefinedWindowsDefaultWindow);

            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:newHMIStatus];
            [[NSNotificationCenter defaultCenter] postNotification:notification];

            testManager.voiceCommands = testVCArray;
        });

        // should properly update a command
        it(@"should properly update a command", ^{
            expect(testManager.voiceCommands.firstObject.commandId).to(equal(VoiceCommandIdMin));
            expect(testManager.transactionQueue.isSuspended).to(beFalse());
            expect(testManager.transactionQueue.operations).to(haveCount(1));
        });

        // when new voice commands is identical to the existing ones
        describe(@"when new voice commands is identical to the existing ones", ^{
            beforeEach(^{
                testManager.voiceCommands = testVCArray;
            });

            // should only have one operation
            it(@"should only have one operation", ^{
                expect(testManager.transactionQueue.operations).to(haveCount(1));
            });
        });

        // when new voice commands are set
        describe(@"when new voice commands are set", ^{
            beforeEach(^{
                testManager.voiceCommands = @[testVoiceCommand2];
            });

            // should queue another operation
            it(@"should queue another operation", ^{
                expect(testManager.transactionQueue.operations).to(haveCount(2));
            });

            // when the first operation finishes and updates the current voice commands
            describe(@"when the first operation finishes and updates the current voice commands", ^{
                beforeEach(^{
                    SDLVoiceCommandUpdateOperation *firstOp = testManager.transactionQueue.operations[0];
                    firstOp.currentVoiceCommands = [@[testVoiceCommand2] mutableCopy];
                    [firstOp finishOperation];

                    [NSThread sleepForTimeInterval:0.5];
                });

                it(@"should update the second operation", ^{
                    expect(((SDLVoiceCommandUpdateOperation *)testManager.transactionQueue.operations.firstObject).oldVoiceCommands.firstObject).withTimeout(3.0).toEventually(equal(testVoiceCommand2));
                });
            });
        });

        // updating voice commands with duplicate string in different voice commands
        describe(@"when new voice commands are set and have duplicate strings in different voice commands", ^{
            beforeEach(^{
                testManager.voiceCommands = @[testVoiceCommand2, testVoiceCommand3];
            });

            // should queue another operation
            fit(@"should only have one operation", ^{
                expect(testManager.transactionQueue.operations).to(haveCount(1));
                expect(testManager.sdl_arePendingVoiceCommandsUnique:@[testVoiceCommand2, testVoiceCommand3]).to(equal(NO));
            });
        });
    });

    // on disconnect
    context(@"on disconnect", ^{
        beforeEach(^{
            [testManager stop];
        });

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
