#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLArtwork.h"
#import "SDLDisplayCapabilities.h"
#import "SDLDisplayCapability.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLImage.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSoftButtonManager.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonReplaceOperation.h"
#import "SDLSoftButtonState.h"
#import "SDLSoftButtonTransitionOperation.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLWindowCapability.h"
#import "TestConnectionManager.h"

@interface SDLSoftButtonObject()

@property (assign, nonatomic) NSUInteger buttonId;
@property (weak, nonatomic) SDLSoftButtonManager *manager;

@end

@interface SDLSoftButtonManager()

@property (strong, nonatomic) NSArray<SDLSoftButton *> *currentSoftButtons;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@property (strong, nonatomic, nullable) SDLSoftButtonCapabilities *softButtonCapabilities;
@property (copy, nonatomic, nullable) SDLHMILevel currentLevel;

@property (strong, nonatomic) NSMutableArray<SDLAsynchronousOperation *> *batchQueue;

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification;
- (void)sdl_displayCapabilityDidUpdate:(SDLSystemCapability *)systemCapability;

@end

QuickSpecBegin(SDLSoftButtonManagerSpec)

describe(@"a soft button manager", ^{
    __block SDLSoftButtonManager *testManager = nil;

    __block SDLFileManager *testFileManager = nil;
    __block SDLSystemCapabilityManager *testSystemCapabilityManager = nil;
    __block TestConnectionManager *testConnectionManager = nil;

    __block SDLSoftButtonObject *testObject1 = nil;
    __block NSString *object1Name = @"O1 Name";
    __block NSString *object1State1Name = @"O1S1 Name";
    __block NSString *object1State2Name = @"O1S2 Name";
    __block NSString *object1State1Text = @"O1S1 Text";
    __block NSString *object1State2Text = @"O1S2 Text";
    __block SDLSoftButtonState *object1State1 = [[SDLSoftButtonState alloc] initWithStateName:object1State1Name text:object1State1Text artwork:nil];
    __block SDLSoftButtonState *object1State2 = [[SDLSoftButtonState alloc] initWithStateName:object1State2Name text:object1State2Text artwork:nil];

    __block SDLSoftButtonObject *testObject2 = nil;
    __block NSString *object2Name = @"O2 Name";
    __block NSString *object2State1Name = @"O2S1 Name";
    __block NSString *object2State1Text = @"O2S1 Text";
    __block NSString *object2State1ArtworkName = @"O2S1 Artwork";
    __block SDLArtwork *object2State1Art = [[SDLArtwork alloc] initWithData:[@"TestData" dataUsingEncoding:NSUTF8StringEncoding] name:object2State1ArtworkName fileExtension:@"png" persistent:YES];
    __block SDLSoftButtonState *object2State1 = [[SDLSoftButtonState alloc] initWithStateName:object2State1Name text:object2State1Text artwork:object2State1Art];

    beforeEach(^{
        testFileManager = OCMClassMock([SDLFileManager class]);
        testSystemCapabilityManager = OCMClassMock([SDLSystemCapabilityManager class]);
        testConnectionManager = [[TestConnectionManager alloc] init];

        testManager = [[SDLSoftButtonManager alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager systemCapabilityManager:testSystemCapabilityManager];
        [testManager start];

        SDLOnHMIStatus *status = [[SDLOnHMIStatus alloc] init];
        status.hmiLevel = SDLHMILevelFull;
        [testManager sdl_hmiStatusNotification:[[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:status]];

        SDLSoftButtonCapabilities *softButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
        softButtonCapabilities.imageSupported = @YES;
        softButtonCapabilities.textSupported = @YES;
        softButtonCapabilities.longPressAvailable = @YES;
        softButtonCapabilities.shortPressAvailable = @YES;

        SDLWindowCapability *windowCapability = [[SDLWindowCapability alloc] init];
        windowCapability.softButtonCapabilities = @[softButtonCapabilities];
        SDLDisplayCapability *displayCapability = [[SDLDisplayCapability alloc] initWithDisplayName:@"TEST" windowCapabilities:@[windowCapability] windowTypeSupported:nil];
        [testManager sdl_displayCapabilityDidUpdate:[[SDLSystemCapability alloc] initWithDisplayCapabilities:@[displayCapability]]];
    });

    it(@"should instantiate correctly", ^{
        expect(testManager.connectionManager).to(equal(testConnectionManager));
        expect(testManager.fileManager).to(equal(testFileManager));

        expect(testManager.softButtonObjects).to(beEmpty());
        expect(testManager.currentMainField1).to(beNil());
        expect(testManager.transactionQueue).toNot(beNil());
        expect(testManager.transactionQueue.isSuspended).to(beFalse());
        expect(testManager.softButtonCapabilities).toNot(beNil());
        expect(testManager.currentLevel).to(equal(SDLHMILevelFull));

        // These are set up earlier for future tests and therefore won't be nil
//        expect(testManager.windowCapability).to(beNil());
//        expect(testManager.currentLevel).to(beNil());
    });

    context(@"when in HMI NONE", ^{
        beforeEach(^{
            SDLOnHMIStatus *status = [[SDLOnHMIStatus alloc] init];
            status.hmiLevel = SDLHMILevelNone;
            [testManager sdl_hmiStatusNotification:[[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:status]];

            testObject1 = [[SDLSoftButtonObject alloc] initWithName:@"name1" states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
            testObject2 = [[SDLSoftButtonObject alloc] initWithName:@"name2" state:object2State1 handler:nil];

            testManager.softButtonObjects = @[testObject1, testObject2];
        });

        it(@"should set the soft buttons, but not update", ^{
            expect(testManager.softButtonObjects).toNot(beEmpty());
            expect(testManager.transactionQueue.suspended).to(beTrue());
        });
    });

    context(@"when there are no soft button capabilities", ^{
        beforeEach(^{
            SDLWindowCapability *windowCapability = [[SDLWindowCapability alloc] init];
            SDLDisplayCapability *displayCapability = [[SDLDisplayCapability alloc] initWithDisplayName:@"TEST" windowCapabilities:@[windowCapability] windowTypeSupported:nil];
            [testManager sdl_displayCapabilityDidUpdate:[[SDLSystemCapability alloc] initWithDisplayCapabilities:@[displayCapability]]];
        });

        it(@"should set the buttons but have the queue suspended", ^{
            expect(testManager.softButtonObjects).toNot(beNil());
            expect(testManager.transactionQueue.isSuspended).to(beTrue());
        });
    });

    context(@"when button objects have the same name", ^{
        beforeEach(^{
            NSString *sameName = @"Same name";
            testObject1 = [[SDLSoftButtonObject alloc] initWithName:sameName states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
            testObject2 = [[SDLSoftButtonObject alloc] initWithName:sameName state:object2State1 handler:nil];

            testManager.softButtonObjects = @[testObject1, testObject2];
        });

        it(@"should fail to set the buttons", ^{
            expect(testManager.softButtonObjects).to(beEmpty());
        });
    });

    context(@"when button objects have different names", ^{
        beforeEach(^{
            testObject1 = [[SDLSoftButtonObject alloc] initWithName:object1Name states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
            testObject2 = [[SDLSoftButtonObject alloc] initWithName:object2Name state:object2State1 handler:nil];

            testManager.softButtonObjects = @[testObject1, testObject2];

            [NSThread sleepForTimeInterval:0.5];
        });

        it(@"should set soft buttons correctly", ^{
            expect(testManager.softButtonObjects).toNot(beNil());
            expect(testObject1.buttonId).to(equal(0));
            expect(testObject2.buttonId).to(equal(100));
            expect(testObject1.manager).to(equal(testManager));
            expect(testObject2.manager).to(equal(testManager));

            // One replace operation
            expect(testManager.transactionQueue.operationCount).to(equal(1));
        });

        it(@"should replace earlier operations when a replace operation is entered", ^{
            [testObject1 transitionToNextState];
            testManager.softButtonObjects = @[testObject1];
            expect(testManager.transactionQueue.operationCount).to(equal(3));
            expect(testManager.transactionQueue.operations[0].isCancelled).to(beTrue());
            expect(testManager.transactionQueue.operations[1].isCancelled).to(beTrue());
            expect(testManager.transactionQueue.operations[2].isCancelled).to(beFalse());
        });

        it(@"should retrieve soft buttons correctly", ^{
            expect([testManager softButtonObjectNamed:object1Name].name).to(equal(object1Name));
        });

        describe(@"while batching", ^{
            beforeEach(^{
                testManager.batchUpdates = YES;

                [testObject1 transitionToNextState];
                [testObject2 transitionToNextState];
                testManager.softButtonObjects = @[testObject2, testObject1];
            });

            it(@"should properly queue the batching updates", ^{
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.batchQueue).to(haveCount(1));
            });
        });

        context(@"when the HMI level is now NONE", ^{
            beforeEach(^{
                SDLOnHMIStatus *status = [[SDLOnHMIStatus alloc] init];
                status.hmiLevel = SDLHMILevelNone;
                [testManager sdl_hmiStatusNotification:[[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:status]];
            });

            it(@"should not transition buttons", ^{
                [testObject1 transitionToNextState];

                expect(testManager.transactionQueue.suspended).to(beTrue());
                expect(testManager.transactionQueue.operationCount).to(equal(2)); // Replace and transition
            });
        });
    });

    describe(@"transitioning soft button states", ^{
        beforeEach(^{
            testObject1 = [[SDLSoftButtonObject alloc] initWithName:object1Name states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
            testObject2 = [[SDLSoftButtonObject alloc] initWithName:object2Name state:object2State1 handler:nil];

            testManager.softButtonObjects = @[testObject1, testObject2];
        });

        context(@"when batching", ^{
            beforeEach(^{
                testManager.batchUpdates = YES;

                SDLSoftButtonReplaceOperation *replaceOp = [[SDLSoftButtonReplaceOperation alloc] init];
                SDLSoftButtonTransitionOperation *transitionOp = [[SDLSoftButtonTransitionOperation alloc] init];
                testManager.batchQueue = [NSMutableArray arrayWithArray:@[replaceOp, transitionOp]];

                [testObject1 transitionToStateNamed:object1State2Name];
            });

            it(@"should batch queue the update and remove the old transition operation", ^{
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.batchQueue.count).to(equal(2));
            });
        });

        context(@"when not batching", ^{
            beforeEach(^{
                testManager.batchUpdates = NO;
            });

            it(@"should queue an update", ^{
                [testObject1 transitionToStateNamed:object1State2Name];

                expect(testManager.transactionQueue.operationCount).to(equal(2)); // Replace and transition
            });
        });
    });

    context(@"On disconnects", ^{
        beforeEach(^{
            [testManager stop];
        });

        it(@"should reset correctly", ^{
            expect(testManager.connectionManager).to(equal(testConnectionManager));
            expect(testManager.fileManager).to(equal(testFileManager));

            expect(testManager.softButtonObjects).to(beEmpty());
            expect(testManager.currentMainField1).to(beNil());
            expect(testManager.transactionQueue.operationCount).to(equal(0));
            expect(testManager.currentLevel).to(beNil());
            expect(testManager.softButtonCapabilities).to(beNil());
        });
    });
});

QuickSpecEnd
