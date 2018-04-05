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
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLSystemCapabilityManager *testSystemCapabilityManager = nil;

    __block SDLDisplayCapabilities *testDisplayCapabilities;
    __block SDLHMICapabilities *testHMICapabilities;
    __block NSArray<SDLSoftButtonCapabilities *> *testSoftButtonCapabilities;
    __block NSArray<SDLButtonCapabilities *> *testButtonCapabilities;
    __block SDLPresetBankCapabilities *testPresetBankCapabilities;
    __block NSArray<SDLHMIZoneCapabilities> *testHMIZoneCapabilities;
    __block NSArray<SDLSpeechCapabilities> *testSpeechCapabilities;
    __block NSArray<SDLPrerecordedSpeech> *testPrerecordedSpeechCapabilities;
    __block NSArray<SDLVRCapabilities> *testVRCapabilities;
    __block NSArray<SDLAudioPassThruCapabilities *> *testAudioPassThruCapabilities;
    __block SDLAudioPassThruCapabilities *testPCMStreamCapabilities;
    __block SDLNavigationCapability *testNavigationCapability;
    __block SDLPhoneCapability *testPhoneCapability;
    __block SDLVideoStreamingCapability *testVideoStreamingCapability;
    __block SDLRemoteControlCapabilities *testRemoteControlCapability;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testSystemCapabilityManager = [[SDLSystemCapabilityManager alloc] initWithConnectionManager:testConnectionManager];

        testDisplayCapabilities = nil;
        testHMICapabilities = nil;
        testSoftButtonCapabilities = nil;
        testButtonCapabilities = nil;
        testPresetBankCapabilities = nil;
        testHMIZoneCapabilities = nil;
        testSpeechCapabilities = nil;
        testPrerecordedSpeechCapabilities = nil;
        testVRCapabilities = nil;
        testAudioPassThruCapabilities = nil;
        testPCMStreamCapabilities = nil;
        testNavigationCapability = nil;
        testPhoneCapability = nil;
        testVideoStreamingCapability = nil;
        testRemoteControlCapability = nil;
    });

    context(@"When notified of a register app interface response", ^{
        __block SDLRegisterAppInterfaceResponse *testRegisterAppInterfaceResponse = nil;

        beforeEach(^{
            testRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
        });

        it(@"should not save any capabilities the request fails", ^{
            testRegisterAppInterfaceResponse.success = @NO;
        });

        it(@"should should save the correct capabilities if all capabilities in the RAI response are valid", ^{
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
            testPCMStreamCapabilities = audioPassThruCapability;

            testRegisterAppInterfaceResponse.success = @YES;
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
            testRegisterAppInterfaceResponse.pcmStreamCapabilities = testPCMStreamCapabilities;
        });

        afterEach(^{
            SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:testRegisterAppInterfaceResponse];

            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [NSThread sleepForTimeInterval:0.1];
        });
    });

    context(@"When notified of a set display layout response", ^ {
       __block SDLSetDisplayLayoutResponse *testSetDisplayLayoutResponse = nil;

        beforeEach(^{
            testSetDisplayLayoutResponse = [[SDLSetDisplayLayoutResponse alloc] init];
        });

        it(@"should not save any capabilities if all the capabilities in the set display layout response are nil", ^{
            testSetDisplayLayoutResponse.success = @NO;
        });

        it(@"should should save the correct capabilities if all capabilities in the set display layout response are valid", ^{
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

            testSetDisplayLayoutResponse.success = @YES;
            testSetDisplayLayoutResponse.displayCapabilities = testDisplayCapabilities;
            testSetDisplayLayoutResponse.buttonCapabilities = testButtonCapabilities;
            testSetDisplayLayoutResponse.softButtonCapabilities = testSoftButtonCapabilities;
            testSetDisplayLayoutResponse.presetBankCapabilities = testPresetBankCapabilities;
        });

        afterEach(^{
            SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveSetDisplayLayoutResponse object:self rpcResponse:testSetDisplayLayoutResponse];

            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [NSThread sleepForTimeInterval:0.1];
        });
    });

    context(@"When requesting the SDLSystemCapabilityType", ^{
        __block NSError *testError = nil;
        __block SDLSystemCapabilityType systemCapabilityType;
        __block SDLGetSystemCapabilityResponse *testGetSystemCapabilityResponse;

        beforeEach(^{
            testGetSystemCapabilityResponse = [[SDLGetSystemCapabilityResponse alloc] init];
            testError = nil;
        });

        it(@"should save the phone call capabilities", ^{
            systemCapabilityType = SDLSystemCapabilityTypePhoneCall;
            testPhoneCapability = [[SDLPhoneCapability alloc] initWithDialNumber:YES];

            testGetSystemCapabilityResponse.success = @YES;
            testGetSystemCapabilityResponse.systemCapability = [[SDLSystemCapability alloc] init];
            testGetSystemCapabilityResponse.systemCapability.phoneCapability = testPhoneCapability;
            testGetSystemCapabilityResponse.systemCapability.systemCapabilityType = systemCapabilityType;
        });

        it(@"should save the navigation capabilities", ^{
            systemCapabilityType = SDLSystemCapabilityTypeNavigation;
            testNavigationCapability = [[SDLNavigationCapability alloc] initWithSendLocation:YES waypoints:YES];

            testGetSystemCapabilityResponse.success = @YES;
            testGetSystemCapabilityResponse.systemCapability = [[SDLSystemCapability alloc] init];
            testGetSystemCapabilityResponse.systemCapability.navigationCapability = testNavigationCapability;
            testGetSystemCapabilityResponse.systemCapability.systemCapabilityType = systemCapabilityType;
        });

        it(@"should save the remote control capabilities", ^{
            systemCapabilityType = SDLSystemCapabilityTypeRemoteControl;
            testRemoteControlCapability = [[SDLRemoteControlCapabilities alloc] initWithClimateControlCapabilities:@[] radioControlCapabilities:@[] buttonCapabilities:@[]];

            testGetSystemCapabilityResponse.success = @YES;
            testGetSystemCapabilityResponse.systemCapability = [[SDLSystemCapability alloc] init];
            testGetSystemCapabilityResponse.systemCapability.remoteControlCapability = testRemoteControlCapability;
            testGetSystemCapabilityResponse.systemCapability.systemCapabilityType = systemCapabilityType;
        });

        it(@"should save the video streaming capabilities", ^{
            systemCapabilityType = SDLSystemCapabilityTypeVideoStreaming;
            testVideoStreamingCapability = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:nil maxBitrate:8 supportedFormats:nil hapticDataSupported:YES];

            testGetSystemCapabilityResponse.success = @YES;
            testGetSystemCapabilityResponse.systemCapability = [[SDLSystemCapability alloc] init];
            testGetSystemCapabilityResponse.systemCapability.videoStreamingCapability = testVideoStreamingCapability;
            testGetSystemCapabilityResponse.systemCapability.systemCapabilityType = systemCapabilityType;
        });

        it(@"should return the error if the request is not successful", ^{
            systemCapabilityType = SDLSystemCapabilityTypeVideoStreaming;
            testVideoStreamingCapability = nil;
            testError = [NSError errorWithDomain:NSCocoaErrorDomain code:23 userInfo:nil];

            testGetSystemCapabilityResponse.success = @NO;
            testGetSystemCapabilityResponse.systemCapability = [[SDLSystemCapability alloc] init];
            testGetSystemCapabilityResponse.systemCapability.videoStreamingCapability = nil;
            testGetSystemCapabilityResponse.systemCapability.systemCapabilityType = systemCapabilityType;
        });

        afterEach(^{
            waitUntilTimeout(1, ^(void (^done)(void)){
                [testSystemCapabilityManager updateCapabilityType:systemCapabilityType completionHandler:^(NSError * _Nullable error, SDLSystemCapabilityManager *systemCapabilityManager) {
                    expect(error).to(testError == nil ? beNil() : equal(testError));
                    expect(systemCapabilityManager).toNot(beNil());
                    done();
                }];

                [NSThread sleepForTimeInterval:0.1];

                [testConnectionManager respondToLastRequestWithResponse: testGetSystemCapabilityResponse error:testError];
            });
        });
    });

    context(@"If a Get System Capability request is sent outside of this manager", ^{
        __block SDLGetSystemCapabilityResponse *testGetSystemCapabilityResponse = nil;

        beforeEach(^{
            testGetSystemCapabilityResponse = [[SDLGetSystemCapabilityResponse alloc] init];
        });

        it(@"should capture and save the capability type in the manager", ^{
            testNavigationCapability = [[SDLNavigationCapability alloc] initWithSendLocation:YES waypoints:YES];
            
            testGetSystemCapabilityResponse.success = @YES;
            testGetSystemCapabilityResponse.systemCapability = [[SDLSystemCapability alloc] init];
            testGetSystemCapabilityResponse.systemCapability.navigationCapability = testNavigationCapability;
            testGetSystemCapabilityResponse.systemCapability.systemCapabilityType = SDLSystemCapabilityTypeNavigation;
        });

        it(@"should not save any capabilities if the request failed", ^{
            testGetSystemCapabilityResponse.success = @NO;
        });

        afterEach(^{
            SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveGetSystemCapabilitiesResponse object:self rpcResponse:testGetSystemCapabilityResponse];

            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [NSThread sleepForTimeInterval:0.1];
        });
    });

    afterEach(^{
        expect(testSystemCapabilityManager.displayCapabilities).to(testDisplayCapabilities != nil ? equal(testDisplayCapabilities) : beNil());
        expect(testSystemCapabilityManager.hmiCapabilities).to(testHMICapabilities != nil ? equal(testHMICapabilities) : beNil());
        expect(testSystemCapabilityManager.softButtonCapabilities).to(testSoftButtonCapabilities != nil ? equal(testSoftButtonCapabilities) : beNil());
        expect(testSystemCapabilityManager.buttonCapabilities).to(testButtonCapabilities != nil ? equal(testButtonCapabilities) : beNil());
        expect(testSystemCapabilityManager.presetBankCapabilities).to(testPresetBankCapabilities != nil ? equal(testPresetBankCapabilities) : beNil());
        expect(testSystemCapabilityManager.hmiZoneCapabilities).to(testHMIZoneCapabilities != nil ? equal(testHMIZoneCapabilities) : beNil());
        expect(testSystemCapabilityManager.speechCapabilities).to(testSpeechCapabilities != nil ? equal(testSpeechCapabilities) : beNil());
        expect(testSystemCapabilityManager.prerecordedSpeechCapabilities).to(testPrerecordedSpeechCapabilities != nil ? equal(testPrerecordedSpeechCapabilities) : beNil());
        expect(testSystemCapabilityManager.vrCapability).to(testVRCapabilities != nil ? equal(testVRCapabilities.firstObject == SDLVRCapabilitiesText ? YES : NO) : equal(NO));
        expect(testSystemCapabilityManager.audioPassThruCapabilities).to(testAudioPassThruCapabilities != nil ? equal(testAudioPassThruCapabilities) : beNil());
        expect(testSystemCapabilityManager.pcmStreamCapability).to(testPCMStreamCapabilities != nil ? equal(testPCMStreamCapabilities) : beNil());

        expect(testSystemCapabilityManager.phoneCapability).to(testPhoneCapability != nil ? equal(testPhoneCapability) : beNil());
        expect(testSystemCapabilityManager.navigationCapability).to(testNavigationCapability != nil ? equal(testNavigationCapability) : beNil());
        expect(testSystemCapabilityManager.videoStreamingCapability).to(testVideoStreamingCapability != nil ? equal(testVideoStreamingCapability) : beNil());
        expect(testSystemCapabilityManager.remoteControlCapability).to(testRemoteControlCapability != nil ? equal(testRemoteControlCapability) : beNil());
    });
});

QuickSpecEnd

