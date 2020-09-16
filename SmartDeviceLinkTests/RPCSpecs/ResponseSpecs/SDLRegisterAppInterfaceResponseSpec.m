//
//  SDLRegisterAppInterfaceResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SmartDeviceLink.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


QuickSpecBegin(SDLRegisterAppInterfaceResponseSpec)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
SDLSyncMsgVersion* version = [[SDLSyncMsgVersion alloc] initWithMajorVersion:0 minorVersion:0 patchVersion:0];
#pragma clang diagnostic pop
SDLMsgVersion *sdlVersion = [[SDLMsgVersion alloc] initWithMajorVersion:0 minorVersion:0 patchVersion:0];
SDLDisplayCapabilities* info = [[SDLDisplayCapabilities alloc] init];
SDLButtonCapabilities* button = [[SDLButtonCapabilities alloc] init];
SDLSoftButtonCapabilities* softButton = [[SDLSoftButtonCapabilities alloc] init];
SDLPresetBankCapabilities* presetBank = [[SDLPresetBankCapabilities alloc] init];
SDLAudioPassThruCapabilities* audioPassThru = [[SDLAudioPassThruCapabilities alloc] init];
SDLVehicleType* vehicle = [[SDLVehicleType alloc] init];
SDLHMICapabilities *hmiCapabilities = [[SDLHMICapabilities alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLRegisterAppInterfaceResponse* testResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testResponse.syncMsgVersion = version;
#pragma clang diagnostic pop
        testResponse.language = SDLLanguageEsMx;
        testResponse.hmiDisplayLanguage = SDLLanguageRuRu;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        testResponse.displayCapabilities = info;
        testResponse.buttonCapabilities = @[button];
        testResponse.softButtonCapabilities = @[softButton];
        testResponse.presetBankCapabilities = presetBank;
#pragma clang diagnostic pop
        testResponse.hmiZoneCapabilities = @[SDLHMIZoneCapabilitiesBack, SDLHMIZoneCapabilitiesFront];
        testResponse.speechCapabilities = @[SDLSpeechCapabilitiesSAPIPhonemes, SDLSpeechCapabilitiesSilence];
        testResponse.vrCapabilities = @[SDLVRCapabilitiesText];
        testResponse.audioPassThruCapabilities = @[audioPassThru];
        testResponse.pcmStreamCapabilities = audioPassThru;
        testResponse.vehicleType = vehicle;
        testResponse.prerecordedSpeech = @[SDLPrerecordedSpeechListen, SDLPrerecordedSpeechHelp];
        testResponse.supportedDiagModes = @[@67, @99, @111];
        testResponse.hmiCapabilities = hmiCapabilities;
        testResponse.sdlVersion = @"sdlVersion";
        testResponse.systemSoftwareVersion = @"systemSoftwareVersion";
        testResponse.iconResumed = @YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testResponse.syncMsgVersion).to(equal(version));
#pragma clang diagnostic pop
        testResponse.sdlMsgVersion = sdlVersion;
        expect(testResponse.sdlMsgVersion).to(equal(sdlVersion));
        expect(testResponse.language).to(equal(SDLLanguageEsMx));
        expect(testResponse.hmiDisplayLanguage).to(equal(SDLLanguageRuRu));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        expect(testResponse.displayCapabilities).to(equal(info));
        expect(testResponse.buttonCapabilities).to(equal(@[button]));
        expect(testResponse.softButtonCapabilities).to(equal(@[softButton]));
        expect(testResponse.presetBankCapabilities).to(equal(presetBank));
#pragma clang diagnostic pop
        expect(testResponse.hmiZoneCapabilities).to(equal(@[SDLHMIZoneCapabilitiesBack, SDLHMIZoneCapabilitiesFront]));
        expect(testResponse.speechCapabilities).to(equal(@[SDLSpeechCapabilitiesSAPIPhonemes, SDLSpeechCapabilitiesSilence]));
        expect(testResponse.vrCapabilities).to(equal(@[SDLVRCapabilitiesText]));
        expect(testResponse.audioPassThruCapabilities).to(equal(@[audioPassThru]));
        expect(testResponse.pcmStreamCapabilities).to(equal(audioPassThru));
        expect(testResponse.vehicleType).to(equal(vehicle));
        expect(testResponse.prerecordedSpeech).to(equal(@[SDLPrerecordedSpeechListen, SDLPrerecordedSpeechHelp]));
        expect(testResponse.supportedDiagModes).to(equal(@[@67, @99, @111]));
        expect(testResponse.hmiCapabilities).to(equal(hmiCapabilities));
        expect(testResponse.sdlVersion).to(equal(@"sdlVersion"));
        expect(testResponse.systemSoftwareVersion).to(equal(@"systemSoftwareVersion"));
        expect(testResponse.iconResumed).to(beTrue());
    });
    describe(@"Setting With Dictionary", ^{
        __block NSDictionary *dict = nil;

        beforeEach( ^{
            dict = @{SDLRPCParameterNameRequest:
                         @{SDLRPCParameterNameParameters:
                               @{SDLRPCParameterNameSyncMessageVersion:@{
                                         SDLRPCParameterNameMajorVersion: @6,
                                         SDLRPCParameterNameMinorVersion: @0,
                                         SDLRPCParameterNamePatchVersion: @0
                                         },
                                 SDLRPCParameterNameLanguage:SDLLanguageEsMx,
                                 SDLRPCParameterNameHMIDisplayLanguage:SDLLanguageRuRu,
                                 SDLRPCParameterNameDisplayCapabilities:info,
                                 SDLRPCParameterNameButtonCapabilities:@[button],
                                 SDLRPCParameterNameSoftButtonCapabilities:@[softButton],
                                 SDLRPCParameterNamePresetBankCapabilities:presetBank,
                                 SDLRPCParameterNameHMIZoneCapabilities:@[SDLHMIZoneCapabilitiesBack, SDLHMIZoneCapabilitiesFront],
                                 SDLRPCParameterNameSpeechCapabilities:@[SDLSpeechCapabilitiesSAPIPhonemes, SDLSpeechCapabilitiesSilence],
                                 SDLRPCParameterNameVRCapabilities:@[SDLVRCapabilitiesText],
                                 SDLRPCParameterNameAudioPassThruCapabilities:@[audioPassThru],
                                 SDLRPCParameterNamePCMStreamCapabilities: audioPassThru,
                                 SDLRPCParameterNameVehicleType:vehicle,
                                 SDLRPCParameterNamePrerecordedSpeech:@[SDLPrerecordedSpeechListen, SDLPrerecordedSpeechHelp],
                                 SDLRPCParameterNameSupportedDiagnosticModes:@[@67, @99, @111],
                                 SDLRPCParameterNameHMICapabilities: hmiCapabilities,
                                 SDLRPCParameterNameSDLVersion: @"sdlVersion",
                                 SDLRPCParameterNameSystemSoftwareVersion: @"systemSoftwareVersion",
                                 SDLRPCParameterNameIconResumed: @YES,
                                 },
                           SDLRPCParameterNameOperationName:SDLRPCFunctionNameRegisterAppInterface}};
        });

        it(@"Should get correctly when initialized with a dictionary and get syncMsgVersion first", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRegisterAppInterfaceResponse* testResponse = [[SDLRegisterAppInterfaceResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testResponse.syncMsgVersion).to(equal([[SDLSyncMsgVersion alloc] initWithMajorVersion:6 minorVersion:0 patchVersion:0]));
#pragma clang diagnostic pop
            expect(testResponse.sdlMsgVersion).to(equal([[SDLMsgVersion alloc] initWithMajorVersion:6 minorVersion:0 patchVersion:0]));
            expect(testResponse.language).to(equal(SDLLanguageEsMx));
            expect(testResponse.hmiDisplayLanguage).to(equal(SDLLanguageRuRu));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            expect(testResponse.displayCapabilities).to(equal(info));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            expect(testResponse.buttonCapabilities).to(equal(@[button]));
            expect(testResponse.softButtonCapabilities).to(equal(@[softButton]));
            expect(testResponse.presetBankCapabilities).to(equal(presetBank));
#pragma clang diagnostic pop
            expect(testResponse.hmiZoneCapabilities).to(equal(@[SDLHMIZoneCapabilitiesBack, SDLHMIZoneCapabilitiesFront]));
            expect(testResponse.speechCapabilities).to(equal(@[SDLSpeechCapabilitiesSAPIPhonemes, SDLSpeechCapabilitiesSilence]));
            expect(testResponse.vrCapabilities).to(equal(@[SDLVRCapabilitiesText]));
            expect(testResponse.audioPassThruCapabilities).to(equal(@[audioPassThru]));
            expect(testResponse.pcmStreamCapabilities).to(equal(audioPassThru));
            expect(testResponse.vehicleType).to(equal(vehicle));
            expect(testResponse.prerecordedSpeech).to(equal(@[SDLPrerecordedSpeechListen, SDLPrerecordedSpeechHelp]));
            expect(testResponse.supportedDiagModes).to(equal(@[@67, @99, @111]));
            expect(testResponse.hmiCapabilities).to(equal(hmiCapabilities));
            expect(testResponse.sdlVersion).to(equal(@"sdlVersion"));
            expect(testResponse.systemSoftwareVersion).to(equal(@"systemSoftwareVersion"));
            expect(testResponse.iconResumed).to(beTrue());
        });

        it(@"Should get correctly when initialized with a dictionary and get sdlMsgVersion first", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLRegisterAppInterfaceResponse* testResponse = [[SDLRegisterAppInterfaceResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
            expect(testResponse.sdlMsgVersion).to(equal([[SDLMsgVersion alloc] initWithMajorVersion:6 minorVersion:0 patchVersion:0]));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testResponse.syncMsgVersion).to(equal([[SDLSyncMsgVersion alloc] initWithMajorVersion:6 minorVersion:0 patchVersion:0]));
#pragma clang diagnostic pop
            expect(testResponse.language).to(equal(SDLLanguageEsMx));
            expect(testResponse.hmiDisplayLanguage).to(equal(SDLLanguageRuRu));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            expect(testResponse.displayCapabilities).to(equal(info));
            expect(testResponse.buttonCapabilities).to(equal(@[button]));
            expect(testResponse.softButtonCapabilities).to(equal(@[softButton]));
            expect(testResponse.presetBankCapabilities).to(equal(presetBank));
#pragma clang diagnostic pop
            expect(testResponse.hmiZoneCapabilities).to(equal(@[SDLHMIZoneCapabilitiesBack, SDLHMIZoneCapabilitiesFront]));
            expect(testResponse.speechCapabilities).to(equal(@[SDLSpeechCapabilitiesSAPIPhonemes, SDLSpeechCapabilitiesSilence]));
            expect(testResponse.vrCapabilities).to(equal(@[SDLVRCapabilitiesText]));
            expect(testResponse.audioPassThruCapabilities).to(equal(@[audioPassThru]));
            expect(testResponse.pcmStreamCapabilities).to(equal(audioPassThru));
            expect(testResponse.vehicleType).to(equal(vehicle));
            expect(testResponse.prerecordedSpeech).to(equal(@[SDLPrerecordedSpeechListen, SDLPrerecordedSpeechHelp]));
            expect(testResponse.supportedDiagModes).to(equal(@[@67, @99, @111]));
            expect(testResponse.hmiCapabilities).to(equal(hmiCapabilities));
            expect(testResponse.sdlVersion).to(equal(@"sdlVersion"));
            expect(testResponse.systemSoftwareVersion).to(equal(@"systemSoftwareVersion"));
            expect(testResponse.iconResumed).to(beTrue());
        });
    });
    
    it(@"Should return nil if not set", ^ {
        SDLRegisterAppInterfaceResponse* testResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testResponse.syncMsgVersion).to(beNil());
#pragma clang diagnostic pop
        expect(testResponse.sdlMsgVersion).to(beNil());
        expect(testResponse.language).to(beNil());
        expect(testResponse.hmiDisplayLanguage).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        expect(testResponse.displayCapabilities).to(beNil());
        expect(testResponse.buttonCapabilities).to(beNil());
        expect(testResponse.softButtonCapabilities).to(beNil());
        expect(testResponse.presetBankCapabilities).to(beNil());
#pragma clang diagnostic pop
        expect(testResponse.hmiZoneCapabilities).to(beNil());
        expect(testResponse.speechCapabilities).to(beNil());
        expect(testResponse.vrCapabilities).to(beNil());
        expect(testResponse.audioPassThruCapabilities).to(beNil());
        expect(testResponse.pcmStreamCapabilities).to(beNil());
        expect(testResponse.vehicleType).to(beNil());
        expect(testResponse.prerecordedSpeech).to(beNil());
        expect(testResponse.supportedDiagModes).to(beNil());
        expect(testResponse.hmiCapabilities).to(beNil());
        expect(testResponse.sdlVersion).to(beNil());
        expect(testResponse.systemSoftwareVersion).to(beNil());
        expect(testResponse.iconResumed).to(beNil());
    });

    it(@"Should get correctly when initialized from NSNull", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameRequest:
                                   @{SDLRPCParameterNameParameters:
                                         @{SDLRPCParameterNameSyncMessageVersion:NSNull.null,
                                           SDLRPCParameterNameLanguage:NSNull.null,
                                           SDLRPCParameterNameHMIDisplayLanguage:NSNull.null,
                                           SDLRPCParameterNameDisplayCapabilities:NSNull.null,
                                           SDLRPCParameterNameButtonCapabilities:NSNull.null,
                                           SDLRPCParameterNameSoftButtonCapabilities:NSNull.null,
                                           SDLRPCParameterNamePresetBankCapabilities:NSNull.null,
                                           SDLRPCParameterNameHMIZoneCapabilities:NSNull.null,
                                           SDLRPCParameterNameSpeechCapabilities:NSNull.null,
                                           SDLRPCParameterNameVRCapabilities:NSNull.null,
                                           SDLRPCParameterNameAudioPassThruCapabilities:NSNull.null,
                                           SDLRPCParameterNamePCMStreamCapabilities:NSNull.null,
                                           SDLRPCParameterNameVehicleType:NSNull.null,
                                           SDLRPCParameterNamePrerecordedSpeech:NSNull.null,
                                           SDLRPCParameterNameSupportedDiagnosticModes:NSNull.null,
                                           SDLRPCParameterNameHMICapabilities: NSNull.null,
                                           SDLRPCParameterNameSDLVersion: NSNull.null,
                                           SDLRPCParameterNameSystemSoftwareVersion: NSNull.null,
                                           SDLRPCParameterNameIconResumed: NSNull.null,
                                           },
                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameRegisterAppInterface}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRegisterAppInterfaceResponse* testResponse = [[SDLRegisterAppInterfaceResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expectAction(^{ [testResponse syncMsgVersion]; }).to(raiseException());
#pragma clang diagnostic pop
        expectAction(^{ [testResponse sdlMsgVersion]; }).to(raiseException());
        expectAction(^{ [testResponse language]; }).to(raiseException());
        expectAction(^{ [testResponse hmiDisplayLanguage]; }).to(raiseException());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        expectAction(^{ [testResponse displayCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse buttonCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse softButtonCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse presetBankCapabilities]; }).to(raiseException());
#pragma clang diagnostic pop
        expectAction(^{ [testResponse hmiZoneCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse speechCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse vrCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse audioPassThruCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse pcmStreamCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse vehicleType]; }).to(raiseException());
        expectAction(^{ [testResponse prerecordedSpeech]; }).to(raiseException());
        expectAction(^{ [testResponse supportedDiagModes]; }).to(raiseException());
        expectAction(^{ [testResponse hmiCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse sdlVersion]; }).to(raiseException());
        expectAction(^{ [testResponse systemSoftwareVersion]; }).to(raiseException());
        expectAction(^{ [testResponse iconResumed]; }).to(raiseException());
    });
});

QuickSpecEnd
