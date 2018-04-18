#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioPassThruCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLHMICapabilities.h"
#import "SDLNavigationCapability.h"
#import "SDLNotificationConstants.h"
#import "SDLPhoneCapability.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRemoteControlCapabilities.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLVideoStreamingCapability.h"
#import "TestConnectionManager.h"


QuickSpecBegin(SDLSystemCapabilityManagerSpec)

describe(@"System capability manager", ^{
    __block SDLSystemCapabilityManager *testSystemCapabilityManager = nil;
    __block TestConnectionManager *testConnectionManager = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testSystemCapabilityManager = [[SDLSystemCapabilityManager alloc] initWithConnectionManager:testConnectionManager];
    });

    it(@"should initialize the system capability manager properties correctly", ^{
        expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
        expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
        expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
        expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
        expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
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
    });

    context(@"When notified of a register app interface response", ^{
        __block SDLRegisterAppInterfaceResponse *testRegisterAppInterfaceResponse = nil;
        __block SDLDisplayCapabilities *testDisplayCapabilities = nil;
        __block SDLHMICapabilities *testHMICapabilities = nil;
        __block NSArray<SDLSoftButtonCapabilities *> *testSoftButtonCapabilities = nil;
        __block NSArray<SDLButtonCapabilities *> *testButtonCapabilities = nil;
        __block SDLPresetBankCapabilities *testPresetBankCapabilities = nil;
        __block NSArray<SDLHMIZoneCapabilities> *testHMIZoneCapabilities = nil;
        __block NSArray<SDLSpeechCapabilities> *testSpeechCapabilities = nil;
        __block NSArray<SDLPrerecordedSpeech> *testPrerecordedSpeechCapabilities = nil;
        __block NSArray<SDLVRCapabilities> *testVRCapabilities = nil;
        __block NSArray<SDLAudioPassThruCapabilities *> *testAudioPassThruCapabilities = nil;
        __block SDLAudioPassThruCapabilities *testPCMStreamCapability = nil;

        beforeEach(^{
            testDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
            testDisplayCapabilities.graphicSupported = @NO;

            testHMICapabilities = [[SDLHMICapabilities alloc] init];
            testHMICapabilities.navigation = @NO;
            testHMICapabilities.phoneCall = @YES;
            testHMICapabilities.videoStreaming = @YES;

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
            testRegisterAppInterfaceResponse.displayCapabilities = testDisplayCapabilities;
            testRegisterAppInterfaceResponse.hmiCapabilities = testHMICapabilities;
            testRegisterAppInterfaceResponse.softButtonCapabilities = testSoftButtonCapabilities;
            testRegisterAppInterfaceResponse.buttonCapabilities = testButtonCapabilities;
            testRegisterAppInterfaceResponse.presetBankCapabilities = testPresetBankCapabilities;
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
                expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
                expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
                expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
                expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
                expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
                expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
                expect(testSystemCapabilityManager.vrCapability).to(beFalse());
                expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
                expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
            });
        });

        describe(@"If the Register App Interface request succeeds", ^{
            beforeEach(^{
                testRegisterAppInterfaceResponse.success = @YES;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:testRegisterAppInterfaceResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should should save the RAIR capabilities", ^{
                expect(testSystemCapabilityManager.displayCapabilities).to(equal(testDisplayCapabilities));
                expect(testSystemCapabilityManager.hmiCapabilities).to(equal(testHMICapabilities));
                expect(testSystemCapabilityManager.softButtonCapabilities).to(equal(testSoftButtonCapabilities));
                expect(testSystemCapabilityManager.buttonCapabilities).to(equal(testButtonCapabilities));
                expect(testSystemCapabilityManager.presetBankCapabilities).to(equal(testPresetBankCapabilities));
                expect(testSystemCapabilityManager.hmiZoneCapabilities).to(equal(testHMIZoneCapabilities));
                expect(testSystemCapabilityManager.speechCapabilities).to(equal(testSpeechCapabilities));
                expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(equal(testPrerecordedSpeechCapabilities));
                expect(testSystemCapabilityManager.vrCapability).to(beTrue());
                expect(testSystemCapabilityManager.audioPassThruCapabilities).to(equal(testAudioPassThruCapabilities));
                expect(testSystemCapabilityManager.pcmStreamCapability).to(equal(testPCMStreamCapability));
            });
        });

        afterEach(^{
            // Make sure the system capabilities properties were not inadverdently set
            expect(testSystemCapabilityManager.phoneCapability).to(beNil());
            expect(testSystemCapabilityManager.navigationCapability).to(beNil());
            expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
            expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
        });
    });

    context(@"When notified of a Set Display Layout Response", ^ {
        __block SDLSetDisplayLayoutResponse *testSetDisplayLayoutResponse = nil;
        __block SDLDisplayCapabilities *testDisplayCapabilities = nil;
        __block NSArray<SDLSoftButtonCapabilities *> *testSoftButtonCapabilities = nil;
        __block NSArray<SDLButtonCapabilities *> *testButtonCapabilities = nil;
        __block SDLPresetBankCapabilities *testPresetBankCapabilities = nil;

        beforeEach(^{
            testDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
            testDisplayCapabilities.graphicSupported = @NO;

            SDLSoftButtonCapabilities *softButtonCapability = [[SDLSoftButtonCapabilities alloc] init];
            softButtonCapability.shortPressAvailable = @NO;
            softButtonCapability.longPressAvailable = @NO;
            softButtonCapability.upDownAvailable = @NO;
            softButtonCapability.imageSupported = @NO;
            testSoftButtonCapabilities = @[softButtonCapability];

            SDLButtonCapabilities *buttonCapabilities = [[SDLButtonCapabilities alloc] init];
            buttonCapabilities.name = SDLButtonNameOk;
            buttonCapabilities.shortPressAvailable = @NO;
            buttonCapabilities.longPressAvailable = @NO;
            buttonCapabilities.upDownAvailable = @NO;
            testButtonCapabilities = @[buttonCapabilities];

            testPresetBankCapabilities = [[SDLPresetBankCapabilities alloc] init];
            testPresetBankCapabilities.onScreenPresetsAvailable = @NO;

            testSetDisplayLayoutResponse = [[SDLSetDisplayLayoutResponse alloc] init];
            testSetDisplayLayoutResponse.displayCapabilities = testDisplayCapabilities;
            testSetDisplayLayoutResponse.buttonCapabilities = testButtonCapabilities;
            testSetDisplayLayoutResponse.softButtonCapabilities = testSoftButtonCapabilities;
            testSetDisplayLayoutResponse.presetBankCapabilities = testPresetBankCapabilities;
        });

        describe(@"If the Set Display Layout request fails", ^{
            beforeEach(^{
                testSetDisplayLayoutResponse.success = @NO;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveSetDisplayLayoutResponse object:self rpcResponse:testSetDisplayLayoutResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should not save any capabilities", ^{
                expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
                expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
            });
        });

        describe(@"If the Set Display Layout request succeeds", ^{
            beforeEach(^{
                testSetDisplayLayoutResponse.success = @YES;
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveSetDisplayLayoutResponse object:self rpcResponse:testSetDisplayLayoutResponse];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should should save the capabilities", ^{
                expect(testSystemCapabilityManager.displayCapabilities).to(equal(testDisplayCapabilities));
                expect(testSystemCapabilityManager.softButtonCapabilities).to(equal(testSoftButtonCapabilities));
                expect(testSystemCapabilityManager.buttonCapabilities).to(equal(testButtonCapabilities));
                expect(testSystemCapabilityManager.presetBankCapabilities).to(equal(testPresetBankCapabilities));
            });
        });

        afterEach(^{
            // Make sure the other RAIR properties and system capabilities were not inadverdently set
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
        });
    });

    context(@"When notified of a Get System Capability Response", ^{
        __block SDLGetSystemCapabilityResponse *testGetSystemCapabilityResponse;
        __block SDLPhoneCapability *testPhoneCapability = nil;

        beforeEach(^{
             testPhoneCapability = [[SDLPhoneCapability alloc] initWithDialNumber:YES];

            testGetSystemCapabilityResponse = [[SDLGetSystemCapabilityResponse alloc] init];
            testGetSystemCapabilityResponse.systemCapability = [[SDLSystemCapability alloc] init];
            testGetSystemCapabilityResponse.systemCapability.phoneCapability = testPhoneCapability;
            testGetSystemCapabilityResponse.systemCapability.systemCapabilityType = SDLSystemCapabilityTypePhoneCall;
        });

        describe(@"If a Get System Capability Response notification is received", ^{
            context(@"If the request failed", ^{
                beforeEach(^{
                    testGetSystemCapabilityResponse.success = @NO;
                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveGetSystemCapabilitiesResponse object:self rpcResponse:testGetSystemCapabilityResponse];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                });

                it(@"should should not save the capabilities", ^{
                    expect(testSystemCapabilityManager.phoneCapability).to(beNil());
                });
            });

            context(@"If the request succeeded", ^{
                beforeEach(^{
                    testGetSystemCapabilityResponse.success = @YES;
                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveGetSystemCapabilitiesResponse object:self rpcResponse:testGetSystemCapabilityResponse];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                });

                it(@"should should save the capabilities", ^{
                    expect(testSystemCapabilityManager.phoneCapability).to(equal(testPhoneCapability));
                });
            });
        });

        describe(@"If a response is received for a sent Get System Capability request", ^{
            context(@"If the request failed with an error", ^{
                __block NSError *testError = nil;

                beforeEach(^{
                    testGetSystemCapabilityResponse.success = @NO;
                    testError = [NSError errorWithDomain:NSCocoaErrorDomain code:-234 userInfo:nil];

                    waitUntilTimeout(1.0, ^(void (^done)(void)) {
                        [testSystemCapabilityManager updateCapabilityType:testGetSystemCapabilityResponse.systemCapability.systemCapabilityType completionHandler:^(NSError * _Nullable error, SDLSystemCapabilityManager * _Nonnull systemCapabilityManager) {
                            expect(error).to(equal(testError));
                            expect(systemCapabilityManager.phoneCapability).to(beNil());
                            done();
                        }];

                        [testConnectionManager respondToLastRequestWithResponse:testGetSystemCapabilityResponse error:testError];
                    });
                });

                it(@"should should not save the capabilities", ^{
                    expect(testSystemCapabilityManager.phoneCapability).to(beNil());
                });
            });

            context(@"If the request succeeded", ^{
                beforeEach(^{
                    testGetSystemCapabilityResponse.success = @YES;

                    [testSystemCapabilityManager updateCapabilityType:testGetSystemCapabilityResponse.systemCapability.systemCapabilityType completionHandler:^(NSError * _Nullable error, SDLSystemCapabilityManager * _Nonnull systemCapabilityManager) {
                        // The handler will not be notifified
                    }];

                    [testConnectionManager respondToLastRequestWithResponse:testGetSystemCapabilityResponse error:nil];
                });

                it(@"should not save the capabilities because a successful Get System Capability Response notification will be intercepted by the manager and be handled there", ^{
                    expect(testSystemCapabilityManager.phoneCapability).to(beNil());
                });
            });
        });

        afterEach(^{
            // Make sure the RAIR properties and other system capabilities were not inadverdently set
            expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
            expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
            expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
            expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
            expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
            expect(testSystemCapabilityManager.hmiZoneCapabilities).to(beNil());
            expect(testSystemCapabilityManager.speechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(beNil());
            expect(testSystemCapabilityManager.vrCapability).to(beFalse());
            expect(testSystemCapabilityManager.audioPassThruCapabilities).to(beNil());
            expect(testSystemCapabilityManager.pcmStreamCapability).to(beNil());
            expect(testSystemCapabilityManager.navigationCapability).to(beNil());
            expect(testSystemCapabilityManager.videoStreamingCapability).to(beNil());
            expect(testSystemCapabilityManager.remoteControlCapability).to(beNil());
        });
    });

    context(@"When the system capability manager is stopped after being started", ^{
        beforeEach(^{
            SDLDisplayCapabilities *testDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
            testDisplayCapabilities.graphicSupported = @NO;

            SDLRegisterAppInterfaceResponse *testRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
            testRegisterAppInterfaceResponse.displayCapabilities = testDisplayCapabilities;
            testRegisterAppInterfaceResponse.success = @YES;

            SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:testRegisterAppInterfaceResponse];
            [[NSNotificationCenter defaultCenter] postNotification:notification];

            expect(testSystemCapabilityManager.displayCapabilities).to(equal(testDisplayCapabilities));
        });

        describe(@"When stopped", ^{
            beforeEach(^{
                [testSystemCapabilityManager stop];
            });

            it(@"It should reset the system capability manager properties correctly", ^{
                expect(testSystemCapabilityManager.displayCapabilities).to(beNil());
                expect(testSystemCapabilityManager.hmiCapabilities).to(beNil());
                expect(testSystemCapabilityManager.softButtonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.buttonCapabilities).to(beNil());
                expect(testSystemCapabilityManager.presetBankCapabilities).to(beNil());
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
            });
        });
    });
});

QuickSpecEnd

