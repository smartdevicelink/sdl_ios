#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLDisplayCapabilities.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLImage.h"
#import "SDLImageField.h"
#import "SDLMetadataTags.h"
#import "SDLPutFileResponse.h"
#import "SDLShow.h"
#import "SDLTextAndGraphicManager.h"
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

@property (strong, nonatomic) SDLShow *currentScreenData;

@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@property (strong, nonatomic, nullable) SDLWindowCapability *windowCapability;
@property (strong, nonatomic, nullable) SDLHMILevel currentLevel;

@property (strong, nonatomic) SDLArtwork *blankArtwork;

@property (assign, nonatomic) BOOL isDirty;

- (void)sdl_displayCapabilityDidUpdate:(SDLSystemCapability *)systemCapability;

@end

QuickSpecBegin(SDLTextAndGraphicManagerSpec)

describe(@"text and graphic manager", ^{
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

        expect(testManager.currentScreenData).to(equal([[SDLShow alloc] init]));
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

        fit(@"should wait until batching ends to create an update operation", ^{
            expect(testManager.transactionQueue.operationCount).to(equal(0));

            testManager.batchUpdates = NO;
            [testManager updateWithCompletionHandler:nil];
            expect(testManager.transactionQueue.operationCount).to(equal(1));
        });
    });

    // on disconnect
    context(@"on disconnect", ^{
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

            expect(testManager.currentScreenData).to(equal([[SDLShow alloc] init]));
            expect(testManager.windowCapability).to(beNil());
            expect(testManager.currentLevel).to(equal(SDLHMILevelNone));
            expect(testManager.blankArtwork).toNot(beNil());
            expect(testManager.isDirty).to(beFalse());
        });
    });
});

QuickSpecEnd
