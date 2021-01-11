#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLDisplayCapabilities.h"
#import "SDLDisplayCapability.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLImage.h"
#import "SDLImageField.h"
#import "SDLMetadataTags.h"
#import "SDLOnHMIStatus.h"
#import "SDLPredefinedWindows.h"
#import "SDLPutFileResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLShow.h"
#import "SDLSystemCapability.h"
#import "SDLTemplateConfiguration.h"
#import "SDLTextAndGraphicManager.h"
#import "SDLTextAndGraphicState.h"
#import "SDLTextAndGraphicUpdateOperation.h"
#import "SDLTextField.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLWindowCapability.h"
#import "TestConnectionManager.h"

@interface SDLTextAndGraphicManager()

// Dependencies
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

@property (strong, nonatomic) SDLTextAndGraphicState *currentScreenData;

@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@property (strong, nonatomic, nullable) SDLWindowCapability *windowCapability;
@property (strong, nonatomic, nullable) SDLHMILevel currentLevel;

@property (strong, nonatomic) SDLArtwork *blankArtwork;

@property (assign, nonatomic) BOOL isDirty;

- (void)sdl_displayCapabilityDidUpdate;

@end

@interface SDLTextAndGraphicUpdateOperation ()

@property (copy, nonatomic, nullable) CurrentDataUpdatedHandler currentDataUpdatedHandler;
@property (strong, nonatomic) SDLTextAndGraphicState *updatedState;

@end

QuickSpecBegin(SDLTextAndGraphicManagerSpec)

