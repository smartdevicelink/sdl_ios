#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLSoftButtonReplaceOperation.h"

#import "SDLArtwork.h"
#import "SDLConnectionManagerType.h"
#import "SDLDisplayCapabilities+ShowManagerExtensions.h"
#import "SDLFileManager.h"
#import "SDLLogMacros.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLSoftButtonReplaceOperationSpec)

describe(@"a soft button replace operation", ^{
    __block SDLSoftButtonReplaceOperation *testOp = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;

    __block BOOL hasCalledOperationCompletionHandler = NO;
    __block NSError *resultError = nil;

    __block NSString *object1Name = @"O1 Name";
    __block NSString *object1State1Name = @"O1S1 Name";
    __block NSString *object1State2Name = @"O1S2 Name";
    __block NSString *object1State1Text = @"O1S1 Text";
    __block NSString *object1State2Text = @"O1S2 Text";
    __block SDLSoftButtonState *object1State1 = nil;
    __block SDLSoftButtonState *object1State2 = nil;
    __block SDLSoftButtonObject *button1 = nil;

    __block NSString *object2Name = @"O2 Name";
    __block NSString *object2State1Name = @"O2S1 Name";
    __block NSString *object2State1Text = @"O2S1 Text";
    __block NSString *object2State1ArtworkName = @"O2S1 Artwork";
    __block SDLArtwork *object2State1Art = nil;
    __block SDLSoftButtonState *object2State1 = nil;
    __block SDLSoftButtonObject *button2 = nil;

    __block NSString *object3Name = @"O3 Name";
    __block NSString *object3State1Name = @"O3S1 Name";
    __block NSString *object3State1Text = @"O3S1 Text";
    __block NSString *object3State1IconName = SDLStaticIconNameRSS;
    __block SDLArtwork *object3State1Art = nil;
    __block SDLSoftButtonState *object3State1 = nil;
    __block SDLSoftButtonObject *button3 = nil;

    __block NSString *object4Name = @"O4 Name";
    __block NSString *object4State1Name = @"O4S1 Name";
    __block NSString *object4State1IconName = SDLStaticIconNameAlbum;
    __block SDLArtwork *object4State1Art = nil;
    __block SDLSoftButtonState *object4State1 = nil;
    __block SDLSoftButtonObject *button4 = nil;

    __block NSString *testMainField1 = @"Test main field 1";

    beforeEach(^{
        resultError = nil;
        hasCalledOperationCompletionHandler = NO;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);

        object1State1 = [[SDLSoftButtonState alloc] initWithStateName:object1State1Name text:object1State1Text artwork:nil];
        object1State2 = [[SDLSoftButtonState alloc] initWithStateName:object1State2Name text:object1State2Text artwork:nil];
        button1 = [[SDLSoftButtonObject alloc] initWithName:object1Name state:object1State1 handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        object2State1Art = [[SDLArtwork alloc] initWithData:[@"TestData" dataUsingEncoding:NSUTF8StringEncoding] name:object2State1ArtworkName fileExtension:@"png" persistent:YES];
        object2State1 = [[SDLSoftButtonState alloc] initWithStateName:object2State1Name text:object2State1Text artwork:object2State1Art];
        button2 = [[SDLSoftButtonObject alloc] initWithName:object2Name state:object2State1 handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        object3State1Art = [[SDLArtwork alloc] initWithStaticIcon:object3State1IconName];
        object3State1 = [[SDLSoftButtonState alloc] initWithStateName:object3State1Name text:object3State1Text artwork:object3State1Art];
        button3 = [[SDLSoftButtonObject alloc] initWithName:object3Name state:object3State1 handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        object4State1Art = [[SDLArtwork alloc] initWithStaticIcon:object4State1IconName];
        object4State1 = [[SDLSoftButtonState alloc] initWithStateName:object4State1Name text:nil artwork:object4State1Art];;
        button4 = [[SDLSoftButtonObject alloc] initWithName:object4Name state:object4State1 handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];;

        OCMStub([testFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);
    });

    it(@"should have a priority of 'normal'", ^{
        testOp = [[SDLSoftButtonReplaceOperation alloc] init];

        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    describe(@"running the operation", ^{
        context(@"without artworks", ^{
            beforeEach(^{
                SDLSoftButtonCapabilities *capabilities = [[SDLSoftButtonCapabilities alloc] init];
                capabilities.imageSupported = @YES;

                NSArray<SDLSoftButtonObject *> *testSoftButtonObjects = @[button1];

                testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:capabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                [testOp start];
            });

            it(@"should send the correct RPCs", ^{
                NSArray<SDLShow *> *sentRequests = testConnectionManager.receivedRequests;
                expect(sentRequests).to(haveCount(1));
                expect(sentRequests.firstObject.mainField1).to(equal(testMainField1));
                expect(sentRequests.firstObject.mainField2).to(beNil());
                expect(sentRequests.firstObject.softButtons).to(haveCount(1));
                expect(sentRequests.firstObject.softButtons.firstObject.text).to(equal(object1State1Text));
                expect(sentRequests.firstObject.softButtons.firstObject.image).to(beNil());
                expect(sentRequests.firstObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeText));
            });
        });

        context(@"with artworks", ^{
            __block NSArray<SDLSoftButtonObject *> *testSoftButtonObjects = nil;

            beforeEach(^{
                testSoftButtonObjects = @[button1, button2];
            });

            context(@"but we don't support artworks", ^{
                beforeEach(^{
                    SDLSoftButtonCapabilities *capabilities = [[SDLSoftButtonCapabilities alloc] init];
                    capabilities.imageSupported = @NO;

                    testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:capabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                    [testOp start];
                });

                it(@"should not send artworks", ^{
                    OCMReject([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);

                    NSArray<SDLShow *> *sentRequests = testConnectionManager.receivedRequests;
                    expect(sentRequests).to(haveCount(1));
                    expect(sentRequests.firstObject.mainField1).to(equal(testMainField1));
                    expect(sentRequests.firstObject.mainField2).to(beNil());
                    expect(sentRequests.firstObject.softButtons).to(haveCount(2));
                    expect(sentRequests.firstObject.softButtons.firstObject.text).to(equal(object1State1Text));
                    expect(sentRequests.firstObject.softButtons.firstObject.image).to(beNil());
                    expect(sentRequests.firstObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeText));
                    expect(sentRequests.firstObject.softButtons.lastObject.text).to(equal(object2State1Text));
                    expect(sentRequests.firstObject.softButtons.lastObject.image).to(beNil());
                    expect(sentRequests.firstObject.softButtons.lastObject.type).to(equal(SDLSoftButtonTypeText));
                });
            });

            context(@"but we don't support artworks and some buttons are image-only", ^{
                __block NSArray<SDLSoftButtonObject *> *testImageOnlySoftButtonObjects = nil;

                beforeEach(^{
                    testImageOnlySoftButtonObjects = @[button3, button4];
                });

                beforeEach(^{
                    SDLSoftButtonCapabilities *capabilities = [[SDLSoftButtonCapabilities alloc] init];
                    capabilities.imageSupported = @NO;

                    testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:capabilities softButtonObjects:testImageOnlySoftButtonObjects mainField1:testMainField1];
                    [testOp start];
                });

                it(@"should not send artworks", ^{
                    OCMReject([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
                });

                it(@"should not send any buttons", ^{
                    NSArray<SDLShow *> *sentRequests = testConnectionManager.receivedRequests;
                    expect(sentRequests).to(haveCount(0));
                });

                it(@"should have set the operation to finished", ^ {
                    expect(testOp.isFinished).to(beTrue());
                });
            });

            context(@"and we support artworks", ^{
                __block SDLSoftButtonCapabilities *buttonCapabilities = nil;

                beforeEach(^{
                    buttonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                    buttonCapabilities.imageSupported = @YES;
                });

                context(@"when artworks are already on the system", ^{
                    beforeEach(^{
                        OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);

                        testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:buttonCapabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                        [testOp start];
                    });

                    it(@"should not upload artworks", ^{
                        OCMReject([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);

                        NSArray<SDLShow *> *sentRequests = testConnectionManager.receivedRequests;
                        expect(sentRequests).to(haveCount(1));
                        expect(sentRequests.firstObject.mainField1).to(equal(testMainField1));
                        expect(sentRequests.firstObject.mainField2).to(beNil());
                        expect(sentRequests.firstObject.softButtons).to(haveCount(2));
                        expect(sentRequests.firstObject.softButtons.firstObject.text).to(equal(object1State1Text));
                        expect(sentRequests.firstObject.softButtons.firstObject.image).to(beNil());
                        expect(sentRequests.firstObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeText));
                        expect(sentRequests.firstObject.softButtons.lastObject.text).to(equal(object2State1Text));
                        expect(sentRequests.firstObject.softButtons.lastObject.image).toNot(beNil());
                        expect(sentRequests.firstObject.softButtons.lastObject.type).to(equal(SDLSoftButtonTypeBoth));
                    });
                });

                context(@"when the artworks need uploading", ^{
                    __block SDLSoftButtonCapabilities *buttonCapabilities = nil;

                    beforeEach(^{
                        buttonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                        buttonCapabilities.imageSupported = @YES;
                    });

                    context(@"when artworks are static icons", ^{
                        beforeEach(^{
                            testSoftButtonObjects = @[button3];

                            testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:buttonCapabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                            [testOp start];
                        });

                        it(@"should skip uploading artwork", ^{
                            OCMReject([testFileManager uploadArtwork:[OCMArg any] completionHandler:[OCMArg any]]);

                            NSArray<SDLShow *> *sentRequests = testConnectionManager.receivedRequests;
                            expect(sentRequests).to(haveCount(1));
                            expect(sentRequests.firstObject.mainField1).to(equal(testMainField1));
                            expect(sentRequests.firstObject.mainField2).to(beNil());
                            expect(sentRequests.firstObject.softButtons).to(haveCount(1));
                            expect(sentRequests.firstObject.softButtons.firstObject.text).to(equal(object3State1Text));
                            expect(sentRequests.firstObject.softButtons.firstObject.image).toNot(beNil());
                            expect(sentRequests.firstObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeBoth));
                        });
                    });

                    context(@"when artwork are not already on the system", ^{
                        beforeEach(^{
                            OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);

                            testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:buttonCapabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                            [testOp start];
                        });

                        it(@"should upload artworks", ^{
                            OCMVerify([testFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id obj) {
                                NSArray<SDLArtwork *> *artworks = (NSArray<SDLArtwork *> *)obj;
                                return (artworks.count == 1);
                            }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                            // Both the text only buttons and the image buttons should be sent
                            NSArray<SDLShow *> *sentRequests = testConnectionManager.receivedRequests;
                            expect(sentRequests).to(haveCount(2));
                            expect(sentRequests.firstObject.mainField1).to(equal(testMainField1));
                            expect(sentRequests.firstObject.mainField2).to(beNil());
                            expect(sentRequests.firstObject.softButtons).to(haveCount(2));
                            expect(sentRequests.firstObject.softButtons.firstObject.text).to(equal(object1State1Text));
                            expect(sentRequests.firstObject.softButtons.firstObject.image).to(beNil());
                            expect(sentRequests.firstObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeText));
                            expect(sentRequests.firstObject.softButtons.lastObject.text).to(equal(object2State1Text));
                            expect(sentRequests.firstObject.softButtons.lastObject.image).to(beNil());
                            expect(sentRequests.firstObject.softButtons.lastObject.type).to(equal(SDLSoftButtonTypeText));

                            expect(sentRequests.lastObject.mainField1).to(equal(testMainField1));
                            expect(sentRequests.lastObject.mainField2).to(beNil());
                            expect(sentRequests.lastObject.softButtons).to(haveCount(2));
                            expect(sentRequests.lastObject.softButtons.firstObject.text).to(equal(object1State1Text));
                            expect(sentRequests.lastObject.softButtons.firstObject.image).to(beNil());
                            expect(sentRequests.firstObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeText));
                            expect(sentRequests.lastObject.softButtons.lastObject.text).to(equal(object2State1Text));
                            expect(sentRequests.lastObject.softButtons.lastObject.image).toNot(beNil());
                            expect(sentRequests.lastObject.softButtons.lastObject.type).to(equal(SDLSoftButtonTypeBoth));
                        });
                    });
                });
            });
        });
    });
});

QuickSpecEnd
