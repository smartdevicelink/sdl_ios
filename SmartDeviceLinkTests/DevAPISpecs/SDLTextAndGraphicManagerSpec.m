#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLDisplayCapabilities.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLImage.h"
#import "SDLMetadataTags.h"
#import "SDLShow.h"
#import "SDLTextAndGraphicManager.h"
#import "SDLTextField.h"
#import "TestConnectionManager.h"

@interface SDLTextAndGraphicManager()

// Dependencies
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (strong, nonatomic) SDLShow *currentScreenData;

@property (strong, nonatomic, nullable) SDLShow *inProgressUpdate;
@property (copy, nonatomic, nullable) SDLTextAndGraphicUpdateCompletionHandler inProgressHandler;

@property (strong, nonatomic, nullable) SDLShow *queuedImageUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (copy, nonatomic, nullable) SDLTextAndGraphicUpdateCompletionHandler queuedUpdateHandler;

@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;
@property (strong, nonatomic, nullable) SDLHMILevel currentLevel;

@property (strong, nonatomic) SDLArtwork *blankArtwork;
@property (strong, nonatomic) NSMutableDictionary<SDLFileName *, NSNumber<SDLUInt> *> *artworkUploadRetries;

@property (assign, nonatomic) BOOL isDirty;

@end

QuickSpecBegin(SDLTextAndGraphicManagerSpec)

