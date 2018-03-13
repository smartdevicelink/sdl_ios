#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLFileManager.h"
#import "SDLScreenManager.h"
#import "SDLShow.h"
#import "SDLSoftButtonManager.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"
#import "SDLTextAndGraphicManager.h"
#import "TestConnectionManager.h"

@interface SDLSoftButtonManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (strong, nonatomic, nullable) SDLShow *inProgressUpdate;

@end

@interface SDLTextAndGraphicManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (strong, nonatomic, nullable) SDLShow *inProgressUpdate;

@end

@interface SDLScreenManager()

@property (strong, nonatomic) SDLTextAndGraphicManager *textAndGraphicManager;
@property (strong, nonatomic) SDLSoftButtonManager *softButtonManager;

@end

QuickSpecBegin(SDLScreenManagerSpec)

describe(@"screen manager", ^{
    __block TestConnectionManager *mockConnectionManager = nil;
    __block SDLFileManager *mockFileManager = nil;
    __block SDLScreenManager *testScreenManager = nil;

    __block NSString *testString1 = @"test1";
    __block NSString *testString2 = @"test2";
    __block NSString *testString3 = @"test3";
    __block NSString *testString4 = @"test4";
    __block SDLTextAlignment testAlignment = SDLTextAlignmentRight;
    __block SDLMetadataType testMetadataType1 = SDLMetadataTypeMediaTitle;
    __block SDLMetadataType testMetadataType2 = SDLMetadataTypeMediaAlbum;
    __block SDLMetadataType testMetadataType3 = SDLMetadataTypeMediaArtist;
    __block SDLMetadataType testMetadataType4 = SDLMetadataTypeMediaStation;
    __block NSString *testArtworkName = @"some artwork name";
    __block SDLArtwork *testArtwork = [[SDLArtwork alloc] initWithData:[@"Test data" dataUsingEncoding:NSUTF8StringEncoding] name:testArtworkName fileExtension:@"png" persistent:NO];

    __block NSString *testSBObjectName = @"test sb object";
    __block NSString *testSBStateName = @"test sb state";
    __block NSString *testSBStateText = @"test sb text";
    __block SDLSoftButtonState *testSBState = [[SDLSoftButtonState alloc] initWithStateName:testSBStateName text:testSBStateText image:nil];
    __block SDLSoftButtonObject *testSBObject = [[SDLSoftButtonObject alloc] initWithName:testSBObjectName state:testSBState handler:nil];

    beforeEach(^{
        mockConnectionManager = [[TestConnectionManager alloc] init];
        mockFileManager = OCMClassMock([SDLFileManager class]);

        testScreenManager = [[SDLScreenManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager];
    });

    it(@"should set up the sub-managers correctly", ^{
        expect(testScreenManager.textAndGraphicManager.connectionManager).to(equal(mockConnectionManager));
        expect(testScreenManager.textAndGraphicManager.fileManager).to(equal(mockFileManager));
        expect(testScreenManager.softButtonManager.connectionManager).to(equal(mockConnectionManager));
        expect(testScreenManager.softButtonManager.fileManager).to(equal(mockFileManager));
    });

    describe(@"batching updates", ^{
        beforeEach(^{
            [testScreenManager beginUpdates];
        });

        it(@"should tell the sub-managers to batch", ^{
            expect(testScreenManager.textAndGraphicManager.batchUpdates).to(beTrue());
            expect(testScreenManager.softButtonManager.batchUpdates).to(beTrue());
        });

        describe(@"after finishing batching", ^{
            beforeEach(^{
                testScreenManager.textField1 = testString1;
                testScreenManager.softButtonObjects = @[testSBObject];
                [testScreenManager endUpdatesWithCompletionHandler:nil];
            });

            it(@"should have in progress updates", ^{
                expect(testScreenManager.textAndGraphicManager.inProgressUpdate).toNot(beNil());
                expect(testScreenManager.softButtonManager.inProgressUpdate).toNot(beNil());

                expect(testScreenManager.textAndGraphicManager.batchUpdates).to(beFalse());
                expect(testScreenManager.softButtonManager.batchUpdates).to(beFalse());
            });
        });
    });

    describe(@"setters", ^{
        beforeEach(^{
            [testScreenManager beginUpdates];
        });

        it(@"should set text and graphic setters properly", ^{
            testScreenManager.textField1 = testString1;
            testScreenManager.textField2 = testString2;
            testScreenManager.textField3 = testString3;
            testScreenManager.textField4 = testString4;
            testScreenManager.textAlignment = testAlignment;
            testScreenManager.primaryGraphic = testArtwork;
            testScreenManager.secondaryGraphic = testArtwork;
            testScreenManager.textField1Type = testMetadataType1;
            testScreenManager.textField2Type = testMetadataType2;
            testScreenManager.textField3Type = testMetadataType3;
            testScreenManager.textField4Type = testMetadataType4;

            expect(testScreenManager.textAndGraphicManager.textField1).to(equal(testString1));
            expect(testScreenManager.textAndGraphicManager.textField2).to(equal(testString2));
            expect(testScreenManager.textAndGraphicManager.textField3).to(equal(testString3));
            expect(testScreenManager.textAndGraphicManager.textField4).to(equal(testString4));
            expect(testScreenManager.textAndGraphicManager.primaryGraphic.name).to(equal(testArtwork.name));
            expect(testScreenManager.textAndGraphicManager.secondaryGraphic.name).to(equal(testArtwork.name));
            expect(testScreenManager.textAndGraphicManager.alignment).to(equal(testAlignment));
            expect(testScreenManager.textAndGraphicManager.textField1Type).to(equal(testMetadataType1));
            expect(testScreenManager.textAndGraphicManager.textField2Type).to(equal(testMetadataType2));
            expect(testScreenManager.textAndGraphicManager.textField3Type).to(equal(testMetadataType3));
            expect(testScreenManager.textAndGraphicManager.textField4Type).to(equal(testMetadataType4));
        });

        it(@"should set soft button setters properly", ^{
            testScreenManager.softButtonObjects = @[testSBObject];

            expect(testScreenManager.softButtonManager.softButtonObjects).to(haveCount(1));
            expect(testScreenManager.softButtonManager.softButtonObjects.firstObject.name).to(equal(testSBObjectName));
        });
    });
});

QuickSpecEnd
