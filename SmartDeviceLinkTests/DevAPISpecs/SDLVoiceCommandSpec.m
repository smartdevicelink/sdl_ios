#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLAddCommand.h"
#import "SDLDeleteCommand.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLVoiceCommand.h"
#import "SDLVoiceCommandManager.h"
#import "TestConnectionManager.h"

@interface SDLVoiceCommand()

@property (assign, nonatomic) UInt32 commandId;

@end

@interface SDLVoiceCommandManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (copy, nonatomic, nullable) SDLHMILevel currentLevel;

@property (strong, nonatomic, nullable) NSArray<SDLRPCRequest *> *inProgressUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (assign, nonatomic) BOOL waitingOnHMILevelUpdate;

@property (assign, nonatomic) UInt32 lastVoiceCommandId;
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *oldVoiceCommands;

@end

UInt32 const VoiceCommandIdMin = 1900000000;

QuickSpecBegin(SDLVoiceCommandSpec)

describe(@"voice command manager", ^{
    __block SDLVoiceCommandManager *testManager = nil;
    __block TestConnectionManager *mockConnectionManager = nil;

    __block SDLVoiceCommand *testVoiceCommand = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"Test 1"] handler:^{}];
    __block SDLVoiceCommand *testVoiceCommand2 = [[SDLVoiceCommand alloc] initWithVoiceCommands:@[@"Test 2"] handler:^{}];

    beforeEach(^{
        mockConnectionManager = [[TestConnectionManager alloc] init];
        testManager = [[SDLVoiceCommandManager alloc] initWithConnectionManager:mockConnectionManager];
    });

    it(@"should instantiate correctly", ^{
        expect(testManager.voiceCommands).to(beEmpty());
        expect(testManager.connectionManager).to(equal(mockConnectionManager));
        expect(testManager.currentLevel).to(beNil());
        expect(testManager.inProgressUpdate).to(beNil());
        expect(testManager.hasQueuedUpdate).to(beFalse());
        expect(testManager.waitingOnHMILevelUpdate).to(beFalse());
        expect(testManager.lastVoiceCommandId).to(equal(VoiceCommandIdMin));
        expect(testManager.oldVoiceCommands).to(beEmpty());
    });

    describe(@"updating voice commands before HMI is ready", ^{
        context(@"when in HMI NONE", ^{
            beforeEach(^{
                testManager.currentLevel = SDLHMILevelNone;
            });

            it(@"should not update", ^{
                testManager.voiceCommands = @[testVoiceCommand];
                expect(testManager.inProgressUpdate).to(beNil());
            });
        });

        context(@"when no HMI level has been received", ^{
            beforeEach(^{
                testManager.currentLevel = nil;
            });

            it(@"should not update", ^{
                testManager.voiceCommands = @[testVoiceCommand];
                expect(testManager.inProgressUpdate).to(beNil());
            });
        });
    });

    describe(@"updating voice commands", ^{
        beforeEach(^{
            testManager.currentLevel = SDLHMILevelFull;
        });

        it(@"should properly update a command", ^{
            testManager.voiceCommands = @[testVoiceCommand];

            NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLDeleteCommand class]];
            NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];
            expect(deletes).to(beEmpty());

            NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
            NSArray *add = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];
            expect(add).toNot(beEmpty());
        });

        context(@"when a menu already exists", ^{
            beforeEach(^{
                testManager.voiceCommands = @[testVoiceCommand];
            });

            it(@"should send deletes first", ^{
                testManager.voiceCommands = @[testVoiceCommand2];

                NSPredicate *deleteCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLDeleteCommand class]];
                NSArray *deletes = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:deleteCommandPredicate];

                NSPredicate *addCommandPredicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [SDLAddCommand class]];
                NSArray *adds = [[mockConnectionManager.receivedRequests copy] filteredArrayUsingPredicate:addCommandPredicate];

                expect(deletes).to(haveCount(1));
                expect(adds).to(haveCount(2));
            });
        });
    });
});

QuickSpecEnd
