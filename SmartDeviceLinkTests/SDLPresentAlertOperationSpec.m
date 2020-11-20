//
//  SDLPresentAlertOperationSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 11/18/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLAlert.h"
#import "SDLAlertResponse.h"
#import "SDLAlertView.h"
#import "SDLAlertAudioData.h"
#import "SDLFileManager.h"
#import "SDLImage.h"
#import "SDLPresentAlertOperation.h"
#import "SDLWindowCapability.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"
#import "SDLTTSChunk.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"
#import "TestConnectionManager.h"

@interface SDLPresentAlertOperation()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (copy, nonatomic, nullable) SDLWindowCapability *currentCapabilities;
@property (strong, nonatomic, readwrite) SDLAlertView *alertView;
@property (strong, nonatomic, readwrite) SDLAlert *alert;
@property (assign, nonatomic) UInt16 cancelId;
@property (copy, nonatomic, nullable) NSError *internalError;

@end

QuickSpecBegin(SDLPresentAlertOperationSpec)

describe(@"SDLPresentAlertOperation", ^{
    __block SDLPresentAlertOperation *testPresentAlertOperation = nil;
    __block id mockConnectionManager = nil;
    __block id mockFileManager = nil;
    __block id mockCurrentWindowCapability = nil;
    __block SDLAlertView *testAlertView = nil;
    __block UInt16 testCancelID = 45;
    __block BOOL hasCalledOperationCompletionHandler = NO;

    __block SDLAlertAudioData *testAlertAudioData = nil;
    __block SDLSoftButtonObject *testAlertSoftButton1 = nil;
    __block SDLSoftButtonObject *testAlertSoftButton2 = nil;
    __block SDLArtwork *testAlertIcon = nil;

    beforeEach(^{
        mockConnectionManager = OCMProtocolMock(@protocol(SDLConnectionManagerType));
        mockFileManager = OCMClassMock([SDLFileManager class]);
        mockCurrentWindowCapability = OCMClassMock([SDLWindowCapability class]);

        testAlertAudioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"test synthesizer string"];

        testAlertSoftButton1 = [[SDLSoftButtonObject alloc] initWithName:@"button1" text:@"button1" artwork:[SDLArtwork artworkWithStaticIcon:SDLStaticIconNameKey] handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
            // TODO
        }];
        testAlertSoftButton2 = [[SDLSoftButtonObject alloc] initWithName:@"button2" text:@"button2" artwork:[SDLArtwork artworkWithStaticIcon:SDLStaticIconNameRSS] handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
            // TODO
        }];

        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        UIImage *testImage = [[UIImage alloc] initWithContentsOfFile:[testBundle pathForResource:@"testImageJPEG" ofType:@"jpeg"]];
        testAlertIcon = [SDLArtwork artworkWithImage:testImage asImageFormat:SDLArtworkImageFormatPNG];

        testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
    });

    it(@"should be initialized correctly", ^{
        testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

        expect(@(testPresentAlertOperation.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
        expect(testPresentAlertOperation.connectionManager).to(equal(mockConnectionManager));
        expect(testPresentAlertOperation.fileManager).to(equal(mockFileManager));
        expect(testPresentAlertOperation.alertView).to(equal(testAlertView));
        expect(@(testPresentAlertOperation.cancelId)).to(equal(@(testCancelID)));
        expect(testPresentAlertOperation.currentCapabilities).to(equal(mockCurrentWindowCapability));
        expect(testPresentAlertOperation.internalError).to(beNil());
    });

    describe(@"creating the alert", ^{
        describe(@"with all three text fields set", ^{
            beforeEach(^{
                testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
            });

            it(@"should set all textfields if all textfields are supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(equal(testAlertView.text));
                expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                expect(testAlert.alertText3).to(equal(testAlertView.tertiaryText));
            });

            it(@"should set textfields correctly if only two textfields are supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(2)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(equal(testAlertView.text));
                expect(testAlert.alertText2).to(equal([NSString stringWithFormat:@"%@ - %@", testAlertView.secondaryText, testAlertView.tertiaryText]));
                expect(testAlert.alertText3).to(beNil());
            });

            it(@"should set textfields correctly if only one textfield is supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(1)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(equal([NSString stringWithFormat:@"%@ - %@ - %@", testAlertView.text, testAlertView.secondaryText, testAlertView.tertiaryText]));
                expect(testAlert.alertText2).to(beNil());
                expect(testAlert.alertText3).to(beNil());
            });
        });

        describe(@"with two text fields set", ^{
            beforeEach(^{
                testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:nil timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
            });

            it(@"should set all textfields if all textfields are supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(equal(testAlertView.text));
                expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                expect(testAlert.alertText3).to(beNil());
            });

            it(@"should set textfields correctly if only two textfields are supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(2)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(equal(testAlertView.text));
                expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                expect(testAlert.alertText3).to(beNil());
            });

            it(@"should set textfields correctly if only one textfield is supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(1)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(equal([NSString stringWithFormat:@"%@ - %@", testAlertView.text, testAlertView.secondaryText]));
                expect(testAlert.alertText2).to(beNil());
                expect(testAlert.alertText3).to(beNil());
            });
        });

        describe(@"with one text field set", ^{
            beforeEach(^{
                testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:nil tertiaryText:nil timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
            });

            it(@"should set all textfields if all textfields are supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(equal(testAlertView.text));
                expect(testAlert.alertText2).to(beNil());
                expect(testAlert.alertText3).to(beNil());
            });

            it(@"should set textfields correctly if only two textfields are supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(2)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(equal(testAlertView.text));
                expect(testAlert.alertText2).to(beNil());
                expect(testAlert.alertText3).to(beNil());
            });

            it(@"should set textfields correctly if only one textfield is supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(1)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(equal(testAlertView.text));
                expect(testAlert.alertText2).to(beNil());
                expect(testAlert.alertText3).to(beNil());
            });
        });

        describe(@"with no text fields set", ^{
            beforeEach(^{
                testAlertView = [[SDLAlertView alloc] initWithText:nil secondaryText:nil tertiaryText:nil timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
            });

            it(@"should set all textfields if all textfields are supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(beNil());
                expect(testAlert.alertText2).to(beNil());
                expect(testAlert.alertText3).to(beNil());
            });

            it(@"should set textfields correctly if only two textfields are supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(2)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(beNil());
                expect(testAlert.alertText2).to(beNil());
                expect(testAlert.alertText3).to(beNil());
            });

            it(@"should set textfields correctly if only one textfield is supported", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(1)] maxNumberOfAlertMainFieldLines];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(beNil());
                expect(testAlert.alertText2).to(beNil());
                expect(testAlert.alertText3).to(beNil());
            });
        });

        describe(@"with a nil currentWindowCapability", ^{
            beforeEach(^{
                testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager currentWindowCapability:nil alertView:testAlertView cancelID:testCancelID];
            });

            it(@"should assume all textfields are supported", ^{
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertText1).to(equal(testAlertView.text));
                expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                expect(testAlert.alertText3).to(equal(testAlertView.tertiaryText));
            });
        });
    });

    describe(@"presenting the alert", ^{
        beforeEach(^{
            [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertMainFieldLines];
            testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

            testPresentAlertOperation.completionBlock = ^{
                hasCalledOperationCompletionHandler = YES;
            };
        });

        it(@"should send the alert if the operation has not been cancelled", ^{
            [testPresentAlertOperation start];
            OCMExpect([mockConnectionManager sendConnectionRequest:[OCMArg checkWithBlock:^BOOL(id value) {
                SDLAlert *alertRequest = (SDLAlert *)value;
                expect(alertRequest.alertText1).to(equal(testAlertView.text));
                expect(alertRequest.alertText2).to(equal(testAlertView.secondaryText));
                expect(alertRequest.alertText3).to(equal(testAlertView.tertiaryText));
                expect(alertRequest.ttsChunks.count).to(equal(1));
                expect(alertRequest.ttsChunks[0].text).to(equal(testAlertView.audio.prompts.firstObject.text));
                expect(alertRequest.duration).to(equal(testAlertView.timeout * 1000));
                expect(alertRequest.playTone).to(equal(testAlertView.audio.playTone));
                expect(alertRequest.progressIndicator).to(equal(testAlertView.showWaitIndicator));
                expect(alertRequest.softButtons.count).to(equal(testAlertView.softButtons.count));
                expect(alertRequest.softButtons[0].text).to(equal(testAlertView.softButtons[0].currentState.text));
                expect(alertRequest.softButtons[1].text).to(equal(testAlertView.softButtons[1].currentState.text));
                expect(alertRequest.cancelID).to(equal(testCancelID));
                expect(alertRequest.alertIcon.value).to(equal(testAlertView.icon.name));
                return [value isKindOfClass:[SDLAlert class]];
            }] withResponseHandler:[OCMArg any]]);

            OCMVerifyAllWithDelay(mockConnectionManager, 0.5);
        });

        it(@"should not send the alert if the operation has been cancelled", ^{
            [testPresentAlertOperation cancel];
            [testPresentAlertOperation start];
            OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg any] withResponseHandler:[OCMArg any]]);

            OCMVerifyAllWithDelay(mockConnectionManager, 0.5);
        });

        describe(@"Getting a response from the module", ^{
            __block SDLAlertResponse *response = nil;

            beforeEach(^{
                [testPresentAlertOperation start];
            });

            it(@"should call the completion handler and finish the operation after a successful alert response", ^{
                response = [[SDLAlertResponse alloc] init];
                response.tryAgainTime = nil;
                response.success = @YES;
                response.resultCode = SDLResultSuccess;

                OCMStub([mockConnectionManager sendConnectionRequest:[OCMArg any] withResponseHandler:([OCMArg invokeBlockWithArgs:[OCMArg any], response, [NSNull null], nil])]);

                expect(testPresentAlertOperation.internalError).toEventually(beNil());
                expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                expect(testPresentAlertOperation.isFinished).toEventually(beTrue());
            });

            it(@"should save the error, call the completion handler and finish the operation after an unsuccessful alert response", ^{
                response = [[SDLAlertResponse alloc] init];
                response.tryAgainTime = @5;
                response.success = @NO;
                response.resultCode = SDLResultAborted;
                NSError *defaultError = [NSError errorWithDomain:@"com.sdl.testConnectionManager" code:-1 userInfo:nil];

                OCMStub([mockConnectionManager sendConnectionRequest:[OCMArg any] withResponseHandler:([OCMArg invokeBlockWithArgs:[OCMArg any], response, defaultError, nil])]);

                expect(testPresentAlertOperation.internalError).toEventually(equal(defaultError));
                expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                expect(testPresentAlertOperation.isFinished).toEventually(beTrue());
            });
        });
    });
});

QuickSpecEnd
