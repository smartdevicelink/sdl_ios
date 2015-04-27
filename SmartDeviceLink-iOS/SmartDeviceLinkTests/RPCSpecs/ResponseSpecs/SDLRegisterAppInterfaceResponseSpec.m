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
        testResponse.language = [SDLLanguage ES_MX];
        testResponse.hmiDisplayLanguage = [SDLLanguage RU_RU];
        testResponse.displayCapabilities = info;
        testResponse.buttonCapabilities = [@[button] mutableCopy];
        testResponse.softButtonCapabilities = [@[softButton] mutableCopy];
        testResponse.presetBankCapabilities = presetBank;
        testResponse.hmiZoneCapabilities = [@[[SDLHMIZoneCapabilities BACK], [SDLHMIZoneCapabilities FRONT]] copy];
        testResponse.speechCapabilities = [@[[SDLSpeechCapabilities SAPI_PHONEMES], [SDLSpeechCapabilities SILENCE]] copy];
        testResponse.vrCapabilities = [@[[SDLVRCapabilities TEXT]] copy];
        testResponse.audioPassThruCapabilities = [@[audioPassThru] mutableCopy];
        testResponse.vehicleType = vehicle;
        testResponse.prerecordedSpeech = [@[[SDLPrerecordedSpeech LISTEN_JINGLE], [SDLPrerecordedSpeech HELP_JINGLE]] copy];
        testResponse.supportedDiagModes = [@[@67, @99, @111] mutableCopy];
        testResponse.hmiCapabilities = hmiCapabilities;
        testResponse.sdlVersion = @"sdlVersion";
        testResponse.systemSoftwareVersion = @"systemSoftwareVersion";
        
        expect(testResponse.syncMsgVersion).to(equal(version));
        expect(testResponse.language).to(equal([SDLLanguage ES_MX]));
        expect(testResponse.hmiDisplayLanguage).to(equal([SDLLanguage RU_RU]));
        expect(testResponse.displayCapabilities).to(equal(info));
        expect(testResponse.buttonCapabilities).to(equal([@[button] mutableCopy]));
        expect(testResponse.softButtonCapabilities).to(equal([@[softButton] mutableCopy]));
        expect(testResponse.presetBankCapabilities).to(equal(presetBank));
        expect(testResponse.hmiZoneCapabilities).to(equal([@[[SDLHMIZoneCapabilities BACK], [SDLHMIZoneCapabilities FRONT]] copy]));
        expect(testResponse.speechCapabilities).to(equal([@[[SDLSpeechCapabilities SAPI_PHONEMES], [SDLSpeechCapabilities SILENCE]] copy]));
        expect(testResponse.vrCapabilities).to(equal([@[[SDLVRCapabilities TEXT]] copy]));
        expect(testResponse.audioPassThruCapabilities).to(equal([@[audioPassThru] mutableCopy]));
        expect(testResponse.vehicleType).to(equal(vehicle));
        expect(testResponse.prerecordedSpeech).to(equal([@[[SDLPrerecordedSpeech LISTEN_JINGLE], [SDLPrerecordedSpeech HELP_JINGLE]] copy]));
        expect(testResponse.supportedDiagModes).to(equal([@[@67, @99, @111] mutableCopy]));
        expect(testResponse.hmiCapabilities).to(equal(hmiCapabilities));
        expect(testResponse.sdlVersion).to(equal(@"sdlVersion"));
        expect(testResponse.systemSoftwareVersion).to(equal(@"systemSoftwareVersion"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_syncMsgVersion:version,
                                                   NAMES_language:[SDLLanguage ES_MX],
                                                   NAMES_hmiDisplayLanguage:[SDLLanguage RU_RU],
                                                   NAMES_displayCapabilities:info,
                                                   NAMES_buttonCapabilities:[@[button] mutableCopy],
                                                   NAMES_softButtonCapabilities:[@[softButton] mutableCopy],
                                                   NAMES_presetBankCapabilities:presetBank,
                                                   NAMES_hmiZoneCapabilities:[@[[SDLHMIZoneCapabilities BACK], [SDLHMIZoneCapabilities FRONT]] copy],
                                                   NAMES_speechCapabilities:[@[[SDLSpeechCapabilities SAPI_PHONEMES], [SDLSpeechCapabilities SILENCE]] copy],
                                                   NAMES_vrCapabilities:[@[[SDLVRCapabilities TEXT]] copy],
                                                   NAMES_audioPassThruCapabilities:[@[audioPassThru] mutableCopy],
                                                   NAMES_vehicleType:vehicle,
                                                   NAMES_prerecordedSpeech:[@[[SDLPrerecordedSpeech LISTEN_JINGLE], [SDLPrerecordedSpeech HELP_JINGLE]] mutableCopy],
                                                   NAMES_supportedDiagModes:[@[@67, @99, @111] mutableCopy],
                                                   NAMES_hmiCapabilities: hmiCapabilities,
                                                   NAMES_sdlVersion: @"sdlVersion",
                                                   NAMES_systemSoftwareVersion: @"systemSoftwareVersion"
                                                   },
                                             NAMES_operation_name:NAMES_RegisterAppInterface}} mutableCopy];
        SDLRegisterAppInterfaceResponse* testResponse = [[SDLRegisterAppInterfaceResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.syncMsgVersion).to(equal(version));
        expect(testResponse.language).to(equal([SDLLanguage ES_MX]));
        expect(testResponse.hmiDisplayLanguage).to(equal([SDLLanguage RU_RU]));
        expect(testResponse.displayCapabilities).to(equal(info));
        expect(testResponse.buttonCapabilities).to(equal([@[button] mutableCopy]));
        expect(testResponse.softButtonCapabilities).to(equal([@[softButton] mutableCopy]));
        expect(testResponse.presetBankCapabilities).to(equal(presetBank));
        expect(testResponse.hmiZoneCapabilities).to(equal([@[[SDLHMIZoneCapabilities BACK], [SDLHMIZoneCapabilities FRONT]] copy]));
        expect(testResponse.speechCapabilities).to(equal([@[[SDLSpeechCapabilities SAPI_PHONEMES], [SDLSpeechCapabilities SILENCE]] copy]));
        expect(testResponse.vrCapabilities).to(equal([@[[SDLVRCapabilities TEXT]] copy]));
        expect(testResponse.audioPassThruCapabilities).to(equal([@[audioPassThru] mutableCopy]));
        expect(testResponse.vehicleType).to(equal(vehicle));
        expect(testResponse.prerecordedSpeech).to(equal([@[[SDLPrerecordedSpeech LISTEN_JINGLE], [SDLPrerecordedSpeech HELP_JINGLE]] copy]));
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
