#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLSoftButtonReplaceOperation.h"

#import "SDLArtwork.h"
#import "SDLConnectionManagerType.h"
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
    __block id testFileManager = nil;

    __block BOOL hasCalledOperationCompletionHandler = NO;
    __block NSError *resultError = nil;

    __block NSString *object1Name = @"O1 Name";
    __block NSString *object1State1Name = @"O1S1 Name";
    __block NSString *object1State2Name = @"O1S2 Name";
    __block NSString *object1State1Text = @"O1S1 Text";
    __block NSString *object1State2Text = @"O1S2 Text";
    __block SDLSoftButtonState *object1State1 = nil;
    __block SDLSoftButtonState *object1State2 = nil;
    __block SDLSoftButtonObject *buttonWithText = nil;

    __block NSString *object2Name = @"O2 Name";
    __block NSString *object2State1Name = @"O2S1 Name";
    __block NSString *object2State2Name = @"O2S2 Name";
    __block NSString *object2State1Text = @"O2S1 Text";
    __block NSString *object2State2Text = @"O2S2 Text";
    __block NSString *object2State1ArtworkName = @"O2S1 Artwork";
    __block NSString *object2State2ArtworkName = @"O2S2 Artwork";
    __block SDLArtwork *object2State1Art = nil;
    __block SDLArtwork *object2State2Art = nil;
    __block SDLSoftButtonState *object2State1 = nil;
    __block SDLSoftButtonState *object2State2 = nil;
    __block SDLSoftButtonObject *buttonWithTextAndImage = nil;

    __block NSString *object3Name = @"O3 Name";
    __block NSString *object3State1Name = @"O3S1 Name";
    __block NSString *object3State1Text = @"O3S1 Text";
    __block NSString *object3State1IconName = SDLStaticIconNameRSS;
    __block SDLArtwork *object3State1Art = nil;
    __block SDLSoftButtonState *object3State1 = nil;
    __block SDLSoftButtonObject *buttonWithTextAndStaticImage = nil;

    __block NSString *object4Name = @"O4 Name";
    __block NSString *object4State1Name = @"O4S1 Name";
    __block NSString *object4State1IconName = SDLStaticIconNameAlbum;
    __block SDLArtwork *object4State1Art = nil;
    __block SDLSoftButtonState *object4State1 = nil;
    __block SDLSoftButtonObject *buttonWithImage = nil;

    __block NSString *object5Name = @"O5 Name";
    __block NSString *object5State1Name = @"O5S1 Name";
    __block NSString *object5State2Name = @"O5S2 Name";
    __block NSString *object5State3Name = @"O5S3 Name";
    __block NSString *object5State2IconName = @"O5S2 Name";
    __block NSString *object5State3IconName = @"O5S3 Name";
    __block NSString *object5State1Text = @"O5S1 Text";
    __block NSString *object5State2Text = @"O5S2 Text";
    __block NSString *object5State3Text = @"O5S3 Text";
    __block SDLArtwork *object5State2Art = nil;
    __block SDLArtwork *object5State3Art = nil;
    __block SDLSoftButtonState *object5State1 = nil;
    __block SDLSoftButtonState *object5State2 = nil;
    __block SDLSoftButtonState *object5State3 = nil;
    __block SDLSoftButtonObject *buttonWithTextAndImage2 = nil;

    __block NSString *testMainField1 = @"Test main field 1";

    __block SDLRPCResponse *successResponse = nil;
    __block SDLRPCResponse *failedResponse = nil;

    beforeEach(^{
        resultError = nil;
        hasCalledOperationCompletionHandler = NO;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMStrictClassMock([SDLFileManager class]);

        object1State1 = [[SDLSoftButtonState alloc] initWithStateName:object1State1Name text:object1State1Text artwork:nil];
        object1State2 = [[SDLSoftButtonState alloc] initWithStateName:object1State2Name text:object1State2Text artwork:nil];
        buttonWithText = [[SDLSoftButtonObject alloc] initWithName:object1Name state:object1State1 handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        object2State1Art = [[SDLArtwork alloc] initWithData:[@"TestData" dataUsingEncoding:NSUTF8StringEncoding] name:object2State1ArtworkName fileExtension:@"png" persistent:YES];
        object2State2Art = [[SDLArtwork alloc] initWithData:[@"TestData2" dataUsingEncoding:NSUTF8StringEncoding] name:object2State2ArtworkName fileExtension:@"png" persistent:YES];
        object2State1 = [[SDLSoftButtonState alloc] initWithStateName:object2State1Name text:object2State1Text artwork:object2State1Art];
        object2State2 = [[SDLSoftButtonState alloc] initWithStateName:object2State2Name text:object2State2Text artwork:object2State2Art];
        buttonWithTextAndImage = [[SDLSoftButtonObject alloc] initWithName:object2Name states:@[object2State1, object2State2] initialStateName:object2State1.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        object3State1Art = [[SDLArtwork alloc] initWithStaticIcon:object3State1IconName];
        object3State1 = [[SDLSoftButtonState alloc] initWithStateName:object3State1Name text:object3State1Text artwork:object3State1Art];
        buttonWithTextAndStaticImage = [[SDLSoftButtonObject alloc] initWithName:object3Name state:object3State1 handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        object4State1Art = [[SDLArtwork alloc] initWithStaticIcon:object4State1IconName];
        object4State1 = [[SDLSoftButtonState alloc] initWithStateName:object4State1Name text:nil artwork:object4State1Art];;
        buttonWithImage = [[SDLSoftButtonObject alloc] initWithName:object4Name state:object4State1 handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        object5State2Art = [[SDLArtwork alloc] initWithData:[@"object5State2Art" dataUsingEncoding:NSUTF8StringEncoding] name:object5State2IconName fileExtension:@"png" persistent:YES];
        object5State3Art = [[SDLArtwork alloc] initWithData:[@"object5State3Art" dataUsingEncoding:NSUTF8StringEncoding] name:object5State3IconName fileExtension:@"png" persistent:YES];
        object5State1 = [[SDLSoftButtonState alloc] initWithStateName:object5State1Name text:object5State1Text artwork:nil];
        object5State2 = [[SDLSoftButtonState alloc] initWithStateName:object5State2Name text:object5State2Text artwork:object5State2Art];
        object5State3 = [[SDLSoftButtonState alloc] initWithStateName:object5State3Name text:object5State3Text artwork:object5State3Art];
        buttonWithTextAndImage2 = [[SDLSoftButtonObject alloc] initWithName:object5Name states:@[object5State1, object5State2, object5State3] initialStateName:object5State1.name handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        successResponse = [[SDLRPCResponse alloc] init];
        successResponse.success = @YES;
        successResponse.resultCode = SDLResultSuccess;

        failedResponse = [[SDLRPCResponse alloc] init];
        failedResponse.success = @NO;
        failedResponse.resultCode = SDLResultRejected;
    });

    it(@"should have a priority of 'normal'", ^{
        testOp = [[SDLSoftButtonReplaceOperation alloc] init];
        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    describe(@"running the operation", ^{
        context(@"without artworks", ^{
            __block NSArray<SDLSoftButtonObject *> *testSoftButtonObjects = nil;
            __block SDLSoftButtonCapabilities *capabilities = nil;

            beforeEach(^{
                testSoftButtonObjects = @[buttonWithText];
                testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:capabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];

                capabilities = [[SDLSoftButtonCapabilities alloc] init];
                capabilities.imageSupported = @YES;
            });

            it(@"should send the correct RPCs", ^{
                OCMReject([testFileManager uploadArtworks:[OCMArg any] progressHandler:nil completionHandler:nil]);

                [testOp start];

                OCMVerifyAllWithDelay(testFileManager, 0.5);

                NSArray<SDLShow *> *sentRequests = testConnectionManager.receivedRequests;
                expect(sentRequests).to(haveCount(1));
                expect(sentRequests.firstObject.mainField1).to(equal(testMainField1));
                expect(sentRequests.firstObject.mainField2).to(beNil());
                expect(sentRequests.firstObject.softButtons).to(haveCount(1));
                expect(sentRequests.firstObject.softButtons.firstObject.text).to(equal(object1State1Text));
                expect(sentRequests.firstObject.softButtons.firstObject.image).to(beNil());
                expect(sentRequests.firstObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeText));
            });

            context(@"When a response is received to the upload", ^{
                beforeEach(^{
                    [testOp start];
                });

                it(@"should finish the operation on a successful response", ^{
                    [testConnectionManager respondToLastRequestWithResponse:successResponse];

                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.isExecuting).to(beFalse());
                });

                it(@"should finish the operation on a failed response", ^{
                    [testConnectionManager respondToLastRequestWithResponse:failedResponse];

                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.isExecuting).to(beFalse());
                });
            });
        });

        context(@"with artworks", ^{
            __block NSArray<SDLSoftButtonObject *> *testSoftButtonObjects = nil;
            __block SDLSoftButtonCapabilities *capabilities = nil;

            beforeEach(^{
                testSoftButtonObjects = @[buttonWithText, buttonWithTextAndImage];
            });

            context(@"but the HMI does not support artworks", ^{
                beforeEach(^{
                    capabilities = [[SDLSoftButtonCapabilities alloc] init];
                    capabilities.imageSupported = @NO;

                    testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:capabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                });

                it(@"should send the button text", ^{
                    OCMReject([testFileManager uploadArtworks:[OCMArg any] progressHandler:nil completionHandler:nil]);

                    [testOp start];

                    OCMVerifyAllWithDelay(testFileManager, 0.5);

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

                context(@"When a response is received to the upload", ^{
                    beforeEach(^{
                        [testOp start];
                    });

                    it(@"should finish the operation on a successful response", ^{
                        [testConnectionManager respondToLastRequestWithResponse:successResponse];

                        expect(testOp.isFinished).to(beTrue());
                        expect(testOp.isExecuting).to(beFalse());
                    });

                    it(@"should finish the operation on a failed response", ^{
                        [testConnectionManager respondToLastRequestWithResponse:failedResponse];

                        expect(testOp.isFinished).to(beTrue());
                        expect(testOp.isExecuting).to(beFalse());
                    });
                });
            });

            context(@"but the HMI does not support artworks and some buttons are image-only", ^{
                beforeEach(^{
                    testSoftButtonObjects = @[buttonWithTextAndStaticImage, buttonWithImage];

                    capabilities = [[SDLSoftButtonCapabilities alloc] init];
                    capabilities.imageSupported = @NO;

                    testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:capabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                });

                it(@"should not send any buttons", ^{
                    OCMReject([testFileManager uploadArtworks:[OCMArg any] progressHandler:nil completionHandler:nil]);

                    [testOp start];

                    OCMVerifyAllWithDelay(testFileManager, 0.5);

                    NSArray<SDLShow *> *sentRequests = testConnectionManager.receivedRequests;
                    expect(sentRequests).to(haveCount(0));

                    expect(testOp.isFinished).to(beTrue());
                });
            });

            context(@"and the module supports artworks", ^{
                beforeEach(^{
                    capabilities = [[SDLSoftButtonCapabilities alloc] init];
                    capabilities.imageSupported = @YES;
                });

                context(@"when artworks are already on the system", ^{
                    beforeEach(^{
                        OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);

                        testSoftButtonObjects = @[buttonWithText, buttonWithTextAndImage];
                        testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:capabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                    });

                    it(@"should not upload artworks", ^{
                        OCMReject([testFileManager uploadArtworks:[OCMArg any] progressHandler:nil completionHandler:nil]);

                        [testOp start];

                        OCMVerifyAllWithDelay(testFileManager, 0.5);

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

                    context(@"When a response is received to the upload", ^{
                        beforeEach(^{
                            [testOp start];
                        });

                        it(@"should finish the operation on a successful response", ^{
                            [testConnectionManager respondToLastRequestWithResponse:successResponse];

                            expect(testOp.isFinished).to(beTrue());
                            expect(testOp.isExecuting).to(beFalse());
                        });

                        it(@"should finish the operation on a failed response", ^{
                            [testConnectionManager respondToLastRequestWithResponse:failedResponse];

                            expect(testOp.isFinished).to(beTrue());
                            expect(testOp.isExecuting).to(beFalse());
                        });
                    });
                });

                context(@"when the artworks need uploading", ^{
                    beforeEach(^{
                        OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);
                    });

                    context(@"when artworks are static icons", ^{
                        beforeEach(^{
                            testSoftButtonObjects = @[buttonWithTextAndStaticImage];

                            testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:capabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                        });

                        it(@"should skip uploading artwork", ^{
                            OCMReject([testFileManager uploadArtworks:[OCMArg any] progressHandler:nil completionHandler:nil]);

                            [testOp start];

                            OCMVerifyAllWithDelay(testFileManager, 0.5);

                            NSArray<SDLShow *> *sentRequests = testConnectionManager.receivedRequests;
                            expect(sentRequests).to(haveCount(1));
                            expect(sentRequests.firstObject.mainField1).to(equal(testMainField1));
                            expect(sentRequests.firstObject.mainField2).to(beNil());
                            expect(sentRequests.firstObject.softButtons).to(haveCount(1));
                            expect(sentRequests.firstObject.softButtons.firstObject.text).to(equal(object3State1Text));
                            expect(sentRequests.firstObject.softButtons.firstObject.image).toNot(beNil());
                            expect(sentRequests.firstObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeBoth));
                        });

                        context(@"When a response is received to the upload", ^{
                            beforeEach(^{
                                [testOp start];
                            });

                            it(@"should finish the operation on a successful response", ^{
                                [testConnectionManager respondToLastRequestWithResponse:successResponse];

                                expect(testOp.isFinished).to(beTrue());
                                expect(testOp.isExecuting).to(beFalse());
                            });

                            it(@"should finish the operation on a failed response", ^{
                                [testConnectionManager respondToLastRequestWithResponse:failedResponse];

                                expect(testOp.isFinished).to(beTrue());
                                expect(testOp.isExecuting).to(beFalse());
                            });
                        });
                    });

                    context(@"when artworks are dynamic icons", ^{
                        it(@"should upload all artworks", ^{
                            // Check that the artworks in the initial button states are uploaded
                            OCMExpect([testFileManager uploadArtworks:@[buttonWithTextAndImage.states[0].artwork] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);
                            testSoftButtonObjects = @[buttonWithText, buttonWithTextAndImage];
                            testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:capabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                            [testOp start];
                            OCMVerifyAllWithDelay(testFileManager, 0.5);

                            // Check that the artworks in the other states (i.e. the non-first states) are uploaded
                            OCMExpect([testFileManager uploadArtworks:@[buttonWithTextAndImage.states[1].artwork] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);
                            [testConnectionManager respondToLastRequestWithResponse:successResponse];
                            OCMVerifyAllWithDelay(testFileManager, 0.5);
                            
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
                            expect(sentRequests.lastObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeText));
                            expect(sentRequests.lastObject.softButtons.lastObject.text).to(equal(object2State1Text));
                            expect(sentRequests.lastObject.softButtons.lastObject.image).toNot(beNil());
                            expect(sentRequests.lastObject.softButtons.lastObject.type).to(equal(SDLSoftButtonTypeBoth));
                        });

                        it(@"should upload all artworks even if the initial state does not have artworks", ^{
                            OCMReject([testFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                            // buttonWithTextAndImage2 has text in the first state and an text and image in the second & third states
                            testSoftButtonObjects = @[buttonWithTextAndStaticImage, buttonWithTextAndImage2];
                            testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:capabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                            [testOp start];
                            OCMVerifyAllWithDelay(testFileManager, 0.5);

                            NSArray<SDLArtwork *> *testArtworkUploads = @[buttonWithTextAndImage2.states[1].artwork, buttonWithTextAndImage2.states[2].artwork];
                            OCMExpect([testFileManager uploadArtworks:testArtworkUploads progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);
                            [testConnectionManager respondToLastRequestWithResponse:successResponse];
                            OCMVerifyAllWithDelay(testFileManager, 0.5);

                            // Both the text only buttons and the image buttons should be sent
                            NSArray<SDLShow *> *sentRequests = testConnectionManager.receivedRequests;
                            expect(sentRequests).to(haveCount(2));
                            expect(sentRequests.firstObject.mainField1).to(equal(testMainField1));
                            expect(sentRequests.firstObject.mainField2).to(beNil());
                            expect(sentRequests.firstObject.softButtons).to(haveCount(2));
                            expect(sentRequests.firstObject.softButtons.firstObject.text).to(equal(object3State1Text));
                            expect(sentRequests.firstObject.softButtons.firstObject.image).to(beNil());
                            expect(sentRequests.firstObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeText));
                            expect(sentRequests.firstObject.softButtons.lastObject.text).to(equal(object5State1Text));
                            expect(sentRequests.firstObject.softButtons.lastObject.image).to(beNil());
                            expect(sentRequests.firstObject.softButtons.lastObject.type).to(equal(SDLSoftButtonTypeText));

                            expect(sentRequests.lastObject.mainField1).to(equal(testMainField1));
                            expect(sentRequests.lastObject.mainField2).to(beNil());
                            expect(sentRequests.lastObject.softButtons).to(haveCount(2));
                            expect(sentRequests.lastObject.softButtons.firstObject.text).to(equal(object3State1Text));
                            expect(sentRequests.lastObject.softButtons.firstObject.image).to(equal(object3State1Art.imageRPC));
                            expect(sentRequests.lastObject.softButtons.firstObject.type).to(equal(SDLSoftButtonTypeBoth));
                            expect(sentRequests.lastObject.softButtons.lastObject.text).to(equal(object5State1Text));
                            expect(sentRequests.lastObject.softButtons.lastObject.image).to(beNil());
                            expect(sentRequests.lastObject.softButtons.lastObject.type).to(equal(SDLSoftButtonTypeText));
                        });

                        context(@"When a response is received to the upload", ^{
                            beforeEach(^{
                                OCMExpect([testFileManager uploadArtworks:[OCMArg isNotNil] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                                testSoftButtonObjects = @[buttonWithTextAndImage];
                                testOp = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager capabilities:capabilities softButtonObjects:testSoftButtonObjects mainField1:testMainField1];
                                [testOp start];

                                OCMVerifyAllWithDelay(testFileManager, 0.5);
                            });

                            it(@"should finish the operation on a successful response", ^{
                                OCMExpect([testFileManager uploadArtworks:[OCMArg isNotNil] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                                [testConnectionManager respondToLastRequestWithResponse:successResponse];

                                OCMVerifyAllWithDelay(testFileManager, 0.5);
                                expect(testOp.isFinished).to(beTrue());
                                expect(testOp.isExecuting).to(beFalse());
                            });

                            it(@"should finish the operation on a failed response", ^{
                                OCMExpect([testFileManager uploadArtworks:[OCMArg isNotNil] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);
                                [testConnectionManager respondToLastRequestWithResponse:failedResponse];

                                OCMVerifyAllWithDelay(testFileManager, 0.5);
                                expect(testOp.isFinished).to(beTrue());
                                expect(testOp.isExecuting).to(beFalse());
                            });
                        });
                    });
                });
            });
        });
    });
});

QuickSpecEnd
