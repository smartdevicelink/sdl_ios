#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLPreloadChoicesOperation.h"

#import "SDLChoice.h"
#import "SDLChoiceCell.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLDisplayType.h"
#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLImageField.h"
#import "SDLImageFieldName.h"
#import "SDLTextField.h"
#import "SDLTextFieldName.h"
#import "SDLWindowCapability.h"
#import "TestConnectionManager.h"

@interface SDLPreloadChoicesOperation()

@property (strong, nonatomic) NSUUID *operationId;
@property (strong, nonatomic) NSMutableOrderedSet<SDLChoiceCell *> *cellsToUpload;
@property (strong, nonatomic) SDLWindowCapability *windowCapability;
@property (strong, nonatomic) NSString *displayName;
@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;
@property (copy, nonatomic) SDLPreloadChoicesCompletionHandler completionHandler;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (copy, nonatomic, nullable) NSError *internalError;

@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *mutableLoadedCells;

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
    __block SDLVersion *choiceSetUniquenessActiveVersion = nil;

    __block SDLWindowCapability *enabledWindowCapability = nil;
    __block SDLWindowCapability *disabledWindowCapability = nil;
    __block SDLWindowCapability *primaryTextOnlyCapability = nil;

    __block NSSet<SDLChoiceCell *> *emptyLoadedCells = [NSSet set];
    __block NSData *cellArtData = [@"testart" dataUsingEncoding:NSUTF8StringEncoding];
    __block NSData *cellArtData2 = [@"testart2" dataUsingEncoding:NSUTF8StringEncoding];
    __block NSOrderedSet<SDLChoiceCell *> *cellsWithArtwork = nil;
    __block NSOrderedSet<SDLChoiceCell *> *cellsWithStaticIcon = nil;
    __block NSString *art1Name = @"Art1Name";
    __block NSString *art2Name = @"Art2Name";
    __block SDLArtwork *cell1Art2 = [[SDLArtwork alloc] initWithData:cellArtData2 name:art1Name fileExtension:@"png" persistent:NO];

    __block SDLChoiceCell *cellBasic = nil;
    __block SDLChoiceCell *cellBasicDuplicate = nil;
    __block SDLChoiceCell *cellWithVR = nil;
    __block SDLChoiceCell *cellWithAllText = nil;

    __block NSOrderedSet<SDLChoiceCell *> *cellsWithoutArtwork = nil;

    __block NSSet<SDLChoiceCell *> *resultChoices = nil;
    __block NSError *resultError = nil;

    beforeEach(^{
        choiceSetUniquenessActiveVersion = [[SDLVersion alloc] initWithMajor:7 minor:1 patch:0];

        resultError = nil;
        resultChoices = nil;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);

        enabledWindowCapability = [[SDLWindowCapability alloc] init];
        enabledWindowCapability.textFields = @[
            [[SDLTextField alloc] initWithName:SDLTextFieldNameMenuName characterSet:SDLCharacterSetUtf8 width:500 rows:1],
            [[SDLTextField alloc] initWithName:SDLTextFieldNameSecondaryText characterSet:SDLCharacterSetUtf8 width:500 rows:1],
            [[SDLTextField alloc] initWithName:SDLTextFieldNameTertiaryText characterSet:SDLCharacterSetUtf8 width:500 rows:1]
        ];
        enabledWindowCapability.imageFields = @[
            [[SDLImageField alloc] initWithName:SDLImageFieldNameChoiceImage imageTypeSupported:@[SDLFileTypePNG] imageResolution:nil],
            [[SDLImageField alloc] initWithName:SDLImageFieldNameChoiceSecondaryImage imageTypeSupported:@[SDLFileTypePNG] imageResolution:nil]
        ];
        disabledWindowCapability = [[SDLWindowCapability alloc] init];
        disabledWindowCapability.textFields = @[];
        primaryTextOnlyCapability = [[SDLWindowCapability alloc] init];
        primaryTextOnlyCapability.textFields = @[
            [[SDLTextField alloc] initWithName:SDLTextFieldNameMenuName characterSet:SDLCharacterSetUtf8 width:500 rows:1],
        ];

        SDLArtwork *cell1Art = [[SDLArtwork alloc] initWithData:cellArtData name:art1Name fileExtension:@"png" persistent:NO];
        SDLChoiceCell *cell1WithArt = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:cell1Art voiceCommands:nil];
        SDLArtwork *cell2Art = [[SDLArtwork alloc] initWithData:cellArtData name:art2Name fileExtension:@"png" persistent:NO];
        SDLChoiceCell *cell2WithArtAndSecondary = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:cell2Art secondaryArtwork:cell2Art];

        SDLArtwork *staticIconArt = [SDLArtwork artworkWithStaticIcon:SDLStaticIconNameDate];
        SDLChoiceCell *cellWithStaticIcon = [[SDLChoiceCell alloc] initWithText:@"Static Icon" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:staticIconArt secondaryArtwork:nil];

        cellsWithArtwork = [[NSOrderedSet alloc] initWithArray:@[cell1WithArt, cell2WithArtAndSecondary]];
        cellsWithStaticIcon = [[NSOrderedSet alloc] initWithArray:@[cellWithStaticIcon]];

        cellBasic = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:nil voiceCommands:nil];
        cellBasicDuplicate = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:nil voiceCommands:nil];
        cellWithVR = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:nil tertiaryText:nil voiceCommands:@[@"Cell2"] artwork:nil secondaryArtwork:nil];
        cellWithAllText = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:@"Cell2" tertiaryText:@"Cell2" voiceCommands:nil artwork:nil secondaryArtwork:nil];
        cellsWithoutArtwork = [[NSOrderedSet alloc] initWithArray:@[cellBasic, cellWithVR, cellWithAllText]];
    });

    it(@"should have a priority of 'normal'", ^{
        testOp = [[SDLPreloadChoicesOperation alloc] init];

        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    describe(@"running the operation", ^{
        beforeEach(^{
            OCMStub([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
            OCMStub([testFileManager fileNeedsUpload:[OCMArg isNotNil]]).andReturn(YES);
        });

        describe(@"updating cells for uniqueness", ^{
            context(@"when some choices are already uploaded with duplicate titles version >= 7.1.0", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = choiceSetUniquenessActiveVersion;
                });

                context(@"if there are duplicate cells once you strip unused cell properties", ^{
                    beforeEach(^{
                        testOp.windowCapability = primaryTextOnlyCapability;
                    });

                    fit(@"should update the choiceCells' unique title", ^{
                        for (SDLChoiceCell *choiceCell in testOp.cellsToUpload) {
                            if (choiceCell.secondaryText) {
                                expect(choiceCell.uniqueText).to(equal("test1 (2)"));
                            } else {
                                expect(choiceCell.uniqueText).to(equal("test1"));
                            }
                        }
                        expect(testOp.cellsToUpload).to(haveCount(2));
                        expect(testOp.cellsToUpload).to(contain(cellBasic));
                        expect(testOp.cellsToUpload).to(contain(cellBasicDuplicate));
                    });
                });

                context(@"if all cell properties are used", ^{
                    beforeEach(^{
                        testOp.windowCapability = enabledWindowCapability;
                    });

                    it(@"should not update the choiceCells' unique title", ^{
                        NSArray<SDLChoiceCell *> *cellsToUpload = testOp.cellsToUpload.array;
                        for (SDLChoiceCell *choiceCell in cellsToUpload) {
                            expect(choiceCell.uniqueText).to(equal("test1"));
                        }
                        expect(cellsToUpload).to(haveCount(2));
                        expect(cellsToUpload).to(contain(cellBasic));
                        expect(cellsToUpload).to(contain(cellBasicDuplicate));
                    });
                });
            });

            context(@"when some choices are already uploaded with duplicate titles version <= 7.1.0", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = [[SDLVersion alloc] initWithMajor:7 minor:0 patch:0];
                    [testManager preloadChoices:@[cellBasic, cellWithVR] withCompletionHandler:^(NSError * _Nullable error) { }];
                });

                it(@"append a number to the unique text for choice set cells", ^{
                    NSArray<SDLChoiceCell *> *cellsToUpload = testOp.cellsToUpload.allObjects;
                    for (SDLChoiceCell *choiceCell in cellsToUpload) {
                        if (choiceCell.secondaryText) {
                            expect(choiceCell.uniqueText).to(equal("test1 (2)"));
                        } else {
                            expect(choiceCell.uniqueText).to(equal("test1"));
                        }
                    }
                    expect(cellsToUpload).to(haveCount(2));
                    expect(cellsToUpload).to(contain(cellBasic));
                    expect(cellsToUpload).to(contain(cellBasicDuplicate));
                });
            });
        });

        context(@"with artworks", ^{
            context(@"if the menuName is not set", ^{
                it(@"should not send any requests", ^{
                    SDLTextField *primaryTextField = [[SDLTextField alloc] init];
                    primaryTextField.name = SDLTextFieldNameMenuName;
                    windowCapability.textFields = @[];

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultError = error;
                        resultChoices = updatedLoadedCells;
                    }];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;
                    
                    expect(receivedRequests).to(haveCount(0));
                });
            });

            context(@"only main text capabilities", ^{
                it(@"should skip to preloading cells", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        error = resultError;
                    }];
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

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        resultError = error;
                    }];
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

                        testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                            resultChoices = updatedLoadedCells;
                            resultError = error;
                        }];
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
                        testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                            resultChoices = updatedLoadedCells;
                            resultError = error;
                        }];
                        [testOp start];

                        OCMExpect([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
                        OCMVerify([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
                    });
                });

                context(@"when artworks are static icons", ^{
                    beforeEach(^{
                        testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithStaticIcon loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                            resultChoices = updatedLoadedCells;
                            resultError = error;
                        }];
                        [testOp start];
                    });

                    it(@"should skip uploading artwork", ^{
                        OCMReject([testFileManager uploadArtwork:[OCMArg any] completionHandler:[OCMArg any]]);
                    });
                });

                context(@"when artwork are not already on the system", ^{
                    beforeEach(^{
                        OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);

                        testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithArtwork loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                            resultChoices = updatedLoadedCells;
                            resultError = error;
                        }];
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
            it(@"should skip to preloading cells", ^{
                expect(@(testOp.currentState)).to(equal(SDLPreloadChoicesOperationStatePreloadingChoices));
            });

            describe(@"assembling choices", ^{
                it(@"should skip preloading the choices if all choice items have already been uploaded", ^{
                    // TODO
                });

                it(@"should be correct with no text and VR required", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithoutArtwork loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        resultError = error;
                    }];
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

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithoutArtwork loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        resultError = error;
                    }];
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

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithoutArtwork loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        resultError = error;
                    }];
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

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:cellsWithoutArtwork loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        resultError = error;
                    }];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));
                    expect(receivedRequests.lastObject.choiceSet.firstObject.menuName).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.secondaryText).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.tertiaryText).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.vrCommands).toNot(beNil());
                });

                it(@"should be correct with VR optional", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:YES cellsToPreload:cellsWithoutArtwork loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        resultError = error;
                    }];
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
                it(@"should not add the item to the list of loaded cells", ^{
                    // TODO
                });
                it(@"should add the choiceID of the failed choice item to the failedChoiceUploadIDs array", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:testCells loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        resultError = error;
                    }];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(2));
                    expect(receivedRequests[0].choiceSet[0].menuName).to(equal(testCell1.text));
                    expect(receivedRequests[1].choiceSet[0].menuName).to(equal(testCell2.text));

                    [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:0 error:nil];
                    [testConnectionManager respondToRequestWithResponse:testBadResponse requestNumber:1 error:[NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorUploadFailed userInfo:nil]];
                    [testConnectionManager respondToLastMultipleRequestsWithSuccess:NO];

                    expect(testOp.loadedCells).to(haveCount(1));
                    expect(testOp.loadedCells).to(contain(testCell1));
                    expect(testOp.loadedCells).toNot(contain(testCell2));
                    expect(testOp.error).toNot(beNil());
                    expect(resultChoices).toNot(beNil());
                    expect(resultError).toNot(beNil());
                });
            });

            context(@"when only good responses comes back", ^{
                it(@"should leave the failedChoiceUploadIDs array empty", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:windowCapability isVROptional:NO cellsToPreload:testCells loadedCells:emptyLoadedCells completionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        resultError = error;
                    }];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(2));
                    expect(receivedRequests[0].choiceSet[0].menuName).to(equal(testCell1.text));
                    expect(receivedRequests[1].choiceSet[0].menuName).to(equal(testCell2.text));

                    [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:0 error:nil];
                    [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:1 error:nil];
                    [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                    expect(resultChoices).to(haveCount(2));
                    expect(resultError).to(beNil());
                });
            });
        });
    });
});

QuickSpecEnd
