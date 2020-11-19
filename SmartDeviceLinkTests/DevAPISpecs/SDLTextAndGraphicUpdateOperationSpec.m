//
//  SDLTextAndGraphicUpdateOperationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 8/18/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLImage.h"
#import "SDLImageField.h"
#import "SDLImageField+ScreenManagerExtensions.h"
#import "SDLMetadataTags.h"
#import "SDLResult.h"
#import "SDLSetDisplayLayout.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLShow.h"
#import "SDLShowResponse.h"
#import "SDLTemplateConfiguration.h"
#import "SDLTextAndGraphicState.h"
#import "SDLTextAndGraphicUpdateOperation.h"
#import "SDLTextField.h"
#import "SDLTextField+ScreenManagerExtensions.h"
#import "SDLTextFieldName.h"
#import "SDLVersion.h"
#import "SDLWindowCapability.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLTextAndGraphicUpdateOperationSpec)

SDLTextField *fieldLine1 = [[SDLTextField alloc] initWithName:SDLTextFieldNameMainField1 characterSet:SDLCharacterSetUtf8 width:20 rows:20];
SDLTextField *fieldLine2 = [[SDLTextField alloc] initWithName:SDLTextFieldNameMainField2 characterSet:SDLCharacterSetUtf8 width:20 rows:20];
SDLTextField *fieldLine3 = [[SDLTextField alloc] initWithName:SDLTextFieldNameMainField3 characterSet:SDLCharacterSetUtf8 width:20 rows:20];
SDLTextField *fieldLine4 = [[SDLTextField alloc] initWithName:SDLTextFieldNameMainField4 characterSet:SDLCharacterSetUtf8 width:20 rows:20];
SDLImageField *fieldGraphic = [[SDLImageField alloc] initWithName:SDLImageFieldNameGraphic imageTypeSupported:@[SDLFileTypePNG] imageResolution:nil];
SDLImageField *fieldSecondaryGraphic = [[SDLImageField alloc] initWithName:SDLImageFieldNameSecondaryGraphic imageTypeSupported:@[SDLFileTypePNG] imageResolution:nil];

NSString *field1String = @"Text Field 1";
NSString *field2String = @"Text Field 2";
NSString *field3String = @"Text Field 3";
NSString *field4String = @"Text Field 4";
NSString *titleString = @"Title";
NSString *mediaTrackString = @"Media track string";

NSString *testArtworkName = @"some artwork name";
SDLArtwork *testArtwork = [[SDLArtwork alloc] initWithData:[@"Test data" dataUsingEncoding:NSUTF8StringEncoding] name:testArtworkName fileExtension:@"png" persistent:NO];
NSString *testArtworkName2 = @"some other artwork name";
SDLArtwork *testArtwork2 = [[SDLArtwork alloc] initWithData:[@"Test data 2" dataUsingEncoding:NSUTF8StringEncoding] name:testArtworkName2 fileExtension:@"png" persistent:NO];
SDLArtwork *testArtwork3 = [[SDLArtwork alloc] initWithData:[@"Test data 3" dataUsingEncoding:NSUTF8StringEncoding] name:testArtworkName fileExtension:@"png" persistent:NO];
SDLArtwork *testStaticIcon = [SDLArtwork artworkWithStaticIcon:SDLStaticIconNameDate];

SDLTemplateConfiguration *newConfiguration = [[SDLTemplateConfiguration alloc] initWithPredefinedLayout:SDLPredefinedLayoutTilesOnly];

