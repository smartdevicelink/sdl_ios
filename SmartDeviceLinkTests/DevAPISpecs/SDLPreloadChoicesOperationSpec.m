#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLPreloadChoicesOperation.h"

#import "SDLChoice.h"
#import "SDLChoiceCell.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLDisplayCapabilities.h"
#import "SDLFileManager.h"
#import "SDLImageField.h"
#import "SDLImageFieldName.h"
#import "SDLTextField.h"
#import "SDLTextFieldName.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLPreloadChoicesOperationSpec)

describe(@"a preload choices operation", ^{
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *testFileManager = nil;
    __block SDLPreloadChoicesOperation *testOp = nil;

    __block NSData *cellArtData = [@"testart" dataUsingEncoding:NSUTF8StringEncoding];

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
        __block SDLDisplayCapabilities *displayCapabilities = nil;
        beforeEach(^{
            displayCapabilities = [[SDLDisplayCapabilities alloc] init];
            displayCapabilities.graphicSupported = @YES;

            OCMStub([testFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg invokeBlock]]);
        });

        context(@"with artworks", ^{
            __block NSSet<SDLChoiceCell *> *cellsWithArtwork = nil;
            __block NSSet<SDLChoiceCell *> *cellsWithStaticIcon = nil;
            __block NSString *art1Name = @"Art1Name";
            __block NSString *art2Name = @"Art2Name";

            beforeEach(^{
                SDLArtwork *cell1Art = [[SDLArtwork alloc] initWithData:cellArtData name:art1Name fileExtension:@"png" persistent:NO];
                SDLChoiceCell *cell1WithArt = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:cell1Art voiceCommands:nil];

                SDLArtwork *cell2Art = [[SDLArtwork alloc] initWithData:cellArtData name:art2Name fileExtension:@"png" persistent:NO];
                SDLChoiceCell *cell2WithArtAndSecondary = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:cell2Art secondaryArtwork:cell2Art];

                SDLArtwork *staticIconArt = [SDLArtwork artworkWithStaticIcon:SDLStaticIconNameDate];
                SDLChoiceCell *cellWithStaticIcon = [[SDLChoiceCell alloc] initWithText:@"Static Icon" secondaryText:nil tertiaryText:nil voiceCommands:nil artwork:staticIconArt secondaryArtwork:nil];

                cellsWithArtwork = [NSSet setWithArray:@[cell1WithArt, cell2WithArtAndSecondary]];
                cellsWithStaticIcon = [NSSet setWithArray:@[cellWithStaticIcon]];
            });

            context(@"disallowed display capabilities", ^{
                it(@"should skip to preloading cells", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayCapabilities:displayCapabilities isVROptional:NO cellsToPreload:cellsWithArtwork];
                    [testOp start];

                    expect(@(testOp.currentState)).to(equal(SDLPreloadChoicesOperationStatePreloadingChoices));
                });
            });

            context(@"mixed display capabilities", ^{
                beforeEach(^{
                    SDLImageField *choiceField = [[SDLImageField alloc] init];
                    choiceField.name = SDLImageFieldNameChoiceImage;

                    displayCapabilities.imageFields = @[choiceField];

                    OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayCapabilities:displayCapabilities isVROptional:NO cellsToPreload:cellsWithArtwork];
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

            context(@"allowed display capabilities", ^{
                beforeEach(^{
                    SDLImageField *choiceField = [[SDLImageField alloc] init];
                    choiceField.name = SDLImageFieldNameChoiceImage;
                    SDLImageField *choiceSecondaryField = [[SDLImageField alloc] init];
                    choiceSecondaryField.name = SDLImageFieldNameChoiceSecondaryImage;

                    displayCapabilities.imageFields = @[choiceField, choiceSecondaryField];
                });

                context(@"when artworks are already on the system", ^{
                    beforeEach(^{
                        OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);

                        testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayCapabilities:displayCapabilities isVROptional:NO cellsToPreload:cellsWithArtwork];
                        [testOp start];
                    });

                    it(@"should not upload artworks", ^{
                        OCMReject([testFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id obj) {
                            NSArray<SDLArtwork *> *artworks = (NSArray<SDLArtwork *> *)obj;
                            return (artworks.count == 2);
                        }] completionHandler:[OCMArg any]]);
                        expect(@(testOp.currentState)).to(equal(SDLPreloadChoicesOperationStatePreloadingChoices));
                    });
                });

                context(@"when artworks are static icons", ^{
                    beforeEach(^{
                        testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayCapabilities:displayCapabilities isVROptional:NO cellsToPreload:cellsWithStaticIcon];
                        [testOp start];
                    });

                    it(@"should skip uploading artwork", ^{
                        OCMReject([testFileManager uploadArtwork:[OCMArg any] completionHandler:[OCMArg any]]);
                    });
                });

                context(@"when artwork are not already on the system", ^{
                    beforeEach(^{
                        OCMStub([testFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);

                        testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayCapabilities:displayCapabilities isVROptional:NO cellsToPreload:cellsWithArtwork];
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
            __block NSSet<SDLChoiceCell *> *cellsWithoutArtwork = nil;
            beforeEach(^{
                SDLChoiceCell *cellBasic = [[SDLChoiceCell alloc] initWithText:@"Cell1" artwork:nil voiceCommands:nil];
                SDLChoiceCell *cellWithVR = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:nil tertiaryText:nil voiceCommands:@[@"Cell2"] artwork:nil secondaryArtwork:nil];
                 SDLChoiceCell *cellWithAllText = [[SDLChoiceCell alloc] initWithText:@"Cell2" secondaryText:@"Cell2" tertiaryText:@"Cell2" voiceCommands:nil artwork:nil secondaryArtwork:nil];

                cellsWithoutArtwork = [NSSet setWithArray:@[cellBasic, cellWithVR, cellWithAllText]];
            });

            it(@"should skip to preloading cells", ^{
                expect(@(testOp.currentState)).to(equal(SDLPreloadChoicesOperationStatePreloadingChoices));
            });

            describe(@"assembling choices", ^{
                it(@"should be correct with no text and VR required", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayCapabilities:displayCapabilities isVROptional:NO cellsToPreload:cellsWithoutArtwork];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));
                    expect(receivedRequests.lastObject.choiceSet.firstObject.menuName).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.secondaryText).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.tertiaryText).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.vrCommands).toNot(beNil());
                });

                it(@"should be correct with only primary text", ^{
                    SDLTextField *primaryTextField = [[SDLTextField alloc] init];
                    primaryTextField.name = SDLTextFieldNameMenuName;
                    displayCapabilities.textFields = @[primaryTextField];

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayCapabilities:displayCapabilities isVROptional:NO cellsToPreload:cellsWithoutArtwork];
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
                    displayCapabilities.textFields = @[primaryTextField, secondaryTextField];

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayCapabilities:displayCapabilities isVROptional:NO cellsToPreload:cellsWithoutArtwork];
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
                    displayCapabilities.textFields = @[primaryTextField, secondaryTextField, tertiaryTextField];

                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayCapabilities:displayCapabilities isVROptional:NO cellsToPreload:cellsWithoutArtwork];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));
                    expect(receivedRequests.lastObject.choiceSet.firstObject.menuName).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.secondaryText).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.tertiaryText).toNot(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.vrCommands).toNot(beNil());
                });

                it(@"should be correct with VR optional", ^{
                    testOp = [[SDLPreloadChoicesOperation alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager displayCapabilities:displayCapabilities isVROptional:YES cellsToPreload:cellsWithoutArtwork];
                    [testOp start];

                    NSArray<SDLCreateInteractionChoiceSet *> *receivedRequests = (NSArray<SDLCreateInteractionChoiceSet *> *)testConnectionManager.receivedRequests;

                    expect(receivedRequests).to(haveCount(3));
                    expect(receivedRequests.lastObject.choiceSet.firstObject.menuName).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.secondaryText).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.tertiaryText).to(beNil());
                    expect(receivedRequests.lastObject.choiceSet.firstObject.vrCommands).to(beNil());
                });
            });
        });
    });
});

QuickSpecEnd
