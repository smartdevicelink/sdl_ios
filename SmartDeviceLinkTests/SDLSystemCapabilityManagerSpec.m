#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceCapability.h"
#import "SDLAppServiceManifest.h"
#import "SDLAppServiceRecord.h"
#import "SDLAppServicesCapabilities.h"
#import "SDLAudioPassThruCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"
#import "SDLDisplayCapability.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLGlobals.h"
#import "SDLHMICapabilities.h"
#import "SDLImageField.h"
#import "SDLImageResolution.h"
#import "SDLMediaServiceManifest.h"
#import "SDLNavigationCapability.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnSystemCapabilityUpdated.h"
#import "SDLPhoneCapability.h"
#import "SDLPredefinedWindows.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRemoteControlCapabilities.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityObserver.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLTextField.h"
#import "SDLVersion.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLWindowCapability.h"
#import "SDLWindowTypeCapabilities.h"
#import "TestConnectionManager.h"
#import "TestSystemCapabilityObserver.h"

typedef NSString * SDLServiceID;

@interface SDLSystemCapabilityManager ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

@property (nullable, strong, nonatomic, readwrite) NSArray<SDLDisplayCapability *> *displays;
@property (nullable, strong, nonatomic, readwrite) SDLDisplayCapabilities *displayCapabilities;
@property (nullable, strong, nonatomic, readwrite) SDLHMICapabilities *hmiCapabilities;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLButtonCapabilities *> *buttonCapabilities;
@property (nullable, strong, nonatomic, readwrite) SDLPresetBankCapabilities *presetBankCapabilities;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLHMIZoneCapabilities> *hmiZoneCapabilities;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLSpeechCapabilities> *speechCapabilities;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLPrerecordedSpeech> *prerecordedSpeechCapabilities;
@property (nonatomic, assign, readwrite) BOOL vrCapability;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLAudioPassThruCapabilities *> *audioPassThruCapabilities;
@property (nullable, strong, nonatomic, readwrite) SDLAudioPassThruCapabilities *pcmStreamCapability;
@property (nullable, strong, nonatomic, readwrite) SDLNavigationCapability *navigationCapability;
@property (nullable, strong, nonatomic, readwrite) SDLPhoneCapability *phoneCapability;
@property (nullable, strong, nonatomic, readwrite) SDLVideoStreamingCapability *videoStreamingCapability;
@property (nullable, strong, nonatomic, readwrite) SDLRemoteControlCapabilities *remoteControlCapability;
@property (nullable, strong, nonatomic, readwrite) SDLSeatLocationCapability *seatLocationCapability;
@property (nullable, strong, nonatomic, readwrite) SDLDriverDistractionCapability *driverDistractionCapability;

@property (nullable, strong, nonatomic) NSMutableDictionary<SDLServiceID, SDLAppServiceCapability *> *appServicesCapabilitiesDictionary;

@property (assign, nonatomic, readwrite) BOOL supportsSubscriptions;
@property (strong, nonatomic) NSMutableDictionary<SDLSystemCapabilityType, NSMutableArray<SDLSystemCapabilityObserver *> *> *capabilityObservers;
@property (strong, nonatomic) NSMutableDictionary<SDLSystemCapabilityType, NSNumber<SDLBool> *> *subscriptionStatus;

@property (nullable, strong, nonatomic) SDLSystemCapability *lastReceivedCapability;

@property (assign, nonatomic) BOOL shouldConvertDeprecatedDisplayCapabilities;
@property (strong, nonatomic) SDLHMILevel currentHMILevel;

@end


QuickSpecBegin(SDLSystemCapabilityManagerSpec)

