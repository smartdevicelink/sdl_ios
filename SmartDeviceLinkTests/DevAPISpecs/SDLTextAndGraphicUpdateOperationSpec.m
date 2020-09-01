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
#import "SDLImage.h"
#import "SDLImageField.h"
#import "SDLMetadataTags.h"
#import "SDLResult.h"
#import "SDLShow.h"
#import "SDLShowResponse.h"
#import "SDLTextAndGraphicState.h"
#import "SDLTextAndGraphicUpdateOperation.h"
#import "SDLTextField.h"
#import "SDLTextFieldName.h"
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

NSString *testArtworkName = @"some artwork name";
SDLArtwork *testArtwork = [[SDLArtwork alloc] initWithData:[@"Test data" dataUsingEncoding:NSUTF8StringEncoding] name:testArtworkName fileExtension:@"png" persistent:NO];
NSString *testArtworkName2 = @"some other artwork name";
SDLArtwork *testArtwork2 = [[SDLArtwork alloc] initWithData:[@"Test data 2" dataUsingEncoding:NSUTF8StringEncoding] name:testArtworkName2 fileExtension:@"png" persistent:NO];
SDLArtwork *testStaticIcon = [SDLArtwork artworkWithStaticIcon:SDLStaticIconNameDate];

describe(@"the text and graphic operation", ^{
    __block SDLTextAndGraphicUpdateOperation *testOp = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *mockFileManager = nil;
    __block SDLWindowCapability *windowCapability = nil;
    __block SDLTextAndGraphicState *updatedState = nil;

    __block SDLShowResponse *successShowResponse = [[SDLShowResponse alloc] init];
    __block SDLShow *emptyCurrentDataShow = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        mockFileManager = OCMClassMock([SDLFileManager class]);
        testOp = nil;
        updatedState = nil;

        successShowResponse.success = @YES;
        successShowResponse.resultCode = SDLResultSuccess;
        emptyCurrentDataShow = [[SDLShow alloc] init];
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should not send any text", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(beEmpty());
                    expect(testOp.currentScreenData.mainField2).to(beEmpty());
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(testOp.currentScreenData.mainField2).to(beEmpty());
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending two lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into one line", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@", field1String, field2String]));
                    expect(testOp.currentScreenData.mainField2).to(beEmpty());
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending three lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into one line", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@ - %@", field1String, field2String, field3String]));
                    expect(testOp.currentScreenData.mainField2).to(beEmpty());
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending four lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;
                    updatedState.textField4 = field4String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into one line", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@ - %@ - %@", field1String, field2String, field3String, field4String]));
                    expect(testOp.currentScreenData.mainField2).to(beEmpty());
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(testOp.currentScreenData.mainField2).to(beEmpty());
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending two lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send two lines of text", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(testOp.currentScreenData.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending three lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into two lines", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@", field1String, field2String]));
                    expect(testOp.currentScreenData.mainField2).to(equal([NSString stringWithFormat:@"%@", field3String]));
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending four lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;
                    updatedState.textField4 = field4String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into two lines", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@", field1String, field2String]));
                    expect(testOp.currentScreenData.mainField2).to(equal([NSString stringWithFormat:@"%@ - %@", field3String, field4String]));
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(testOp.currentScreenData.mainField2).to(beEmpty());
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending two lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send two lines of text", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(testOp.currentScreenData.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending three lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send three lines of text", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(testOp.currentScreenData.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(testOp.currentScreenData.mainField3).to(equal([NSString stringWithFormat:@"%@", field3String]));
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending four lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;
                    updatedState.textField4 = field4String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should concatenate the strings into three lines", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(testOp.currentScreenData.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(testOp.currentScreenData.mainField3).to(equal([NSString stringWithFormat:@"%@ - %@", field3String, field4String]));
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(testOp.currentScreenData.mainField2).to(beEmpty());
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending two lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send two lines of text", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(testOp.currentScreenData.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(testOp.currentScreenData.mainField3).to(beEmpty());
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending three lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send three lines text", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(testOp.currentScreenData.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(testOp.currentScreenData.mainField3).to(equal([NSString stringWithFormat:@"%@", field3String]));
                    expect(testOp.currentScreenData.mainField4).to(beEmpty());
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"when sending four lines of text", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.textField2 = field2String;
                    updatedState.textField3 = field3String;
                    updatedState.textField4 = field4String;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should send four lines of text", ^{
                    expect(testOp.isFinished).to(beTrue());
                    expect(testOp.currentScreenData.mainField1).to(equal([NSString stringWithFormat:@"%@", field1String]));
                    expect(testOp.currentScreenData.mainField2).to(equal([NSString stringWithFormat:@"%@", field2String]));
                    expect(testOp.currentScreenData.mainField3).to(equal([NSString stringWithFormat:@"%@", field3String]));
                    expect(testOp.currentScreenData.mainField4).to(equal([NSString stringWithFormat:@"%@", field4String]));
                    expect(testOp.currentScreenData.templateTitle).to(beEmpty());
                    expect(testOp.currentScreenData.alignment).to(beNil());
                    expect(testOp.currentScreenData.mediaTrack).to(beEmpty());
                    expect(testOp.currentScreenData.graphic).to(beNil());
                    expect(testOp.currentScreenData.secondaryGraphic).to(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField1).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField2).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField3).toNot(beNil());
                    expect(testOp.currentScreenData.metadataTags.mainField4).toNot(beNil());
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

                testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:^(NSError * _Nullable error) {
                    didCallHandler = YES;
                }];
                [testOp start];

                [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
            });

            it(@"should send the text and then call the update handler", ^{
                expect(didCallHandler).to(equal(YES));
            });
        });

        context(@"should call the currentScreenDataUpdatedHandler when the screen data is updated", ^{
            __block SDLShow *updatedData = nil;
            beforeEach(^{
                windowCapability = [[SDLWindowCapability alloc] init];
                windowCapability.textFields = @[fieldLine1, fieldLine2, fieldLine3, fieldLine4];

                updatedState = [[SDLTextAndGraphicState alloc] init];
                updatedState.textField1 = field1String;
                updatedState.textField2 = field2String;
                updatedState.textField3 = field3String;
                updatedState.textField4 = field4String;

                testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:^(SDLShow * _Nonnull newScreenData) {
                    updatedData = newScreenData;
                } updateCompletionHandler:nil];
                [testOp start];

                [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
            });

            it(@"should send the text and then call the update handler", ^{
                expect(updatedData.mainField1).to(equal(field1String));
                expect(updatedData.mainField2).to(equal(field2String));
                expect(updatedData.mainField3).to(equal(field3String));
                expect(updatedData.mainField4).to(equal(field4String));
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
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
            });

            // when both image fields are supported
            context(@"when both image fields are supported", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.primaryGraphic = testArtwork;
                    updatedState.secondaryGraphic = testArtwork2;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
                    [testOp start];
                });

                it(@"should send the text, then upload the images, then send the full show", ^{
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

            // when there is no text to update
            context(@"when there is no text to update", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.primaryGraphic = testArtwork;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState currentScreenDataUpdatedHandler:nil updateCompletionHandler:nil];
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
});

QuickSpecEnd
