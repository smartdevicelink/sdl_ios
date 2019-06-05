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
        testResponse.iconResumed = @YES;
        
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
        expect(testResponse.iconResumed).to(beTrue());
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameRequest:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameSyncMessageVersion:version,
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRegisterAppInterfaceResponse* testResponse = [[SDLRegisterAppInterfaceResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
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
        expect(testResponse.iconResumed).to(beTrue());
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

        expectAction(^{ [testResponse syncMsgVersion]; }).to(raiseException());
        expectAction(^{ [testResponse language]; }).to(raiseException());
        expectAction(^{ [testResponse hmiDisplayLanguage]; }).to(raiseException());
        expectAction(^{ [testResponse displayCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse buttonCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse softButtonCapabilities]; }).to(raiseException());
        expectAction(^{ [testResponse presetBankCapabilities]; }).to(raiseException());
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
