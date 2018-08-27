//
//  SDLRegisterAppInterfaceResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SmartDeviceLink.h"
#import "SDLNames.h"


QuickSpecBegin(SDLRegisterAppInterfaceResponseSpec)

SDLSyncMsgVersion* version = [[SDLSyncMsgVersion alloc] init];
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
        
        testResponse.syncMsgVersion = version;
        testResponse.language = SDLLanguageEsMx;
        testResponse.hmiDisplayLanguage = SDLLanguageRuRu;
        testResponse.displayCapabilities = info;
        testResponse.buttonCapabilities = @[button];
        testResponse.softButtonCapabilities = @[softButton];
        testResponse.presetBankCapabilities = presetBank;
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
        
        expect(testResponse.syncMsgVersion).to(equal(version));
        expect(testResponse.language).to(equal(SDLLanguageEsMx));
        expect(testResponse.hmiDisplayLanguage).to(equal(SDLLanguageRuRu));
        expect(testResponse.displayCapabilities).to(equal(info));
        expect(testResponse.buttonCapabilities).to(equal(@[button]));
        expect(testResponse.softButtonCapabilities).to(equal(@[softButton]));
        expect(testResponse.presetBankCapabilities).to(equal(presetBank));
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
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary *dict = @{SDLNameRequest:
                                           @{SDLNameParameters:
                                                 @{SDLNameSyncMessageVersion:version,
                                                   SDLNameLanguage:SDLLanguageEsMx,
                                                   SDLNameHMIDisplayLanguage:SDLLanguageRuRu,
                                                   SDLNameDisplayCapabilities:info,
                                                   SDLNameButtonCapabilities:@[button],
                                                   SDLNameSoftButtonCapabilities:@[softButton],
                                                   SDLNamePresetBankCapabilities:presetBank,
                                                   SDLNameHMIZoneCapabilities:@[SDLHMIZoneCapabilitiesBack, SDLHMIZoneCapabilitiesFront],
                                                   SDLNameSpeechCapabilities:@[SDLSpeechCapabilitiesSAPIPhonemes, SDLSpeechCapabilitiesSilence],
                                                   SDLNameVRCapabilities:@[SDLVRCapabilitiesText],
                                                   SDLNameAudioPassThruCapabilities:@[audioPassThru],
                                                   SDLNamePCMStreamCapabilities: audioPassThru,
                                                   SDLNameVehicleType:vehicle,
                                                   SDLNamePrerecordedSpeech:@[SDLPrerecordedSpeechListen, SDLPrerecordedSpeechHelp],
                                                   SDLNameSupportedDiagnosticModes:@[@67, @99, @111],
                                                   SDLNameHMICapabilities: hmiCapabilities,
                                                   SDLNameSDLVersion: @"sdlVersion",
                                                   SDLNameSystemSoftwareVersion: @"systemSoftwareVersion"
                                                   },
                                             SDLNameOperationName:SDLNameRegisterAppInterface}};
        SDLRegisterAppInterfaceResponse* testResponse = [[SDLRegisterAppInterfaceResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.syncMsgVersion).to(equal(version));
        expect(testResponse.language).to(equal(SDLLanguageEsMx));
        expect(testResponse.hmiDisplayLanguage).to(equal(SDLLanguageRuRu));
        expect(testResponse.displayCapabilities).to(equal(info));
        expect(testResponse.buttonCapabilities).to(equal(@[button]));
        expect(testResponse.softButtonCapabilities).to(equal(@[softButton]));
        expect(testResponse.presetBankCapabilities).to(equal(presetBank));
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
    });
    
    it(@"Should return nil if not set", ^ {
        SDLRegisterAppInterfaceResponse* testResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
        
        expect(testResponse.syncMsgVersion).to(beNil());
        expect(testResponse.language).to(beNil());
        expect(testResponse.hmiDisplayLanguage).to(beNil());
        expect(testResponse.displayCapabilities).to(beNil());
        expect(testResponse.buttonCapabilities).to(beNil());
        expect(testResponse.softButtonCapabilities).to(beNil());
        expect(testResponse.presetBankCapabilities).to(beNil());
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
    });
});

QuickSpecEnd
