#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import <SmartDeviceLink/SmartDeviceLink.h>
#import "SDLError.h"
#import "SDLPreloadPresentChoicesOperation.h"

#import "SDLGlobals.h"
#import "TestConnectionManager.h"

@interface SDLPreloadPresentChoicesOperation()

// Dependencies
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (strong, nonatomic) SDLWindowCapability *windowCapability;

// Preload Dependencies
@property (strong, nonatomic) NSMutableOrderedSet<SDLChoiceCell *> *cellsToUpload;
@property (strong, nonatomic) NSString *displayName;
@property (assign, nonatomic, readwrite, getter=isVROptional) BOOL vrOptional;
@property (copy, nonatomic) SDLUploadChoicesCompletionHandler preloadCompletionHandler;

// Present Dependencies
@property (strong, nonatomic) SDLChoiceSet *choiceSet;
@property (strong, nonatomic, nullable) SDLInteractionMode presentationMode;
@property (strong, nonatomic, nullable) SDLKeyboardProperties *originalKeyboardProperties;
@property (strong, nonatomic, nullable) SDLKeyboardProperties *customKeyboardProperties;
@property (weak, nonatomic, nullable) id<SDLKeyboardDelegate> keyboardDelegate;
@property (assign, nonatomic) UInt16 cancelId;

// Internal operation properties
@property (strong, nonatomic) NSUUID *operationId;
@property (copy, nonatomic, nullable) NSError *internalError;

// Mutable state
@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *mutableLoadedCells;

@end

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

QuickSpecBegin(SDLPreloadPresentChoicesOperationSpec)

