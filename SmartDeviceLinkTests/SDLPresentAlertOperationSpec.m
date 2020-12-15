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
#import "SDLCancelInteraction.h"
#import "SDLCancelInteractionResponse.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLFunctionID.h"
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
@property (strong, nonatomic, readwrite) SDLAlertView *alertView;
@property (strong, nonatomic, readwrite) SDLAlert *alert;
@property (assign, nonatomic) UInt16 cancelId;
@property (copy, nonatomic, nullable) NSError *internalError;

- (BOOL)sdl_isValidAlertViewData:(SDLAlertView *)alertView;

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

    __block SDLVersion *alertAudioFileSupportedSpecVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
    __block SDLVersion *alertAudioFileNotSupportedSpecVersion = [SDLVersion versionWithMajor:4 minor:8 patch:0];

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

        testAlertSoftButton1 = [[SDLSoftButtonObject alloc] initWithName:@"button1" text:@"button1" artwork:testButton1Icon handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];
        testAlertSoftButton2 = [[SDLSoftButtonObject alloc] initWithName:@"button2" text:@"button2" artwork:testButton2Icon handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        UIImage *testImage = [[UIImage alloc] initWithContentsOfFile:[testBundle pathForResource:@"testImageJPEG" ofType:@"jpeg"]];
        testAlertIcon = [SDLArtwork artworkWithImage:testImage asImageFormat:SDLArtworkImageFormatPNG];

        testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
    });

    it(@"should be initialized correctly", ^{
        testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

        expect(@(testPresentAlertOperation.queuePriority)).to(equal(@(NSOperationQueuePriorityNormal)));
        expect(testPresentAlertOperation.connectionManager).to(equal(mockConnectionManager));
        expect(testPresentAlertOperation.fileManager).to(equal(mockFileManager));
        expect(testPresentAlertOperation.alertView).toNot(equal(testAlertView));
        expect(@(testPresentAlertOperation.cancelId)).to(equal(@(testCancelID)));
        expect(testPresentAlertOperation.currentWindowCapability).to(equal(mockCurrentWindowCapability));
        expect(testPresentAlertOperation.internalError).to(beNil());
    });

    describe(@"creating the alert", ^{
        beforeEach(^{
            [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:6 minor:0 patch:0];
        });

        describe(@"setting the text fields", ^{
            describe(@"with all three text fields set", ^{
                beforeEach(^{
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];

                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set all textfields if all textfields are supported", ^{
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertFieldLines];
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                    expect(testAlert.alertText3).to(equal(testAlertView.tertiaryText));
                });

                it(@"should set textfields correctly if only two textfields are supported", ^{
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(2)] maxNumberOfAlertFieldLines];
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(equal([NSString stringWithFormat:@"%@ - %@", testAlertView.secondaryText, testAlertView.tertiaryText]));
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only one textfield is supported", ^{
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(1)] maxNumberOfAlertFieldLines];
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
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertFieldLines];
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only two textfields are supported", ^{
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(2)] maxNumberOfAlertFieldLines];
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only one textfield is supported", ^{
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(1)] maxNumberOfAlertFieldLines];
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
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertFieldLines];
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only two textfields are supported", ^{
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(2)] maxNumberOfAlertFieldLines];
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only one textfield is supported", ^{
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(1)] maxNumberOfAlertFieldLines];
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
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertFieldLines];
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.alertText1).to(beNil());
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only two textfields are supported", ^{
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(2)] maxNumberOfAlertFieldLines];
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.alertText1).to(beNil());
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only one textfield is supported", ^{
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(1)] maxNumberOfAlertFieldLines];
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
            context(@"only audio prompts set", ^{
                beforeEach(^{
                    [[[mockCurrentWindowCapability stub] andReturnValue:@(3)] maxNumberOfAlertFieldLines];

                    SDLAlertAudioData *audioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"test synthesizer string"];
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:audioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set the tts chunks correctly", ^{
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.ttsChunks.count).to(equal(1));
                    expect(testAlert.ttsChunks[0].text).to(equal(testAlertView.audio.prompts.firstObject.text));
                });
            });

            context(@"only audio file data set", ^{
                beforeEach(^{
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:testAlertAudioFileData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                context(@"the negotiated RPC spec version does not support the audio file feature", ^{
                    beforeEach(^{
                        [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileNotSupportedSpecVersion;
                    });

                    it(@"should set the `ttsChunks` to nil (and not an empty array) if only an audio file was set", ^{
                        SDLAlert *testAlert = testPresentAlertOperation.alert;
                        expect(testAlert.ttsChunks).to(beNil());
                    });
                });

                context(@"the negotiated RPC spec version supports the audio file feature", ^{
                    beforeEach(^{
                        [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileSupportedSpecVersion;
                    });

                    context(@"the module does not support the speech capability of type `file`", ^{
                        beforeEach(^{
                            [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesSilence]] speechCapabilities];
                        });

                        it(@"should set the `ttsChunks` to nil (and not an empty array) if only an audio file was set", ^{
                            SDLAlert *testAlert = testPresentAlertOperation.alert;
                            expect(testAlert.ttsChunks).to(beNil());
                        });
                    });

                    context(@"the module supports the speech capability of type `file`", ^{
                        beforeEach(^{
                            [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesFile, SDLSpeechCapabilitiesText]] speechCapabilities];
                        });

                        it(@"should set the tts chunks correctly", ^{
                            SDLAlert *testAlert = testPresentAlertOperation.alert;
                            expect(testAlert.ttsChunks.count).to(equal(1));
                            expect(testAlert.ttsChunks[0].text).to(equal(testAlertView.audio.audioFiles.firstObject.name));
                        });
                    });
                });
            });

            context(@"both audio prompts and audio file data set", ^{
                beforeEach(^{
                    SDLAlertAudioData *audioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"test synthesizer string"];
                    [audioData addAudioFiles:@[testAudioFile]];

                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:audioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set the tts chunks correctly", ^{
                    SDLAlert *testAlert = testPresentAlertOperation.alert;
                    expect(testAlert.ttsChunks.count).to(equal(2));
                    expect(testAlert.ttsChunks[0].text).to(equal(testAlertView.audio.audioFiles[0].name));
                    expect(testAlert.ttsChunks[1].text).to(equal(testAlertView.audio.prompts[0].text));
                });
            });

            context(@"no audio data set", ^{
                beforeEach(^{
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:4 showWaitIndicator:YES audioIndication:nil buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set the `ttsChunks` to nil (and not an empty array)", ^{
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
                [[[mockCurrentWindowCapability stub] andReturnValue:@(YES)] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertIcon.value).to(equal(testAlertView.icon.name));
            });

            it(@"should not set the image if icons are not supported on the module", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(NO)] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLAlert *testAlert = testPresentAlertOperation.alert;
                expect(testAlert.alertIcon).to(beNil());
            });
        });
    });

    describe(@"uploading files", ^{
        describe(@"audio files", ^{
            beforeEach(^{
                testAlertView.audio = testAlertAudioFileData;

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
            });

            context(@"the negotiated RPC spec version does not support the audio file feature", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileNotSupportedSpecVersion;
                });

                it(@"should not attempt to upload audio files", ^{
                    OCMReject([mockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                    [testPresentAlertOperation start];
                });
            });

            context(@"the negotiated RPC spec version supports the audio file feature", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileSupportedSpecVersion;
                });

                context(@"the module does not support the speech capability of type `file`", ^{
                    beforeEach(^{
                        [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesText]] speechCapabilities];
                    });

                    it(@"should not attempt to upload audio files", ^{
                        OCMReject([mockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                        [testPresentAlertOperation start];
                    });
                });

                context(@"the module supports the speech capability of type `file`", ^{
                    beforeEach(^{
                        [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesFile]] speechCapabilities];
                    });

                    it(@"should not upload the audio file if it has already been uploaded", ^{
                        [[[mockFileManager stub] andReturnValue:@(YES)] hasUploadedFile:testAudioFile];

                        OCMReject([mockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                        [testPresentAlertOperation start];
                    });

                    it(@"should upload the audio file if it has not yet been uploaded", ^{
                        [[[mockFileManager stub] andReturnValue:@(YES)] fileNeedsUpload:testAudioFile];

                        OCMExpect([mockFileManager uploadFiles:[OCMArg checkWithBlock:^BOOL(id value) {
                            NSArray<SDLPutFile *> *files = (NSArray<SDLPutFile *> *)value;
                            expect(files.count).to(equal(1));
                            expect(files.firstObject.name).to(equal(testAlertAudioFileData.audioFiles.firstObject.name));
                            return [value isKindOfClass:[NSArray class]];
                        }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                        [testPresentAlertOperation start];

                        OCMVerifyAllWithDelay(mockFileManager, 0.5);
                    });

                    it(@"should re-upload an audio file if `overwrite` has been set to true", ^{
                        testAudioFile.overwrite = YES;
                        [[[mockFileManager stub] andReturnValue:@(YES)] fileNeedsUpload:testAudioFile];

                        OCMExpect([mockFileManager uploadFiles:[OCMArg checkWithBlock:^BOOL(id value) {
                            NSArray<SDLPutFile *> *files = (NSArray<SDLPutFile *> *)value;
                            expect(files.count).to(equal(1));
                            expect(files.firstObject.name).to(equal(testAlertAudioFileData.audioFiles.firstObject.name));
                            return [value isKindOfClass:[NSArray class]];
                        }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                        [testPresentAlertOperation start];

                        OCMVerifyAllWithDelay(mockFileManager, 0.5);
                    });
                });
            });
        });

        describe(@"image files", ^{
            beforeEach(^{
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
            });

            it(@"should upload the alert icons and soft button images if they are supported on the module", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(YES)] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@(YES)] fileNeedsUpload:[OCMArg any]];

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

            it(@"should not upload the soft button images if soft button images are not supported on the module", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(YES)] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @(NO);
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@(YES)] fileNeedsUpload:[OCMArg any]];

                OCMExpect([mockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(1));
                    expect(files[0].name).to(equal(testAlertView.icon.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];

                OCMVerifyAllWithDelay(mockFileManager, 0.5);
            });

            it(@"should upload the alert icon if the alert icon is not supported on the module", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(NO)] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@(YES)] fileNeedsUpload:[OCMArg any]];

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

            it(@"should not upload any images if the alert icon and soft button graphics are not supported on the module", ^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@(NO)] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @NO;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@(NO)] hasUploadedFile:[OCMArg any]];

                OCMReject([mockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];
            });

            it(@"should not upload a static image", ^{
                testAlertView.icon = [[SDLArtwork alloc] initWithStaticIcon:SDLStaticIconNameKey];

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                [[[mockCurrentWindowCapability stub] andReturnValue:@(YES)] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@(NO)] hasUploadedFile:[OCMArg any]];

                OCMExpect([mockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(2));
                    expect(files[0].name).to(equal(testAlertView.softButtons[0].currentState.artwork.name));
                    expect(files[1].name).to(equal(testAlertView.softButtons[1].currentState.artwork.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];
            });

            it(@"should not upload a dynamic image that has already been uploaded", ^{
                testAlertIcon.overwrite = NO;
                testAlertView.icon = testAlertIcon;

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                [[[mockCurrentWindowCapability stub] andReturnValue:@(YES)] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@(YES)] hasUploadedFile:testAlertIcon];
                [[[mockFileManager stub] andReturnValue:@(NO)] hasUploadedFile:testButton1Icon];
                [[[mockFileManager stub] andReturnValue:@(NO)] hasUploadedFile:testButton2Icon];

                OCMExpect([mockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(2));
                    expect(files[0].name).to(equal(testAlertView.softButtons[0].currentState.artwork.name));
                    expect(files[1].name).to(equal(testAlertView.softButtons[1].currentState.artwork.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];
            });

            it(@"should upload a dynamic image that has already been uploaded but has overwrite set to true", ^{
                testAlertIcon.overwrite = YES;
                testAlertView.icon = testAlertIcon;

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                [[[mockCurrentWindowCapability stub] andReturnValue:@(YES)] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@(YES)] hasUploadedFile:testAlertIcon];
                [[[mockFileManager stub] andReturnValue:@(NO)] hasUploadedFile:testButton1Icon];
                [[[mockFileManager stub] andReturnValue:@(NO)] hasUploadedFile:testButton2Icon];

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
        describe(@"checking if alert data is valid", ^{
            context(@"the module does not support audio data uploads", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileSupportedSpecVersion;
                });

                it(@"should be valid if at least the first text field was set", ^{
                    testAlertView = [[SDLAlertView alloc] init];
                    testAlertView.text = @"test text";
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                    BOOL testAlertDataValid = [testPresentAlertOperation sdl_isValidAlertViewData:testAlertView];
                    expect(testAlertDataValid).to(beTrue());
                });

                it(@"should be valid if at least the second text field was set", ^{
                    testAlertView = [[SDLAlertView alloc] init];
                    testAlertView.secondaryText = @"test text";
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                    BOOL testAlertDataValid = [testPresentAlertOperation sdl_isValidAlertViewData:testAlertView];
                    expect(testAlertDataValid).to(beTrue());
                });

                it(@"should be valid if at least the audio data was set", ^{
                    testAlertView = [[SDLAlertView alloc] init];
                    testAlertView.audio = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"test audio"];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                    BOOL testAlertDataValid = [testPresentAlertOperation sdl_isValidAlertViewData:testAlertView];
                    expect(testAlertDataValid).to(beTrue());
                });

                it(@"should be invalid if the first two text fields or the audio data was not set", ^{
                    testAlertView = [[SDLAlertView alloc] init];
                    testAlertView.tertiaryText = @"test text";
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                    BOOL testAlertDataValid = [testPresentAlertOperation sdl_isValidAlertViewData:testAlertView];
                    expect(testAlertDataValid).to(beFalse());
                });
            });

            context(@"the module does not support audio data uploads", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileNotSupportedSpecVersion;
                });

                it(@"should be invalid if only audio data was set but audio data is not supported on the module", ^{
                    testAlertView = [[SDLAlertView alloc] init];
                    testAlertView.audio = [[SDLAlertAudioData alloc] initWithAudioFile:testAudioFile];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                    BOOL testAlertDataValid = [testPresentAlertOperation sdl_isValidAlertViewData:testAlertView];
                    expect(testAlertDataValid).to(beFalse());
                });
            });
        });

        context(@"with invalid data", ^{
            context(@"the module supports audio data uploads", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileSupportedSpecVersion;
                });

                it(@"should return an error if invalid data was set", ^{
                    testAlertView = [[SDLAlertView alloc] init];
                    testAlertView.tertiaryText = @"test text";

                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                    testPresentAlertOperation.completionBlock = ^{
                        hasCalledOperationCompletionHandler = YES;
                    };

                    [testPresentAlertOperation start];

                    expect(testPresentAlertOperation.internalError).to(equal([NSError sdl_alertManager_alertDataInvalid]));
                    expect(hasCalledOperationCompletionHandler).to(beTrue());
                    expect(testPresentAlertOperation.isFinished).toEventually(beTrue());
                });
            });

            context(@"the module does not support audio data uploads", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileNotSupportedSpecVersion;
                });

                it(@"should return an error if valid audio data was set but the module does not support audio files", ^{
                    testAlertView = [[SDLAlertView alloc] init];
                    testAlertView.audio = [[SDLAlertAudioData alloc] initWithAudioFile:testAudioFile];

                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                    testPresentAlertOperation.completionBlock = ^{
                        hasCalledOperationCompletionHandler = YES;
                    };

                    [testPresentAlertOperation start];

                    expect(testPresentAlertOperation.internalError).to(equal([NSError sdl_alertManager_alertAudioFileNotSupported]));
                    expect(hasCalledOperationCompletionHandler).to(beTrue());
                    expect(testPresentAlertOperation.isFinished).toEventually(beTrue());
                });

                it(@"should return an error if invalid data was set", ^{
                    testAlertView = [[SDLAlertView alloc] init];
                    testAlertView.tertiaryText = @"test text";

                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                    testPresentAlertOperation.completionBlock = ^{
                        hasCalledOperationCompletionHandler = YES;
                    };

                    [testPresentAlertOperation start];

                    expect(testPresentAlertOperation.internalError).to(equal([NSError sdl_alertManager_alertDataInvalid]));
                    expect(hasCalledOperationCompletionHandler).to(beTrue());
                    expect(testPresentAlertOperation.isFinished).toEventually(beTrue());
                });
            });
        });

        context(@"with valid data", ^{
            beforeEach(^{
                [[[mockCurrentWindowCapability stub] andReturnValue:@3] maxNumberOfAlertFieldLines];
                [[[mockCurrentWindowCapability stub] andReturnValue:@(YES)] hasImageFieldOfName:SDLImageFieldNameAlertIcon];
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
                [[[mockSystemCapabilityManager stub] andReturn:@[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesFile]] speechCapabilities];
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                [[[mockFileManager stub] andReturnValue:@(NO)] hasUploadedFile:[OCMArg any]];
                OCMStub([mockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);
                OCMStub([mockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                SDLVersion *supportedVersion = [SDLVersion versionWithMajor:6 minor:3 patch:0];
                id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                OCMStub([globalMock rpcVersion]).andReturn(supportedVersion);

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
                OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLAlert.class] withResponseHandler:[OCMArg any]]);

                [testPresentAlertOperation start];

                expect(testPresentAlertOperation.internalError).to(beNil());
                expect(hasCalledOperationCompletionHandler).to(beTrue());
                expect(testPresentAlertOperation.isFinished).toEventually(beTrue());
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

                    OCMStub([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLAlert.class] withResponseHandler:([OCMArg invokeBlockWithArgs:[OCMArg any], response, [NSNull null], nil])]);

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

                    OCMStub([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLAlert.class] withResponseHandler:([OCMArg invokeBlockWithArgs:[OCMArg any], response, defaultError, nil])]);

                    expect(testPresentAlertOperation.internalError).toEventually(equal(expectedAlertResponseError));
                    expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                    expect(testPresentAlertOperation.isFinished).toEventually(beTrue());
                });
            });
        });
    });

    describe(@"canceling the alert", ^{
        __block SDLAlertView *testCancelAlertView = nil;
        __block SDLVersion *cancelInteractionSupportedSpecVersion = [SDLVersion versionWithMajor:6 minor:0 patch:0];
        __block SDLVersion *cancelInteractionNotSupportedSpecVersion = [SDLVersion versionWithMajor:5 minor:10 patch:0];

        beforeEach(^{
            testCancelAlertView = [[SDLAlertView alloc] init];
            testCancelAlertView.text = @"Alert view to be canceled";

            [[[mockCurrentWindowCapability stub] andReturnValue:@3] maxNumberOfAlertFieldLines];

            testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testCancelAlertView cancelID:testCancelID];
            testPresentAlertOperation.completionBlock = ^{
                hasCalledOperationCompletionHandler = YES;
            };
        });

        context(@"Module supports the CancelInteration RPC", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = cancelInteractionSupportedSpecVersion;
            });

            describe(@"If the operation is executing", ^{
                it(@"should attempt to send a cancel interaction", ^{
                    OCMExpect([mockConnectionManager sendConnectionRequest:[OCMArg checkWithBlock:^BOOL(id value) {
                        return [value isKindOfClass:[SDLAlert class]];
                    }] withResponseHandler:[OCMArg any]]);

                    [testPresentAlertOperation start];

                    OCMVerifyAllWithDelay(mockConnectionManager, 0.5);
                    expect(testPresentAlertOperation.isExecuting).to(beTrue());
                    expect(testPresentAlertOperation.isFinished).to(beFalse());
                    expect(testPresentAlertOperation.isCancelled).to(beFalse());

                    OCMExpect([mockConnectionManager sendConnectionRequest:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLCancelInteraction *cancelRequest = (SDLCancelInteraction *)value;
                        expect(cancelRequest).to(beAnInstanceOf([SDLCancelInteraction class]));
                        expect(cancelRequest.cancelID).to(equal(testCancelID));
                        expect(cancelRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameAlert]));
                        return [value isKindOfClass:[SDLCancelInteraction class]];
                    }] withResponseHandler:[OCMArg any]]);

                    [testCancelAlertView cancel];

                    OCMVerifyAllWithDelay(mockConnectionManager, 0.5);
                });

                context(@"If the cancel interaction was successful", ^{
                    beforeEach(^{
                        [testPresentAlertOperation start];
                    });

                    it(@"should not save an error", ^{
                        SDLCancelInteractionResponse *testResponse = [[SDLCancelInteractionResponse alloc] init];
                        testResponse.success = @YES;
                        testResponse.resultCode = SDLResultSuccess;

                        OCMStub([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:([OCMArg invokeBlockWithArgs:[OCMArg any], testResponse, [NSNull null], nil])]);

                        [testCancelAlertView cancel];

                        expect(testPresentAlertOperation.error).to(beNil());
                    });
                });

                context(@"If the cancel interaction was not successful", ^{
                    beforeEach(^{
                        [testPresentAlertOperation start];
                    });

                    it(@"should save an error", ^{
                        SDLCancelInteractionResponse *testResponse = [[SDLCancelInteractionResponse alloc] init];
                        testResponse.success = @NO;
                        testResponse.resultCode = SDLResultAborted;
                        NSError *defaultError = [NSError errorWithDomain:@"com.sdl.testConnectionManager" code:-1 userInfo:nil];

                        OCMStub([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:([OCMArg invokeBlockWithArgs:[OCMArg any], testResponse, defaultError, nil])]);

                        [testCancelAlertView cancel];

                        expect(testPresentAlertOperation.error).to(equal(defaultError));
                    });
                });
            });

            describe(@"If the operation has already finished", ^{
                beforeEach(^{
                    [testPresentAlertOperation finishOperation];
                });

                it(@"should not attempt to send a cancel interaction", ^{
                    OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                    [testCancelAlertView cancel];
                });
            });

            describe(@"If the started operation has been canceled", ^{
                beforeEach(^{
                    [testPresentAlertOperation start];
                    [testPresentAlertOperation cancel];
                });

                it(@"should not attempt to send a cancel interaction", ^{
                    OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                    [testCancelAlertView cancel];
                });
            });

            context(@"If the operation has not started", ^{
                it(@"should not attempt to send a cancel interaction", ^{
                    OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                    [testCancelAlertView cancel];
                });

                context(@"Once the operation has started after being canceled", ^{
                    it(@"should not attempt to send a cancel interaction", ^{
                        OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                        [testCancelAlertView cancel];

                        OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                        [testPresentAlertOperation start];
                        [testCancelAlertView cancel];
                    });
                });
            });
        });

        context(@"Module does not support the CancelInteration RPC", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = cancelInteractionNotSupportedSpecVersion;
            });

            it(@"should not attempt to send a cancel interaction if the operation is executing", ^{
                [testPresentAlertOperation start];

                OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                [testCancelAlertView cancel];
            });

            it(@"should cancel the operation if it has not yet been run", ^{
                OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                [testCancelAlertView cancel];

                expect(testPresentAlertOperation.isCancelled).to(beTrue());
            });
        });
    });
});

QuickSpecEnd
