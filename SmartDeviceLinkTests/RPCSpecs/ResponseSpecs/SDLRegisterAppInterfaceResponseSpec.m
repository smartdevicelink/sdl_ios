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
        testResponse.buttonCapabilities = [@[button] mutableCopy];
        testResponse.softButtonCapabilities = [@[softButton] mutableCopy];
        testResponse.presetBankCapabilities = presetBank;
        testResponse.hmiZoneCapabilities = [@[SDLHMIZoneCapabilitiesBack, SDLHMIZoneCapabilitiesFront] copy];
        testResponse.speechCapabilities = [@[SDLSpeechCapabilitiesSAPIPhonemes, SDLSpeechCapabilitiesSilence] copy];
        testResponse.vrCapabilities = [@[SDLVRCapabilitiesText] copy];
        testResponse.audioPassThruCapabilities = [@[audioPassThru] mutableCopy];
        testResponse.vehicleType = vehicle;
        testResponse.prerecordedSpeech = [@[SDLPrerecordedSpeechListen, SDLPrerecordedSpeechHelp] copy];
        testResponse.supportedDiagModes = [@[@67, @99, @111] mutableCopy];
        testResponse.hmiCapabilities = hmiCapabilities;
        testResponse.sdlVersion = @"sdlVersion";
        testResponse.systemSoftwareVersion = @"systemSoftwareVersion";
        
        expect(testResponse.syncMsgVersion).to(equal(version));
        expect(testResponse.language).to(equal(SDLLanguageEsMx));
        expect(testResponse.hmiDisplayLanguage).to(equal(SDLLanguageRuRu));
        expect(testResponse.displayCapabilities).to(equal(info));
        expect(testResponse.buttonCapabilities).to(equal([@[button] mutableCopy]));
        expect(testResponse.softButtonCapabilities).to(equal([@[softButton] mutableCopy]));
        expect(testResponse.presetBankCapabilities).to(equal(presetBank));
        expect(testResponse.hmiZoneCapabilities).to(equal([@[SDLHMIZoneCapabilitiesBack, SDLHMIZoneCapabilitiesFront] copy]));
        expect(testResponse.speechCapabilities).to(equal([@[SDLSpeechCapabilitiesSAPIPhonemes, SDLSpeechCapabilitiesSilence] copy]));
        expect(testResponse.vrCapabilities).to(equal([@[SDLVRCapabilitiesText] copy]));
        expect(testResponse.audioPassThruCapabilities).to(equal([@[audioPassThru] mutableCopy]));
        expect(testResponse.vehicleType).to(equal(vehicle));
        expect(testResponse.prerecordedSpeech).to(equal([@[SDLPrerecordedSpeechListen, SDLPrerecordedSpeechHelp] copy]));
        expect(testResponse.supportedDiagModes).to(equal([@[@67, @99, @111] mutableCopy]));
        expect(testResponse.hmiCapabilities).to(equal(hmiCapabilities));
        expect(testResponse.sdlVersion).to(equal(@"sdlVersion"));
        expect(testResponse.systemSoftwareVersion).to(equal(@"systemSoftwareVersion"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameRequest:
                                           @{SDLNameParameters:
                                                 @{SDLNameSyncMessageVersion:version,
                                                   SDLNameLanguage:SDLLanguageEsMx,
                                                   SDLNameHMIDisplayLanguage:SDLLanguageRuRu,
                                                   SDLNameDisplayCapabilities:info,
                                                   SDLNameButtonCapabilities:[@[button] mutableCopy],
                                                   SDLNameSoftButtonCapabilities:[@[softButton] mutableCopy],
                                                   SDLNamePresetBankCapabilities:presetBank,
                                                   SDLNameHMIZoneCapabilities:[@[SDLHMIZoneCapabilitiesBack, SDLHMIZoneCapabilitiesFront] copy],
                                                   SDLNameSpeechCapabilities:[@[SDLSpeechCapabilitiesSAPIPhonemes, SDLSpeechCapabilitiesSilence] copy],
                                                   SDLNameVRCapabilities:[@[SDLVRCapabilitiesText] copy],
                                                   SDLNameAudioPassThruCapabilities:[@[audioPassThru] mutableCopy],
                                                   SDLNameVehicleType:vehicle,
                                                   SDLNamePrerecordedSpeech:[@[SDLPrerecordedSpeechListen, SDLPrerecordedSpeechHelp] mutableCopy],
                                                   SDLNameSupportedDiagnosticModes:[@[@67, @99, @111] mutableCopy],
                                                   SDLNameHMICapabilities: hmiCapabilities,
                                                   SDLNameSDLVersion: @"sdlVersion",
                                                   SDLNameSystemSoftwareVersion: @"systemSoftwareVersion"
                                                   },
                                             SDLNameOperationName:SDLNameRegisterAppInterface}} mutableCopy];
        SDLRegisterAppInterfaceResponse* testResponse = [[SDLRegisterAppInterfaceResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.syncMsgVersion).to(equal(version));
        expect(testResponse.language).to(equal(SDLLanguageEsMx));
        expect(testResponse.hmiDisplayLanguage).to(equal(SDLLanguageRuRu));
        expect(testResponse.displayCapabilities).to(equal(info));
        expect(testResponse.buttonCapabilities).to(equal([@[button] mutableCopy]));
        expect(testResponse.softButtonCapabilities).to(equal([@[softButton] mutableCopy]));
        expect(testResponse.presetBankCapabilities).to(equal(presetBank));
        expect(testResponse.hmiZoneCapabilities).to(equal([@[SDLHMIZoneCapabilitiesBack, SDLHMIZoneCapabilitiesFront] copy]));
        expect(testResponse.speechCapabilities).to(equal([@[SDLSpeechCapabilitiesSAPIPhonemes, SDLSpeechCapabilitiesSilence] copy]));
        expect(testResponse.vrCapabilities).to(equal([@[SDLVRCapabilitiesText] copy]));
        expect(testResponse.audioPassThruCapabilities).to(equal([@[audioPassThru] mutableCopy]));
        expect(testResponse.vehicleType).to(equal(vehicle));
        expect(testResponse.prerecordedSpeech).to(equal([@[SDLPrerecordedSpeechListen, SDLPrerecordedSpeechHelp] copy]));
        expect(testResponse.supportedDiagModes).to(equal([@[@67, @99, @111] mutableCopy]));
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
        expect(testResponse.vehicleType).to(beNil());
        expect(testResponse.prerecordedSpeech).to(beNil());
        expect(testResponse.supportedDiagModes).to(beNil());
        expect(testResponse.hmiCapabilities).to(beNil());
        expect(testResponse.sdlVersion).to(beNil());
        expect(testResponse.systemSoftwareVersion).to(beNil());
    });
});

QuickSpecEnd
