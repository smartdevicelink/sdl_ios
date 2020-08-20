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

SDLShow *emptyCurrentDataShow = [[SDLShow alloc] init];

describe(@"the text and graphic operation", ^{
    __block SDLTextAndGraphicUpdateOperation *testOp = nil;

    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFileManager *mockFileManager = nil;
    __block SDLTextAndGraphicUpdateCompletionHandler updateHandler = nil;
    __block SDLWindowCapability *windowCapability = nil;
    __block SDLTextAndGraphicState *updatedState = nil;

    __block SDLShowResponse *successShowResponse = [[SDLShowResponse alloc] init];

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        mockFileManager = OCMStrictClassMock([SDLFileManager class]);

        successShowResponse.success = @YES;
        successShowResponse.resultCode = SDLResultSuccess;
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
                    [testOp start];

                    [testConnectionManager respondToLastRequestWithResponse:successShowResponse];
                });

                it(@"should only send one line of text", ^{
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

            // when only graphic is supported
            context(@"when only graphic is supported", ^{

            });

            // when both image fields are supported
            context(@"when both image fields are supported", ^{

            });
        }); // TODO

        // when images are not on the head unit
        context(@"when images are not on the head unit", ^{
            beforeEach(^{
                OCMStub([mockFileManager hasUploadedFile:[OCMArg isNotNil]]).andReturn(NO);
            });

            // when there is text to update as well
            context(@"when there is text to update as well", ^{
                beforeEach(^{
                    updatedState = [[SDLTextAndGraphicState alloc] init];
                    updatedState.textField1 = field1String;
                    updatedState.primaryGraphic = testArtwork;

                    testOp = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager currentCapabilities:windowCapability currentScreenData:emptyCurrentDataShow newState:updatedState updateCompletionHandler:nil];
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

                    // Then the full show should be sent
                }); // TODO
            });

            // when there is no text to update
            context(@"when there is no text to update", ^{
                it(@"should just upload the images, then send the full show", ^{

                });
            }); // TODO
        });
    });
});

QuickSpecEnd