describe(@"the text and graphic operation", ^{
    __block SDLTextAndGraphicUpdateOperation *testOp = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *mockFileManager = nil;
    __block SDLWindowCapability *windowCapability = nil;
    __block SDLTextAndGraphicState *updatedState = nil;
    __block SDLWindowCapability *allEnabledCapability = [[SDLWindowCapability alloc] init];

    __block SDLShowResponse *successShowResponse = [[SDLShowResponse alloc] init];
    __block SDLShowResponse *failShowResponse = [[SDLShowResponse alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    __block SDLSetDisplayLayoutResponse *successSetDisplayLayoutResponse = [[SDLSetDisplayLayoutResponse alloc] init];
    __block SDLSetDisplayLayoutResponse *failSetDisplayLayoutResponse = [[SDLSetDisplayLayoutResponse alloc] init];
#pragma clang diagnostic pop
    __block SDLTextAndGraphicState *emptyCurrentData = nil;

    __block SDLTextAndGraphicState *receivedState = nil;
    __block NSError *receivedError = nil;
    __block NSError *completionError = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        mockFileManager = OCMClassMock([SDLFileManager class]);
        testOp = nil;
        updatedState = nil;
        allEnabledCapability.imageFields = [SDLImageField allImageFields];
        allEnabledCapability.textFields = [SDLTextField allTextFields];

        successShowResponse.success = @YES;
        successShowResponse.resultCode = SDLResultSuccess;
        successSetDisplayLayoutResponse.success = @YES;
        successSetDisplayLayoutResponse.resultCode = SDLResultSuccess;
        failShowResponse.success = @NO;
        failShowResponse.resultCode = SDLResultInUse;
        failSetDisplayLayoutResponse.success = @NO;
        failSetDisplayLayoutResponse.resultCode = SDLResultInUse;

        emptyCurrentData = [[SDLTextAndGraphicState alloc] init];
        receivedState = nil;
        receivedError = nil;
        testArtwork3.overwrite = YES;

        // Default to the max version
        [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:SDLMaxProxyRPCVersion];
    });

    // updating text fields
    describe(@"updating text fields", ^{
        // with textfields available == nil
        context(@"with textfields available == nil", ^{
            beforeEach(^{
                windowCapability = [[SDLWindowCapability alloc] init];
            });

            context(@"when sending four lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;
                    updatedState.textField4 = field4String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should not send any text", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(beEmpty());
                    expect(sentShow.mainField2).to(beEmpty());
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beNil());
                    expect(sentShow.metadataTags.mainField2).to(beNil());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });
        });

        // when updating the media track and title
        context(@"when updating the media track and title", ^{
            beforeEach(^{
                updatedState = [[SDLTextAndGraphicState alloc] init];
                updatedState.title = titleString;
                updatedState.mediaTrackTextField = mediaTrackString;
            });

            // when they're available
            context(@"when they're available", ^{
                beforeEach(^{
                    windowCapability = [[SDLWindowCapability alloc] init];
                    windowCapability.textFields = [SDLTextField allTextFields];
                });

                it(@"should send the media track and title", ^{
                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;
                    expect(sentShow.templateTitle).toNot(beNil());
                    expect(sentShow.mediaTrack).toNot(beNil());
                });
            });

            // when they're not available
            context(@"when they're not available", ^{
                beforeEach(^{
                    windowCapability = [[SDLWindowCapability alloc] init];
                });

                it(@"should not send the media track and title", ^{
                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.mediaTrack).to(beEmpty());
                });
            });
        });

        // with one line available
        context(@"with one line available", ^{
            beforeEach(^{
                windowCapability = [[SDLWindowCapability alloc] init];
                windowCapability.textFields = @[fieldLine1];
            });

            context(@"when sending one line of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal(field1String));
                    expect(sentShow.mainField2).to(beEmpty());
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beNil());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending two lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into one line", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@", field1String, field2String]));
                    expect(sentShow.mainField2).to(beEmpty());
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beNil());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending three lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into one line", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@ - %@", field1String, field2String, field3String]));
                    expect(sentShow.mainField2).to(beEmpty());
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beNil());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending four lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;
                    updatedState.textField4 = field4String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into one line", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@ - %@ - %@", field1String, field2String, field3String, field4String]));
                    expect(sentShow.mainField2).to(beEmpty());
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beNil());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });
        });

        // with two lines available
        context(@"with two lines available", ^{
            beforeEach(^{
                windowCapability = [[SDLWindowCapability alloc] init];
                windowCapability.textFields = @[fieldLine1, fieldLine2];
            });

            context(@"when sending one line of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal(field1String));
                    expect(sentShow.mainField2).to(beEmpty());
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beNil());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending two lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send two lines of text", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal(field1String));
                    expect(sentShow.mainField2).to(equal(field2String));
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beEmpty());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending three lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into two lines", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@", field1String, field2String]));
                    expect(sentShow.mainField2).to(equal(field3String));
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beEmpty());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending four lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;
                    updatedState.textField4 = field4String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into two lines", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@", field1String, field2String]));
                    expect(sentShow.mainField2).to(equal([NSString stringWithFormat:@"%@ - %@", field3String, field4String]));
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beEmpty());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });
        });

        // with three lines available
        context(@"with three lines available", ^{
            beforeEach(^{
                windowCapability = [[SDLWindowCapability alloc] init];
                windowCapability.textFields = @[fieldLine1, fieldLine2, fieldLine3];
            });

            context(@"when sending one line of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(sentShow.mainField2).to(beEmpty());
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beNil());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending two lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send two lines of text", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(sentShow.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beEmpty());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending three lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send three lines of text", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(sentShow.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(sentShow.mainField3).to(equal([NSString stringWithFormat:@"%@", field3String]));
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beEmpty());
                    expect(sentShow.metadataTags.mainField3).to(beEmpty());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending four lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;
                    updatedState.textField4 = field4String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into three lines", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(sentShow.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(sentShow.mainField3).to(equal([NSString stringWithFormat:@"%@ - %@", field3String, field4String]));
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beEmpty());
                    expect(sentShow.metadataTags.mainField3).to(beEmpty());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });
        });

        // with four lines available
        context(@"with four lines available", ^{
            beforeEach(^{
                windowCapability = [[SDLWindowCapability alloc] init];
                windowCapability.textFields = @[fieldLine1, fieldLine2, fieldLine3, fieldLine4];
            });

            context(@"when sending one line of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(sentShow.mainField2).to(beEmpty());
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beNil());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending two lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send two lines of text", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(sentShow.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(sentShow.mainField3).to(beEmpty());
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beEmpty());
                    expect(sentShow.metadataTags.mainField3).to(beNil());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending three lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send three lines text", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(sentShow.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(sentShow.mainField3).to(equal([NSString stringWithFormat:@"%@", field3String]));
                    expect(sentShow.mainField4).to(beEmpty());
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beEmpty());
                    expect(sentShow.metadataTags.mainField3).to(beEmpty());
                    expect(sentShow.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending four lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;
                    updatedState.textField4 = field4String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send four lines of text", ^{
                    SDLShow *sentShow = testConnectionManager.receivedRequests.firstObject;

                    expect(testOp.isFinished).to(beTrue());
                    expect(sentShow.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(sentShow.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(sentShow.mainField3).to(equal([NSString stringWithFormat:@"%@", field3String]));
                    expect(sentShow.mainField4).to(equal([NSString stringWithFormat:@"%@", field4String]));
                    expect(sentShow.templateTitle).to(beEmpty());
                    expect(sentShow.alignment).to(beNil());
                    expect(sentShow.mediaTrack).to(beEmpty());
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                    expect(sentShow.metadataTags.mainField1).to(beEmpty());
                    expect(sentShow.metadataTags.mainField2).to(beEmpty());
                    expect(sentShow.metadataTags.mainField3).to(beEmpty());
                    expect(sentShow.metadataTags.mainField4).to(beEmpty());
                });
            });
        });

        // should call the update handler when done
        context(@"should call the update handler when done", ^{
            __block BOOL didCallHandler = NO;
            beforeEach(^{
                windowCapability = [[SDLWindowCapability alloc] init];
                windowCapability.textFields = @[fieldLine1, fieldLine2, fieldLine3, fieldLine4];

                updatedState = [[SDLTextAndGraphicState alloc] init];
                updatedState.textField1 = field1String;
                updatedState.textField2 = field2String;
                updatedState.textField3 = field3String;
                updatedState.textField4 = field4String;

                testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:^(NSError * _Nullable error) {
                    didCallHandler = YES;
                }];
                [testOp start];

                [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
            });

            it(@"should send the text and then call the update handler", ^{
                expect(didCallHandler).to(equal(YES));
            });
        });

        // should call the currentScreenDataUpdatedHandler when the screen data is updated
        context(@"should call the currentScreenDataUpdatedHandler when the screen data is updated", ^{
            __block SDLTextAndGraphicState *updatedData = nil;
            beforeEach(^{
                windowCapability = [[SDLWindowCapability alloc] init];
                windowCapability.textFields = @[fieldLine1, fieldLine2, fieldLine3, fieldLine4];

                updatedState = [[SDLTextAndGraphicState alloc] init];
                updatedState.textField1 = field1String;
                updatedState.textField2 = field2String;
                updatedState.textField3 = field3String;
                updatedState.textField4 = field4String;

                testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState *_Nullable newScreenData, NSError *_Nullable error) {
                    updatedData = newScreenData;
                } updateCompletionHandler:nil];
                [testOp start];

                [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
            });

            it(@"should send the text and then call the update handler", ^{
                expect(updatedData.textField1).to(equal(field1String));
                expect(updatedData.textField2).to(equal(field2String));
                expect(updatedData.textField3).to(equal(field3String));
                expect(updatedData.textField4).to(equal(field4String));
            });
        });
    });

    // updating image fields
    describe(@"updating image fields", ^{
        beforeEach(^{
            windowCapability = [[SDLWindowCapability alloc] init];
            windowCapability.textFields = @[fieldLine1, fieldLine2, fieldLine3, fieldLine4];
            windowCapability.imageFields = @[fieldGraphic, fieldSecondaryGraphic];
        });

        // when the images are already available on the head unit
        context(@"when the images are already available on the head unit", ^{
            beforeEach(^{
                OCMStub([mockFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(YES);
            });

            // when only the primary graphic is supported
            context(@"when only the primary graphic is supported", ^{
                beforeEach(^{
                    windowCapability.imageFields = @[fieldGraphic];

                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.primaryGraphic = testArtwork;
                    updatedState.secondaryGraphic = testArtwork2;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];
                });

                it(@"should send a show and not upload any artworks", ^{
                    expect(testConnectionManager.receivedRequests).to(haveCount(1));
                    SDLShow *firstSentRequest = testConnectionManager.receivedRequests[0];
                    expect(firstSentRequest.mainField1).to(equal(field1String));
                    expect(firstSentRequest.mainField2).to(beEmpty());
                    expect(firstSentRequest.graphic).toNot(beNil());
                    expect(firstSentRequest.secondaryGraphic).to(beNil());
                });

                it(@"should properly override artwork", ^{
                    SDLTextAndGraphicState *updatedState2 = [[SDLTextAndGraphicState alloc] init];
                    updatedState2.textField1 = field1String;
                    updatedState2.primaryGraphic = testArtwork3;
                    updatedState2.secondaryGraphic = testArtwork2;

                    SDLTextAndGraphicUpdateOperation *testOp2 = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:updatedState newState:updatedState2 currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp2 start];

                    OCMVerify([mockFileManager uploadArtworks:[OCMArg any] completionHandler:[OCMArg any]]);
                });
            });

            // when both image fields are supported
            context(@"when both image fields are supported", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.primaryGraphic = testArtwork;
                    updatedState.secondaryGraphic = testArtwork2;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];
                });

                it(@"should send a show and not upload any artworks", ^{
                    expect(testConnectionManager.receivedRequests).to(haveCount(1));
                    SDLShow *firstSentRequest = testConnectionManager.receivedRequests[0];
                    expect(firstSentRequest.mainField1).to(equal(field1String));
                    expect(firstSentRequest.mainField2).to(beEmpty());
                    expect(firstSentRequest.graphic).toNot(beNil());
                    expect(firstSentRequest.secondaryGraphic).toNot(beNil());
                });
            });
        });

        // when images are not on the head unit
        context(@"when images are not on the head unit", ^{
            beforeEach(^{
                OCMStub([mockFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);
                OCMStub([mockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg any] completionHandler:([OCMArg invokeBlockWithArgs:[NSNull null], [NSNull null], nil])]);
            });

            // when there is text to update as well
            context(@"when there is text to update as well", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.primaryGraphic = testArtwork;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {
                        receivedState = newScreenData;
                        receivedError = error;
                    } updateCompletionHandler:^(NSError * _Nullable error) {
                        completionError = error;
                    }];
                    [testOp start];
                });

                context(@"when the text show succeeds", ^{
                    it(@"should then upload the images, then send the full show", ^{
                        // First the text only show should be sent
                        expect(testConnectionManager.receivedRequests).to(haveCount(1));
                        SDLShow *firstSentRequest = testConnectionManager.receivedRequests[0];
                        expect(firstSentRequest.mainField1).to(equal(field1String));
                        expect(firstSentRequest.graphic).to(beNil());
                        [testConnectionManager respondToLastRequestWithResponse:successShowResponse];

                        // Then the images should be uploaded
                        OCMExpect([mockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                        // Then the full show should be sent, this is currently not testable because the `mockFileManager hasUploadedFile` should change mid-call of `uploadArtworks` after the artwork is uploaded but before the final Show is sent in sdl_createImageOnlyShowWithPrimaryArtwork.
    //                    expect(testConnectionManager.receivedRequests).to(haveCount(2));
    //                    SDLShow *secondSentRequest = testConnectionManager.receivedRequests[1];
    //                    expect(secondSentRequest.mainField1).to(beNil());
    //                    expect(secondSentRequest.graphic).toNot(beNil());
                    });
                });

                context(@"when the text show fails", ^{
                    it(@"should return an error and finish the operation", ^{
                        // First the text only show should be sent
                        expect(testConnectionManager.receivedRequests).to(haveCount(1));
                        SDLShow *firstSentRequest = testConnectionManager.receivedRequests[0];
                        expect(firstSentRequest.mainField1).to(equal(field1String));
                        expect(firstSentRequest.graphic).to(beNil());
                        [testConnectionManager respondToLastRequestWithResponse:failShowResponse];

                        // Then it should return a failure and finish
                        expect(receivedState).to(beNil());
                        expect(receivedError).toNot(beNil());
                        expect(completionError).toNot(beNil());

                        expect(testOp.isFinished).to(beTrue());
                    });
                });

                context(@"when cancelled before the text show returns", ^{
                    it(@"should return an error and finish the operation", ^{
                        // First the text only show should be sent
                        expect(testConnectionManager.receivedRequests).to(haveCount(1));
                        SDLShow *firstSentRequest = testConnectionManager.receivedRequests[0];
                        expect(firstSentRequest.mainField1).to(equal(field1String));
                        expect(firstSentRequest.graphic).to(beNil());

                        [testOp cancel];
                        [testConnectionManager respondToLastRequestWithResponse:successShowResponse];

                        // Then it should return a failure and finish
                        expect(receivedState).toNot(beNil());
                        expect(receivedError).to(beNil());
                        expect(completionError).toNot(beNil());

                        expect(testOp.isFinished).to(beTrue());
                    });
                });
            });

            // when there is no text to update
            context(@"when there is no text to update", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.primaryGraphic = testArtwork;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];
                });

                it(@"should just upload the images, then send the full show", ^{
                    // First the text only show should be sent
                    expect(testConnectionManager.receivedRequests).to(haveCount(1));
                    SDLShow *firstSentRequest = testConnectionManager.receivedRequests[0];
                    expect(firstSentRequest.mainField1).to(beEmpty());
                    expect(firstSentRequest.graphic).to(beNil());
                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];

                    // Then the images should be uploaded
                    OCMExpect([mockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                    // Then the full show should be sent, this is currently not testable because the `mockFileManager hasUploadedFile` should change mid-call of `uploadArtworks` after the artwork is uploaded but before the final Show is sent in sdl_createImageOnlyShowWithPrimaryArtwork.
//                    expect(testConnectionManager.receivedRequests).to(haveCount(2));
//                    SDLShow *secondSentRequest = testConnectionManager.receivedRequests[1];
//                    expect(secondSentRequest.mainField1).to(beEmpty());
//                    expect(secondSentRequest.graphic).toNot(beNil());
                });
            });

            // when the image is a static icon
            context(@"when the image is a static icon", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.primaryGraphic = testStaticIcon;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];
                });

                it(@"should not upload the artwork", ^{
                    // The full show should be sent immediately
                    expect(testConnectionManager.receivedRequests).to(haveCount(1));
                    SDLShow *firstSentRequest = testConnectionManager.receivedRequests[0];
                    expect(firstSentRequest.mainField1).to(beEmpty());
                    expect(firstSentRequest.graphic).toNot(beNil());
                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];

                    // Then the images should be uploaded
                    OCMReject([mockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);
                });
            });
        });

        // when an image fails to upload to the remote
        describe(@"when an image fails to upload to the remote", ^{
            context(@"if the images for the primary and secondary graphics fail the upload process", ^{
                beforeEach(^{
                    OCMStub([mockFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);
                    NSArray<NSString *> *testSuccessfulArtworks = @[];
                    NSError *testError = [NSError errorWithDomain:@"errorDomain"
                                                             code:9
                                                         userInfo:@{testArtwork.name:@"error 1", testArtwork2.name:@"error 2"}
                                          ];
                    OCMStub([mockFileManager uploadArtworks:[OCMArg isNotNil] completionHandler:([OCMArg invokeBlockWithArgs:testSuccessfulArtworks, testError, nil])]);

                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.primaryGraphic = testArtwork;
                    updatedState.secondaryGraphic = testArtwork2;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];
                });

                it(@"should skip sending an update", ^{
                    // Just the empty text show
                    expect(testConnectionManager.receivedRequests).to(haveCount(1));

                    SDLShow *sentShow = testConnectionManager.receivedRequests[0];
                    expect(sentShow.graphic).to(beNil());
                    expect(sentShow.secondaryGraphic).to(beNil());
                });
            });

            context(@"if only one of images for the primary and secondary graphics fails to upload", ^{
                it(@"should show the primary graphic even if the secondary graphic upload fails", ^{
                    OCMStub([mockFileManager hasUploadedFile:testArtwork]).andReturn(YES);
                    OCMStub([mockFileManager hasUploadedFile:testArtwork2]).andReturn(NO);
                    NSArray<NSString *> *testSuccessfulArtworks = @[testArtwork.name];
                    NSError *testError = [NSError errorWithDomain:@"errorDomain" code:9 userInfo:@{testArtwork2.name:@"error 2"}];
                    OCMStub([mockFileManager uploadArtworks:[OCMArg isNotNil] progressHandler:[OCMArg isNotNil] completionHandler:([OCMArg invokeBlockWithArgs:testSuccessfulArtworks, testError, nil])]);
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.primaryGraphic = testArtwork;
                    updatedState.secondaryGraphic = testArtwork2;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    expect(testConnectionManager.receivedRequests).to(haveCount(1));
                    SDLShow *receivedShow = testConnectionManager.receivedRequests[0];
                    expect(receivedShow.mainField1).to(equal(field1String));
                    expect(receivedShow.graphic.value).to(beNil());
                    expect(receivedShow.secondaryGraphic).to(beNil());

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                    expect(testConnectionManager.receivedRequests).to(haveCount(2));
                    SDLShow *secondReceivedShow = testConnectionManager.receivedRequests[1];
                    expect(secondReceivedShow.mainField1).to(beNil());
                    expect(secondReceivedShow.graphic.value).to(equal(testArtwork.name));
                    expect(secondReceivedShow.secondaryGraphic).to(beNil());
                });

                it(@"Should show the secondary graphic even if the primary graphic upload fails", ^{
                    OCMStub([mockFileManager hasUploadedFile:testArtwork]).andReturn(NO);
                    OCMStub([mockFileManager hasUploadedFile:testArtwork2]).andReturn(YES);
                    NSArray<NSString *> *testSuccessfulArtworks = @[testArtwork2.name];
                    NSError *testError = [NSError errorWithDomain:@"errorDomain" code:9 userInfo:@{testArtwork.name:@"error 2"}];
                    OCMStub([mockFileManager uploadArtworks:[OCMArg isNotNil] progressHandler:[OCMArg isNotNil] completionHandler:([OCMArg invokeBlockWithArgs:testSuccessfulArtworks, testError, nil])]);
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.primaryGraphic = testArtwork;
                    updatedState.secondaryGraphic = testArtwork2;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {} updateCompletionHandler:nil];
                    [testOp start];

                    expect(testConnectionManager.receivedRequests).to(haveCount(1));
                    SDLShow *receivedShow = testConnectionManager.receivedRequests[0];
                    expect(receivedShow.mainField1).to(equal(field1String));
                    expect(receivedShow.graphic).to(beNil());
                    expect(receivedShow.secondaryGraphic).to(beNil());

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                    expect(testConnectionManager.receivedRequests).to(haveCount(2));
                    SDLShow *secondReceivedShow = testConnectionManager.receivedRequests[1];
                    expect(secondReceivedShow.mainField1).to(beNil());
                    expect(secondReceivedShow.graphic).to(beNil());
                    expect(secondReceivedShow.secondaryGraphic.value).to(equal(testArtwork2.name));
                });
            });
        });
    });

    // changing a layout
    describe(@"changing a layout", ^{
        // on less than RPC 6.0
        context(@"on less than RPC 6.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"5.0.0"];
            });

            // by itself
            context(@"by itself", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.templateConfig = newConfiguration;
                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:allEnabledCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {
                        receivedState = newScreenData;
                        receivedError = error;
                    } updateCompletionHandler:nil];
                    [testOp start];
                });

                it(@"should send a set display layout, then update the screen data, then send a Show with no data", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    SDLSetDisplayLayout *sentRPC = testConnectionManager.receivedRequests.firstObject;
                    expect(sentRPC).to(beAnInstanceOf([SDLSetDisplayLayout class]));
#pragma clang diagnostic pop
                    expect(sentRPC.displayLayout).to(equal(newConfiguration.template));

                    [testConnectionManager respondToLastRequestWithResponse:successSetDisplayLayoutResponse];
                    expect(receivedState.templateConfig).toNot(beNil());
                    expect(receivedError).to(beNil());

                    SDLShow *sentRPC2 = testConnectionManager.receivedRequests[1];
                    expect(sentRPC2).to(beAnInstanceOf([SDLShow class]));
                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                    expect(testOp.isFinished).to(beTrue());
                });
            });

            // with other text
            context(@"with other text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.templateConfig = newConfiguration;
                    updatedState.textField1 = field1String;
                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:allEnabledCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {
                        receivedState = newScreenData;
                        receivedError = error;
                    } updateCompletionHandler:^(NSError * _Nullable error) {
                        completionError = error;
                    }];
                    [testOp start];
                });

                // should send a set display layout, then update the screen data, then send a Show with data and then update the screen data again
                it(@"should send a set display layout, then update the screen data, then send a Show with data and then update the screen data again", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    SDLSetDisplayLayout *sentRPC = testConnectionManager.receivedRequests.firstObject;
                    expect(sentRPC).to(beAnInstanceOf([SDLSetDisplayLayout class]));
#pragma clang diagnostic pop
                    expect(sentRPC.displayLayout).to(equal(newConfiguration.template));

                    [testConnectionManager respondToLastRequestWithResponse:successSetDisplayLayoutResponse];
                    expect(receivedState.templateConfig).toNot(beNil());
                    expect(receivedState.textField1).to(beNil());
                    expect(receivedError).to(beNil());

                    SDLShow *sentRPC2 = testConnectionManager.receivedRequests[1];
                    expect(sentRPC2).to(beAnInstanceOf([SDLShow class]));
                    expect(sentRPC2.mainField1).to(equal(field1String));
                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                    expect(receivedState.templateConfig).toNot(beNil());
                    expect(receivedState.textField1).toNot(beNil());
                    expect(receivedError).to(beNil());
                    expect(completionError).to(beNil());
                    expect(testOp.isFinished).to(beTrue());
                });

                // when cancelled before finishing
                describe(@"when cancelled before finishing", ^{
                    it(@"should finish the operation with the set display layout data in the current data handler and set an update superseded error in the update completion handler", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        SDLSetDisplayLayout *sentRPC = testConnectionManager.receivedRequests.firstObject;
                        expect(sentRPC).to(beAnInstanceOf([SDLSetDisplayLayout class]));
#pragma clang diagnostic pop
                        expect(sentRPC.displayLayout).to(equal(newConfiguration.template));

                        [testOp cancel];
                        [testConnectionManager respondToLastRequestWithResponse:successSetDisplayLayoutResponse];
                        expect(receivedState).toNot(beNil());
                        expect(receivedError).to(beNil());
                        expect(completionError).toNot(beNil());

                        expect(testOp.isFinished).to(beTrue());

                    });
                });

                // when it receives a set display layout failure
                describe(@"when it receives a set display layout failure", ^{
                    it(@"should send a set display layout, then reset the screen data, then finish the operation", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        SDLSetDisplayLayout *sentRPC = testConnectionManager.receivedRequests.firstObject;
                        expect(sentRPC).to(beAnInstanceOf([SDLSetDisplayLayout class]));
#pragma clang diagnostic pop
                        expect(sentRPC.displayLayout).to(equal(newConfiguration.template));

                        [testConnectionManager respondToLastRequestWithResponse:failSetDisplayLayoutResponse];
                        expect(receivedState).to(beNil());
                        expect(receivedError).toNot(beNil());
                        expect(completionError).toNot(beNil());

                        expect(testOp.isFinished).to(beTrue());
                    });
                });
            });
        });

        // on greater or equal than RPC 6.0
        context(@"on greater or equal than RPC 6.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"6.0.0"];
            });

            // by itself
            context(@"by itself", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.templateConfig = newConfiguration;
                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:allEnabledCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {
                        receivedState = newScreenData;
                        receivedError = error;
                    } updateCompletionHandler:nil];
                    [testOp start];
                });

                it(@"should send a show, then update the screen data", ^{
                    SDLShow *sentRPC = testConnectionManager.receivedRequests.firstObject;
                    expect(sentRPC).to(beAnInstanceOf([SDLShow class]));
                    expect(sentRPC.templateConfiguration).to(equal(newConfiguration));

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                    expect(receivedState.templateConfig).toNot(beNil());
                    expect(receivedState.textField1).to(beNil());
                    expect(receivedError).to(beNil());
                    expect(testOp.isFinished).to(beTrue());
                });
            });

            // with other text
            context(@"with other text that isn't supported", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.templateConfig = newConfiguration;
                    updatedState.textField1 = field1String;
                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:allEnabledCapability currentScreenData:emptyCurrentData newState:updatedState currentScreenDataUpdatedHandler:^(SDLTextAndGraphicState * _Nullable newScreenData, NSError * _Nullable error) {
                        receivedState = newScreenData;
                        receivedError = error;
                    } updateCompletionHandler:nil];
                    [testOp start];
                });

                it(@"should send a show, then update all screen data", ^{
                    SDLShow *sentRPC = testConnectionManager.receivedRequests.firstObject;
                    expect(sentRPC).to(beAnInstanceOf([SDLShow class]));
                    expect(sentRPC.templateConfiguration).to(equal(newConfiguration));

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                    expect(receivedState.templateConfig).toNot(beNil());
                    expect(receivedState.textField1).to(equal(field1String));
                    expect(receivedError).to(beNil());
                    expect(testOp.isFinished).to(beTrue());
                });

                // when it receives a show failure
                describe(@"when it receives a show failure", ^{
                    it(@"it should send a set display layout, then reset the screen data, then do nothing else", ^{
                        SDLShow *sentRPC = testConnectionManager.receivedRequests.firstObject;
                        expect(sentRPC).to(beAnInstanceOf([SDLShow class]));
                        expect(sentRPC.templateConfiguration).to(equal(newConfiguration));

                        [testConnectionManager respondToLastRequestWithResponse:failShowResponse];
                        expect(receivedState).to(beNil());
                        expect(receivedError).toNot(beNil());

                        expect(testOp.isFinished).to(beTrue());
                    });
                });
            });
        });
    });
});

QuickSpecEnd
