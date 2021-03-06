#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLPreloadChoicesOperation.h"

#import "SDLChoice.h"
#import "SDLChoiceCell.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLDisplayType.h"
#import "SDLFileManager.h"
#import "SDLImageField.h"
#import "SDLImageFieldName.h"
#import "SDLTextField.h"
#import "SDLTextFieldName.h"
#import "SDLWindowCapability.h"
#import "TestConnectionManager.h"

@interface SDLPreloadChoicesOperation()

@property (strong, nonatomic, nullable) NSMutableArray<NSNumber *> *failedChoiceUploadIDs;

@end

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

QuickSpecBegin(SDLPreloadChoicesOperationSpec)

describe(@"a preload choices operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block SDLPreloadChoicesOperation *testOp = nil;
    __block NSString *testDisplayName = @"SDL_GENERIC";

    __block NSData *cellArtData = [@"testart" dataUsingEncoding:NSUTF8StringEncoding];
    __block NSData *cellArtData2 = [@"testart2" dataUsingEncoding:NSUTF8StringEncoding];

    __block BOOL hasCalledOperationCompletionHandler = NO;
    __block NSError *resultError = nil;

    beforeEach(^{
        resultError = nil;
        hasCalledOperationCompletionHandler = NO;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);
    });

    it(@"should have a priority of 'normal'", ^{
        testOp = [[SDLPreloadChoicesOperation alloc] init];

        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    describe(@"running the operation", ^{
        __block SDLWindowCapability *windowCapability = nil;
        beforeEach(^{
            windowCapability = [[SDLWindowCapability alloc] init];
            windowCapability.imageTypeSupported = @[SDLImageTypeStatic, SDLImageTypeDynamic];
            SDLTextField *primaryTextField = [[SDLTextField alloc] init];
            primaryTextField.name = SDLTextFieldNameMenuName;
            windowCapability.textFields = @[primaryTextField];

            OCMStub([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
            OCMStub([testFileManager fileNeedsUpload:[OCMArg isNotNil]]).andReturn(YES);
        });

        context(@"with artworks", ^{
            __block NSOrderedSet<SDLChoiceCell *> *cellsWithArtwork = nil;
            __block NSOrderedSet<SDLChoiceCell *> *cellsWithStaticIcon = nil;
            __block NSString *art1Name = @"Art1Name";
            __block NSString *art2Name = @"Art2Name";
            __block SDLArtwork *cell1Art2 = [[SDLArtwork alloc] initWithData:cellArtData2 name:art1Name fileExtension:@"png" persistent:NO];

            beforeEach(^{
                SDLArtwork *cell1Art = [[SDLArtwork alloc] initWithData:cellArtData name:art1Name fileExtension:@"png" persistent:NO];
                SDLChoiceCell *cell1WithArt = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:cell1Art voiceCommands:nil];

                SDLArtwork *cell2Art = [[SDLArtwork alloc] initWithData:cellArtData name:art2Name fileExtension:@"png" persistent:NO];
                SDLChoiceCell *cell2WithArtAndSecondary = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:cell2Art secondaryArtwork:cell2Art];

                SDLArtwork *staticIconArt = [SDLArtwork artworkWithStaticIcon:SDLStaticIconNameDate];
                SDLChoiceCell *cellWithStaticIcon = [[SDLChoiceCell alloc] initWithText:@"Static Icon" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:staticIconArt secondaryArtwork:nil];

                cellsWithArtwork = [[NSOrderedSet alloc] initWithArray:@[cell1WithArt, cell2WithArtAndSecondary]];
                cellsWithStaticIcon = [[NSOrderedSet alloc] initWithArray:@[cellWithStaticIcon]];
            });
            
            context(@"if the menuName is not set", ^{
                it(@"should not send any requests", ^{
                    SDLTextField *primaryTextField = [[SDLTextField alloc] init];
                    primaryTextField.name = SDLTextFieldNameMenuName;
                    windowCapability.textFields = @[];

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp start];
                
                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;
                    
                    expect(receivedRequests).to(haveCount(0));
                });
            });

            context(@"only main text capabilities", ^{
                it(@"should skip to preloading cells", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp start];

                    expect(@(testOp.currentState)).to(equal(SDLPreloadChoicesOperationStatePreloadingChoices));
                });
            });

            context(@"only main text and image capabilities", ^{
                beforeEach(^{
                    SDLImageField *choiceField = [[SDLImageField alloc] init];
                    choiceField.name = SDLImageFieldNameChoiceImage;
                    windowCapability.imageFields = @[choiceField];

                    OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp start];
                });

                it(@"should upload some artworks", ^{
                    OCMVerify([testFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id obj) {
                        NSArray<SDLArtwork *> *artworks = (NSArray<SDLArtwork *> *)obj;
                        return (artworks.count == 2);
                    }] completionHandler:[OCMArg any]]);
                    expect(@(testOp.currentState)).to(equal(SDLPreloadChoicesOperationStatePreloadingChoices));
                });
            });

            context(@"main text and all image display capabilities", ^{
                beforeEach(^{
                    SDLImageField *choiceField = [[SDLImageField alloc] init];
                    choiceField.name = SDLImageFieldNameChoiceImage;
                    SDLImageField *choiceSecondaryField = [[SDLImageField alloc] init];
                    choiceSecondaryField.name = SDLImageFieldNameChoiceSecondaryImage;

                    windowCapability.imageFields = @[choiceField, choiceSecondaryField];
                });

                context(@"when artworks are already on the system", ^{
                    beforeEach(^{
                        OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);

                        testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                        [testOp start];
                    });

                    it(@"should not upload artworks", ^{
                        OCMReject([testFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id obj) {
                            NSArray<SDLArtwork *> *artworks = (NSArray<SDLArtwork *> *)obj;
                            return (artworks.count == 2);
                        }] completionHandler:[OCMArg any]]);
                        expect(@(testOp.currentState)).to(equal(SDLPreloadChoicesOperationStatePreloadingChoices));
                    });

                    it(@"should properly overwrite artwork", ^{
                        cell1Art2.overwrite = YES;
                        SDLChoiceCell *cell1WithArt = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:cell1Art2 voiceCommands:nil];

                        SDLArtwork *cell2Art = [[SDLArtwork alloc] initWithData:cellArtData name:art2Name fileExtension:@"png" persistent:NO];
                        SDLChoiceCell *cell2WithArtAndSecondary = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:cell2Art secondaryArtwork:cell2Art];

                        SDLArtwork *staticIconArt = [SDLArtwork artworkWithStaticIcon:SDLStaticIconNameDate];
                        SDLChoiceCell *cellWithStaticIcon = [[SDLChoiceCell alloc] initWithText:@"Static Icon" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:staticIconArt secondaryArtwork:nil];

                        cellsWithArtwork = [[NSOrderedSet alloc] initWithArray:@[cell1WithArt, cell2WithArtAndSecondary]];
                        cellsWithStaticIcon = [[NSOrderedSet alloc] initWithArray:@[cellWithStaticIcon]];
                        testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                        [testOp start];

                        OCMExpect([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
                        OCMVerify([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
                    });
                });

                context(@"when artworks are static icons", ^{
                    beforeEach(^{
                        testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithStaticIcon updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                        [testOp start];
                    });

                    it(@"should skip uploading artwork", ^{
                        OCMReject([testFileManager uploadArtwork:[OCMArg any] completionHandler:[OCMArg any]]);
                    });
                });

                context(@"when artwork are not already on the system", ^{
                    beforeEach(^{
                        OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);

                        testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                        [testOp start];
                    });

                    it(@"should upload artworks", ^{
                        OCMVerify([testFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id obj) {
                            NSArray<SDLArtwork *> *artworks = (NSArray<SDLArtwork *> *)obj;
                            return (artworks.count == 3);
                        }] completionHandler:[OCMArg any]]);
                        expect(@(testOp.currentState)).to(equal(SDLPreloadChoicesOperationStatePreloadingChoices));
                    });
                });
            });
        });

        context(@"without artworks", ^{
            __block NSOrderedSet<SDLChoiceCell *> *cellsWithoutArtwork = nil;
            beforeEach(^{
                SDLChoiceCell *cellBasic = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:nil voiceCommands:nil];
                SDLChoiceCell *cellWithVR = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:nil tertiaryText:nil voiceCommands:@[@"Cell2"] artwork:nil secondaryArtwork:nil];
                SDLChoiceCell *cellWithAllText = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:@"Cell2" tertiaryText:@"Cell2" voiceCommands:nil artwork:nil secondaryArtwork:nil];
                cellsWithoutArtwork = [[NSOrderedSet alloc] initWithArray:@[cellBasic, cellWithVR, cellWithAllText]];
            });

            it(@"should skip to preloading cells", ^{
                expect(@(testOp.currentState)).to(equal(SDLPreloadChoicesOperationStatePreloadingChoices));
            });

            describe(@"assembling choices", ^{
                it(@"should be correct with no text and VR required", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithoutArtwork updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp start];
                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));
                    expect(receivedRequests.lastObject.choiceSet.firstObject.menuName).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.secondaryText).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.tertiaryText).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.vrCommands).toNot(beNil());
                });

                it(@"should be correct with only primary text", ^{
                    SDLTextField *primaryTextField = [[SDLTextField alloc] init];
                    primaryTextField.name = SDLTextFieldNameMenuName;
                    windowCapability.textFields = @[primaryTextField];

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithoutArtwork updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));
                    expect(receivedRequests.lastObject.choiceSet.firstObject.menuName).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.secondaryText).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.tertiaryText).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.vrCommands).toNot(beNil());
                });

                it(@"should be correct with primary and secondary text", ^{
                    SDLTextField *primaryTextField = [[SDLTextField alloc] init];
                    primaryTextField.name = SDLTextFieldNameMenuName;
                    SDLTextField *secondaryTextField = [[SDLTextField alloc] init];
                    secondaryTextField.name = SDLTextFieldNameSecondaryText;
                    windowCapability.textFields = @[primaryTextField, secondaryTextField];

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithoutArtwork updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));
                    expect(receivedRequests.lastObject.choiceSet.firstObject.menuName).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.secondaryText).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.tertiaryText).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.vrCommands).toNot(beNil());
                });

                it(@"should be correct with all text", ^{
                    SDLTextField *primaryTextField = [[SDLTextField alloc] init];
                    primaryTextField.name = SDLTextFieldNameMenuName;
                    SDLTextField *secondaryTextField = [[SDLTextField alloc] init];
                    secondaryTextField.name = SDLTextFieldNameSecondaryText;
                    SDLTextField *tertiaryTextField = [[SDLTextField alloc] init];
                    tertiaryTextField.name = SDLTextFieldNameTertiaryText;
                    windowCapability.textFields = @[primaryTextField, secondaryTextField, tertiaryTextField];

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithoutArtwork updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));
                    expect(receivedRequests.lastObject.choiceSet.firstObject.menuName).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.secondaryText).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.tertiaryText).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.vrCommands).toNot(beNil());
                });

                it(@"should be correct with VR optional", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:YES cellsToPreload:cellsWithoutArtwork updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));
                    expect(receivedRequests.lastObject.choiceSet.firstObject.menuName).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.secondaryText).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.tertiaryText).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.vrCommands).to(beNil());
                });
            });
        });

        context(@"updating choices", ^{
            __block SDLChoiceCell *testCell1 = nil;
            __block SDLChoiceCell *testCell2 = nil;
            __block NSOrderedSet<SDLChoiceCell *> *testCells = nil;

            beforeEach(^{
                testCell1 = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:nil voiceCommands:nil];
                testCell2 = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:[SDLArtwork artworkWithStaticIcon:SDLStaticIconNameClock]];
                testCells = [[NSOrderedSet alloc] initWithArray:@[testCell1, testCell2]];
            });

            describe(@"if a choice item is removed", ^{
                it(@"should be removed if the removal is attempted while the operation is pending", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:testCells updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp removeChoicesFromUpload:[NSSet setWithArray:@[testCell1]]];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(1));
                    expect(receivedRequests[0].choiceSet[0].menuName).to(equal(testCell2.text));
                });

                it(@"should not be removed if the removal is attempted while operation is executing", ^{
                    SDLTextField *primaryTextField = [[SDLTextField alloc] init];
                    primaryTextField.name = SDLTextFieldNameMenuName;
                    windowCapability.textFields = @[primaryTextField];

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:testCells updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp start];
                    [testOp removeChoicesFromUpload:[NSSet setWithArray:@[testCell1]]];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(2));
                    expect(receivedRequests[0].choiceSet[0].menuName).to(equal(testCell1.text));
                    expect(receivedRequests[1].choiceSet[0].menuName).to(equal(testCell2.text));
                });
            });
        });

        describe(@"the module's response to choice uploads", ^{
            __block SDLChoiceCell *testCell1 = nil;
            __block SDLChoiceCell *testCell2 = nil;
            __block NSOrderedSet<SDLChoiceCell *> *testCells = nil;
            __block SDLCreateInteractionChoiceSetResponse *testBadResponse = nil;
            __block SDLCreateInteractionChoiceSetResponse *testGoodResponse = nil;

            beforeEach(^{
                testCell1 = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:nil voiceCommands:nil];
                testCell1.choiceId = 55;
                testCell2 = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:nil secondaryArtwork:[SDLArtwork artworkWithStaticIcon:SDLStaticIconNameClock]];
                testCell2.choiceId = 66;
                testCells = [[NSOrderedSet alloc] initWithArray:@[testCell1, testCell2]];

                testBadResponse = [[SDLCreateInteractionChoiceSetResponse alloc] init];
                testBadResponse.success = @NO;
                testBadResponse.resultCode = SDLResultRejected;

                testGoodResponse = [[SDLCreateInteractionChoiceSetResponse alloc] init];
                testGoodResponse.success = @YES;
                testGoodResponse.resultCode = SDLResultSuccess;
            });

            context(@"when a bad response comes back", ^{
                 it(@"should add the choiceID of the failed choice item to the failedChoiceUploadIDs array", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:testCells updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(2));
                    expect(receivedRequests[0].choiceSet[0].menuName).to(equal(testCell1.text));
                    expect(receivedRequests[1].choiceSet[0].menuName).to(equal(testCell2.text));

                    [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:0 error:nil];
                    [testConnectionManager respondToRequestWithResponse:testBadResponse requestNumber:1 error:[NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorUploadFailed userInfo:nil]];

                    expect(testOp.failedChoiceUploadIDs.count).to(equal(1));
                    expect(testOp.failedChoiceUploadIDs).to(contain(@(testCell2.choiceId)));
                    expect(testOp.failedChoiceUploadIDs).toNot(contain(@(testCell1.choiceId)));
                });
            });

            context(@"when only good responses comes back", ^{
                it(@"should leave the failedChoiceUploadIDs array empty", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:testCells updateCompletionHandler:^(NSArray<NSNumber *> * _Nullable failedChoiceUploadIDs) {}];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(2));
                    expect(receivedRequests[0].choiceSet[0].menuName).to(equal(testCell1.text));
                    expect(receivedRequests[1].choiceSet[0].menuName).to(equal(testCell2.text));

                    [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:0 error:nil];
                    [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:1 error:nil];

                    expect(testOp.failedChoiceUploadIDs).to(beEmpty());
                });
            });
        });
    });
});

QuickSpecEnd
