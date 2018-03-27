#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioPassThruCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLDisplayCapabilities.h"
#import "SDLHMICapabilities.h"
#import "SDLNotificationConstants.h"
#import "SDLPresetBankCapabilities.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSystemCapabilityManager.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLSystemCapabilityManagerSpec)

describe(@"System capability manager", ^{
    __block TestConnectionManager *mockConnectionManager = nil;
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
        mockConnectionManager = [[TestConnectionManager alloc] init];
        testSystemCapabilityManager = [[SDLSystemCapabilityManager alloc] initWithConnectionManager:mockConnectionManager];

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
        it(@"should not save any capabilities if all the capabilities in the RAI response are nil", ^{
            testRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
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

        it(@"should not save any capabilities if all the capabilities in the set display layout response are nil", ^{
            testSetDisplayLayoutResponse = [[SDLSetDisplayLayoutResponse alloc] init];
            testSetDisplayLayoutResponse.displayCapabilities = nil;
            testSetDisplayLayoutResponse.buttonCapabilities = nil;
            testSetDisplayLayoutResponse.softButtonCapabilities = nil;
            testSetDisplayLayoutResponse.presetBankCapabilities = nil;
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

            testSetDisplayLayoutResponse = [[SDLSetDisplayLayoutResponse alloc] init];
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

    afterEach(^{
        expect(testSystemCapabilityManager.displayCapabilities).to(testDisplayCapabilities != nil ? equal(testDisplayCapabilities) : beNil());
        expect(testSystemCapabilityManager.hmiCapabilities).to(testHMICapabilities != nil ? equal(testHMICapabilities) : beNil());
        expect(testSystemCapabilityManager.softButtonCapabilities).to(testSoftButtonCapabilities != nil ? equal(testSoftButtonCapabilities) : beNil());
        expect(testSystemCapabilityManager.buttonCapabilities).to(testButtonCapabilities != nil ? equal(testButtonCapabilities) : beNil());
        expect(testSystemCapabilityManager.presetBankCapabilities).to(testPresetBankCapabilities != nil ? equal(testPresetBankCapabilities) : beNil());
        expect(testSystemCapabilityManager.hmiZoneCapabilities).to(testHMIZoneCapabilities != nil ? equal(testHMIZoneCapabilities) : beNil());
        expect(testSystemCapabilityManager.speechCapabilities).to(testSpeechCapabilities != nil ? equal(testSpeechCapabilities) : beNil());
        expect(testSystemCapabilityManager.prerecordedSpeech).to(testPrerecordedSpeechCapabilities != nil ? equal(testPrerecordedSpeechCapabilities) : beNil());
        expect(testSystemCapabilityManager.vrCapabilities).to(testVRCapabilities != nil ? equal(testVRCapabilities) : beNil());
        expect(testSystemCapabilityManager.audioPassThruCapabilities).to(testAudioPassThruCapabilities != nil ? equal(testAudioPassThruCapabilities) : beNil());
        expect(testSystemCapabilityManager.pcmStreamCapabilities).to(testPCMStreamCapabilities != nil ? equal(@[testPCMStreamCapabilities]) : beNil());

        expect(testSystemCapabilityManager.phoneCapability).to(testPhoneCapability != nil ? equal(testNavigationCapability) : beNil());
        expect(testSystemCapabilityManager.navigationCapability).to(testNavigationCapability != nil ? equal(testNavigationCapability) : beNil());
        expect(testSystemCapabilityManager.videoStreamingCapability).to(testVideoStreamingCapability != nil ? equal(testVideoStreamingCapability) : beNil());
        expect(testSystemCapabilityManager.remoteControlCapability).to(testRemoteControlCapability != nil ? equal(testRemoteControlCapability) : beNil());
    });
});

QuickSpecEnd