describe(@"a preload choices operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block SDLPreloadPresentChoicesOperation *testOp = nil;
    __block NSString *testDisplayName = @"SDL_GENERIC";
    __block SDLVersion *choiceSetUniquenessActiveVersion = [[SDLVersion alloc] initWithMajor:7 minor:1 patch:0];
    __block SDLVersion *choiceSetUniquenessInactiveVersion = [[SDLVersion alloc] initWithMajor:7 minor:0 patch:0];

    __block SDLWindowCapability *enabledWindowCapability = nil;
    __block SDLWindowCapability *disabledWindowCapability = nil;
    __block SDLWindowCapability *primaryTextOnlyCapability = nil;

    __block NSSet<SDLChoiceCell *> *emptyLoadedCells = [NSSet set];
    __block NSArray<SDLChoiceCell *> *cellsWithArtwork = nil;
    __block NSArray<SDLChoiceCell *> *cellsWithStaticIcon = nil;
    __block NSArray<SDLChoiceCell *> *cellsWithoutArtwork = nil;

    __block NSData *cellArtData = [@"testart" dataUsingEncoding:NSUTF8StringEncoding];
    __block NSData *cellArtData2 = [@"testart2" dataUsingEncoding:NSUTF8StringEncoding];
    __block NSString *art1Name = @"Art1Name";
    __block NSString *art2Name = @"Art2Name";
    __block SDLArtwork *cell1Art2 = [[SDLArtwork alloc] initWithData:cellArtData2 name:art1Name fileExtension:@"png" persistent:NO];

    __block SDLChoiceCell *cellBasic = nil;
    __block SDLChoiceCell *cellBasicDuplicate = nil;
    __block SDLChoiceCell *cellWithVR = nil;
    __block SDLChoiceCell *cellWithAllText = nil;

    __block SDLCreateInteractionChoiceSetResponse *testBadResponse = nil;
    __block SDLCreateInteractionChoiceSetResponse *testGoodResponse = nil;

    __block NSSet<SDLChoiceCell *> *resultChoices = nil;
    __block NSError *resultPreloadError = nil;

    __block SDLChoiceSet *testChoiceSet = nil;
    __block int testCancelID = 98;
    __block SDLInteractionMode testInteractionMode = SDLInteractionModeBoth;
    __block SDLKeyboardProperties *testKeyboardProperties = nil;
    __block id<SDLKeyboardDelegate> testKeyboardDelegate = nil;
    __block id<SDLChoiceSetDelegate> testChoiceDelegate = nil;

    beforeEach(^{
        resultPreloadError = nil;
        resultChoices = nil;

        testConnectionManager = [[TestConnectionManager alloc] init];
        testFileManager = OCMClassMock([SDLFileManager class]);
        OCMStub([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
        OCMStub([testFileManager fileNeedsUpload:[OCMArg isNotNil]]).andReturn(YES);

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
        cell1WithArt.choiceId = 1;
        SDLArtwork *cell2Art = [[SDLArtwork alloc] initWithData:cellArtData name:art2Name fileExtension:@"png" persistent:NO];
        SDLChoiceCell *cell2WithArtAndSecondary = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:cell2Art secondaryArtwork:cell2Art];
        cell2WithArtAndSecondary.choiceId = 2;

        SDLArtwork *staticIconArt = [SDLArtwork artworkWithStaticIcon:SDLStaticIconNameDate];
        SDLChoiceCell *cellWithStaticIcon = [[SDLChoiceCell alloc] initWithText:@"Static Icon" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:staticIconArt secondaryArtwork:nil];
        cellWithStaticIcon.choiceId = 3;

        cellsWithArtwork = @[cell1WithArt, cell2WithArtAndSecondary];
        cellsWithStaticIcon = @[cellWithStaticIcon];

        cellBasic = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:nil voiceCommands:nil];
        cellBasic.choiceId = 4;
        cellBasicDuplicate = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:nil voiceCommands:nil];
        cellBasicDuplicate.choiceId = 5;
        cellWithVR = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:nil tertiaryText:nil voiceCommands:@[@"Cell2"] artwork:nil secondaryArtwork:nil];
        cellWithVR.choiceId = 6;
        cellWithAllText = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:@"Cell2" tertiaryText:@"Cell2" voiceCommands:nil artwork:nil secondaryArtwork:nil];
        cellWithAllText.choiceId = 7;
        cellsWithoutArtwork = @[cellBasic, cellWithVR, cellWithAllText];

        testBadResponse = [[SDLCreateInteractionChoiceSetResponse alloc] init];
        testBadResponse.success = @NO;
        testBadResponse.resultCode = SDLResultRejected;

        testGoodResponse = [[SDLCreateInteractionChoiceSetResponse alloc] init];
        testGoodResponse.success = @YES;
        testGoodResponse.resultCode = SDLResultSuccess;

        testChoiceDelegate = OCMProtocolMock(@protocol(SDLChoiceSetDelegate));
        testKeyboardDelegate = OCMProtocolMock(@protocol(SDLKeyboardDelegate));
        OCMStub([testKeyboardDelegate customKeyboardConfiguration]).andReturn(nil);
        testKeyboardProperties = [[SDLKeyboardProperties alloc] initWithLanguage:SDLLanguageArSa keyboardLayout:SDLKeyboardLayoutAZERTY keypressMode:SDLKeypressModeResendCurrentEntry limitedCharacterList:nil autoCompleteList:nil maskInputCharacters:nil customKeys:nil];
        testChoiceSet = [[SDLChoiceSet alloc] initWithTitle:@"Choice Set" delegate:testChoiceDelegate layout:SDLChoiceSetLayoutTiles timeout:8.0 initialPromptString:@"Initial Prompt" timeoutPromptString:@"Timeout Prompt" helpPromptString:@"Help Prompt" vrHelpList:nil choices:cellsWithoutArtwork];
    });

    it(@"should have a priority of 'normal'", ^{
        testOp = [[SDLPreloadPresentChoicesOperation alloc] init];

        expect(@(testOp.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
    });

    context(@"running a preload only operation", ^{
        describe(@"updating cells for uniqueness", ^{
            beforeEach(^{
                testOp = [[SDLPreloadPresentChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:enabledWindowCapability isVROptional:YES cellsToPreload:@[cellWithVR] loadedCells:[NSSet setWithArray:@[cellWithAllText]] preloadCompletionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {}];
            });

            context(@"when some choices are already uploaded with duplicate titles version >= 7.1.0", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = choiceSetUniquenessActiveVersion;
                });

                context(@"if there are duplicate cells once you strip unused cell properties", ^{
                    beforeEach(^{
                        testOp.windowCapability = primaryTextOnlyCapability;
                        testOp.loadedCells = [NSSet setWithObject:[[SDLChoiceCell alloc] initWithText:@"Cell2"]];
                        [testOp start];
                    });

                    it(@"should update the choiceCells' unique title", ^{
                        expect(testOp.cellsToUpload.count).to(equal(1));
                        expect(testOp.cellsToUpload[0].uniqueText).to(equal(@"Cell2 (2)"));
                    });
                });

                context(@"if all cell properties are used", ^{
                    beforeEach(^{
                        testOp.windowCapability = enabledWindowCapability;
                        [testOp start];
                    });

                    it(@"should not update the choiceCells' unique title", ^{
                        expect(testOp.cellsToUpload[0].uniqueText).to(equal("Cell2"));
                        expect(testOp.cellsToUpload.count).to(equal(1));
                    });
                });
            });

            context(@"when some choices are already uploaded with duplicate titles version <= 7.1.0", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = choiceSetUniquenessInactiveVersion;
                });

                context(@"if all cell properties are used", ^{
                    beforeEach(^{
                        testOp.windowCapability = enabledWindowCapability;
                        [testOp start];
                    });

                    it(@"should update the choiceCells' unique title", ^{
                        expect(testOp.cellsToUpload[0].uniqueText).to(equal("Cell2 (2)"));
                        expect(testOp.cellsToUpload.count).to(equal(1));
                    });
                });
            });
        });

        context(@"with artworks", ^{
            context(@"only primary text allowed", ^{
                it(@"should skip loading artworks to preloading cells", ^{
                    testOp = [[SDLPreloadPresentChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:primaryTextOnlyCapability isVROptional:YES cellsToPreload:cellsWithArtwork loadedCells:emptyLoadedCells preloadCompletionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultPreloadError = error;
                        resultChoices = updatedLoadedCells;
                    }];
                    [testOp start];

                    for (SDLRPCRequest *request in testConnectionManager.receivedRequests) {
                        expect(request).toNot(beAnInstanceOf(SDLPutFile.class));
                    }
                    expect(testConnectionManager.receivedRequests).to(haveCount(2));
                });
            });

            context(@"all text and image display capabilities", ^{
                beforeEach(^{
                    testOp = [[SDLPreloadPresentChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:enabledWindowCapability isVROptional:YES cellsToPreload:cellsWithArtwork loadedCells:emptyLoadedCells preloadCompletionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultPreloadError = error;
                        resultChoices = updatedLoadedCells;
                    }];
                });

                context(@"when artworks are already on the system", ^{
                    beforeEach(^{
                        OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);
                    });

                    it(@"should not upload artworks", ^{
                        OCMReject([testFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id obj) {
                            NSArray<SDLArtwork *> *artworks = (NSArray<SDLArtwork *> *)obj;
                            return (artworks.count == 2);
                        }] completionHandler:[OCMArg any]]);

                        [testOp start];

                        OCMVerifyAll(testFileManager);
                    });

                    it(@"should properly overwrite artwork", ^{
                        cell1Art2.overwrite = YES;
                        SDLChoiceCell *cellOverwriteArt = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:cell1Art2 voiceCommands:nil];

                        testOp.cellsToUpload = [NSMutableOrderedSet orderedSetWithArray:@[cellOverwriteArt]];
                        [testOp start];

                        OCMVerify([testFileManager uploadArtworks:[OCMArg isNotNil] completionHandler:[OCMArg any]]);
                    });
                });

                context(@"when artworks are static icons", ^{
                    beforeEach(^{
                        testOp.cellsToUpload = [NSMutableOrderedSet orderedSetWithArray:cellsWithStaticIcon];
                        [testOp start];
                    });

                    it(@"should skip uploading artwork", ^{
                        OCMReject([testFileManager uploadArtwork:[OCMArg any] completionHandler:[OCMArg any]]);
                    });
                });

                context(@"when artwork are not already on the system", ^{
                    beforeEach(^{
                        OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);

                        testOp.cellsToUpload = [NSMutableOrderedSet orderedSetWithArray:cellsWithArtwork];
                        testOp.loadedCells = [NSSet set];
                    });

                    it(@"should upload artworks", ^{
                        [testOp start];
                        OCMVerify([testFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id obj) {
                            NSArray<SDLArtwork *> *artworks = (NSArray<SDLArtwork *> *)obj;
                            return (artworks.count == 3);
                        }] completionHandler:[OCMArg any]]);
                    });
                });
            });
        });

        context(@"without artworks", ^{
            describe(@"only main text capabilities", ^{
                it(@"should skip loading artworks to preloading cells", ^{
                    testOp = [[SDLPreloadPresentChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:primaryTextOnlyCapability isVROptional:YES cellsToPreload:cellsWithArtwork loadedCells:emptyLoadedCells preloadCompletionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultPreloadError = error;
                        resultChoices = updatedLoadedCells;
                    }];
                    [testOp start];

                    for (SDLRPCRequest *request in testConnectionManager.receivedRequests) {
                        expect(request).toNot(beAnInstanceOf(SDLPutFile.class));
                    }
                    expect(testConnectionManager.receivedRequests).to(haveCount(2));
                });
            });

            describe(@"assembling choices", ^{
                beforeEach(^{
                    testOp = [[SDLPreloadPresentChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:enabledWindowCapability isVROptional:YES cellsToPreload:cellsWithoutArtwork loadedCells:emptyLoadedCells preloadCompletionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        resultPreloadError = error;
                    }];
                });

                it(@"should skip preloading the choices if all choice items have already been uploaded", ^{
                    testOp.loadedCells = [NSSet setWithArray:cellsWithoutArtwork];
                    [testOp start];

                    expect(testConnectionManager.receivedRequests).to(haveCount(0));
                });

                it(@"should not send any requests if all items are disabled", ^{
                    testOp.windowCapability = disabledWindowCapability;
                    [testOp start];

                    expect(testConnectionManager.receivedRequests).to(haveCount(0));
                });

                it(@"should be correct with only primary text", ^{
                    testOp.windowCapability = primaryTextOnlyCapability;
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));

                    SDLChoice *representativeItem = receivedRequests.lastObject.choiceSet.firstObject;
                    expect(representativeItem.menuName).toNot(beNil());
                    expect(representativeItem.secondaryText).to(beNil());
                    expect(representativeItem.tertiaryText).to(beNil());
                });

                it(@"should be correct with all text", ^{
                    SDLWindowCapability *allTextCapability = [enabledWindowCapability copy];
                    allTextCapability.imageFields = @[];
                    testOp.windowCapability = allTextCapability;
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));

                    SDLChoice *representativeItem = receivedRequests.lastObject.choiceSet.firstObject;
                    expect(representativeItem.menuName).toNot(beNil());
                    expect(representativeItem.secondaryText).toNot(beNil());
                    expect(representativeItem.tertiaryText).toNot(beNil());
                });

                it(@"should be correct with VR required", ^{
                    testOp.vrOptional = NO;
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));

                    // The last item has no VR
                    SDLChoice *representativeItem = receivedRequests.lastObject.choiceSet.firstObject;
                    expect(representativeItem.vrCommands).toNot(beNil());
                });

                it(@"should be correct with VR Optional", ^{
                    testOp.vrOptional = YES;
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));

                    // The middle item is the one with VR
                    SDLChoice *representativeItem = receivedRequests.lastObject.choiceSet.firstObject;
                    expect(representativeItem.vrCommands).to(beNil());
                });
            });
        });

        describe(@"the module's response to choice uploads", ^{
            context(@"when a bad response comes back", ^{
                beforeEach(^{
                    testOp = [[SDLPreloadPresentChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:primaryTextOnlyCapability isVROptional:YES cellsToPreload:cellsWithoutArtwork loadedCells:emptyLoadedCells preloadCompletionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        resultPreloadError = error;
                    }];
                });

                it(@"should not add the item to the list of loaded cells", ^{
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));
                    expect(receivedRequests[0].choiceSet[0].menuName).to(equal(cellsWithoutArtwork[0].uniqueText));
                    expect(receivedRequests[1].choiceSet[0].menuName).to(equal(cellsWithoutArtwork[1].uniqueText));
                    expect(receivedRequests[2].choiceSet[0].menuName).to(equal(cellsWithoutArtwork[2].uniqueText));

                    [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:0 error:nil];
                    [testConnectionManager respondToRequestWithResponse:testBadResponse requestNumber:1 error:[NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorUploadFailed userInfo:nil]];
                    [testConnectionManager respondToLastMultipleRequestsWithSuccess:NO];

                    expect(testOp.loadedCells).to(haveCount(1));
                    expect(testOp.loadedCells).to(contain(cellsWithoutArtwork[0]));
                    expect(testOp.loadedCells).toNot(contain(cellsWithoutArtwork[1]));
                    expect(testOp.error).toNot(beNil());
                    expect(resultChoices).toNot(beNil());
                    expect(resultPreloadError).toNot(beNil());
                });
            });

            context(@"when only good responses comes back", ^{
                beforeEach(^{
                    testOp = [[SDLPreloadPresentChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayName:testDisplayName windowCapability:primaryTextOnlyCapability isVROptional:YES cellsToPreload:cellsWithoutArtwork loadedCells:emptyLoadedCells preloadCompletionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                        resultChoices = updatedLoadedCells;
                        resultPreloadError = error;
                    }];
                });

                it(@"should add all the items to the list of loaded cells", ^{
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));
                    expect(receivedRequests[0].choiceSet[0].menuName).to(equal(cellsWithoutArtwork[0].uniqueText));
                    expect(receivedRequests[1].choiceSet[0].menuName).to(equal(cellsWithoutArtwork[1].uniqueText));
                    expect(receivedRequests[2].choiceSet[0].menuName).to(equal(cellsWithoutArtwork[2].uniqueText));

                    [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:0 error:nil];
                    [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:1 error:nil];
                    [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:2 error:nil];
                    [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                    expect(testOp.loadedCells).to(haveCount(3));
                    expect(testOp.loadedCells).to(contain(cellsWithoutArtwork[0]));
                    expect(testOp.loadedCells).to(contain(cellsWithoutArtwork[1]));
                    expect(testOp.loadedCells).to(contain(cellsWithoutArtwork[2]));
                    expect(resultPreloadError).to(beNil());
                });
            });
        });
    });

    context(@"running a preload and present operation", ^{
        beforeEach(^{
            testOp = [[SDLPreloadPresentChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager choiceSet:testChoiceSet mode:testInteractionMode keyboardProperties:testKeyboardProperties keyboardDelegate:testKeyboardDelegate cancelID:testCancelID displayName:testDisplayName windowCapability:enabledWindowCapability isVROptional:YES loadedCells:emptyLoadedCells preloadCompletionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                resultChoices = updatedLoadedCells;
                resultPreloadError = error;
            }];
        });

        describe(@"updating cells for uniqueness", ^{
            beforeEach(^{
                testOp = [[SDLPreloadPresentChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager choiceSet:[[SDLChoiceSet alloc] initWithTitle:@"Test Choice Set" delegate:testChoiceDelegate choices:@[cellWithVR]] mode:testInteractionMode keyboardProperties:testKeyboardProperties keyboardDelegate:testKeyboardDelegate cancelID:testCancelID displayName:testDisplayName windowCapability:enabledWindowCapability isVROptional:YES loadedCells:[NSSet setWithArray:@[cellWithAllText]] preloadCompletionHandler:^(NSSet<SDLChoiceCell *> * _Nonnull updatedLoadedCells, NSError * _Nullable error) {
                    resultChoices = updatedLoadedCells;
                    resultPreloadError = error;
                }];
            });

            context(@"when some choices are already uploaded with duplicate titles version >= 7.1.0", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = choiceSetUniquenessActiveVersion;
                });

                context(@"if there are duplicate cells once you strip unused cell properties", ^{
                    beforeEach(^{
                        testOp.windowCapability = primaryTextOnlyCapability;
                        testOp.loadedCells = [NSSet setWithObject:[[SDLChoiceCell alloc] initWithText:@"Cell2"]];
                        [testOp start];
                    });

                    it(@"should update the choiceCells' unique title", ^{
                        expect(testOp.cellsToUpload.count).to(equal(1));
                        expect(testOp.cellsToUpload[0].uniqueText).to(equal(@"Cell2 (2)"));
                    });
                });

                context(@"if all cell properties are used", ^{
                    beforeEach(^{
                        testOp.windowCapability = enabledWindowCapability;
                        [testOp start];
                    });

                    it(@"should not update the choiceCells' unique title", ^{
                        expect(testOp.cellsToUpload[0].uniqueText).to(equal("Cell2"));
                        expect(testOp.cellsToUpload.count).to(equal(1));
                    });
                });
            });

            context(@"when some choices are already uploaded with duplicate titles version <= 7.1.0", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = choiceSetUniquenessInactiveVersion;
                });

                context(@"if all cell properties are used", ^{
                    beforeEach(^{
                        testOp.windowCapability = enabledWindowCapability;
                        [testOp start];
                    });

                    it(@"should update the choiceCells' unique title", ^{
                        expect(testOp.cellsToUpload[0].uniqueText).to(equal("Cell2 (2)"));
                        expect(testOp.cellsToUpload.count).to(equal(1));
                    });
                });
            });
        });

        describe(@"running a non-searchable choice set operation", ^{
            beforeEach(^{
                testOp.keyboardDelegate = nil;
                [testOp start];

                // Move us past the preload
                [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:0 error:nil];
                [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:1 error:nil];
                [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:2 error:nil];
                [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
            });

            it(@"should not update global keyboard properties", ^{
                for (SDLRPCRequest *req in testConnectionManager.receivedRequests) {
                    expect(req).toNot(beAnInstanceOf([SDLSetGlobalProperties class]));
                }
            });

            it(@"should send the perform interaction", ^{
                SDLPerformInteraction *request = testConnectionManager.receivedRequests.lastObject;
                expect(request).to(beAnInstanceOf([SDLPerformInteraction class]));

                expect(request.initialText).to(equal(testChoiceSet.title));
                expect(request.initialPrompt).to(equal(testChoiceSet.initialPrompt));
                expect(request.interactionMode).to(equal(testInteractionMode));
                expect(request.interactionLayout).to(equal(SDLLayoutModeIconOnly));
                expect(request.timeoutPrompt).to(equal(testChoiceSet.timeoutPrompt));
                expect(request.helpPrompt).to(equal(testChoiceSet.helpPrompt));
                expect(request.timeout).to(equal(testChoiceSet.timeout * 1000));
                expect(request.vrHelp).to(beNil());
                expect(request.interactionChoiceSetIDList).to(equal(@[@(cellsWithoutArtwork[0].choiceId), @(cellsWithoutArtwork[1].choiceId), @(cellsWithoutArtwork[2].choiceId)]));
                expect(request.cancelID).to(equal(testCancelID));
            });

            describe(@"after a perform interaction response", ^{
                __block UInt16 responseChoiceId = UINT16_MAX;
                __block SDLTriggerSource responseTriggerSource = SDLTriggerSourceMenu;

                beforeEach(^{
                    SDLPerformInteractionResponse *response = [[SDLPerformInteractionResponse alloc] init];
                    response.success = @YES;
                    response.choiceID = @(responseChoiceId);
                    response.triggerSource = responseTriggerSource;

                    [testConnectionManager respondToLastRequestWithResponse:response];
                });

                it(@"should not reset the keyboard properties and should be finished", ^{
                    expect(testConnectionManager.receivedRequests.lastObject).toNot(beAnInstanceOf([SDLSetGlobalProperties class]));
                    expect(testOp.isFinished).to(beTrue());
                });
            });
        });

        describe(@"running a searchable choice set operation", ^{
            beforeEach(^{
                [testOp start];

                // Move us past the preload
                [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:0 error:nil];
                [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:1 error:nil];
                [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:2 error:nil];
                [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];
            });

            it(@"should ask for custom properties", ^{
                OCMVerify([testKeyboardDelegate customKeyboardConfiguration]);

                expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLSetGlobalProperties class]));
            });

            describe(@"presenting the keyboard", ^{
                beforeEach(^{
                    SDLSetGlobalPropertiesResponse *response = [[SDLSetGlobalPropertiesResponse alloc] init];
                    response.success = @YES;
                    [testConnectionManager respondToLastRequestWithResponse:response];
                });

                it(@"should send the perform interaction", ^{
                    expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLPerformInteraction class]));
                    SDLPerformInteraction *request = testConnectionManager.receivedRequests.lastObject;
                    expect(request.initialText).to(equal(testChoiceSet.title));
                    expect(request.initialPrompt).to(equal(testChoiceSet.initialPrompt));
                    expect(request.interactionMode).to(equal(testInteractionMode));
                    expect(request.interactionLayout).to(equal(SDLLayoutModeIconWithSearch));
                    expect(request.timeoutPrompt).to(equal(testChoiceSet.timeoutPrompt));
                    expect(request.helpPrompt).to(equal(testChoiceSet.helpPrompt));
                    expect(request.timeout).to(equal(testChoiceSet.timeout * 1000));
                    expect(request.vrHelp).to(beNil());
                    expect(request.interactionChoiceSetIDList).to(equal(@[@(testChoiceSet.choices[0].choiceId), @(testChoiceSet.choices[1].choiceId), @(testChoiceSet.choices[2].choiceId)]));
                    expect(request.cancelID).to(equal(testCancelID));
                });

                it(@"should respond to submitted notifications", ^{
                    NSString *inputData = @"Test";
                    SDLRPCNotificationNotification *notification = nil;

                    // Submit notification
                    SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                    input.event = SDLKeyboardEventSubmitted;
                    input.data = inputData;
                    notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];

                    OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventSubmitted];
                    }] text:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(NSString *)obj isEqualToString:inputData];
                    }]]);

                    OCMVerify([testKeyboardDelegate userDidSubmitInput:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(NSString *)obj isEqualToString:inputData];
                    }] withEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventSubmitted];
                    }]]);
                });

                it(@"should respond to voice request notifications", ^{
                    SDLRPCNotificationNotification *notification = nil;

                    // Submit notification
                    SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                    input.event = SDLKeyboardEventVoice;
                    notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];

                    OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventVoice];
                    }] text:[OCMArg isNil]]);

                    OCMVerify([testKeyboardDelegate userDidSubmitInput:[OCMArg isNil] withEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventVoice];
                    }]]);
                });

                it(@"should respond to abort notifications", ^{
                    SDLRPCNotificationNotification *notification = nil;

                    // Submit notification
                    SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                    input.event = SDLKeyboardEventAborted;
                    notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];

                    OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventAborted];
                    }] text:[OCMArg isNil]]);

                    OCMVerify([testKeyboardDelegate keyboardDidAbortWithReason:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventAborted];
                    }]]);
                });

                it(@"should respond to enabled keyboard event", ^{
                    SDLRPCNotificationNotification *notification = nil;

                    // Submit notification
                    SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                    input.event = SDLKeyboardEventInputKeyMaskEnabled;
                    notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];

                    OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventInputKeyMaskEnabled];
                    }] text:[OCMArg isNil]]);

                    OCMVerify([testKeyboardDelegate keyboardDidUpdateInputMask:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventInputKeyMaskEnabled];
                    }]]);
                });

                it(@"should respond to cancellation notifications", ^{
                    SDLRPCNotificationNotification *notification = nil;

                    // Submit notification
                    SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                    input.event = SDLKeyboardEventCancelled;
                    notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];

                    OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventCancelled];
                    }] text:[OCMArg isNil]]);

                    OCMVerify([testKeyboardDelegate keyboardDidAbortWithReason:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventCancelled];
                    }]]);
                });

                it(@"should respond to text input notification with autocomplete", ^{
                    NSString *inputData = @"Test";
                    SDLRPCNotificationNotification *notification = nil;

                    OCMStub([testKeyboardDelegate updateAutocompleteWithInput:[OCMArg any] autoCompleteResultsHandler:([OCMArg invokeBlockWithArgs:@[inputData], nil])]);

                    // Submit notification
                    SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                    input.event = SDLKeyboardEventKeypress;
                    input.data = inputData;
                    notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];

                    OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventKeypress];
                    }] text:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(NSString *)obj isEqualToString:inputData];
                    }]]);

                    OCMVerify([testKeyboardDelegate updateAutocompleteWithInput:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(NSString *)obj isEqualToString:inputData];
                    }] autoCompleteResultsHandler:[OCMArg any]]);

                    expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLSetGlobalProperties class]));

                    SDLSetGlobalProperties *setProperties = testConnectionManager.receivedRequests.lastObject;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    expect(setProperties.keyboardProperties.autoCompleteText).to(equal(inputData));