describe(@"System capability manager", ^{
    __block SDLSystemCapabilityManager *testSystemCapabilityManager = nil;
    __block TestConnectionManager *testConnectionManager = nil;

    __block NSArray<SDLDisplayCapability *> *testDisplayCapabilityList = nil;
    __block SDLDisplayCapabilities *testDisplayCapabilities = nil;
    __block NSArray<SDLSoftButtonCapabilities *> *testSoftButtonCapabilities = nil;
    __block NSArray<SDLButtonCapabilities *> *testButtonCapabilities = nil;
    __block SDLPresetBankCapabilities *testPresetBankCapabilities = nil;
    
    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testSystemCapabilityManager = [[SDLSystemCapabilityManager alloc] initWithConnectionManager:testConnectionManager];
        
        testDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
        testDisplayCapabilities.graphicSupported = @NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        testDisplayCapabilities.displayType = SDLDisplayTypeGeneric;
        testDisplayCapabilities.displayName = SDLDisplayTypeGeneric;
#pragma clang diagnostic pop
        SDLTextField *textField = [[SDLTextField alloc] init];
        textField.name = SDLTextFieldNameMainField1;
        textField.characterSet = SDLCharacterSetUtf8;
        textField.width = @(123);
        textField.rows = @(1);
        testDisplayCapabilities.textFields = @[textField];
        SDLImageField *imageField = [[SDLImageField alloc] init];
        imageField.name = SDLImageFieldNameAppIcon;
        imageField.imageTypeSupported = @[SDLFileTypePNG];
        imageField.imageResolution = [[SDLImageResolution alloc] initWithWidth:42 height:4711];
        testDisplayCapabilities.imageFields = @[imageField];
        testDisplayCapabilities.mediaClockFormats = @[];
        testDisplayCapabilities.templatesAvailable = @[@"DEFAULT", @"MEDIA"];
        testDisplayCapabilities.numCustomPresetsAvailable = @(8);

        SDLSoftButtonCapabilities *softButtonCapability = [[SDLSoftButtonCapabilities alloc] init];
        softButtonCapability.shortPressAvailable = @YES;
        softButtonCapability.longPressAvailable = @NO;
        softButtonCapability.upDownAvailable = @NO;
        softButtonCapability.imageSupported = @YES;
        testSoftButtonCapabilities = @[softButtonCapability];
        
        SDLButtonCapabilities *buttonCapabilities = [[SDLButtonCapabilities alloc] init];
        buttonCapabilities.name = SDLButtonNameOk;
        buttonCapabilities.shortPressAvailable = @YES;
        buttonCapabilities.longPressAvailable = @YES;
        buttonCapabilities.upDownAvailable = @YES;
        testButtonCapabilities = @[buttonCapabilities];
        
        testPresetBankCapabilities = [[SDLPresetBankCapabilities alloc] init];
        testPresetBankCapabilities.onScreenPresetsAvailable = @NO;

        SDLWindowTypeCapabilities *windowTypeCapabilities = [[SDLWindowTypeCapabilities alloc] initWithType:SDLWindowTypeMain maximumNumberOfWindows:1];
        SDLDisplayCapability *displayCapability = [[SDLDisplayCapability alloc] initWithDisplayName:testDisplayCapabilities.displayName];
        displayCapability.windowTypeSupported = @[windowTypeCapabilities];
        SDLWindowCapability *defaultWindowCapability = [[SDLWindowCapability alloc] init];
        defaultWindowCapability.windowID = @(SDLPredefinedWindowsDefaultWindow);
        defaultWindowCapability.buttonCapabilities = testButtonCapabilities.copy;
        defaultWindowCapability.softButtonCapabilities = testSoftButtonCapabilities.copy;
        defaultWindowCapability.templatesAvailable = testDisplayCapabilities.templatesAvailable.copy;
        defaultWindowCapability.numCustomPresetsAvailable = testDisplayCapabilities.numCustomPresetsAvailable.copy;
        defaultWindowCapability.textFields = testDisplayCapabilities.textFields.copy;
        defaultWindowCapability.imageFields = testDisplayCapabilities.imageFields.copy;
        defaultWindowCapability.imageTypeSupported = @[SDLImageTypeStatic];
        displayCapability.windowCapabilities = @[defaultWindowCapability];
        testDisplayCapabilityList = @[displayCapability];
    });

    afterEach(^{
        if (testSystemCapabilityManager) {
            // just in case unsubscribe from notifications and dealloc the manager
            [[NSNotificationCenter defaultCenter] removeObserver:testSystemCapabilityManager];
            testSystemCapabilityManager = nil;
        }
    });

    it(@"should initialize the system capability manager properties correctly", ^{
        expect(testSystemCapabilityManager.displays).to(beNil());
        expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
        expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
        expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
        expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
#pragma clang diagnostic pop
        expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
        expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
        expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
        expect(testSystemCapabilityManager.vrCapability).to(beFalse());
        expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
        expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
        expect(testSystemCapabilityManager.phoneCapability).to(beNil());
        expect(testSystemCapabilityManager.navigationCapability).to(beNil());
        expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
        expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
        expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
        expect(testSystemCapabilityManager.seatLocationCapability).to(beNil());
        expect(testSystemCapabilityManager.driverDistractionCapability).to(beNil());
        expect(testSystemCapabilityManager.currentHMILevel).to(equal(SDLHMILevelNone));
    });

    describe(@"isCapabilitySupported method should work correctly", ^{
        __block SDLHMICapabilities *hmiCapabilities = nil;

        beforeEach(^{
            hmiCapabilities = [[SDLHMICapabilities alloc] init];
        });

        context(@"when there's a cached phone capability and hmiCapabilities is nil", ^{
            beforeEach(^{
                testSystemCapabilityManager.phoneCapability = [[SDLPhoneCapability alloc] initWithDialNumber:YES];
            });

            it(@"should return true", ^{
                expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypePhoneCall]).to(beTrue());
            });
        });

        context(@"when there's no cached capability", ^{
            describe(@"pulling a phone capability when HMICapabilites.phoneCapability is false", ^{
                beforeEach(^{
                    hmiCapabilities.phoneCall = @NO;
                    testSystemCapabilityManager.hmiCapabilities = hmiCapabilities;
                });

                it(@"should return NO", ^{
                    expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypePhoneCall]).to(beFalse());
                });
            });

            describe(@"pulling a phone capability when HMICapabilites.phoneCapability is true", ^{
                beforeEach(^{
                    hmiCapabilities.phoneCall = @YES;
                    testSystemCapabilityManager.hmiCapabilities = hmiCapabilities;
                });

                it(@"should return NO", ^{
                    expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypePhoneCall]).to(beTrue());
                });
            });

            describe(@"pulling a phone capability when HMICapabilites.phoneCapability is nil", ^{
                it(@"should return NO", ^{
                    expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypePhoneCall]).to(beFalse());
                });
            });

            describe(@"pulling an app services capability", ^{
                context(@"on RPC connection version 5.1.0 and HMICapabilities.appServices is false", ^{
                    beforeEach(^{
                        [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"5.1.0"];
                        hmiCapabilities.appServices = @NO;
                        testSystemCapabilityManager.hmiCapabilities = hmiCapabilities;
                    });

                    it(@"should return true", ^{
                        expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeAppServices]).to(beTrue());
                    });
                });

                context(@"on RPC connection version 5.2.0 and HMICapabilities.appServices is false", ^{
                    beforeEach(^{
                        [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"5.2.0"];
                        hmiCapabilities.appServices = @NO;
                        testSystemCapabilityManager.hmiCapabilities = hmiCapabilities;
                    });

                    it(@"should return false", ^{
                        expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeAppServices]).to(beFalse());
                    });
                });
            });

            describe(@"pulling a video streaming capability", ^{
                context(@"on RPC connection version 2.0.0 and HMICapabilities is nil", ^{
                    beforeEach(^{
                        [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"2.0.0"];
                    });

                    it(@"should return false", ^{
                        expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeVideoStreaming]).to(beFalse());
                    });
                });

                context(@"on RPC connection version 3.0.0 and HMICapabilities is nil", ^{
                    beforeEach(^{
                        [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"3.0.0"];
                    });

                    context(@"when displayCapabilities.graphicSupported is true", ^{
                        beforeEach(^{
                            testSystemCapabilityManager.displayCapabilities = [[SDLDisplayCapabilities alloc] init];
                            testSystemCapabilityManager.displayCapabilities.graphicSupported = @YES;
                        });

                        it(@"should return true", ^{
                            expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeVideoStreaming]).to(beTrue());
                        });
                    });

                    context(@"when displayCapabilities.graphicSupported is false", ^{
                        beforeEach(^{
                            testSystemCapabilityManager.displayCapabilities.graphicSupported = @NO;
                        });

                        it(@"should return true", ^{
                            expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeVideoStreaming]).to(beFalse());
                        });
                    });
                });

                context(@"on RPC connection version 5.1.0", ^{
                    beforeEach(^{
                        [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"5.1.0"];
                    });

                    context(@"when HMICapabilites.videoStreaming is false", ^{
                        beforeEach(^{
                            hmiCapabilities.videoStreaming = @NO;
                            testSystemCapabilityManager.hmiCapabilities = hmiCapabilities;
                        });

                        it(@"should return false", ^{
                            expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeVideoStreaming]).to(beFalse());
                        });
                    });

                    context(@"when HMICapabilites.videoStreaming is true", ^{
                        beforeEach(^{
                            hmiCapabilities.videoStreaming = @YES;
                            testSystemCapabilityManager.hmiCapabilities = hmiCapabilities;
                        });

                        it(@"should return true", ^{
                            expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeVideoStreaming]).to(beTrue());
                        });
                    });

                    context(@"when HMICapabilites.videoStreaming is nil", ^{
                        it(@"should return false", ^{
                            expect([testSystemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeVideoStreaming]).to(beFalse());
                        });
                    });
                });
            });
        });
    });

    context(@"When notified of a register app interface response", ^{
        __block SDLRegisterAppInterfaceResponse *testRegisterAppInterfaceResponse = nil;
        __block SDLHMICapabilities *testHMICapabilities = nil;
        __block NSArray<SDLHMIZoneCapabilities> *testHMIZoneCapabilities = nil;
        __block NSArray<SDLSpeechCapabilities> *testSpeechCapabilities = nil;
        __block NSArray<SDLPrerecordedSpeech> *testPrerecordedSpeechCapabilities = nil;
        __block NSArray<SDLVRCapabilities> *testVRCapabilities = nil;
        __block NSArray<SDLAudioPassThruCapabilities *> *testAudioPassThruCapabilities = nil;
        __block SDLAudioPassThruCapabilities *testPCMStreamCapability = nil;

        beforeEach(^{
            testHMICapabilities = [[SDLHMICapabilities alloc] init];
            testHMICapabilities.navigation = @NO;
            testHMICapabilities.phoneCall = @YES;
            testHMICapabilities.videoStreaming = @YES;

            testHMIZoneCapabilities = @[SDLHMIZoneCapabilitiesFront, SDLHMIZoneCapabilitiesBack];
            testSpeechCapabilities = @[SDLSpeechCapabilitiesText, SDLSpeechCapabilitiesSilence];
            testPrerecordedSpeechCapabilities = @[SDLPrerecordedSpeechHelp, SDLPrerecordedSpeechInitial];
            testVRCapabilities = @[SDLVRCapabilitiesText];

            SDLAudioPassThruCapabilities *audioPassThruCapability = [[SDLAudioPassThruCapabilities alloc] init];
            audioPassThruCapability.samplingRate = SDLSamplingRate8KHZ;
            audioPassThruCapability.bitsPerSample = SDLBitsPerSample8Bit;
            audioPassThruCapability.audioType = SDLAudioTypePCM;
            testAudioPassThruCapabilities = @[audioPassThruCapability];
            testPCMStreamCapability = audioPassThruCapability;

            testRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            testRegisterAppInterfaceResponse.displayCapabilities = testDisplayCapabilities;
            testRegisterAppInterfaceResponse.hmiCapabilities = testHMICapabilities;
            testRegisterAppInterfaceResponse.softButtonCapabilities = testSoftButtonCapabilities;
            testRegisterAppInterfaceResponse.buttonCapabilities = testButtonCapabilities;
            testRegisterAppInterfaceResponse.presetBankCapabilities = testPresetBankCapabilities;
#pragma clang diagnostic pop
            testRegisterAppInterfaceResponse.hmiZoneCapabilities = testHMIZoneCapabilities;
            testRegisterAppInterfaceResponse.speechCapabilities = testSpeechCapabilities;
            testRegisterAppInterfaceResponse.prerecordedSpeech = testPrerecordedSpeechCapabilities;
            testRegisterAppInterfaceResponse.vrCapabilities = testVRCapabilities;
            testRegisterAppInterfaceResponse.audioPassThruCapabilities = testAudioPassThruCapabilities;
            testRegisterAppInterfaceResponse.pcmStreamCapabilities = testPCMStreamCapability;
        });

        describe(@"If the Register App Interface request fails", ^{
            beforeEach(^{
                testRegisterAppInterfaceResponse.success = @NO;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:testRegisterAppInterfaceResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should not save any of the RAIR capabilities", ^{
                expect(testSystemCapabilityManager.displays).to(beNil());
                expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
                expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
#pragma clang diagnostic pop
                expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
                expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
                expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
                expect(testSystemCapabilityManager.vrCapability).to(beFalse());
                expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
                expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());

                expect(testSystemCapabilityManager.phoneCapability).to(beNil());
                expect(testSystemCapabilityManager.navigationCapability).to(beNil());
                expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
                expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
                expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
            });
        });

        describe(@"If the Register App Interface request succeeds", ^{
            beforeEach(^{
                testRegisterAppInterfaceResponse.success = @YES;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:testRegisterAppInterfaceResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should should save the RAIR capabilities", ^{
                expect(testSystemCapabilityManager.displays).to(equal(testDisplayCapabilityList));
                expect(testSystemCapabilityManager.hmiCapabilities).to(equal(testHMICapabilities));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                expect(testSystemCapabilityManager.displayCapabilities).to(equal(testDisplayCapabilities));
                expect(testSystemCapabilityManager.softButtonCapabilities).to(equal(testSoftButtonCapabilities));
                expect(testSystemCapabilityManager.buttonCapabilities).to(equal(testButtonCapabilities));
                expect(testSystemCapabilityManager.presetBankCapabilities).to(equal(testPresetBankCapabilities));
#pragma clang diagnostic pop
                expect(testSystemCapabilityManager.hmiZoneCapabilities).to(equal(testHMIZoneCapabilities));
                expect(testSystemCapabilityManager.speechCapabilities).to(equal(testSpeechCapabilities));
                expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(equal(testPrerecordedSpeechCapabilities));
                expect(testSystemCapabilityManager.vrCapability).to(beTrue());
                expect(testSystemCapabilityManager.audioPassThruCapabilities).to(equal(testAudioPassThruCapabilities));
                expect(testSystemCapabilityManager.pcmStreamCapability).to(equal(testPCMStreamCapability));

                expect(testSystemCapabilityManager.phoneCapability).to(beNil());
                expect(testSystemCapabilityManager.navigationCapability).to(beNil());
                expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
                expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
                expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
            });
        });
    });

    context(@"When notified of a SetDisplayLayout Response", ^ {
        __block SDLSetDisplayLayoutResponse *testSetDisplayLayoutResponse = nil;

        beforeEach(^{
            testSetDisplayLayoutResponse = [[SDLSetDisplayLayoutResponse alloc] init];
            testSetDisplayLayoutResponse.displayCapabilities = testDisplayCapabilities;
            testSetDisplayLayoutResponse.buttonCapabilities = testButtonCapabilities;
            testSetDisplayLayoutResponse.softButtonCapabilities = testSoftButtonCapabilities;
            testSetDisplayLayoutResponse.presetBankCapabilities = testPresetBankCapabilities;
        });

        describe(@"If the SetDisplayLayout request fails", ^{
            beforeEach(^{
                testSetDisplayLayoutResponse.success = @NO;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveSetDisplayLayoutResponse object:self rpcResponse:testSetDisplayLayoutResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should not save any capabilities", ^{
                expect(testSystemCapabilityManager.displays).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
                expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
#pragma clang diagnostic pop

                expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
                expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
                expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
                expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
                expect(testSystemCapabilityManager.vrCapability).to(beFalse());
                expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
                expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
                expect(testSystemCapabilityManager.phoneCapability).to(beNil());
                expect(testSystemCapabilityManager.navigationCapability).to(beNil());
                expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
                expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
                expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
            });
        });

        describe(@"If the SetDisplayLayout request succeeds", ^{
            beforeEach(^{
                testSetDisplayLayoutResponse.success = @YES;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveSetDisplayLayoutResponse object:self rpcResponse:testSetDisplayLayoutResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should should save the capabilities", ^{
                expect(testSystemCapabilityManager.displays).to(equal(testDisplayCapabilityList));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                expect(testSystemCapabilityManager.displayCapabilities).to(equal(testDisplayCapabilities));
                expect(testSystemCapabilityManager.softButtonCapabilities).to(equal(testSoftButtonCapabilities));
                expect(testSystemCapabilityManager.buttonCapabilities).to(equal(testButtonCapabilities));
                expect(testSystemCapabilityManager.presetBankCapabilities).to(equal(testPresetBankCapabilities));
#pragma clang diagnostic pop

                expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
                expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
                expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
                expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
                expect(testSystemCapabilityManager.vrCapability).to(beFalse());
                expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
                expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
                expect(testSystemCapabilityManager.phoneCapability).to(beNil());
                expect(testSystemCapabilityManager.navigationCapability).to(beNil());
                expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
                expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
                expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
            });
        });

        describe(@"if the setdisplaylayout has nil displaycapabilities", ^{
            beforeEach(^{
                testSetDisplayLayoutResponse.success = @YES;
                testSetDisplayLayoutResponse.displayCapabilities = nil;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveSetDisplayLayoutResponse object:self rpcResponse:testSetDisplayLayoutResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should should save the capabilities", ^{
                // All the text fields and image fields should be available
                expect(testSystemCapabilityManager.defaultMainWindowCapability.textFields).to(haveCount(29));
                expect(testSystemCapabilityManager.defaultMainWindowCapability.imageFields).to(haveCount(14));
            });
        });
    });
    
    context(@"when updating display capabilities with OnSystemCapabilityUpdated", ^{
        it(@"should properly update display capability including conversion two times", ^{
            // two times because capabilities are just saved in first run but merged/updated in subsequent runs
            for (int i = 0; i < 2; i++) {
                testDisplayCapabilities.displayName = [NSString stringWithFormat:@"Display %i", i];
                testDisplayCapabilities.graphicSupported = i == 0 ? @(NO) : @(YES);
                testDisplayCapabilities.templatesAvailable = @[[NSString stringWithFormat:@"Template %i", i]];
                
                SDLWindowTypeCapabilities *windowTypeCapabilities = [[SDLWindowTypeCapabilities alloc] initWithType:SDLWindowTypeMain maximumNumberOfWindows:1];
                SDLDisplayCapability *displayCapability = [[SDLDisplayCapability alloc] initWithDisplayName:testDisplayCapabilities.displayName];
                displayCapability.windowTypeSupported = @[windowTypeCapabilities];
                SDLWindowCapability *defaultWindowCapability = [[SDLWindowCapability alloc] init];
                defaultWindowCapability.windowID = @(SDLPredefinedWindowsDefaultWindow);
                defaultWindowCapability.buttonCapabilities = testButtonCapabilities.copy;
                defaultWindowCapability.softButtonCapabilities = testSoftButtonCapabilities.copy;
                defaultWindowCapability.templatesAvailable = testDisplayCapabilities.templatesAvailable.copy;
                defaultWindowCapability.numCustomPresetsAvailable = testDisplayCapabilities.numCustomPresetsAvailable.copy;
                defaultWindowCapability.textFields = testDisplayCapabilities.textFields.copy;
                defaultWindowCapability.imageFields = testDisplayCapabilities.imageFields.copy;
                defaultWindowCapability.imageTypeSupported = testDisplayCapabilities.graphicSupported.boolValue ? @[SDLImageTypeStatic, SDLImageTypeDynamic] : @[SDLImageTypeStatic];
                displayCapability.windowCapabilities = @[defaultWindowCapability];
                NSArray<SDLDisplayCapability *> *newDisplayCapabilityList = testDisplayCapabilityList = @[displayCapability];
                
                SDLSystemCapability *newCapability = [[SDLSystemCapability alloc] initWithDisplayCapabilities:newDisplayCapabilityList];
                SDLOnSystemCapabilityUpdated *testUpdateNotification = [[SDLOnSystemCapabilityUpdated alloc] initWithSystemCapability:newCapability];
                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemCapabilityUpdatedNotification object:nil rpcNotification:testUpdateNotification];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                expect(testSystemCapabilityManager.displays).to(equal(testDisplayCapabilityList));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                expect(testSystemCapabilityManager.displayCapabilities).to(equal(testDisplayCapabilities));
                expect(testSystemCapabilityManager.buttonCapabilities).to(equal(testButtonCapabilities));
                expect(testSystemCapabilityManager.softButtonCapabilities).to(equal(testSoftButtonCapabilities));
                expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
#pragma clang diagnostic pop
            }
        });
    });

    context(@"When sending a updateCapabilityType request in HMI FULL", ^{
        __block SDLGetSystemCapabilityResponse *testGetSystemCapabilityResponse = nil;
        __block SDLPhoneCapability *testPhoneCapability = nil;

        beforeEach(^{
            testPhoneCapability = [[SDLPhoneCapability alloc] initWithDialNumber:YES];

            testGetSystemCapabilityResponse = [[SDLGetSystemCapabilityResponse alloc] init];
            testGetSystemCapabilityResponse.systemCapability = [[SDLSystemCapability alloc] init];
            testGetSystemCapabilityResponse.systemCapability.phoneCapability = testPhoneCapability;
            testGetSystemCapabilityResponse.systemCapability.systemCapabilityType = SDLSystemCapabilityTypePhoneCall;

            testSystemCapabilityManager.currentHMILevel = SDLHMILevelFull;
        });

        context(@"If the request failed with an error", ^{
            __block NSError *testError = nil;

            beforeEach(^{
                testGetSystemCapabilityResponse.success = @NO;
                testError = [NSError errorWithDomain:NSCocoaErrorDomain code:-234 userInfo:nil];
            });

            it(@"should should not save the capabilities", ^{
                [testSystemCapabilityManager updateCapabilityType:SDLSystemCapabilityTypePhoneCall completionHandler:^(NSError * _Nullable error, SDLSystemCapabilityManager * _Nonnull systemCapabilityManager) {
                    expect(error).toEventually(equal(testConnectionManager.defaultError));
                    expect(systemCapabilityManager.phoneCapability).toEventually(beNil());
                }];

                [NSThread sleepForTimeInterval:0.1];

                [testConnectionManager respondToLastRequestWithResponse:testGetSystemCapabilityResponse];
            });
        });

        context(@"If the request succeeded", ^{
            beforeEach(^{
                testGetSystemCapabilityResponse.success = @YES;
            });

            it(@"should save the capabilitity", ^{
                [testSystemCapabilityManager updateCapabilityType:SDLSystemCapabilityTypePhoneCall completionHandler:^(NSError * _Nullable error, SDLSystemCapabilityManager * _Nonnull systemCapabilityManager) {
                    expect(testSystemCapabilityManager.phoneCapability).toEventually(equal(testPhoneCapability));
                    expect(error).toEventually(beNil());
                }];

                [NSThread sleepForTimeInterval:0.1];

                [testConnectionManager respondToLastRequestWithResponse:testGetSystemCapabilityResponse];
            });
        });

        afterEach(^{
            // Make sure the RAIR properties and other system capabilities were not inadverdently set
            expect(testSystemCapabilityManager.displays).to(beNil());
            expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
            expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
            expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
            expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
#pragma clang diagnostic pop
            expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
            expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.vrCapability).to(beFalse());
            expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
            expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
            expect(testSystemCapabilityManager.navigationCapability).to(beNil());
            expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
            expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
            expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
        });
    });

    describe(@"updating the SCM through OnSystemCapability in HMI Full", ^{
        __block SDLPhoneCapability *phoneCapability = nil;

        beforeEach(^{
            testSystemCapabilityManager.currentHMILevel = SDLHMILevelFull;

            phoneCapability = [[SDLPhoneCapability alloc] initWithDialNumber:YES];
            SDLSystemCapability *newCapability = [[SDLSystemCapability alloc] initWithPhoneCapability:phoneCapability];
            SDLOnSystemCapabilityUpdated *update = [[SDLOnSystemCapabilityUpdated alloc] initWithSystemCapability:newCapability];
            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemCapabilityUpdatedNotification object:nil rpcNotification:update];

            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });

        it(@"should properly update phone capability", ^{
            expect(testSystemCapabilityManager.phoneCapability).toEventually(equal(phoneCapability));
        });
    });

    describe(@"subscribing to capability types when HMI is full", ^{
        __block TestSystemCapabilityObserver *phoneObserver = nil;
        __block TestSystemCapabilityObserver *navigationObserver = nil;
        __block TestSystemCapabilityObserver *videoStreamingObserver = nil;
        __block TestSystemCapabilityObserver *displaysObserver = nil;

        __block NSUInteger observerTriggeredCount = 0;
        __block NSUInteger handlerTriggeredCount = 0;

        beforeEach(^{
            testSystemCapabilityManager.currentHMILevel = SDLHMILevelFull;

            observerTriggeredCount = 0;
            handlerTriggeredCount = 0;
            [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"5.1.0"]; // supports subscriptions

            phoneObserver = [[TestSystemCapabilityObserver alloc] init];
            [testSystemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypePhoneCall withObserver:phoneObserver selector:@selector(capabilityUpdatedWithCapability:)];
            navigationObserver = [[TestSystemCapabilityObserver alloc] init];
            [testSystemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeNavigation withObserver:navigationObserver selector:@selector(capabilityUpdatedWithCapability:error:)];
            videoStreamingObserver = [[TestSystemCapabilityObserver alloc] init];
            [testSystemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeVideoStreaming withObserver:videoStreamingObserver selector:@selector(capabilityUpdatedWithCapability:error:subscribed:)];
            displaysObserver = [[TestSystemCapabilityObserver alloc] init];
            [testSystemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:displaysObserver selector:@selector(capabilityUpdatedWithCapability:error:subscribed:)];
        });

        context(@"when observers aren't supported", ^{
            __block BOOL observationSuccess = NO;

            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithString:@"5.0.0"]; // no subscriptions

                observationSuccess = [testSystemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypePhoneCall withObserver:phoneObserver selector:@selector(capabilityUpdatedWithCapability:)];
            });

            it(@"should fail to subscribe", ^{
                expect(observationSuccess).to(beTrue());
            });
        });

        context(@"from a GetSystemCapabilitiesResponse", ^{
            __block id blockObserver = nil;
            __block id handlerObserver = nil;

            beforeEach(^{
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wdeprecated-declarations"
                blockObserver = [testSystemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypePhoneCall withBlock:^(SDLSystemCapability * _Nonnull systemCapability) {
                    observerTriggeredCount++;
                }];
#pragma clang diagnostic pop

                handlerObserver = [testSystemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypePhoneCall withUpdateHandler:^(SDLSystemCapability * _Nullable capability, BOOL subscribed, NSError * _Nullable error) {
                    handlerTriggeredCount++;
                }];

                SDLGetSystemCapabilityResponse *testResponse = [[SDLGetSystemCapabilityResponse alloc] init];
                testResponse.systemCapability = [[SDLSystemCapability alloc] initWithPhoneCapability:[[SDLPhoneCapability alloc] initWithDialNumber:YES]];
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveGetSystemCapabilitiesResponse object:nil rpcResponse:testResponse];

                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should not notify subscribers of new data because it was sent outside of the SCM", ^{
                expect(handlerTriggeredCount).toEventually(equal(1));
                expect(observerTriggeredCount).toEventually(equal(1));

                expect(phoneObserver.selectorCalledCount).toEventually(equal(0));
                expect(navigationObserver.selectorCalledCount).toEventually(equal(0));

                expect(videoStreamingObserver.selectorCalledCount).toEventually(equal(0));
                expect(videoStreamingObserver.subscribedValuesReceived).toEventually(haveCount(0));
                expect(videoStreamingObserver.subscribedValuesReceived.firstObject).toEventually(beNil());

                expect(displaysObserver.selectorCalledCount).toEventually(equal(1));
                expect(displaysObserver.subscribedValuesReceived).toEventually(haveCount(1));
                expect(displaysObserver.subscribedValuesReceived.firstObject).toEventually(beTrue());
            });

            describe(@"unsubscribing", ^{
                beforeEach(^{
                    [testSystemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypePhoneCall withObserver:phoneObserver];
                    [testSystemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypePhoneCall withObserver:handlerObserver];
                    [testSystemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypePhoneCall withObserver:blockObserver];

                    SDLGetSystemCapabilityResponse *testResponse = [[SDLGetSystemCapabilityResponse alloc] init];
                    testResponse.systemCapability = [[SDLSystemCapability alloc] initWithPhoneCapability:[[SDLPhoneCapability alloc] initWithDialNumber:YES]];
                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveGetSystemCapabilitiesResponse object:nil rpcResponse:testResponse];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                });

                it(@"should not notify the subscriber of the new data", ^{
                    expect(handlerTriggeredCount).toEventually(equal(1));
                    expect(observerTriggeredCount).toEventually(equal(1));

                    expect(phoneObserver.selectorCalledCount).toEventually(equal(0)); // No change from above
                    expect(navigationObserver.selectorCalledCount).toEventually(equal(0));
                    expect(videoStreamingObserver.selectorCalledCount).toEventually(equal(0));

                    expect(displaysObserver.selectorCalledCount).toEventually(equal(1));
                });
            });
        });

        context(@"from an OnSystemCapabilities notification", ^{
            __block id blockObserver = nil;
            __block id handlerObserver = nil;

            beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                blockObserver = [testSystemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypePhoneCall withBlock:^(SDLSystemCapability * _Nonnull systemCapability) {
                    observerTriggeredCount++;
                }];
#pragma clang diagnostic pop

                handlerObserver = [testSystemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypePhoneCall withUpdateHandler:^(SDLSystemCapability * _Nullable capability, BOOL subscribed, NSError * _Nullable error) {
                    handlerTriggeredCount++;
                }];

                SDLOnSystemCapabilityUpdated *testNotification = [[SDLOnSystemCapabilityUpdated alloc] initWithSystemCapability:[[SDLSystemCapability alloc] initWithPhoneCapability:[[SDLPhoneCapability alloc] initWithDialNumber:YES]]];
                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemCapabilityUpdatedNotification object:nil rpcNotification:testNotification];

                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should notify subscribers of the new data", ^{
                expect(handlerTriggeredCount).toEventually(equal(2));
                expect(observerTriggeredCount).toEventually(equal(2));

                expect(phoneObserver.selectorCalledCount).toEventually(equal(1));
                expect(navigationObserver.selectorCalledCount).toEventually(equal(0));

                expect(videoStreamingObserver.selectorCalledCount).toEventually(equal(0));
                expect(videoStreamingObserver.subscribedValuesReceived).toEventually(haveCount(0));
                expect(videoStreamingObserver.subscribedValuesReceived.firstObject).toEventually(beNil());

                expect(displaysObserver.selectorCalledCount).toEventually(equal(1));
                expect(displaysObserver.subscribedValuesReceived).toEventually(haveCount(1));
                expect(displaysObserver.subscribedValuesReceived.firstObject).toEventually(beTrue());
            });

            describe(@"unsubscribing", ^{
                beforeEach(^{
                    [testSystemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypePhoneCall withObserver:phoneObserver];
                    [testSystemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypePhoneCall withObserver:blockObserver];

                    SDLGetSystemCapabilityResponse *testResponse = [[SDLGetSystemCapabilityResponse alloc] init];
                    testResponse.systemCapability = [[SDLSystemCapability alloc] initWithPhoneCapability:[[SDLPhoneCapability alloc] initWithDialNumber:YES]];
                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveGetSystemCapabilitiesResponse object:nil rpcResponse:testResponse];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                });

                it(@"should not notify the subscriber of the new data", ^{
                    expect(phoneObserver.selectorCalledCount).toEventually(equal(1)); // No change from above
                    expect(observerTriggeredCount).toEventually(equal(2));
                    expect(navigationObserver.selectorCalledCount).toEventually(equal(0));
                    expect(videoStreamingObserver.selectorCalledCount).toEventually(equal(0));
                    expect(displaysObserver.selectorCalledCount).toEventually(equal(1));
                });
            });
        });
    });

    describe(@"merging app services capability changes", ^{
        __block SDLAppServicesCapabilities *baseAppServices = nil;
        __block SDLAppServiceCapability *deleteCapability = nil;
        __block SDLAppServiceCapability *updateCapability = nil;
        __block SDLAppServiceCapability *newCapability = nil;

        beforeEach(^{
            SDLAppServiceManifest *deleteCapabilityManifest = [[SDLAppServiceManifest alloc] initWithMediaServiceName:@"Delete me" serviceIcon:nil allowAppConsumers:YES maxRPCSpecVersion:nil handledRPCs:nil mediaServiceManifest:[[SDLMediaServiceManifest alloc] init]];
            SDLAppServiceRecord *deleteCapabilityRecord = [[SDLAppServiceRecord alloc] initWithServiceID:@"1234" serviceManifest:deleteCapabilityManifest servicePublished:YES serviceActive:YES];
            deleteCapability = [[SDLAppServiceCapability alloc] initWithUpdatedAppServiceRecord:deleteCapabilityRecord];

            SDLAppServiceManifest *updateCapabilityManifest = [[SDLAppServiceManifest alloc] initWithMediaServiceName:@"Update me" serviceIcon:nil allowAppConsumers:YES maxRPCSpecVersion:nil handledRPCs:nil mediaServiceManifest:[[SDLMediaServiceManifest alloc] init]];
            SDLAppServiceRecord *updateCapabilityRecord = [[SDLAppServiceRecord alloc] initWithServiceID:@"2345" serviceManifest:updateCapabilityManifest servicePublished:YES serviceActive:NO];
            updateCapability = [[SDLAppServiceCapability alloc] initWithUpdatedAppServiceRecord:updateCapabilityRecord];

            baseAppServices = [[SDLAppServicesCapabilities alloc] initWithAppServices:@[deleteCapability, updateCapability]];
            SDLSystemCapability *appServiceCapability = [[SDLSystemCapability alloc] initWithAppServicesCapabilities:baseAppServices];
            SDLOnSystemCapabilityUpdated *update = [[SDLOnSystemCapabilityUpdated alloc] initWithSystemCapability:appServiceCapability];
            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemCapabilityUpdatedNotification object:nil rpcNotification:update];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });

        it(@"should have the correct base services", ^{
            expect(testSystemCapabilityManager.appServicesCapabilities).to(equal(baseAppServices));
        });

        describe(@"when sending the merge update", ^{
            it(@"should correctly merge", ^{
                deleteCapability.updateReason = SDLServiceUpdateRemoved;
                deleteCapability.updatedAppServiceRecord.servicePublished = @NO;
                deleteCapability.updatedAppServiceRecord.serviceActive = @NO;

                updateCapability.updateReason = SDLServiceUpdateActivated;
                updateCapability.updatedAppServiceRecord.serviceActive = @YES;

                SDLAppServiceManifest *newCapabilityManifest = [[SDLAppServiceManifest alloc] initWithMediaServiceName:@"New me" serviceIcon:nil allowAppConsumers:YES maxRPCSpecVersion:nil handledRPCs:nil mediaServiceManifest:[[SDLMediaServiceManifest alloc] init]];
                SDLAppServiceRecord *newCapabilityRecord = [[SDLAppServiceRecord alloc] initWithServiceID:@"3456" serviceManifest:newCapabilityManifest servicePublished:YES serviceActive:NO];
                newCapability = [[SDLAppServiceCapability alloc] initWithUpdateReason:SDLServiceUpdatePublished updatedAppServiceRecord:newCapabilityRecord];

                SDLAppServicesCapabilities *appServicesUpdate = [[SDLAppServicesCapabilities alloc] initWithAppServices:@[deleteCapability, updateCapability, newCapability]];
                SDLSystemCapability *appServiceCapability = [[SDLSystemCapability alloc] initWithAppServicesCapabilities:appServicesUpdate];
                SDLOnSystemCapabilityUpdated *update = [[SDLOnSystemCapabilityUpdated alloc] initWithSystemCapability:appServiceCapability];
                SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveSystemCapabilityUpdatedNotification object:nil rpcNotification:update];
                [[NSNotificationCenter defaultCenter] postNotification:notification];

                expect(testSystemCapabilityManager.appServicesCapabilities.appServices).toNot(contain(deleteCapability));
                expect(testSystemCapabilityManager.appServicesCapabilities.appServices).to(haveCount(2));

                SDLAppServiceCapability *firstCapability = testSystemCapabilityManager.appServicesCapabilities.appServices.firstObject;
                SDLAppServiceCapability *secondCapability = testSystemCapabilityManager.appServicesCapabilities.appServices.lastObject;

                expect(firstCapability.updateReason).to(equal(SDLServiceUpdatePublished));
                expect(firstCapability.updatedAppServiceRecord.serviceID).to(equal(@"3456"));

                expect(secondCapability.updateReason).to(equal(SDLServiceUpdateActivated));
                expect(secondCapability.updatedAppServiceRecord.serviceID).to(equal(@"2345"));
                expect(secondCapability.updatedAppServiceRecord.serviceActive).to(beTrue());
            });
        });
    });

    describe(@"when the system capability manager is stopped after being started", ^{
        beforeEach(^{
            [testSystemCapabilityManager stop];
        });

        it(@"It should reset the system capability manager properties correctly", ^{
            expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
            expect(testSystemCapabilityManager.displays).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
            expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
            expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
            expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
#pragma clang diagnostic pop
            expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
            expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.vrCapability).to(beFalse());
            expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
            expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
            expect(testSystemCapabilityManager.phoneCapability).to(beNil());
            expect(testSystemCapabilityManager.navigationCapability).to(beNil());
            expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
            expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
            expect(testSystemCapabilityManager.appServicesCapabilities).to(beNil());
            expect(testSystemCapabilityManager.driverDistractionCapability).to(beNil());
            expect(testSystemCapabilityManager.seatLocationCapability).to(beNil());
        });
    });
});

QuickSpecEnd