describe(@"text and graphic manager", ^{
    __block SDLTextAndGraphicManager *testManager = nil;
    __block TestConnectionManager *mockConnectionManager = [[TestConnectionManager alloc] init];
    __block SDLFileManager *mockFileManager = nil;

    __block NSString *testString = @"some string";
    __block NSString *testArtworkName = @"some artwork name";
    __block SDLArtwork *testArtwork = [[SDLArtwork alloc] initWithData:[@"Test data" dataUsingEncoding:NSUTF8StringEncoding] name:testArtworkName fileExtension:@"png" persistent:NO];

    beforeEach(^{
        mockFileManager = OCMClassMock([SDLFileManager class]);
        testManager = [[SDLTextAndGraphicManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager];
    });

    it(@"should instantiate correctly", ^{
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
        expect(testManager.inProgressUpdate).to(beNil());
        expect(testManager.queuedImageUpdate).to(beNil());
        expect(testManager.hasQueuedUpdate).to(beFalse());
        expect(testManager.displayCapabilities).to(beNil());
        expect(testManager.currentLevel).to(equal(SDLHMILevelNone));
        expect(testManager.blankArtwork).toNot(beNil());
        expect(testManager.artworkUploadRetries).to(beEmpty());
        expect(testManager.isDirty).to(beFalse());
    });

    describe(@"setting setters", ^{
        beforeEach(^{
            testManager.currentLevel = SDLHMILevelFull;
        });

        context(@"when in HMI NONE", ^{
            beforeEach(^{
                testManager.currentLevel = SDLHMILevelNone;
            });

            it(@"should not set text field 1", ^{
                testManager.textField1 = testString;

                expect(testManager.textField1).to(equal(testString));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beFalse());
            });
        });

        context(@"when no HMI level has been received", ^{
            beforeEach(^{
                testManager.currentLevel = nil;
            });

            it(@"should not set text field 1", ^{
                testManager.textField1 = testString;

                expect(testManager.textField1).to(equal(testString));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beFalse());
            });
        });

        context(@"while batching", ^{
            beforeEach(^{
                testManager.batchUpdates = YES;
            });

            it(@"should set text field 1", ^{
                testManager.textField1 = testString;

                expect(testManager.textField1).to(equal(testString));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set text field 2", ^{
                testManager.textField2 = testString;

                expect(testManager.textField2).to(equal(testString));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set text field 3", ^{
                testManager.textField3 = testString;

                expect(testManager.textField3).to(equal(testString));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set text field 4", ^{
                testManager.textField4 = testString;

                expect(testManager.textField4).to(equal(testString));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set media track text field", ^{
                testManager.mediaTrackTextField = testString;

                expect(testManager.mediaTrackTextField).to(equal(testString));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set primary graphic", ^{
                testManager.primaryGraphic = testArtwork;

                expect(testManager.primaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set secondary graphic", ^{
                testManager.secondaryGraphic = testArtwork;

                expect(testManager.secondaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set the alignment", ^{
                testManager.alignment = SDLTextAlignmentLeft;

                expect(testManager.alignment).to(equal(SDLTextAlignmentLeft));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType1", ^{
                testManager.textField1Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField1Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType2", ^{
                testManager.textField2Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField2Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType3", ^{
                testManager.textField3Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField3Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType4", ^{
                testManager.textField4Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField4Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });
        });

        context(@"while not batching", ^{
            beforeEach(^{
                testManager.batchUpdates = NO;
            });

            it(@"should set text field 1", ^{
                testManager.textField1 = testString;

                expect(testManager.textField1).to(equal(testString));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set text field 2", ^{
                testManager.textField2 = testString;

                expect(testManager.textField2).to(equal(testString));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set text field 3", ^{
                testManager.textField3 = testString;

                expect(testManager.textField3).to(equal(testString));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set text field 4", ^{
                testManager.textField4 = testString;

                expect(testManager.textField4).to(equal(testString));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set media track text field", ^{
                testManager.mediaTrackTextField = testString;

                expect(testManager.mediaTrackTextField).to(equal(testString));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set primary graphic", ^{
                testManager.primaryGraphic = testArtwork;

                expect(testManager.primaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set secondary graphic", ^{
                testManager.secondaryGraphic = testArtwork;

                expect(testManager.secondaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set the alignment", ^{
                testManager.alignment = SDLTextAlignmentLeft;

                expect(testManager.alignment).to(equal(SDLTextAlignmentLeft));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType1", ^{
                testManager.textField1Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField1Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType2", ^{
                testManager.textField2Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField2Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType3", ^{
                testManager.textField3Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField3Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType4", ^{
                testManager.textField4Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField4Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });
        });
    });

    describe(@"batching an update", ^{
        NSString *textLine1 = @"line1";
        NSString *textLine2 = @"line2";
        NSString *textLine3 = @"line3";
        NSString *textLine4 = @"line4";
        NSString *textMediaTrack = @"line5";

        SDLMetadataType line1Type = SDLMetadataTypeMediaTitle;
        SDLMetadataType line2Type = SDLMetadataTypeMediaAlbum;
        SDLMetadataType line3Type = SDLMetadataTypeMediaArtist;
        SDLMetadataType line4Type = SDLMetadataTypeMediaStation;

        beforeEach(^{
            testManager.currentLevel = SDLHMILevelFull;
            testManager.batchUpdates = YES;

            testManager.textField1 = nil;
            testManager.textField2 = nil;
            testManager.textField3 = nil;
            testManager.textField4 = nil;
            testManager.mediaTrackTextField = nil;
            testManager.textField1Type = nil;
            testManager.textField2Type = nil;
            testManager.textField3Type = nil;
            testManager.textField4Type = nil;
        });

        context(@"with one line available", ^{
            beforeEach(^{
                testManager.displayCapabilities = [[SDLDisplayCapabilities alloc] init];
                SDLTextField *lineOneField = [[SDLTextField alloc] init];
                lineOneField.name = SDLTextFieldNameMainField1;
                testManager.displayCapabilities.textFields = @[lineOneField];
            });

            it(@"should set mediatrack properly", ^{
                testManager.mediaTrackTextField = textMediaTrack;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mediaTrack).to(equal(textMediaTrack));
                expect(testManager.inProgressUpdate.mainField1).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(beNil());
            });

            it(@"should format a one line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField1Type = line1Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                expect(testManager.inProgressUpdate.metadataTags.mainField1.firstObject).to(equal(line1Type));
                expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
            });

            it(@"should format a two line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@", textLine1, textLine2]));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[1]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
            });

            it(@"should format a three line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField3 = textLine3;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;
                testManager.textField3Type = line3Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@ - %@", textLine1, textLine2, textLine3]));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[1]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[2]).to(equal(line3Type));
                expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
            });

            it(@"should format a four line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField3 = textLine3;
                testManager.textField4 = textLine4;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;
                testManager.textField3Type = line3Type;
                testManager.textField4Type = line4Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@ - %@ - %@", textLine1, textLine2, textLine3, textLine4]));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[1]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[2]).to(equal(line3Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[3]).to(equal(line4Type));
                expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
            });
        });

        context(@"with two lines available", ^{
            beforeEach(^{
                testManager.displayCapabilities = [[SDLDisplayCapabilities alloc] init];
                SDLTextField *lineTwoField = [[SDLTextField alloc] init];
                lineTwoField.name = SDLTextFieldNameMainField2;
                testManager.displayCapabilities.textFields = @[lineTwoField];
            });

            it(@"should set mediatrack properly", ^{
                testManager.mediaTrackTextField = textMediaTrack;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mediaTrack).to(equal(textMediaTrack));
                expect(testManager.inProgressUpdate.mainField1).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(beNil());
            });

            it(@"should format a one line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField1Type = line1Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                expect(testManager.inProgressUpdate.metadataTags.mainField1.firstObject).to(equal(line1Type));
                expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
            });

            it(@"should format a two line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                expect(testManager.inProgressUpdate.metadataTags.mainField1.firstObject).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                expect(testManager.inProgressUpdate.mainField3).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField3).to(beNil());
            });

            it(@"should format a three line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField3 = textLine3;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;
                testManager.textField3Type = line3Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@", textLine1, textLine2]));
                expect(testManager.inProgressUpdate.mainField2).to(equal(textLine3));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[1]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(2));
                expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line3Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                expect(testManager.inProgressUpdate.mainField3).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField3).to(beNil());
            });

            it(@"should format a four line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField3 = textLine3;
                testManager.textField4 = textLine4;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;
                testManager.textField3Type = line3Type;
                testManager.textField4Type = line4Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@", textLine1, textLine2]));
                expect(testManager.inProgressUpdate.mainField2).to(equal([NSString stringWithFormat:@"%@ - %@", textLine3, textLine4]));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[1]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(2));
                expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line3Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField2[1]).to(equal(line4Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(2));
                expect(testManager.inProgressUpdate.mainField3).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField3).to(beNil());
            });
        });

        context(@"with three lines available", ^{
            beforeEach(^{
                testManager.displayCapabilities = [[SDLDisplayCapabilities alloc] init];
                SDLTextField *lineThreeField = [[SDLTextField alloc] init];
                lineThreeField.name = SDLTextFieldNameMainField3;
                testManager.displayCapabilities.textFields = @[lineThreeField];
            });

            it(@"should set mediatrack properly", ^{
                testManager.mediaTrackTextField = textMediaTrack;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mediaTrack).to(equal(textMediaTrack));
                expect(testManager.inProgressUpdate.mainField1).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(beNil());
            });

            it(@"should format a one line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField1Type = line1Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
            });

            it(@"should format a two line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                expect(testManager.inProgressUpdate.metadataTags.mainField1.firstObject).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                expect(testManager.inProgressUpdate.mainField3).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField3).to(beNil());
            });

            it(@"should format a three line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField3 = textLine3;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;
                testManager.textField3Type = line3Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                expect(testManager.inProgressUpdate.mainField3).to(equal(textLine3));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                expect(testManager.inProgressUpdate.metadataTags.mainField3[0]).to(equal(line3Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField3).to(haveCount(1));
                expect(testManager.inProgressUpdate.mainField4).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField4).to(beNil());
            });

            it(@"should format a four line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField3 = textLine3;
                testManager.textField4 = textLine4;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;
                testManager.textField3Type = line3Type;
                testManager.textField4Type = line4Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                expect(testManager.inProgressUpdate.mainField3).to(equal([NSString stringWithFormat:@"%@ - %@", textLine3, textLine4]));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                expect(testManager.inProgressUpdate.metadataTags.mainField3[0]).to(equal(line3Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField3[1]).to(equal(line4Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField3).to(haveCount(2));
                expect(testManager.inProgressUpdate.mainField4).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField4).to(beNil());
            });
        });

        context(@"with four lines available", ^{
            beforeEach(^{
                testManager.displayCapabilities = [[SDLDisplayCapabilities alloc] init];
                SDLTextField *lineFourField = [[SDLTextField alloc] init];
                lineFourField.name = SDLTextFieldNameMainField4;
                testManager.displayCapabilities.textFields = @[lineFourField];
            });

            it(@"should set mediatrack properly", ^{
                testManager.mediaTrackTextField = textMediaTrack;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mediaTrack).to(equal(textMediaTrack));
                expect(testManager.inProgressUpdate.mainField1).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(beNil());
            });

            it(@"should format a one line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField1Type = line1Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
            });

            it(@"should format a two line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                expect(testManager.inProgressUpdate.metadataTags.mainField1.firstObject).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                expect(testManager.inProgressUpdate.mainField3).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField3).to(beNil());
            });

            it(@"should format a three line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField3 = textLine3;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;
                testManager.textField3Type = line3Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                expect(testManager.inProgressUpdate.mainField3).to(equal(textLine3));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                expect(testManager.inProgressUpdate.metadataTags.mainField3[0]).to(equal(line3Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField3).to(haveCount(1));
                expect(testManager.inProgressUpdate.mainField4).to(beEmpty());
                expect(testManager.inProgressUpdate.metadataTags.mainField4).to(beNil());
            });

            it(@"should format a four line text and metadata update properly", ^{
                testManager.textField1 = textLine1;
                testManager.textField2 = textLine2;
                testManager.textField3 = textLine3;
                testManager.textField4 = textLine4;
                testManager.textField1Type = line1Type;
                testManager.textField2Type = line2Type;
                testManager.textField3Type = line3Type;
                testManager.textField4Type = line4Type;

                testManager.batchUpdates = NO;
                [testManager updateWithCompletionHandler:nil];

                expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                expect(testManager.inProgressUpdate.mainField3).to(equal(textLine3));
                expect(testManager.inProgressUpdate.mainField4).to(equal(textLine4));
                expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                expect(testManager.inProgressUpdate.metadataTags.mainField3[0]).to(equal(line3Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField3).to(haveCount(1));
                expect(testManager.inProgressUpdate.metadataTags.mainField4[0]).to(equal(line4Type));
                expect(testManager.inProgressUpdate.metadataTags.mainField4).to(haveCount(1));
            });
        });

        context(@"updating images", ^{
            beforeEach(^{
                testManager.batchUpdates = YES;
            });

            context(@"when the image is already on the head unit", ^{
                beforeEach(^{
                    OCMStub([mockFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);

                    testManager.primaryGraphic = testArtwork;
                    testManager.secondaryGraphic = testArtwork;
                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];
                });

                it(@"should immediately attempt to update", ^{
                    expect(testManager.inProgressUpdate.mainField1).to(equal(@""));
                    expect(testManager.inProgressUpdate.graphic.value).to(equal(testArtworkName));
                    expect(testManager.inProgressUpdate.secondaryGraphic.value).to(equal(testArtworkName));
                });
            });

            context(@"when the image is not on the head unit", ^{
                beforeEach(^{
                    OCMStub([mockFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);

                    testManager.primaryGraphic = testArtwork;
                    testManager.secondaryGraphic = testArtwork;
                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];
                });

                it(@"should immediately attempt to update without the images", ^{
                    expect(testManager.inProgressUpdate.mainField1).to(equal(@""));
                    expect(testManager.inProgressUpdate.graphic.value).to(beNil());
                    expect(testManager.inProgressUpdate.secondaryGraphic.value).to(beNil());
                    expect(testManager.queuedImageUpdate.graphic.value).to(equal(testArtworkName));
                    expect(testManager.queuedImageUpdate.secondaryGraphic.value).to(equal(testArtworkName));
                });
            });

            describe(@"When an image fails to upload to the remote", ^{
                __block SDLArtwork *testArtwork1 = nil;
                __block SDLArtwork *testArtwork2 = nil;

                beforeEach(^{
                    testArtwork1 = [[SDLArtwork alloc] initWithData:[@"Test data 1" dataUsingEncoding:NSUTF8StringEncoding] name:@"Test data 1" fileExtension:@"png" persistent:NO];
                    testArtwork2 = [[SDLArtwork alloc] initWithData:[@"Test data 2" dataUsingEncoding:NSUTF8StringEncoding] name:@"Test data 2" fileExtension:@"png" persistent:NO];
                });

                context(@"If both the primary and secondary images fail to upload", ^{
                    it(@"Should only attempt to re-upload the image a max of 3 times", ^{
                        testManager.primaryGraphic = testArtwork1;
                        testManager.secondaryGraphic = testArtwork2;
                        testManager.batchUpdates = NO;
                        testManager.artworkUploadRetries = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            @3, testArtwork1.name,
                                                            @3, testArtwork2.name,
                                                            nil];

                        OCMStub([mockFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);
                        [testManager updateWithCompletionHandler:nil];

                        expect(testManager.inProgressUpdate.graphic).to(beNil());
                        expect(testManager.inProgressUpdate.secondaryGraphic).to(beNil());
                        expect(testManager.queuedImageUpdate).to(beNil());
                    });
                });

                context(@"If both the primary and secondary images are uploaded successfully after several failed upload attempts", ^{
                    it(@"Should show the successfully uploaded graphics", ^{
                        testManager.primaryGraphic = testArtwork1;
                        testManager.secondaryGraphic = testArtwork2;
                        testManager.batchUpdates = NO;
                        testManager.artworkUploadRetries = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            @1, testArtwork1.name,
                                                            @2, testArtwork2.name,
                                                            nil];

                        OCMStub([mockFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);
                        [testManager updateWithCompletionHandler:nil];

                        expect(testManager.inProgressUpdate.graphic.value).to(equal(testArtwork1.name));
                        expect(testManager.inProgressUpdate.secondaryGraphic.value).to(equal(testArtwork2.name));
                        expect(testManager.queuedImageUpdate).to(beNil());
                    });
                });

                context(@"If one of the primary or secondary images fails to upload", ^{
                    it(@"Should show the primary graphic even if the secondary graphic upload fails", ^{
                        testManager.primaryGraphic = testArtwork1;
                        testManager.secondaryGraphic = testArtwork2;
                        testManager.batchUpdates = NO;
                        testManager.artworkUploadRetries = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            @3, testArtwork2.name,
                                                            nil];

                        OCMStub([mockFileManager hasUploadedFile:testArtwork1]).andReturn(YES);
                        OCMStub([mockFileManager hasUploadedFile:testArtwork2]).andReturn(NO);
                        [testManager updateWithCompletionHandler:nil];

                        expect(testManager.inProgressUpdate.graphic.value).to(equal(testArtwork1.name));
                        expect(testManager.inProgressUpdate.secondaryGraphic).to(beNil());
                        expect(testManager.queuedImageUpdate).to(beNil());
                    });

                    it(@"Should show the secondary graphic even if the primary graphic upload fails", ^{
                        testManager.primaryGraphic = testArtwork1;
                        testManager.secondaryGraphic = testArtwork2;
                        testManager.batchUpdates = NO;
                        testManager.artworkUploadRetries = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            @3, testArtwork1.name,
                                                            nil];

                        OCMStub([mockFileManager hasUploadedFile:testArtwork1]).andReturn(NO);
                        OCMStub([mockFileManager hasUploadedFile:testArtwork2]).andReturn(YES);
                        [testManager updateWithCompletionHandler:nil];

                        expect(testManager.inProgressUpdate.graphic).to(beNil());
                        expect(testManager.inProgressUpdate.secondaryGraphic.value).to(equal(testArtwork2.name));
                        expect(testManager.queuedImageUpdate).to(beNil());
                    });
                });

                context(@"If only one of the primary or secondary images is set", ^{
                    it(@"Should show the uploaded primary graphic even if the secondary graphic is not set", ^{
                        testManager.primaryGraphic = testArtwork1;
                        testManager.secondaryGraphic = nil;
                        testManager.batchUpdates = NO;
                        testManager.artworkUploadRetries = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            @1, testArtwork1.name,
                                                            nil];

                        OCMStub([mockFileManager hasUploadedFile:testArtwork1]).andReturn(YES);
                        [testManager updateWithCompletionHandler:nil];

                        expect(testManager.inProgressUpdate.graphic.value).to(equal(testArtwork1.name));
                        expect(testManager.inProgressUpdate.secondaryGraphic).to(beNil());
                        expect(testManager.queuedImageUpdate).to(beNil());
                    });


                    it(@"Should show the uploaded secondary graphic even if the primary graphic is not set", ^{
                        testManager.primaryGraphic = nil;
                        testManager.secondaryGraphic = testArtwork2;
                        testManager.batchUpdates = NO;
                        testManager.artworkUploadRetries = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                            @2, testArtwork2.name,
                                                            nil];

                        OCMStub([mockFileManager hasUploadedFile:testArtwork2]).andReturn(YES);
                        [testManager updateWithCompletionHandler:nil];

                        expect(testManager.inProgressUpdate.graphic).to(beNil());
                        expect(testManager.inProgressUpdate.secondaryGraphic.value).to(equal(testArtwork2.name));
                        expect(testManager.queuedImageUpdate).to(beNil());
                    });
                });
            });
        });
    });

    context(@"On disconnects", ^{
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
            expect(testManager.inProgressUpdate).to(beNil());
            expect(testManager.queuedImageUpdate).to(beNil());
            expect(testManager.hasQueuedUpdate).to(beFalse());
            expect(testManager.displayCapabilities).to(beNil());
            expect(testManager.currentLevel).to(equal(SDLHMILevelNone));
            expect(testManager.blankArtwork).toNot(beNil());
            expect(testManager.artworkUploadRetries).to(beEmpty());
            expect(testManager.isDirty).to(beFalse());
        });
    });
});

QuickSpecEnd