#pragma clang diagnostic pop
                });

                it(@"should respond to text input notification with character set", ^{
                    NSString *inputData = @"Test";
                    SDLRPCNotificationNotification *notification = nil;

                    OCMStub([testKeyboardDelegate updateCharacterSetWithInput:[OCMArg any] completionHandler:([OCMArg invokeBlockWithArgs:@[inputData], nil])]);

                    // Submit notification
                    SDLOnKeyboardInput *input = [[SDLOnKeyboardInput alloc] init];
                    input.event = SDLKeyboardEventKeypress;
                    input.data = inputData;
                    notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveKeyboardInputNotification object:nil rpcNotification:input];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];

                    OCMVerify([testKeyboardDelegate keyboardDidSendEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(SDLKeyboardEvent)obj isEqualToEnum:SDLKeyboardEventKeypress];
                    }] text:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(NSString *)obj isEqualToString:inputData];
                    }]]);

                    OCMVerify([testKeyboardDelegate updateCharacterSetWithInput:[OCMArg checkWithBlock:^BOOL(id obj) {
                        return [(NSString *)obj isEqualToString:inputData];
                    }] completionHandler:[OCMArg any]]);

                    expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLSetGlobalProperties class]));

                    SDLSetGlobalProperties *setProperties = testConnectionManager.receivedRequests.lastObject;
                    expect(setProperties.keyboardProperties.limitedCharacterList).to(equal(@[inputData]));
                });

                describe(@"after a perform interaction response", ^{
                    beforeEach(^{
                        SDLPerformInteractionResponse *response = [[SDLPerformInteractionResponse alloc] init];
                        response.success = @YES;
                        response.choiceID = @65535;
                        response.triggerSource = SDLTriggerSourceVoiceRecognition;

                        [testConnectionManager respondToLastRequestWithResponse:response];
                    });

                    it(@"should reset the keyboard properties", ^{
                        expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLSetGlobalProperties class]));
                    });

                    describe(@"after the reset response", ^{
                        __block SDLSetGlobalPropertiesResponse *response = [[SDLSetGlobalPropertiesResponse alloc] init];
                        beforeEach(^{
                            response.success = @YES;
                        });

                        it(@"should be finished", ^{
                            OCMExpect([testChoiceDelegate choiceSet:[OCMArg isEqual:testChoiceSet] didSelectChoice:[OCMArg isNotNil] withSource:[OCMArg isEqual:SDLTriggerSourceVoiceRecognition] atRowIndex:0]);
                            OCMReject([testChoiceDelegate choiceSet:[OCMArg any] didReceiveError:[OCMArg any]]);

                            [testConnectionManager respondToLastRequestWithResponse:response];

                            expect(testOp.isFinished).to(beTrue());
                        });
                    });
                });
            });
        });

        describe(@"canceling the choice set", ^{
            context(@"if the head unit supports the `CancelInteraction` RPC", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:6 minor:0 patch:0];
                });

                context(@"if the operation is executing", ^{
                    beforeEach(^{
                        [testOp start];
                    });

                    context(@"before the present is sent", ^{
                        it(@"should cancel without a CancelInteraction", ^{
                            expect(testOp.isExecuting).to(beTrue());
                            expect(testOp.isFinished).to(beFalse());
                            expect(testOp.isCancelled).to(beFalse());

                            [testChoiceSet cancel];

                            expect(testConnectionManager.receivedRequests.lastObject).toNot(beAnInstanceOf([SDLCancelInteraction class]));

                            expect(testOp.isExecuting).to(beTrue());
                            expect(testOp.isFinished).to(beFalse());
                            expect(testOp.isCancelled).to(beTrue());
                        });
                    });

                    context(@"if the present is in progress", ^{
                        beforeEach(^{
                            // Move us past the preload
                            [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:0 error:nil];
                            [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:1 error:nil];
                            [testConnectionManager respondToRequestWithResponse:testGoodResponse requestNumber:2 error:nil];
                            [testConnectionManager respondToLastMultipleRequestsWithSuccess:YES];

                            // Move us past the SetGlobalProperties
                            SDLSetGlobalPropertiesResponse *sgpr = [[SDLSetGlobalPropertiesResponse alloc] init];
                            sgpr.success = @YES;
                            sgpr.resultCode = SDLResultSuccess;
                            [testConnectionManager respondToLastRequestWithResponse:sgpr];
                        });

                        it(@"should attempt to send a cancel interaction", ^{
                            expect(testOp.isExecuting).to(beTrue());
                            expect(testOp.isFinished).to(beFalse());
                            expect(testOp.isCancelled).to(beFalse());

                            [testChoiceSet cancel];

                            SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                            expect(lastRequest).to(beAnInstanceOf([SDLCancelInteraction class]));
                            expect(lastRequest.cancelID).to(equal(testCancelID));
                            expect(lastRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNamePerformInteraction]));
                        });

                        context(@"If the cancel interaction was successful", ^{
                            __block SDLCancelInteractionResponse *testCancelInteractionResponse = [[SDLCancelInteractionResponse alloc] init];
                            beforeEach(^{
                                testCancelInteractionResponse.success = @YES;
                                testCancelInteractionResponse.resultCode = SDLResultSuccess;
                                [testChoiceSet cancel];
                            });

                            it(@"should finish with an error", ^{
                                // Respond to the cancel interaction, then the perform interaction
                                [testConnectionManager respondToLastRequestWithResponse:testCancelInteractionResponse];

                                SDLPerformInteractionResponse *pir = [[SDLPerformInteractionResponse alloc] init];
                                pir.success = @NO;
                                pir.resultCode = SDLResultAborted;
                                [testConnectionManager respondToRequestWithResponse:pir requestNumber:4 error:[NSError sdl_choiceSetManager_cancelled]];

                                // Try to reset the keyboard
                                expect(testConnectionManager.receivedRequests.lastObject).to(beAnInstanceOf([SDLSetGlobalProperties class]));

                                SDLSetGlobalPropertiesResponse *sgpr = [[SDLSetGlobalPropertiesResponse alloc] init];
                                sgpr.success = @YES;
                                sgpr.resultCode = SDLResultSuccess;
                                [testConnectionManager respondToLastRequestWithResponse:sgpr];

                                OCMReject([testChoiceDelegate choiceSet:[OCMArg isNotNil] didSelectChoice:[OCMArg isNotNil] withSource:[OCMArg any] atRowIndex:0]);
                                OCMVerify([testChoiceDelegate choiceSet:[OCMArg isEqual:testChoiceSet] didReceiveError:[OCMArg isNotNil]]);
                            });
                        });

                        context(@"If the cancel interaction was not successful", ^{
                            __block NSError *testError = [NSError sdl_lifecycle_notConnectedError];
                            __block SDLCancelInteractionResponse *testCancelInteractionResponse = [[SDLCancelInteractionResponse alloc] init];

                            beforeEach(^{
                                testCancelInteractionResponse.success = @NO;
                            });

                            it(@"should error", ^{
                                OCMExpect([testChoiceDelegate choiceSet:[OCMArg any] didReceiveError:[OCMArg any]]);
                                OCMReject([testChoiceDelegate choiceSet:[OCMArg isEqual:testChoiceSet] didSelectChoice:[OCMArg isNotNil] withSource:[OCMArg isEqual:SDLTriggerSourceVoiceRecognition] atRowIndex:0]);
                                [testConnectionManager respondToLastRequestWithResponse:testCancelInteractionResponse error:testError];
                            });
                        });
                    });
                });

                context(@"if the operation has already finished", ^{
                    it(@"should not attempt to send a cancel interaction", ^{
                        [testOp finishOperation];

                        expect(testOp.isExecuting).to(beFalse());
                        expect(testOp.isFinished).to(beTrue());
                        expect(testOp.isCancelled).to(beFalse());

                        [testChoiceSet cancel];

                        SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                        expect(lastRequest).to(beNil());
                    });
                });

                context(@"if the operation has not started", ^{
                    beforeEach(^{
                        expect(testOp.isExecuting).to(beFalse());
                        expect(testOp.isFinished).to(beFalse());
                        expect(testOp.isCancelled).to(beFalse());

                        [testChoiceSet cancel];
                    });

                    it(@"should not attempt to send a cancel interaction", ^{
                        expect(testOp.isExecuting).to(beFalse());
                        expect(testOp.isFinished).to(beFalse());
                        expect(testOp.isCancelled).to(beTrue());

                        SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                        expect(lastRequest).to(beNil());
                    });

                    context(@"once the operation has started", ^{
                        beforeEach(^{
                            [testOp start];
                        });

                        it(@"immediately finish", ^{
                            expect(testConnectionManager.receivedRequests).to(haveCount(0));
                            expect(testOp.isExecuting).to(beFalse());
                            expect(testOp.isFinished).to(beTrue());
                            expect(testOp.isCancelled).to(beTrue());
                        });

                        it(@"should finish", ^{
                            expect(testOp.isExecuting).toEventually(beFalse());
                            expect(testOp.isFinished).toEventually(beTrue());
                            expect(testOp.isCancelled).toEventually(beTrue());
                        });
                    });
                });
            });

            context(@"Head unit does not support the `CancelInteraction` RPC", ^{
                beforeEach(^{
                    SDLVersion *unsupportedVersion = [SDLVersion versionWithMajor:5 minor:1 patch:0];
                    id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                    OCMStub([globalMock rpcVersion]).andReturn(unsupportedVersion);
                });

                it(@"should not attempt to send a cancel interaction if the operation is executing", ^{
                    [testOp start];

                    expect(testOp.isExecuting).to(beTrue());
                    expect(testOp.isFinished).to(beFalse());
                    expect(testOp.isCancelled).to(beFalse());

                    [testChoiceSet cancel];

                    SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                    expect(lastRequest).toNot(beAnInstanceOf([SDLCancelInteraction class]));
                });

                it(@"should cancel the operation if it has not yet been run", ^{
                    expect(testOp.isExecuting).to(beFalse());
                    expect(testOp.isFinished).to(beFalse());
                    expect(testOp.isCancelled).to(beFalse());

                    [testChoiceSet cancel];

                    SDLCancelInteraction *lastRequest = testConnectionManager.receivedRequests.lastObject;
                    expect(lastRequest).to(beNil());

                    expect(testOp.isExecuting).to(beFalse());
                    expect(testOp.isFinished).to(beFalse());
                    expect(testOp.isCancelled).to(beTrue());
                });
            });
        });
    });
});

QuickSpecEnd
