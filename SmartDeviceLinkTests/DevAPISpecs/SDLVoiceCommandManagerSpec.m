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

@interface SDLVoiceCommand()

@property (assign, nonatomic) UInt32 commandId;

@end

@interface SDLVoiceCommandManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (copy, nonatomic, nullable) SDLHMILevel currentLevel;

@property (assign, nonatomic) UInt32 lastVoiceCommandId;
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *currentVoiceCommands;

@end

UInt32 const VoiceCommandIdMin = 1900000000;

QuickSpecBegin(SDLVoiceCommandManagerSpec)

describe(@"voice command manager", ^{
    __block SDLVoiceCommandManager *testManager = nil;
    __block TestConnectionManager *mockConnectionManager = nil;

    __block SDLVoiceCommand *testVoiceCommand = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"Test 1"] handler:^{}];
    __block SDLOnHMIStatus *newHMIStatus = [[SDLOnHMIStatus alloc] init];

    beforeEach(^{
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
    describe(@"updating voice commands", ^{
        beforeEach(^{
            newHMIStatus.hmiLevel = SDLHMILevelFull;
            newHMIStatus.windowID = @(SDLPredefinedWindowsDefaultWindow);

            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:newHMIStatus];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });

        it(@"should properly update a command", ^{
            testManager.voiceCommands = @[testVoiceCommand];

            expect(testManager.voiceCommands.firstObject.commandId).to(equal(VoiceCommandIdMin));
            expect(testManager.transactionQueue.isSuspended).to(beFalse());
            expect(testManager.transactionQueue.operationCount).to(equal(1));
        });

        describe(@"when the new voice commands is identical to the existing ones", ^{
            beforeEach(^{
                testManager.voiceCommands = @[testVoiceCommand];
                testManager.voiceCommands = @[testVoiceCommand];
            });

            it(@"should only have one operation", ^{
                expect(testManager.transactionQueue.operationCount).to(equal(1));
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
