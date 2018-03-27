#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLSystemCapabilityManager.h"
#import "TestConnectionManager.h"

@interface SDLSystemCapabilityManager()

@end

QuickSpecBegin(SDLSystemCapabilityManagerSpec)

describe(@"system capability manager", ^{
    __block TestConnectionManager *mockConnectionManager = nil;
    __block SDLSystemCapabilityManager *testSystemCapabilityManager = nil;

    __block SDLDisplayCapabilities *displayCapabilities;
    __block SDLHMICapabilities *hmiCapabilities;
    __block NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;
    __block NSArray<SDLButtonCapabilities *> *buttonCapabilities;
    __block SDLPresetBankCapabilities *presetBankCapabilities;
    __block NSArray<SDLHMIZoneCapabilities> *hmiZoneCapabilities;
    __block NSArray<SDLSpeechCapabilities> *speechCapabilities;
    __block NSArray<SDLPrerecordedSpeech> *prerecordedSpeech;
    __block NSArray<SDLVRCapabilities> *vrCapabilities;
    __block NSArray<SDLAudioPassThruCapabilities *> *audioPassThruCapabilities;
    __block NSArray<SDLAudioPassThruCapabilities *> *pcmStreamCapabilities;
    __block SDLNavigationCapability *navigationCapability;
    __block SDLPhoneCapability *phoneCapability;
    __block SDLVideoStreamingCapability *videoStreamingCapability;
    __block SDLRemoteControlCapabilities *remoteControlCapability;

    beforeEach(^{
        mockConnectionManager = [[TestConnectionManager alloc] init];
        testSystemCapabilityManager = [[SDLSystemCapabilityManager alloc] initWithConnectionManager:mockConnectionManager];

        expect(displayCapabilities).to(beNil());
        expect(hmiCapabilities).to(beNil());
        expect(softButtonCapabilities).to(beNil());
        expect(buttonCapabilities).to(beNil());
        expect(presetBankCapabilities).to(beNil());
        expect(hmiZoneCapabilities).to(beNil());
        expect(speechCapabilities).to(beNil());
        expect(prerecordedSpeech).to(beNil());
        expect(vrCapabilities).to(beNil());
        expect(audioPassThruCapabilities).to(beNil());
        expect(pcmStreamCapabilities).to(beNil());
        expect(navigationCapability).to(beNil());
        expect(phoneCapability).to(beNil());
        expect(videoStreamingCapability).to(beNil());
        expect(remoteControlCapability).to(beNil());
    });

    afterEach(^{

    });


});

QuickSpecEnd

