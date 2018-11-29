#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLArtwork.h"
#import "SDLDisplayCapabilities.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLImage.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSoftButtonManager.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"
#import "TestConnectionManager.h"

@interface SDLSoftButtonObject()

@property (assign, nonatomic) NSUInteger buttonId;
@property (weak, nonatomic) SDLSoftButtonManager *manager;

@end

@interface SDLSoftButtonManager()

@property (strong, nonatomic) NSArray<SDLSoftButton *> *currentSoftButtons;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (strong, nonatomic, nullable) SDLShow *inProgressUpdate;
@property (copy, nonatomic, nullable) SDLSoftButtonUpdateCompletionHandler inProgressHandler;

@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (copy, nonatomic, nullable) SDLSoftButtonUpdateCompletionHandler queuedUpdateHandler;

@property (copy, nonatomic, nullable) SDLHMILevel currentLevel;
@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;
@property (strong, nonatomic, nullable) SDLSoftButtonCapabilities *softButtonCapabilities;

@property (assign, nonatomic) BOOL waitingOnHMILevelUpdateToUpdate;

@end

QuickSpecBegin(SDLSoftButtonManagerSpec)

describe(@"a soft button manager", ^{
    __block SDLSoftButtonManager *testManager = nil;

    __block SDLFileManager *testFileManager = nil;
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
    __block NSString *object2State2Name = @"O2S2 Name";
    __block NSString *object2State1Text = @"O2S1 Text";
    __block NSString *object2State2Text = @"O2S2 Text";
    __block NSString *object2State1ArtworkName = @"O2S1 Artwork";
    __block SDLArtwork *object2State1Art = [[SDLArtwork alloc] initWithData:[@"TestData" dataUsingEncoding:NSUTF8StringEncoding] name:object2State1ArtworkName fileExtension:@"png" persistent:YES];
    __block SDLSoftButtonState *object2State1 = [[SDLSoftButtonState alloc] initWithStateName:object2State1Name text:object2State1Text artwork:object2State1Art];
    __block SDLSoftButtonState *object2State2 = [[SDLSoftButtonState alloc] initWithStateName:object2State2Name text:object2State2Text image:nil];

    __block SDLArtwork *staticIconArt = [SDLArtwork artworkWithStaticIcon:SDLStaticIconNameDate];
    __block SDLSoftButtonState *staticIconState = [[SDLSoftButtonState alloc] initWithStateName:@"Static State" text:nil artwork:staticIconArt];

    beforeEach(^{
        testFileManager = OCMClassMock([SDLFileManager class]);
        testConnectionManager = [[TestConnectionManager alloc] init];

        testManager = [[SDLSoftButtonManager alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager];

        expect(testManager.currentLevel).to(beNil());
        testManager.currentLevel = SDLHMILevelFull;
    });

    it(@"should instantiate correctly", ^{
        expect(testManager.connectionManager).to(equal(testConnectionManager));
        expect(testManager.fileManager).to(equal(testFileManager));

        expect(testManager.softButtonObjects).to(beEmpty());
        expect(testManager.currentMainField1).to(beNil());
        expect(testManager.inProgressUpdate).to(beNil());
        expect(testManager.hasQueuedUpdate).to(beFalse());
        expect(testManager.displayCapabilities).to(beNil());
        expect(testManager.softButtonCapabilities).to(beNil());
        expect(testManager.waitingOnHMILevelUpdateToUpdate).to(beFalse());
    });

    context(@"when in HMI NONE", ^{
        beforeEach(^{
            testManager.currentLevel = SDLHMILevelNone;

            testObject1 = [[SDLSoftButtonObject alloc] initWithName:@"name1" states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
            testObject2 = [[SDLSoftButtonObject alloc] initWithName:@"name2" state:object2State1 handler:nil];

            testManager.softButtonObjects = @[testObject1, testObject2];
        });

        it(@"should set the soft buttons, but not update", ^{
            expect(testManager.softButtonObjects).toNot(beEmpty());
            expect(testManager.waitingOnHMILevelUpdateToUpdate).to(beTrue());
            expect(testManager.inProgressUpdate).to(beNil());
        });
    });

    context(@"when no HMI level has been received", ^{
        beforeEach(^{
            testManager.currentLevel = nil;

            testObject1 = [[SDLSoftButtonObject alloc] initWithName:@"name1" states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
            testObject2 = [[SDLSoftButtonObject alloc] initWithName:@"name2" state:object2State1 handler:nil];

            testManager.softButtonObjects = @[testObject1, testObject2];
        });

        it(@"should set the soft buttons, but not update", ^{
            expect(testManager.softButtonObjects).toNot(beEmpty());
            expect(testManager.waitingOnHMILevelUpdateToUpdate).to(beTrue());
            expect(testManager.inProgressUpdate).to(beNil());
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
        });

        it(@"should set soft buttons correctly", ^{
            expect(testManager.softButtonObjects).toNot(beNil());
            expect(testObject1.buttonId).to(equal(0));
            expect(testObject2.buttonId).to(equal(100));
            expect(testObject1.manager).to(equal(testManager));
            expect(testObject2.manager).to(equal(testManager));
        });

        it(@"should retrieve soft buttons correctly", ^{
            expect([testManager softButtonObjectNamed:object1Name].name).to(equal(object1Name));
        });

        context(@"when the HMI level is now NONE", ^{
            beforeEach(^{
                testManager.currentLevel = SDLHMILevelNone;
                testManager.inProgressUpdate = nil;
            });

            it(@"should not transition buttons", ^{
                [testObject1 transitionToNextState];

                expect(testManager.inProgressUpdate).to(beNil());
            });
        });
    });

    describe(@"uploading soft buttons to a head unit that supports images", ^{
        beforeEach(^{
            SDLSoftButtonCapabilities *softButtonImagesSupported = [[SDLSoftButtonCapabilities alloc] init];
            softButtonImagesSupported.imageSupported = @YES;
            testManager.softButtonCapabilities = softButtonImagesSupported;
        });

        context(@"when button artworks are static icons", ^{
            beforeEach(^{
                testObject1 = [[SDLSoftButtonObject alloc] initWithName:object1Name state:staticIconState handler:nil];
                testManager.softButtonObjects = @[testObject1];
            });

            it(@"should not have attempted to upload any artworks", ^{
                OCMReject([testFileManager uploadArtwork:[OCMArg any] completionHandler:[OCMArg any]]);
            });
        });

        context(@"when button artworks are already on the file system", ^{
            beforeEach(^{
                OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);

                testObject1 = [[SDLSoftButtonObject alloc] initWithName:object1Name states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
                testObject2 = [[SDLSoftButtonObject alloc] initWithName:object2Name state:object2State1 handler:nil];

                testManager.softButtonObjects = @[testObject1, testObject2];
            });

            it(@"should not have attempted to upload any artworks", ^{
                OCMReject([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
            });

            it(@"should set the in progress update", ^{
                NSArray<SDLSoftButton *> *inProgressSoftButtons = testManager.inProgressUpdate.softButtons;

                expect(testManager.hasQueuedUpdate).to(beFalse());
                expect(testManager.inProgressUpdate.mainField1).to(equal(@""));
                expect(inProgressSoftButtons).to(haveCount(2));
                expect(inProgressSoftButtons[0].text).to(equal(object1State1Text));
                expect(inProgressSoftButtons[1].text).to(equal(object2State1Text));
                expect(inProgressSoftButtons[0].image).to(beNil());
                expect(inProgressSoftButtons[1].image.value).to(equal(object2State1ArtworkName));
            });
        });

        context(@"when button artworks are not already on the file system, before upload finishes", ^{
            beforeEach(^{
                OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);

                testObject1 = [[SDLSoftButtonObject alloc] initWithName:object1Name states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
                testObject2 = [[SDLSoftButtonObject alloc] initWithName:object2Name state:object2State1 handler:nil];

                testManager.softButtonObjects = @[testObject1, testObject2];
            });

            it(@"should attempt to upload an artwork", ^{
                OCMVerify([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
            });

            it(@"should set the in progress update for text only buttons", ^{
                NSArray<SDLSoftButton *> *inProgressSoftButtons = testManager.inProgressUpdate.softButtons;

                expect(testManager.hasQueuedUpdate).to(beFalse());
                expect(testManager.inProgressUpdate.mainField1).to(equal(@""));
                expect(inProgressSoftButtons).to(haveCount(2));
                expect(inProgressSoftButtons[0].text).to(equal(object1State1Text));
                expect(inProgressSoftButtons[1].text).to(equal(object2State1Text));
                expect(inProgressSoftButtons[0].image).to(beNil());
                expect(inProgressSoftButtons[1].image).to(beNil());
            });
        });

        context(@"when button artworks are not already on the file system, after upload finishes", ^{
            beforeEach(^{
                OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);
                OCMStub([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);

                testObject1 = [[SDLSoftButtonObject alloc] initWithName:object1Name states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
                testObject2 = [[SDLSoftButtonObject alloc] initWithName:object2Name state:object2State1 handler:nil];

                testManager.softButtonObjects = @[testObject1, testObject2];
            });

            it(@"should attempt to upload an artwork", ^{
                OCMVerify([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
            });

            it(@"should set the in progress update for text only buttons and have a queued update", ^{
                NSArray<SDLSoftButton *> *inProgressSoftButtons = testManager.inProgressUpdate.softButtons;

                expect(testManager.hasQueuedUpdate).to(beTrue());
                expect(testManager.inProgressUpdate.mainField1).to(equal(@""));
                expect(inProgressSoftButtons).to(haveCount(2));
                expect(inProgressSoftButtons[0].text).to(equal(object1State1Text));
                expect(inProgressSoftButtons[1].text).to(equal(object2State1Text));
                expect(inProgressSoftButtons[0].image).to(beNil());
                expect(inProgressSoftButtons[1].image).to(beNil());
            });
        });
    });

    describe(@"uploading soft buttons to a head unit that does not support images", ^{
        beforeEach(^{
            SDLSoftButtonCapabilities *softButtonImagesSupported = [[SDLSoftButtonCapabilities alloc] init];
            softButtonImagesSupported.imageSupported = @NO;
            testManager.softButtonCapabilities = softButtonImagesSupported;
        });

        context(@"when the button contains images", ^{
            beforeEach(^{
                testObject1 = [[SDLSoftButtonObject alloc] initWithName:object1Name states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
                testObject2 = [[SDLSoftButtonObject alloc] initWithName:object2Name state:object2State2 handler:nil];
                testManager.softButtonObjects = @[testObject1, testObject2];
            });

            it(@"should not have attempted to upload any artworks", ^{
                OCMReject([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
            });

            it(@"should set the in progress update to be text buttons", ^{
                NSArray<SDLSoftButton *> *inProgressSoftButtons = testManager.inProgressUpdate.softButtons;

                expect(testManager.hasQueuedUpdate).to(beFalse());
                expect(testManager.inProgressUpdate.mainField1).to(equal(@""));
                expect(inProgressSoftButtons).to(haveCount(2));
                expect(inProgressSoftButtons[0].text).to(equal(object1State1Text));
                expect(inProgressSoftButtons[1].text).to(equal(object2State2Text));
                expect(inProgressSoftButtons[0].image).to(beNil());
                expect(inProgressSoftButtons[1].image.value).to(beNil());
            });
        });

        context(@"when the button does not contain images", ^{
            beforeEach(^{
                testObject1 = [[SDLSoftButtonObject alloc] initWithName:object1Name states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
                testObject2 = [[SDLSoftButtonObject alloc] initWithName:object2Name state:object2State2 handler:nil];
                testManager.softButtonObjects = @[testObject1, testObject2];
            });

            it(@"should not have attempted to upload any artworks", ^{
                OCMReject([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
            });

            it(@"should set the in progress update to be text buttons", ^{
                NSArray<SDLSoftButton *> *inProgressSoftButtons = testManager.inProgressUpdate.softButtons;

                expect(testManager.hasQueuedUpdate).to(beFalse());
                expect(testManager.inProgressUpdate.mainField1).to(equal(@""));
                expect(inProgressSoftButtons).to(haveCount(2));
                expect(inProgressSoftButtons[0].text).to(equal(object1State1Text));
                expect(inProgressSoftButtons[1].text).to(equal(object2State2Text));
                expect(inProgressSoftButtons[0].image).to(beNil());
                expect(inProgressSoftButtons[1].image.value).to(beNil());
            });
        });
    });

    describe(@"transitioning soft button states", ^{
        beforeEach(^{
            OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);

            testObject1 = [[SDLSoftButtonObject alloc] initWithName:object1Name states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
            testObject2 = [[SDLSoftButtonObject alloc] initWithName:object2Name state:object2State1 handler:nil];

            testManager.softButtonObjects = @[testObject1, testObject2];
        });

        it(@"should queue an update", ^{
            testManager.inProgressUpdate = nil; // Reset due to setting the soft button objects
            [testObject1 transitionToStateNamed:object1State2Name];

            expect(testManager.inProgressUpdate).toNot(beNil());
            expect(testManager.inProgressUpdate.mainField1).to(beEmpty());
            expect(testManager.inProgressUpdate.softButtons[0].text).to(equal(object1State2Text));
            expect(testManager.inProgressUpdate.softButtons[1].text).to(equal(object2State1Text));
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
            expect(testManager.inProgressUpdate).to(beNil());
            expect(testManager.hasQueuedUpdate).to(beFalse());
            expect(testManager.currentLevel).to(beNil());
            expect(testManager.displayCapabilities).to(beNil());
            expect(testManager.softButtonCapabilities).to(beNil());
            expect(testManager.waitingOnHMILevelUpdateToUpdate).to(beFalse());
        });
    });
});

QuickSpecEnd