describe(@"text and graphic manager", ^{
    __block SDLDisplayCapability *testDisplayCapability = nil;
    __block SDLWindowCapability *testWindowCapability = nil;
    __block SDLSystemCapability *testSystemCapability = nil;
    __block SDLOnHMIStatus *testHMIStatus = nil;

    __block SDLTextAndGraphicManager *testManager = nil;
    __block TestConnectionManager *mockConnectionManager = [[TestConnectionManager alloc] init];
    __block SDLFileManager *mockFileManager = nil;
    __block SDLSystemCapabilityManager *mockSystemCapabilityManager = nil;

    __block NSString *testString = @"some string";
    __block NSString *testArtworkName = @"some artwork name";
    __block SDLArtwork *testArtwork = [[SDLArtwork alloc] initWithData:[@"Test data" dataUsingEncoding:NSUTF8StringEncoding] name:testArtworkName fileExtension:@"png" persistent:NO];

    beforeEach(^{
        mockFileManager = OCMClassMock([SDLFileManager class]);
        mockSystemCapabilityManager = OCMClassMock([SDLSystemCapabilityManager class]);
        testManager = [[SDLTextAndGraphicManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager];
        [testManager start];
    });

    // should instantiate correctly
    it(@"should instantiate correctly", ^{
        expect(testManager.connectionManager).to(equal(mockConnectionManager));
        expect(testManager.fileManager).to(equal(mockFileManager));

        expect(testManager.textField1).to(beNil());
        expect(testManager.textField2).to(beNil());
        expect(testManager.textField3).to(beNil());
        expect(testManager.textField4).to(beNil());
        expect(testManager.mediaTrackTextField).to(beNil());
        expect(testManager.title).to(beNil());
        expect(testManager.primaryGraphic).to(beNil());
        expect(testManager.secondaryGraphic).to(beNil());
        expect(testManager.alignment).to(equal(SDLTextAlignmentCenter));
        expect(testManager.textField1Type).to(beNil());
        expect(testManager.textField2Type).to(beNil());
        expect(testManager.textField3Type).to(beNil());
        expect(testManager.textField4Type).to(beNil());

        expect(testManager.currentScreenData).toNot(beNil());
        expect(testManager.transactionQueue).toNot(beNil());
        expect(testManager.windowCapability).to(beNil());
        expect(testManager.currentLevel).to(equal(SDLHMILevelNone));
        expect(testManager.blankArtwork).toNot(beNil());
        expect(testManager.isDirty).to(beFalse());
    });

    // setting setters
    describe(@"setting setters", ^{
        beforeEach(^{
            testManager.currentLevel = SDLHMILevelFull;
        });

        // when in HMI NONE
        context(@"when in HMI NONE", ^{
            beforeEach(^{
                testManager.currentLevel = SDLHMILevelNone;
            });

            it(@"should set text field 1 but be suspended", ^{
                testManager.textField1 = testString;

                expect(testManager.textField1).to(equal(testString));
                expect(testManager.transactionQueue.isSuspended).to(beTrue());
                expect(testManager.transactionQueue.operationCount).to(equal(1));
            });
        });

        // when no HMI level has been received
        context(@"when no HMI level has been received", ^{
            beforeEach(^{
                testManager.currentLevel = nil;
            });

            it(@"should set text field 1 but be suspended", ^{
                testManager.textField1 = testString;

                expect(testManager.textField1).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.transactionQueue.isSuspended).to(beTrue());
            });
        });

        // when previous updates have bene cancelled
        context(@"when previous updates have bene cancelled", ^{
            beforeEach(^{
                testManager.textField1 = @"Hello";

                // This should cancel the first operation
                testManager.textField2 = @"Goodbye";
            });

            it(@"should properly queue the new update", ^{
                expect(testManager.transactionQueue.isSuspended).to(beTrue());
                expect(testManager.transactionQueue.operationCount).to(equal(2));
                expect(testManager.transactionQueue.operations[0].cancelled).to(beTrue());
            });
        });

        // while batching
        context(@"while batching", ^{
            beforeEach(^{
                testManager.batchUpdates = YES;
            });

            it(@"should set text field 1", ^{
                testManager.textField1 = testString;

                expect(testManager.textField1).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set text field 2", ^{
                testManager.textField2 = testString;

                expect(testManager.textField2).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set text field 3", ^{
                testManager.textField3 = testString;

                expect(testManager.textField3).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set text field 4", ^{
                testManager.textField4 = testString;

                expect(testManager.textField4).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set media track text field", ^{
                testManager.mediaTrackTextField = testString;

                expect(testManager.mediaTrackTextField).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set template title", ^{
                testManager.title = testString;

                expect(testManager.title).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set primary graphic", ^{
                testManager.primaryGraphic = testArtwork;

                expect(testManager.primaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set secondary graphic", ^{
                testManager.secondaryGraphic = testArtwork;

                expect(testManager.secondaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set the alignment", ^{
                testManager.alignment = SDLTextAlignmentLeft;

                expect(testManager.alignment).to(equal(SDLTextAlignmentLeft));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType1", ^{
                testManager.textField1Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField1Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType2", ^{
                testManager.textField2Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField2Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType3", ^{
                testManager.textField3Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField3Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType4", ^{
                testManager.textField4Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField4Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.transactionQueue.operationCount).to(equal(0));
                expect(testManager.isDirty).to(beTrue());
            });
        });

        // while not batching
        context(@"while not batching", ^{
            beforeEach(^{
                testManager.batchUpdates = NO;
            });

            it(@"should set text field 1", ^{
                testManager.textField1 = testString;

                expect(testManager.textField1).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set text field 2", ^{
                testManager.textField2 = testString;

                expect(testManager.textField2).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set text field 3", ^{
                testManager.textField3 = testString;

                expect(testManager.textField3).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set text field 4", ^{
                testManager.textField4 = testString;

                expect(testManager.textField4).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set media track text field", ^{
                testManager.mediaTrackTextField = testString;

                expect(testManager.mediaTrackTextField).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set template title text field", ^{
                testManager.title = testString;

                expect(testManager.title).to(equal(testString));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set primary graphic", ^{
                testManager.primaryGraphic = testArtwork;

                expect(testManager.primaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set secondary graphic", ^{
                testManager.secondaryGraphic = testArtwork;

                expect(testManager.secondaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set the alignment", ^{
                testManager.alignment = SDLTextAlignmentLeft;

                expect(testManager.alignment).to(equal(SDLTextAlignmentLeft));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType1", ^{
                testManager.textField1Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField1Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType2", ^{
                testManager.textField2Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField2Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType3", ^{
                testManager.textField3Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField3Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType4", ^{
                testManager.textField4Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField4Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.transactionQueue.operationCount).to(equal(1));
                expect(testManager.isDirty).to(beFalse());
            });
        });
    });

    // batching an update
    describe(@"batching an update", ^{
        NSString *textLine1 = @"line1";
        NSString *textLine2 = @"line2";
        NSString *textLine3 = @"line3";
        NSString *textLine4 = @"line4";
        NSString *textMediaTrack = @"line5";
        NSString *textTitle = @"title";

        SDLMetadataType line1Type = SDLMetadataTypeMediaTitle;
        SDLMetadataType line2Type = SDLMetadataTypeMediaAlbum;
        SDLMetadataType line3Type = SDLMetadataTypeMediaArtist;
        SDLMetadataType line4Type = SDLMetadataTypeMediaStation;

        beforeEach(^{
            testManager.currentLevel = SDLHMILevelFull;
            testManager.batchUpdates = YES;

            testManager.textField1 = textLine1;
            testManager.textField2 = textLine2;
            testManager.textField3 = textLine3;
            testManager.textField4 = textLine4;
            testManager.mediaTrackTextField = textMediaTrack;
            testManager.title = textTitle;
            testManager.textField1Type = line1Type;
            testManager.textField2Type = line2Type;
            testManager.textField3Type = line3Type;
            testManager.textField4Type = line4Type;
        });

        it(@"should wait until batching ends to create an update operation", ^{
            expect(testManager.transactionQueue.operationCount).to(equal(0));

            testManager.batchUpdates = NO;
            [testManager updateWithCompletionHandler:nil];
            expect(testManager.transactionQueue.operationCount).to(equal(1));
        });
    });

    // changing the layout
    describe(@"changing the layout", ^{
        // while not batching
        context(@"while not batching", ^{
            beforeEach(^{
                SDLTemplateConfiguration *testConfig = [[SDLTemplateConfiguration alloc] initWithTemplate:@"Test Template"];
                [testManager changeLayout:testConfig withCompletionHandler:nil];
            });

            it(@"should create and start the operation", ^{
                expect(testManager.transactionQueue.operationCount).to(equal(1));
            });
        });

        // while batching
        context(@"while batching", ^{
            beforeEach(^{
                testManager.batchUpdates = YES;
                SDLTemplateConfiguration *testConfig = [[SDLTemplateConfiguration alloc] initWithTemplate:@"Test Template"];
                [testManager changeLayout:testConfig withCompletionHandler:nil];
            });

            it(@"should not create and start the operation", ^{
                expect(testManager.transactionQueue.operationCount).to(equal(0));
            });
        });
    });

    // when the operation updates the current screen data
    describe(@"when the operation updates the current screen data", ^{
        __block SDLTextAndGraphicUpdateOperation *testOperation = nil;
        __block SDLTextAndGraphicUpdateOperation *testOperation2 = nil;

        beforeEach(^{
            testManager.textField1 = @"test";
            testManager.textField2 = @"test2";
            testOperation = testManager.transactionQueue.operations[0];
            testOperation2 = testManager.transactionQueue.operations[1];
        });

        // with good data
        context(@"with good data", ^{
            beforeEach(^{
                testOperation.currentDataUpdatedHandler(testOperation.updatedState, nil);
            });

            it(@"should update the manager's and pending operations' current screen data", ^{
                expect(testManager.currentScreenData).to(equal(testOperation.updatedState));
                expect(testOperation2.currentScreenData).to(equal(testOperation.updatedState));
            });
        });

        // with an error
        context(@"with an error", ^{
            beforeEach(^{
                testManager.currentScreenData = [[SDLTextAndGraphicState alloc] init];
                testManager.currentScreenData.textField1 = @"Test1";
                testOperation.currentDataUpdatedHandler(nil, [NSError errorWithDomain:@"any" code:1 userInfo:nil]);
            });

            it(@"should reset the manager's data", ^{
                expect(testManager.textField1).to(equal(testManager.currentScreenData.textField1));
            });
        });
    });

    // on HMI level update
    describe(@"on hmi level update", ^{
        beforeEach(^{
            testHMIStatus = [[SDLOnHMIStatus alloc] init];

            testWindowCapability = [[SDLWindowCapability alloc] initWithWindowID:@(SDLPredefinedWindowsDefaultWindow) textFields:nil imageFields:nil imageTypeSupported:nil templatesAvailable:nil numCustomPresetsAvailable:nil buttonCapabilities:nil softButtonCapabilities:nil menuLayoutsAvailable:nil dynamicUpdateCapabilities:nil];
            testDisplayCapability = [[SDLDisplayCapability alloc] initWithDisplayName:@"Test display" windowCapabilities:@[testWindowCapability] windowTypeSupported:nil];

            OCMExpect([mockSystemCapabilityManager defaultMainWindowCapability]).andReturn(testWindowCapability);
            [testManager sdl_displayCapabilityDidUpdate];
        });

        // with a non-default window
        context(@"with a non-default window", ^{
            beforeEach(^{
                testHMIStatus.hmiLevel = SDLHMILevelFull;
                testHMIStatus.windowID = @435;

                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:testHMIStatus];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should not alter the current level or update the queue's suspension", ^{
                expect(testManager.currentLevel).toNot(equal(SDLHMILevelFull));
                expect(testManager.transactionQueue.suspended).to(beTrue());
            });
        });

        // with HMI NONE
        context(@"with HMI NONE", ^{
            beforeEach(^{
                testHMIStatus.hmiLevel = SDLHMILevelNone;
                testHMIStatus.windowID = @(SDLPredefinedWindowsDefaultWindow);

                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:testHMIStatus];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should not alter the current level or update the queue's suspension", ^{
                expect(testManager.currentLevel).to(equal(SDLHMILevelNone));
                expect(testManager.transactionQueue.suspended).to(beTrue());
            });
        });

        // with HMI BACKGROUND
        context(@"with HMI BACKGROUND", ^{
            beforeEach(^{
                testHMIStatus.hmiLevel = SDLHMILevelBackground;
                testHMIStatus.windowID = @(SDLPredefinedWindowsDefaultWindow);

                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:testHMIStatus];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should alter the current level and update the queue's suspension", ^{
                expect(testManager.currentLevel).to(equal(SDLHMILevelBackground));
                expect(testManager.transactionQueue.suspended).to(beFalse());
            });
        });
    });

    // on display capability update
    describe(@"on display capability update", ^{
        beforeEach(^{
            testHMIStatus = [[SDLOnHMIStatus alloc] init];
            testHMIStatus.windowID = @(SDLPredefinedWindowsDefaultWindow);
            testHMIStatus.hmiLevel = SDLHMILevelFull;
            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:nil rpcNotification:testHMIStatus];
            [[NSNotificationCenter defaultCenter] postNotification:notification];

            testWindowCapability = [[SDLWindowCapability alloc] initWithWindowID:@(SDLPredefinedWindowsDefaultWindow) textFields:nil imageFields:nil imageTypeSupported:nil templatesAvailable:nil numCustomPresetsAvailable:nil buttonCapabilities:nil softButtonCapabilities:nil menuLayoutsAvailable:nil dynamicUpdateCapabilities:nil];
            testDisplayCapability = [[SDLDisplayCapability alloc] initWithDisplayName:@"Test display" windowCapabilities:@[testWindowCapability] windowTypeSupported:nil];
            testSystemCapability = [[SDLSystemCapability alloc] initWithDisplayCapabilities:@[testDisplayCapability]];
        });

        it(@"should start the transaction queue and not send a transaction", ^{
            OCMExpect([mockSystemCapabilityManager defaultMainWindowCapability]).andReturn(testWindowCapability);
            [testManager sdl_displayCapabilityDidUpdate];

            expect(testManager.transactionQueue.isSuspended).to(beFalse());
            expect(testManager.transactionQueue.operationCount).to(equal(0));
        });

        context(@"if there's data", ^{
            beforeEach(^{
                testManager.textField1 = @"test";
                OCMExpect([mockSystemCapabilityManager defaultMainWindowCapability]).andReturn(testWindowCapability);
                [testManager sdl_displayCapabilityDidUpdate];
            });

            it(@"should send an update and not supersede the previous update", ^{
                expect(testManager.transactionQueue.isSuspended).to(beFalse());
                expect(testManager.transactionQueue.operationCount).to(equal(2));
                expect(testManager.transactionQueue.operations[0].isCancelled).to(beFalse());
            });
        });
    });

    // on disconnect
    describe(@"on disconnect", ^{
        beforeEach(^{
            [testManager stop];
        });

        it(@"should reset correctly", ^{
            expect(testManager.connectionManager).to(equal(mockConnectionManager));
            expect(testManager.fileManager).to(equal(mockFileManager));

            expect(testManager.textField1).to(beNil());
            expect(testManager.textField2).to(beNil());
            expect(testManager.textField3).to(beNil());
            expect(testManager.textField4).to(beNil());
            expect(testManager.mediaTrackTextField).to(beNil());
            expect(testManager.primaryGraphic).to(beNil());
            expect(testManager.secondaryGraphic).to(beNil());
            expect(testManager.alignment).to(equal(SDLTextAlignmentCenter));
            expect(testManager.textField1Type).to(beNil());
            expect(testManager.textField2Type).to(beNil());
            expect(testManager.textField3Type).to(beNil());
            expect(testManager.textField4Type).to(beNil());

            expect(testManager.currentScreenData).toNot(beNil());
            expect(testManager.windowCapability).to(beNil());
            expect(testManager.currentLevel).to(equal(SDLHMILevelNone));
            expect(testManager.blankArtwork).toNot(beNil());
            expect(testManager.isDirty).to(beFalse());
        });
    });
});

QuickSpecEnd
