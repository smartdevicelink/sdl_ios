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
@property (assign, nonatomic) UInt16 cancelId;
@property (copy, nonatomic, nullable) NSError *internalError;
@property (assign, nonatomic) BOOL alertIconUploaded;

- (nullable NSError *)sdl_isValidAlertViewData:(SDLAlertView *)alertView;
- (SDLAlert *)alertRPC;

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
    __block SDLSoftButtonObject *testAlertSoftButton3 = nil;
    __block SDLSoftButtonObject *testAlertSoftButton4 = nil;
    __block SDLSoftButtonObject *testAlertSoftButton5 = nil;
    __block SDLSoftButtonObject *testAlertSoftButton6 = nil;
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
        testAlertSoftButton3 = [[SDLSoftButtonObject alloc] initWithName:@"button3" text:@"button3" artwork:testButton2Icon handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];
        testAlertSoftButton4 = [[SDLSoftButtonObject alloc] initWithName:@"button4" text:@"button4" artwork:testButton2Icon handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];
        testAlertSoftButton5 = [[SDLSoftButtonObject alloc] initWithName:@"button5" text:@"button5" artwork:testButton2Icon handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];
        testAlertSoftButton6 = [[SDLSoftButtonObject alloc] initWithName:@"button6" text:@"button6" artwork:testButton2Icon handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {}];

        UIImage *testImage = [[UIImage alloc] initWithContentsOfFile:[testBundle pathForResource:@"testImageJPEG" ofType:@"jpeg"]];
        testAlertIcon = [SDLArtwork artworkWithImage:testImage asImageFormat:SDLArtworkImageFormatJPG];

        testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:@(4) showWaitIndicator:@(YES) audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
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
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:@(4) showWaitIndicator:@(YES) audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];

                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set all textfields if all textfields are supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(3);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                    expect(testAlert.alertText3).to(equal(testAlertView.tertiaryText));
                });

                it(@"should set textfields correctly if only two textfields are supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(2);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(equal([NSString stringWithFormat:@"%@ - %@", testAlertView.secondaryText, testAlertView.tertiaryText]));
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only one textfield is supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(1);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(equal([NSString stringWithFormat:@"%@ - %@ - %@", testAlertView.text, testAlertView.secondaryText, testAlertView.tertiaryText]));
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });
            });

            describe(@"with two text fields set", ^{
                beforeEach(^{
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:nil timeout:@(4) showWaitIndicator:@(YES) audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set all textfields if all textfields are supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(3);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only two textfields are supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(2);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only one textfield is supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(1);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(equal([NSString stringWithFormat:@"%@ - %@", testAlertView.text, testAlertView.secondaryText]));
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });
            });

            describe(@"with one text field set", ^{
                beforeEach(^{
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:nil tertiaryText:nil timeout:@(4) showWaitIndicator:@(YES) audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set all textfields if all textfields are supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(3);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only two textfields are supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(2);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only one textfield is supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(1);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });
            });

            describe(@"with no text fields set", ^{
                beforeEach(^{
                    testAlertView = [[SDLAlertView alloc] initWithText:nil secondaryText:nil tertiaryText:nil timeout:@(4) showWaitIndicator:@(YES) audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set all textfields if all textfields are supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(3);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(beNil());
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only two textfields are supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(2);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(beNil());
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });

                it(@"should set textfields correctly if only one textfield is supported", ^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(1);
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(beNil());
                    expect(testAlert.alertText2).to(beNil());
                    expect(testAlert.alertText3).to(beNil());
                });
            });

            describe(@"with a nil currentWindowCapability", ^{
                beforeEach(^{
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:@(4) showWaitIndicator:@(YES) audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:nil alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should assume all textfields are supported", ^{
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.alertText1).to(equal(testAlertView.text));
                    expect(testAlert.alertText2).to(equal(testAlertView.secondaryText));
                    expect(testAlert.alertText3).to(equal(testAlertView.tertiaryText));
                });
            });
        });

        describe(@"setting the audio data", ^{
            context(@"only audio prompts set", ^{
                beforeEach(^{
                    OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(3);

                    SDLAlertAudioData *audioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"test synthesizer string"];
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:@(4) showWaitIndicator:@(YES) audioIndication:audioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set the tts chunks correctly", ^{
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.ttsChunks.count).to(equal(1));
                    expect(testAlert.ttsChunks[0].text).to(equal(testAlertView.audio.audioData.firstObject.text));
                });
            });

            context(@"only audio file data set", ^{
                beforeEach(^{
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:@(4) showWaitIndicator:@(YES) audioIndication:testAlertAudioFileData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                context(@"the negotiated RPC spec version does not support the audio file feature", ^{
                    beforeEach(^{
                        [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileNotSupportedSpecVersion;
                    });

                    it(@"should set the `ttsChunks` to nil (and not an empty array) if only an audio file was set", ^{
                        SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                        expect(testAlert.ttsChunks).to(beNil());
                    });
                });

                context(@"the negotiated RPC spec version supports the audio file feature", ^{
                    beforeEach(^{
                        [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileSupportedSpecVersion;
                    });

                    context(@"the module does not support the speech capability of type `file`", ^{
                        beforeEach(^{
                            OCMStub([mockSystemCapabilityManager speechCapabilities]).andReturn((@[SDLSpeechCapabilitiesSilence]));
                        });

                        it(@"should set the `ttsChunks` to nil (and not an empty array) if only an audio file was set", ^{
                            SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                            expect(testAlert.ttsChunks).to(beNil());
                        });
                    });

                    context(@"the module supports the speech capability of type `file`", ^{
                        beforeEach(^{
                            OCMStub([mockSystemCapabilityManager speechCapabilities]).andReturn((@[SDLSpeechCapabilitiesFile, SDLSpeechCapabilitiesText]));
                        });

                        it(@"should set the tts chunks correctly", ^{
                            SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                            expect(testAlert.ttsChunks.count).to(equal(1));
                            expect(testAlert.ttsChunks[0].text).to(equal(testAlertView.audio.audioData.firstObject.text));
                        });
                    });
                });
            });

            context(@"both audio prompts and audio file data set", ^{
                beforeEach(^{
                    SDLAlertAudioData *audioData = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"test synthesizer string"];
                    [audioData addAudioFiles:@[testAudioFile]];

                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:@(4) showWaitIndicator:@(YES) audioIndication:audioData buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set the tts chunks correctly", ^{
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.ttsChunks.count).to(equal(2));
                    expect(testAlert.ttsChunks[0].text).to(equal(testAlertView.audio.audioData[0].text));
                    expect(testAlert.ttsChunks[1].text).to(equal(testAlertView.audio.audioData[1].text));
                });
            });

            context(@"no audio data set", ^{
                beforeEach(^{
                    testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:@(4) showWaitIndicator:@(YES) audioIndication:nil buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
                });

                it(@"should set the `ttsChunks` to nil (and not an empty array)", ^{
                    SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                    expect(testAlert.ttsChunks).to(beNil());
                });
            });
        });

        describe(@"setting the icon", ^{
            beforeEach(^{
                testAlertView = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:@(4) showWaitIndicator:@(YES) audioIndication:nil buttons:@[testAlertSoftButton1, testAlertSoftButton2] icon:testAlertIcon];
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];
            });

            it(@"should not set the image if it fails to upload to the module", ^{
                SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                expect(testAlert.alertIcon.value).to(beNil());
            });

            it(@"should set the image if it is uploaded to the module", ^{
                testPresentAlertOperation.alertIconUploaded = YES;

                SDLAlert *testAlert = testPresentAlertOperation.alertRPC;
                expect(testAlert.alertIcon.value).to(equal(testAlertView.icon.name));
            });
        });
    });

    describe(@"uploading", ^{
        __block id strictMockFileManager = nil;
        __block id strictMockSystemCapabilityManager = nil;
        __block id strictMockCurrentWindowCapability = nil;

        beforeEach(^{
            strictMockFileManager = OCMStrictClassMock([SDLFileManager class]);
            strictMockSystemCapabilityManager = OCMStrictClassMock([SDLSystemCapabilityManager class]);
            strictMockCurrentWindowCapability = OCMStrictClassMock([SDLWindowCapability class]);
        });

        describe(@"audio files", ^{
            beforeEach(^{
                testAlertView.audio = testAlertAudioFileData;
                testAlertView.softButtons = @[];
                testAlertView.icon = nil;
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:strictMockFileManager systemCapabilityManager:strictMockSystemCapabilityManager currentWindowCapability:strictMockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                OCMStub([strictMockFileManager fileNeedsUpload:nil]).andReturn(NO);
                OCMStub([strictMockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(2);
                OCMStub([strictMockCurrentWindowCapability hasImageFieldOfName:SDLImageFieldNameAlertIcon]).andReturn(YES);
            });

            context(@"the negotiated RPC spec version does not support the audio file feature", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileNotSupportedSpecVersion;
                    OCMStub([strictMockSystemCapabilityManager speechCapabilities]).andReturn((@[SDLSpeechCapabilitiesFile, SDLSpeechCapabilitiesText]));
                });

                it(@"should not attempt to upload audio files", ^{
                    OCMReject([strictMockFileManager fileNeedsUpload:testAudioFile]);
                    OCMReject([strictMockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                    [testPresentAlertOperation start];

                    OCMVerifyAll(strictMockFileManager);
                    OCMVerifyAll(strictMockSystemCapabilityManager);
                    OCMVerifyAll(strictMockCurrentWindowCapability);
                });
            });

            context(@"the negotiated RPC spec version supports the audio file feature", ^{
                beforeEach(^{
                    [SDLGlobals sharedGlobals].rpcVersion = alertAudioFileSupportedSpecVersion;
                });

                context(@"the module does not support the speech capability of type `file`", ^{
                    beforeEach(^{
                        OCMStub([strictMockSystemCapabilityManager speechCapabilities]).andReturn((@[SDLSpeechCapabilitiesText]));
                    });

                    it(@"should not attempt to upload audio files", ^{
                        OCMReject([strictMockFileManager fileNeedsUpload:testAudioFile]);
                        OCMReject([strictMockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                        [testPresentAlertOperation start];

                        OCMVerifyAll(strictMockFileManager);
                        OCMVerifyAll(strictMockSystemCapabilityManager);
                        OCMVerifyAll(strictMockCurrentWindowCapability);
                    });
                });

                context(@"the module supports the speech capability of type `file`", ^{
                    beforeEach(^{
                        OCMStub([strictMockSystemCapabilityManager speechCapabilities]).andReturn((@[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesFile]));
                    });

                    it(@"should not upload the audio file if it has already been uploaded", ^{
                        OCMExpect([strictMockFileManager fileNeedsUpload:testAudioFile]).andReturn(NO);
                        OCMReject([strictMockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                        [testPresentAlertOperation start];

                        OCMVerifyAll(strictMockFileManager);
                        OCMVerifyAll(strictMockSystemCapabilityManager);
                        OCMVerifyAll(strictMockCurrentWindowCapability);
                    });

                    it(@"should upload the audio file if it has not yet been uploaded", ^{
                        OCMExpect([strictMockFileManager fileNeedsUpload:testAudioFile]).andReturn(YES);
                        OCMExpect([strictMockFileManager uploadFiles:[OCMArg checkWithBlock:^BOOL(id value) {
                            NSArray<SDLPutFile *> *files = (NSArray<SDLPutFile *> *)value;
                            expect(files.count).to(equal(1));
                            expect(files.firstObject.name).to(equal(testAlertAudioFileData.audioData.firstObject.text));
                            return [value isKindOfClass:[NSArray class]];
                        }] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                        [testPresentAlertOperation start];

                        OCMVerifyAll(strictMockFileManager);
                        OCMVerifyAll(strictMockSystemCapabilityManager);
                        OCMVerifyAll(strictMockCurrentWindowCapability);
                    });

                    it(@"should re-upload an audio file if `overwrite` has been set to true", ^{
                        testAudioFile.overwrite = YES;
                        OCMStub([strictMockFileManager fileNeedsUpload:testAudioFile]).andReturn(YES);;
                        OCMExpect([strictMockFileManager uploadFiles:[OCMArg checkWithBlock:^BOOL(id value) {
                            NSArray<SDLPutFile *> *files = (NSArray<SDLPutFile *> *)value;
                            expect(files.count).to(equal(1));
                            expect(files.firstObject.name).to(equal(testAlertAudioFileData.audioData.firstObject.text));
                            return [value isKindOfClass:[NSArray class]];
                        }] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                        [testPresentAlertOperation start];

                        OCMVerifyAll(strictMockFileManager);
                        OCMVerifyAll(strictMockSystemCapabilityManager);
                        OCMVerifyAll(strictMockCurrentWindowCapability);
                    });
                });
            });
        });

        describe(@"image files", ^{
            beforeEach(^{
                OCMStub([strictMockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(2);
                OCMStub([strictMockSystemCapabilityManager speechCapabilities]).andReturn((@[SDLSpeechCapabilitiesFile, SDLSpeechCapabilitiesText]));
            });

            it(@"should upload the alert icons and soft button images if they are supported on the module", ^{
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:strictMockFileManager systemCapabilityManager:strictMockSystemCapabilityManager currentWindowCapability:strictMockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                OCMStub([strictMockCurrentWindowCapability hasImageFieldOfName:SDLImageFieldNameAlertIcon]).andReturn(YES);
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([strictMockCurrentWindowCapability softButtonCapabilities]).andReturn((@[testSoftButtonCapabilities]));
                OCMStub([strictMockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(YES);

                OCMExpect([strictMockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(3));
                    expect(files[0].name).to(equal(testAlertView.icon.name));
                    expect(files[1].name).to(equal(testAlertView.softButtons[0].currentState.artwork.name));
                    expect(files[2].name).to(equal(testAlertView.softButtons[1].currentState.artwork.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                [testPresentAlertOperation start];

                OCMVerifyAll(strictMockFileManager);
                OCMVerifyAll(strictMockSystemCapabilityManager);
                OCMVerifyAll(strictMockCurrentWindowCapability);
            });

            it(@"should only upload a max of 4 soft button images if soft button images supported on the module", ^{
                SDLAlertView *testAlertViewWithExtraSoftButtons = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:@(4) showWaitIndicator:@(YES) audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2, testAlertSoftButton3, testAlertSoftButton4, testAlertSoftButton5, testAlertSoftButton6] icon:testAlertIcon];
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:strictMockFileManager systemCapabilityManager:strictMockSystemCapabilityManager currentWindowCapability:strictMockCurrentWindowCapability alertView:testAlertViewWithExtraSoftButtons cancelID:testCancelID];

                OCMStub([strictMockCurrentWindowCapability hasImageFieldOfName:SDLImageFieldNameAlertIcon]).andReturn(YES);
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([strictMockCurrentWindowCapability softButtonCapabilities]).andReturn((@[testSoftButtonCapabilities]));
                OCMStub([strictMockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(YES);

                OCMExpect([strictMockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files).to(haveCount(5));
                    expect(files[0].name).to(equal(testAlertViewWithExtraSoftButtons.icon.name));
                    expect(files[1].name).to(equal(testAlertViewWithExtraSoftButtons.softButtons[0].currentState.artwork.name));
                    expect(files[2].name).to(equal(testAlertViewWithExtraSoftButtons.softButtons[1].currentState.artwork.name));
                    expect(files[3].name).to(equal(testAlertViewWithExtraSoftButtons.softButtons[2].currentState.artwork.name));
                    expect(files[4].name).to(equal(testAlertViewWithExtraSoftButtons.softButtons[3].currentState.artwork.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                [testPresentAlertOperation start];

                OCMVerifyAll(strictMockFileManager);
                OCMVerifyAll(strictMockSystemCapabilityManager);
                OCMVerifyAll(strictMockCurrentWindowCapability);
            });

            it(@"should upload the soft button images if soft button image support is unknown", ^{
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:strictMockFileManager systemCapabilityManager:strictMockSystemCapabilityManager currentWindowCapability:nil alertView:testAlertView cancelID:testCancelID];

                OCMStub([strictMockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(YES);

                OCMExpect([strictMockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(2));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                [testPresentAlertOperation start];

                OCMVerifyAll(strictMockFileManager);
                OCMVerifyAll(strictMockSystemCapabilityManager);
                OCMVerifyAll(strictMockCurrentWindowCapability);
            });

            it(@"should not upload the soft button images if soft button images are not supported on the module", ^{
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:strictMockFileManager systemCapabilityManager:strictMockSystemCapabilityManager currentWindowCapability:strictMockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                OCMStub([strictMockCurrentWindowCapability hasImageFieldOfName:SDLImageFieldNameAlertIcon]).andReturn(YES);
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @(NO);
                OCMStub([strictMockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                OCMStub([strictMockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(YES);

                OCMExpect([strictMockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(1));
                    expect(files[0].name).to(equal(testAlertView.icon.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                [testPresentAlertOperation start];

                OCMVerifyAll(strictMockFileManager);
                OCMVerifyAll(strictMockSystemCapabilityManager);
                OCMVerifyAll(strictMockCurrentWindowCapability);
            });

            it(@"should upload the alert icon if the alert icon is not supported on the module", ^{
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:strictMockFileManager systemCapabilityManager:strictMockSystemCapabilityManager currentWindowCapability:strictMockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                OCMStub([strictMockCurrentWindowCapability hasImageFieldOfName:SDLImageFieldNameAlertIcon]).andReturn(NO);
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @(YES);
                OCMStub([strictMockCurrentWindowCapability softButtonCapabilities]).andReturn((@[testSoftButtonCapabilities]));
                OCMStub([strictMockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(YES);

                OCMExpect([strictMockFileManager uploadArtworks:[OCMArg checkWithBlock:^BOOL(id value) {
                    NSArray<SDLArtwork *> *files = (NSArray<SDLArtwork *> *)value;
                    expect(files.count).to(equal(2));
                    expect(files[0].name).to(equal(testAlertView.softButtons[0].currentState.artwork.name));
                    expect(files[1].name).to(equal(testAlertView.softButtons[1].currentState.artwork.name));
                    return [value isKindOfClass:[NSArray class]];
                }] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                [testPresentAlertOperation start];

                OCMVerifyAll(strictMockFileManager);
                OCMVerifyAll(strictMockSystemCapabilityManager);
                OCMVerifyAll(strictMockCurrentWindowCapability);
            });

            it(@"should not upload any images if the alert icon and soft button graphics are not supported on the module", ^{
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:strictMockFileManager systemCapabilityManager:strictMockSystemCapabilityManager currentWindowCapability:strictMockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                OCMStub([strictMockCurrentWindowCapability hasImageFieldOfName:SDLImageFieldNameAlertIcon]).andReturn(NO);
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @NO;
                OCMStub([strictMockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                OCMStub([strictMockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(YES);

                OCMReject([strictMockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg any] completionHandler:[OCMArg any]]);

                [testPresentAlertOperation start];

                OCMVerifyAll(strictMockFileManager);
                OCMVerifyAll(strictMockSystemCapabilityManager);
                OCMVerifyAll(strictMockCurrentWindowCapability);
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

                    NSError *testAlertValidError = [testPresentAlertOperation sdl_isValidAlertViewData:testAlertView];
                    expect(testAlertValidError).to(beNil());
                });

                it(@"should be valid if at least the second text field was set", ^{
                    testAlertView = [[SDLAlertView alloc] init];
                    testAlertView.secondaryText = @"test text";
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                    NSError *testAlertValidError = [testPresentAlertOperation sdl_isValidAlertViewData:testAlertView];
                    expect(testAlertValidError).to(beNil());
                });

                it(@"should be valid if at least the audio data was set", ^{
                    testAlertView = [[SDLAlertView alloc] init];
                    testAlertView.audio = [[SDLAlertAudioData alloc] initWithSpeechSynthesizerString:@"test audio"];
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                    NSError *testAlertValidError = [testPresentAlertOperation sdl_isValidAlertViewData:testAlertView];
                    expect(testAlertValidError).to(beNil());
                });

                it(@"should be invalid if the first two text fields or the audio data was not set", ^{
                    testAlertView = [[SDLAlertView alloc] init];
                    testAlertView.tertiaryText = @"test text";
                    testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                    NSError *testAlertValidError = [testPresentAlertOperation sdl_isValidAlertViewData:testAlertView];
                    expect(testAlertValidError).to(equal([NSError sdl_alertManager_alertDataInvalid]));
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

                    NSError *testAlertValidError = [testPresentAlertOperation sdl_isValidAlertViewData:testAlertView];
                    expect(testAlertValidError).to(equal([NSError sdl_alertManager_alertAudioFileNotSupported]));
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

                    expect(testPresentAlertOperation.internalError).toEventually(equal([NSError sdl_alertManager_alertDataInvalid]));
                    expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
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

        context(@"with too many soft buttons", ^{
            __block SDLAlertView *testAlertViewWithExtraSoftButtons = nil;

            beforeEach(^{
                OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(3);
                OCMStub([mockCurrentWindowCapability hasImageFieldOfName:SDLImageFieldNameAlertIcon]).andReturn(YES);
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
                OCMStub([mockSystemCapabilityManager speechCapabilities]).andReturn((@[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesFile]));;
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                OCMStub([mockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(NO);
                OCMStub([mockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);
                OCMStub([mockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                SDLVersion *supportedVersion = [SDLVersion versionWithMajor:6 minor:3 patch:0];
                id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                OCMStub([globalMock rpcVersion]).andReturn(supportedVersion);

                testAlertViewWithExtraSoftButtons = [[SDLAlertView alloc] initWithText:@"text" secondaryText:@"secondaryText" tertiaryText:@"tertiaryText" timeout:@(4) showWaitIndicator:@(YES) audioIndication:testAlertAudioData buttons:@[testAlertSoftButton1, testAlertSoftButton2, testAlertSoftButton3, testAlertSoftButton4, testAlertSoftButton5, testAlertSoftButton6] icon:testAlertIcon];
                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertViewWithExtraSoftButtons cancelID:testCancelID];
                testPresentAlertOperation.alertIconUploaded = YES;

                testPresentAlertOperation.completionBlock = ^{
                    hasCalledOperationCompletionHandler = YES;
                };
            });

            it(@"should send the alert but only allow 4 soft buttons to be sent", ^{
                OCMExpect([mockConnectionManager sendConnectionRequest:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLAlert *alertRequest = (SDLAlert *)value;
                    expect(alertRequest.alertText1).to(equal(testAlertView.text));
                    expect(alertRequest.alertText2).to(equal(testAlertView.secondaryText));
                    expect(alertRequest.alertText3).to(equal(testAlertView.tertiaryText));
                    expect(alertRequest.ttsChunks.count).to(equal(1));
                    expect(alertRequest.ttsChunks[0].text).to(equal(testAlertView.audio.audioData.firstObject.text));
                    expect(alertRequest.duration).to(equal(testAlertView.timeout * 1000));
                    expect(alertRequest.playTone).to(equal(testAlertView.audio.playTone));
                    expect(alertRequest.progressIndicator).to(equal(testAlertView.showWaitIndicator));
                    expect(alertRequest.softButtons.count).to(equal(4));
                    expect(alertRequest.softButtons[0].text).to(equal(testAlertViewWithExtraSoftButtons.softButtons[0].currentState.text));
                    expect(alertRequest.softButtons[1].text).to(equal(testAlertViewWithExtraSoftButtons.softButtons[1].currentState.text));
                    expect(alertRequest.softButtons[2].text).to(equal(testAlertViewWithExtraSoftButtons.softButtons[2].currentState.text));
                    expect(alertRequest.softButtons[3].text).to(equal(testAlertViewWithExtraSoftButtons.softButtons[3].currentState.text));
                    expect(alertRequest.softButtons[0].softButtonID).to(equal(10));
                    expect(alertRequest.softButtons[1].softButtonID).to(equal(11));
                    expect(alertRequest.softButtons[2].softButtonID).to(equal(12));
                    expect(alertRequest.softButtons[3].softButtonID).to(equal(13));

                    expect(alertRequest.cancelID).to(equal(testCancelID));
                    expect(alertRequest.alertIcon.value).to(equal(testAlertView.icon.name));
                    return [value isKindOfClass:[SDLAlert class]];
                }] withResponseHandler:[OCMArg any]]);

                [testPresentAlertOperation start];

                OCMVerifyAllWithDelay(mockConnectionManager, 1.0);
            });
        });

        context(@"with a failed alert icon upload", ^{
            beforeEach(^{
                OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(3);
                OCMStub([mockCurrentWindowCapability hasImageFieldOfName:SDLImageFieldNameAlertIcon]).andReturn(YES);
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
                OCMStub([mockSystemCapabilityManager speechCapabilities]).andReturn((@[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesFile]));;
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                OCMStub([mockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(YES);
                OCMStub([mockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:([OCMArg invokeBlockWithArgs: @[], [NSNull null], nil])]);
                OCMStub([mockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                SDLVersion *supportedVersion = [SDLVersion versionWithMajor:6 minor:3 patch:0];
                id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                OCMStub([globalMock rpcVersion]).andReturn(supportedVersion);

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                testPresentAlertOperation.completionBlock = ^{
                    hasCalledOperationCompletionHandler = YES;
                };
            });

            it(@"should send the alert but not set the SDLImage for icon", ^{
                OCMExpect([mockConnectionManager sendConnectionRequest:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLAlert *alertRequest = (SDLAlert *)value;
                    expect(alertRequest.alertText1).to(equal(testAlertView.text));
                    expect(alertRequest.alertText2).to(equal(testAlertView.secondaryText));
                    expect(alertRequest.alertText3).to(equal(testAlertView.tertiaryText));
                    expect(alertRequest.ttsChunks.count).to(equal(1));
                    expect(alertRequest.ttsChunks[0].text).to(equal(testAlertView.audio.audioData.firstObject.text));
                    expect(alertRequest.duration).to(equal(testAlertView.timeout * 1000));
                    expect(alertRequest.playTone).to(equal(testAlertView.audio.playTone));
                    expect(alertRequest.progressIndicator).to(equal(testAlertView.showWaitIndicator));
                    expect(alertRequest.softButtons.count).to(equal(2));
                    expect(alertRequest.softButtons[0].text).to(equal(testAlertView.softButtons[0].currentState.text));
                    expect(alertRequest.softButtons[1].text).to(equal(testAlertView.softButtons[1].currentState.text));
                    expect(alertRequest.softButtons[0].softButtonID).to(equal(10));
                    expect(alertRequest.softButtons[1].softButtonID).to(equal(11));
                    expect(alertRequest.cancelID).to(equal(testCancelID));
                    expect(alertRequest.alertIcon).to(beNil());
                    return [value isKindOfClass:[SDLAlert class]];
                }] withResponseHandler:[OCMArg any]]);

                [testPresentAlertOperation start];

                OCMVerifyAllWithDelay(mockConnectionManager, 0.5);
            });
        });

        context(@"with valid data", ^{
            __block id strictMockConnectionManager = nil;

            beforeEach(^{
                strictMockConnectionManager = OCMStrictProtocolMock(@protocol(SDLConnectionManagerType));

                OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(3);
                OCMStub([mockCurrentWindowCapability hasImageFieldOfName:SDLImageFieldNameAlertIcon]).andReturn(YES);
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
                OCMStub([mockSystemCapabilityManager speechCapabilities]).andReturn((@[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesFile]));;
                SDLSoftButtonCapabilities *testSoftButtonCapabilities = [[SDLSoftButtonCapabilities alloc] init];
                testSoftButtonCapabilities.imageSupported = @YES;
                OCMStub([mockCurrentWindowCapability softButtonCapabilities]).andReturn(@[testSoftButtonCapabilities]);
                OCMStub([mockFileManager fileNeedsUpload:[OCMArg any]]).andReturn(YES);
                OCMStub([mockFileManager uploadArtworks:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:([OCMArg invokeBlockWithArgs: @[testAlertView.icon.name], [NSNull null], nil])]);
                OCMStub([mockFileManager uploadFiles:[OCMArg any] progressHandler:[OCMArg invokeBlock] completionHandler:[OCMArg invokeBlock]]);

                SDLVersion *supportedVersion = [SDLVersion versionWithMajor:6 minor:3 patch:0];
                id globalMock = OCMPartialMock([SDLGlobals sharedGlobals]);
                OCMStub([globalMock rpcVersion]).andReturn(supportedVersion);

                testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:strictMockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testAlertView cancelID:testCancelID];

                testPresentAlertOperation.completionBlock = ^{
                    hasCalledOperationCompletionHandler = YES;
                };
            });

            it(@"should send the alert if the operation has not been cancelled", ^{
                OCMExpect([strictMockConnectionManager sendConnectionRequest:[OCMArg checkWithBlock:^BOOL(id value) {
                    SDLAlert *alertRequest = (SDLAlert *)value;
                    expect(alertRequest.alertText1).to(equal(testAlertView.text));
                    expect(alertRequest.alertText2).to(equal(testAlertView.secondaryText));
                    expect(alertRequest.alertText3).to(equal(testAlertView.tertiaryText));
                    expect(alertRequest.ttsChunks.count).to(equal(1));
                    expect(alertRequest.ttsChunks[0].text).to(equal(testAlertView.audio.audioData.firstObject.text));
                    expect(alertRequest.duration).to(equal(testAlertView.timeout * 1000));
                    expect(alertRequest.playTone).to(equal(testAlertView.audio.playTone));
                    expect(alertRequest.progressIndicator).to(equal(testAlertView.showWaitIndicator));
                    expect(alertRequest.softButtons.count).to(equal(2));
                    expect(alertRequest.softButtons[0].text).to(equal(testAlertView.softButtons[0].currentState.text));
                    expect(alertRequest.softButtons[1].text).to(equal(testAlertView.softButtons[1].currentState.text));
                    expect(alertRequest.softButtons[0].softButtonID).to(equal(10));
                    expect(alertRequest.softButtons[1].softButtonID).to(equal(11));
                    expect(alertRequest.cancelID).to(equal(testCancelID));
                    expect(alertRequest.alertIcon.value).to(equal(testAlertView.icon.name));
                    return [value isKindOfClass:[SDLAlert class]];
                }] withResponseHandler:[OCMArg any]]);

                [testPresentAlertOperation start];

                OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
            });

            it(@"should not send the alert if the operation has been cancelled", ^{
                [testPresentAlertOperation cancel];
                OCMReject([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLAlert.class] withResponseHandler:[OCMArg any]]);

                [testPresentAlertOperation start];

                expect(testPresentAlertOperation.internalError).to(beNil());
                expect(hasCalledOperationCompletionHandler).to(beTrue());
                expect(testPresentAlertOperation.isFinished).toEventually(beTrue());

                OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
            });

            describe(@"Getting a response from the module", ^{
                __block SDLAlertResponse *response = nil;

                it(@"should call the completion handler and finish the operation after a successful alert response", ^{
                    response = [[SDLAlertResponse alloc] init];
                    response.tryAgainTime = nil;
                    response.success = @YES;
                    response.resultCode = SDLResultSuccess;

                    OCMExpect([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLAlert.class] withResponseHandler:([OCMArg invokeBlockWithArgs:[OCMArg any], response, [NSNull null], nil])]);

                    [testPresentAlertOperation start];

                    expect(testPresentAlertOperation.internalError).toEventually(beNil());
                    expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                    expect(testPresentAlertOperation.isFinished).toEventually(beTrue());

                    OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
                });

                it(@"should save the error, call the completion handler and finish the operation after an unsuccessful alert response", ^{
                    response = [[SDLAlertResponse alloc] init];
                    response.tryAgainTime = @5;
                    response.success = @NO;
                    response.resultCode = SDLResultAborted;
                    NSError *defaultError = [NSError errorWithDomain:@"com.sdl.testConnectionManager" code:-1 userInfo:nil];
                    
                    OCMExpect([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLAlert.class] withResponseHandler:([OCMArg invokeBlockWithArgs:[OCMArg any], response, defaultError, nil])]);

                    [testPresentAlertOperation start];

                    expect(testPresentAlertOperation.internalError.userInfo[@"tryAgainTime"]).toEventually(equal(response.tryAgainTime));
                    expect(testPresentAlertOperation.internalError.userInfo[@"error"]).toEventually(equal(defaultError));
                    expect(hasCalledOperationCompletionHandler).toEventually(beTrue());
                    expect(testPresentAlertOperation.isFinished).toEventually(beTrue());

                    OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
                });
            });
        });
    });

    describe(@"canceling the alert", ^{
        __block SDLAlertView *testCancelAlertView = nil;
        __block SDLVersion *cancelInteractionSupportedSpecVersion = [SDLVersion versionWithMajor:6 minor:0 patch:0];
        __block SDLVersion *cancelInteractionNotSupportedSpecVersion = [SDLVersion versionWithMajor:5 minor:10 patch:0];
        __block id strictMockConnectionManager = nil;

        beforeEach(^{
            testCancelAlertView = [[SDLAlertView alloc] init];
            testCancelAlertView.text = @"Alert view to be canceled";

            OCMStub([mockCurrentWindowCapability maxNumberOfAlertFieldLines]).andReturn(3);

            strictMockConnectionManager = OCMStrictProtocolMock(@protocol(SDLConnectionManagerType));
            testPresentAlertOperation = [[SDLPresentAlertOperation alloc] initWithConnectionManager:strictMockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager currentWindowCapability:mockCurrentWindowCapability alertView:testCancelAlertView cancelID:testCancelID];
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
                    OCMExpect([strictMockConnectionManager sendConnectionRequest:[OCMArg checkWithBlock:^BOOL(id value) {
                        return [value isKindOfClass:[SDLAlert class]];
                    }] withResponseHandler:[OCMArg any]]);
                    [testPresentAlertOperation start];

                    OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
                    expect(testPresentAlertOperation.isExecuting).to(beTrue());
                    expect(testPresentAlertOperation.isFinished).to(beFalse());
                    expect(testPresentAlertOperation.isCancelled).to(beFalse());

                    OCMExpect([strictMockConnectionManager sendConnectionRequest:[OCMArg checkWithBlock:^BOOL(id value) {
                        SDLCancelInteraction *cancelRequest = (SDLCancelInteraction *)value;
                        expect(cancelRequest).to(beAnInstanceOf([SDLCancelInteraction class]));
                        expect(cancelRequest.cancelID).to(equal(testCancelID));
                        expect(cancelRequest.functionID).to(equal([SDLFunctionID.sharedInstance functionIdForName:SDLRPCFunctionNameAlert]));
                        return [value isKindOfClass:[SDLCancelInteraction class]];
                    }] withResponseHandler:[OCMArg any]]);

                    [testCancelAlertView cancel];

                    OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
                });

                context(@"If the cancel interaction was successful", ^{
                    it(@"should not save an error", ^{
                        OCMExpect([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLAlert.class] withResponseHandler:[OCMArg any]]);
                        [testPresentAlertOperation start];

                        OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
                        
                        SDLCancelInteractionResponse *testResponse = [[SDLCancelInteractionResponse alloc] init];
                        testResponse.success = @YES;
                        testResponse.resultCode = SDLResultSuccess;
                        OCMExpect([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:([OCMArg invokeBlockWithArgs:[OCMArg any], testResponse, [NSNull null], nil])]);

                        [testCancelAlertView cancel];

                        OCMVerifyAllWithDelay(strictMockConnectionManager, 1.0);
                        expect(testPresentAlertOperation.error).to(beNil());
                    });
                });

                context(@"If the cancel interaction was not successful", ^{
                    it(@"should save an error", ^{
                        OCMExpect([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLAlert.class] withResponseHandler:[OCMArg any]]);
                        [testPresentAlertOperation start];

                        OCMVerifyAllWithDelay(strictMockConnectionManager, 1.0);
                        
                        SDLCancelInteractionResponse *testResponse = [[SDLCancelInteractionResponse alloc] init];
                        testResponse.success = @NO;
                        testResponse.resultCode = SDLResultAborted;
                        NSError *defaultError = [NSError errorWithDomain:@"com.sdl.testConnectionManager" code:-1 userInfo:nil];

                        OCMStub([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:([OCMArg invokeBlockWithArgs:[OCMArg any], testResponse, defaultError, nil])]);

                        [testCancelAlertView cancel];

                        OCMVerifyAllWithDelay(strictMockConnectionManager, 1.0);
                        expect(testPresentAlertOperation.error).to(equal(defaultError));
                    });
                });
            });

            describe(@"If the operation has already finished", ^{
                beforeEach(^{
                    [testPresentAlertOperation finishOperation];
                });

                it(@"should not attempt to send a cancel interaction", ^{
                    OCMReject([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                    [testCancelAlertView cancel];

                    OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
                });
            });

            describe(@"If the started operation has been canceled", ^{
                it(@"should not attempt to send a cancel interaction", ^{
                    OCMExpect([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLAlert.class] withResponseHandler:[OCMArg any]]);
                    [testPresentAlertOperation start];

                    OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);

                    [testPresentAlertOperation cancel];

                    OCMReject([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                    [testCancelAlertView cancel];

                    OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
                });
            });

            context(@"If the operation has not started", ^{
                it(@"should not attempt to send a cancel interaction", ^{
                    OCMReject([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                    [testCancelAlertView cancel];

                    OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
                });

                context(@"Once the operation has started after being canceled", ^{
                    it(@"should not attempt to send a cancel interaction", ^{
                        OCMExpect([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLAlert.class] withResponseHandler:[OCMArg any]]);
                        [testPresentAlertOperation start];

                        OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
                        
                        [testPresentAlertOperation cancel];

                        OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);
                        [testCancelAlertView cancel];

                        OCMReject([mockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);
                        [testPresentAlertOperation start];
                        [testCancelAlertView cancel];

                        OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
                    });
                });
            });
        });

        context(@"Module does not support the CancelInteration RPC", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = cancelInteractionNotSupportedSpecVersion;
            });

            it(@"should not attempt to send a cancel interaction if the operation is executing", ^{
                OCMExpect([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLAlert.class] withResponseHandler:[OCMArg any]]);
                [testPresentAlertOperation start];

                OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);

                OCMReject([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                [testCancelAlertView cancel];

                OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
            });

            it(@"should cancel the operation if it has not yet been run", ^{
                OCMReject([strictMockConnectionManager sendConnectionRequest:[OCMArg isKindOfClass:SDLCancelInteraction.class] withResponseHandler:[OCMArg any]]);

                [testCancelAlertView cancel];

                expect(testPresentAlertOperation.isCancelled).to(beTrue());

                OCMVerifyAllWithDelay(strictMockConnectionManager, 0.5);
            });
        });
    });
});

QuickSpecEnd
