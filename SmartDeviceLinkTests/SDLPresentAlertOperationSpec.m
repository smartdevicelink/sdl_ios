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
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLImage.h"
#import "SDLPresentAlertOperation.h"
#import "SDLPutFile.h"
#import "SDLWindowCapability.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLTTSChunk.h"
#import "SDLVersion.h"
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
    __block id mockSystemCapabilityManager = nil;
    __block id mockCurrentWindowCapability = nil;
    __block SDLAlertView *testAlertView = nil;
    __block UInt16 testCancelID = 45;
    __block BOOL hasCalledOperationCompletionHandler = NO;

    __block SDLAlertAudioData *testAlertAudioData = nil;
    __block SDLFile *testAudioFile = nil;
    __block SDLAlertAudioData *testAlertAudioFileData = nil;
    __block SDLSoftButtonObject *testAlertSoftButton1 = nil;
    __block SDLSoftButtonObject *testAlertSoftButton2 = nil;
    __block SDLArtwork *testAlertIcon = nil;
    __block SDLArtwork *testButton1Icon = nil;
    __block SDLArtwork *testButton2Icon = nil;

    beforeEach(^{
        mockConnectionManager = OCMProtocolMock(@protocol(SDLConnectionManagerType));
        mockFileManager = OCMClassMock([SDLFileManager class]);
        mockSystemCapabilityManager = OCMClassMock([SDLSystemCapabilityManager class]);
        mockCurrentWindowCapability = OCMClassMock([SDLWindowCapability class]);

        testAlertAudioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"test synthesizer string"];
        NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
        NSURL *testAudioFileURL = [testBundle URLForResource:@"testAudio" withExtension:@"mp3"];
        NSString *testAudioFileName = @"testAudioFile";
        testAudioFile = [[SDLFile alloc] initWithFileURL:testAudioFileURL name:testAudioFileName persistent:YES];
        testAlertAudioFileData = [[SDLAlertAudioData alloc] initWithAudioFile:testAudioFile];

        UIImage *testButton1Image = [[UIImage alloc] initWithContentsOfFile:[testBundle pathForResource:@"testImageJPEG" ofType:@"jpeg"]];
        testButton1Icon = [SDLArtwork artworkWithImage:testButton1Image asImageFormat:SDLArtworkImageFormatJPG];
        UIImage *testButton2Image = [[UIImage alloc] initWithContentsOfFile:[testBundle pathForResource:@"testImagePNG" ofType:@"png"]];
        testButton2Icon = [SDLArtwork artworkWithImage:testButton2Image asImageFormat:SDLArtworkImageFormatPNG];

        testAlertSoftButton1 = [[SDLSoftButtonObject alloc] initWithName:@"button1" text:@"button1" artwork:testButton1Icon handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
            // TODO
        }];
        testAlertSoftButton2 = [[SDLSoftButtonObject alloc] initWithName:@"button2" text:@"button2" artwork:testButton2Icon handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
            // TODO
        }];

        UIImage *testImage = [[UIImage alloc] initWithContentsOfFile:[testBundle pathForResource:@"testImageJPEG" ofType:@"jpeg"]];
        testAlertIcon = [SDLArtwork artworkWithImage:testImage asImageFormat:SDLArtworkImageFormatPNG];
        testAlertIcon.overwrite = @NO;

        testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
    });

    it(@"should be initialized correctly", ^{
        testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

        expect(@(testPresentAlertOperation.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
        expect(testPresentAlertOperation.connectionManager).to(equal(mockConnectionManager));
        expect(testPresentAlertOperation.fileManager).to(equal(mockFileManager));
        expect(testPresentAlertOperation.alertView).to(equal(testAlertView));
        expect(@(testPresentAlertOperation.cancelId)).to(equal(@(testCancelID)));
        expect(testPresentAlertOperation.currentCapabilities).to(equal(mockCurrentWindowCapability));
        expect(testPresentAlertOperation.internalError).to(beNil());
    });

    describe(@"creating the alert", ^{
        describe(@"setting the text fields", ^{
            describe(@"with all three text fields set", ^{
                beforeEach(^{
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];

                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
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

                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
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

                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
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

                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
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

                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:nil alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should assume all textfields are supported", ^{
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                    expect(testAlert.alertText3).to(equal(testAlertView.tertiaryText));
                });
            });
        });

        describe(@"setting the audio data", ^{
            describe(@"with audio data prompts set", ^{
                beforeEach(^{
                    SDLAlertAudioData *audioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"test synthesizer string"];
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:audioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set the tts chunks correctly", ^{
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertMainFieldLines];
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.ttsChunks.count).to(equal(1));
                    expect(testAlert.ttsChunks[0].text).to(equal(testAlertView.audio.prompts.firstObject.text));
                });
            });

            describe(@"with only an audio file set but the negotiated spec version does not yet support the audio file feature", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:3 minor:0 patch:0];
                    [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesFile]] speechCapabilities];

                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioFileData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set nil (and not an empty array)", ^{
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.ttsChunks).to(beNil());
                });
            });

            describe(@"with only an audio file set but the speech capabilities do not support the audio file feature", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:2 patch:0];
                    [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesText]] speechCapabilities];

                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioFileData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set nil (and not an empty array)", ^{
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.ttsChunks).to(beNil());
                });
            });

            describe(@"with only an audio file set and the module supports the feature", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
                    [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesFile, SDLSpeechCapabilitiesText]] speechCapabilities];

                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioFileData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set the tts chunks correctly", ^{
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.ttsChunks.count).to(equal(1));
                    expect(testAlert.ttsChunks[0].text).to(equal(testAlertView.audio.audioFiles.firstObject.name));
                });
            });

            describe(@"with no audio data set", ^{
                beforeEach(^{
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:nil buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];

                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set nil (and not an empty array)", ^{
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.ttsChunks).to(beNil());
                });
            });
        });

        describe(@"setting the icon", ^{
            beforeEach(^{
                testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:nil buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
            });

            it(@"should set the image if icons are supported on the module", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@YES] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertIcon.value).to(equal(testAlertView.icon.name));
            });

            it(@"should not set the image if icons are not supported on the module", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@NO] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertIcon).to(beNil());
            });
        });
    });

    describe(@"uploading files", ^{
        describe(@"uploading audio files", ^{
            beforeEach(^{
                [testAlertAudioFileData addSpeechSynthesizerStrings:@[@"test1", @"test2"]];
                [testAlertAudioFileData addAudioFiles:@[testAudioFile]];
                testAlertView.audio = testAlertAudioFileData;
                testAlertView.icon = nil;

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
            });

            it(@"should not attempt to upload the audio file if the negotiated spec version does not yet support the audio file feature", ^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:4 minor:5 patch:0];
                [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesFile]] speechCapabilities];

                OCMReject([mockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];
            });

            it(@"should not attempt to upload the audio file if the speech capabilities do not support the audio file feature", ^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:5 patch:0];
                [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesText]] speechCapabilities];

                OCMReject([mockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];
            });

            it(@"should attempt to upload the audio file if the module supports the feature", ^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:5 patch:0];
                [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesFile]] speechCapabilities];

                OCMExpect([mockFileManager uploadFiles:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLPutFile *> *files = (NSArray<SDLPutFile *> *)value;
                    expect(files.count).to(equal(2));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];

                OCMVerifyAllWithDelay(mockFileManager, 0.5);
            });
        });

        describe(@"uploading image files", ^{
            beforeEach(^{
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
            });

            it(@"should attempt to upload the alert icons and soft button images if they are supported on the module", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@YES] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@NO] hasUploadedFile:[OCMArg any]];

                OCMExpect([mockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(3));
                    expect(files[0].name).to(equal(testAlertView.icon.name));
                    expect(files[1].name).to(equal(testAlertView.softButtons[0].currentState.artwork.name));
                    expect(files[2].name).to(equal(testAlertView.softButtons[1].currentState.artwork.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];

                OCMVerifyAllWithDelay(mockFileManager, 0.5);
            });

            it(@"should not attempt to upload the soft button images if soft button images are not supported on the module", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@YES] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @NO;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@NO] hasUploadedFile:[OCMArg any]];

                OCMExpect([mockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(1));
                    expect(files[0].name).to(equal(testAlertView.icon.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];

                OCMVerifyAllWithDelay(mockFileManager, 0.5);
            });

            it(@"should not attempt to upload the alert icon if the alert icon is not supported on the module", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@NO] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@NO] hasUploadedFile:[OCMArg any]];

                OCMExpect([mockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(2));
                    expect(files[0].name).to(equal(testAlertView.softButtons[0].currentState.artwork.name));
                    expect(files[1].name).to(equal(testAlertView.softButtons[1].currentState.artwork.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];

                OCMVerifyAllWithDelay(mockFileManager, 0.5);
            });

            it(@"should not attempt to upload any images if the alert icon and soft button graphics are not supported on the module", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@NO] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @NO;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@NO] hasUploadedFile:[OCMArg any]];

                OCMReject([mockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];
            });

            it(@"should not attempt to upload a static image", ^{
                testAlertView.icon = [[SDLArtwork alloc] initWithStaticIcon:SDLStaticIconNameKey];

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                [[[mockCurrentWindowCapability stub] andReturnValue:@YES] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@NO] hasUploadedFile:[OCMArg any]];

                OCMExpect([mockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(2));
                    expect(files[0].name).to(equal(testAlertView.softButtons[0].currentState.artwork.name));
                    expect(files[1].name).to(equal(testAlertView.softButtons[1].currentState.artwork.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];
            });

            it(@"should not attempt to upload a dynamic image that has already been uploaded", ^{
                testAlertView.icon = testAlertIcon;

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                [[[mockCurrentWindowCapability stub] andReturnValue:@YES] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@YES] hasUploadedFile:testAlertIcon];

                OCMExpect([mockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(2));
                    expect(files[0].name).to(equal(testAlertView.softButtons[0].currentState.artwork.name));
                    expect(files[1].name).to(equal(testAlertView.softButtons[1].currentState.artwork.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];
            });

            // TODO currently fails because the overwrite property is not copied in the `SDLArtwork`'s `copyWithZone`
            xit(@"should attempt to upload a dynamic image that has already been uploaded but has overwrite set to YES", ^{
                testAlertIcon.overwrite = YES;
                testAlertView.icon = testAlertIcon;

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                [[[mockCurrentWindowCapability stub] andReturnValue:@YES] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@YES] hasUploadedFile:testAlertIcon];

                OCMExpect([mockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(3));
                    expect(files[0].name).to(equal(testAlertView.icon.name));
                    expect(files[1].name).to(equal(testAlertView.softButtons[0].currentState.artwork.name));
                    expect(files[2].name).to(equal(testAlertView.softButtons[1].currentState.artwork.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];
            });
        });
    });

    describe(@"presenting the alert", ^{
        beforeEach(^{
            [[[mockCurrentWindowCapability stub] andReturnValue:@3] maxNumberOfAlertMainFieldLines];
            [[[mockCurrentWindowCapability stub] andReturnValue:@YES] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
            [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
            [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesFile]] speechCapabilities];
            SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
            testSoftButtonCapabilities.imageSupported = @YES;
            OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
            [[[mockFileManager stub] andReturnValue:@NO] hasUploadedFile:[OCMArg any]];
            OCMStub([mockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);
            OCMStub([mockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

            testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

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
            OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg any] withResponseHandler:[OCMArg any]]);

            [testPresentAlertOperation start];
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
                NSError *expectedAlertResponseError = [NSError sdl_alertManager_presentationFailed:@{@"tryAgainTime": response.tryAgainTime, @"error": defaultError}];

                OCMStub([mockConnectionManager sendConnectionRequest:[OCMArg any] withResponseHandler:([OCMArg invokeBlockWithArgs:[OCMArg any], response, defaultError, nil])]);

                expect(testPresentAlertOperation.internalError).toEventually(equal(expectedAlertResponseError));
                expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                expect(testPresentAlertOperation.isFinished).toEventually(beTrue());
            });
        });
    });
});

QuickSpecEnd
