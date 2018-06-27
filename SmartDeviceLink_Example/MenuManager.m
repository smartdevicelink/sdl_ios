//
//  MenuManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 5/15/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "MenuManager.h"
#import "AlertManager.h"
#import "AudioManager.h"
#import "AppConstants.h"
#import "PerformInteractionManager.h"
#import "RPCPermissionsManager.h"
#import "SmartDeviceLink.h"
#import "VehicleDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MenuManager

+ (NSArray<SDLMenuCell *> *)allMenuItemsWithManager:(SDLManager *)manager performManager:(PerformInteractionManager *)performManager {
    return @[[self sdlex_menuCellSpeakNameWithManager:manager],
             [self sdlex_menuCellGetVehicleSpeedWithManager:manager],
             [self sdlex_menuCellShowPerformInteractionWithManager:manager performManager:performManager],
             [self sdlex_menuCellRecordInCarMicrophoneAudioWithManager:manager],
             [self sdlex_menuCellDialNumberWithManager:manager],
             [self sdlex_menuCellWithSubmenuWithManager:manager]];
}

+ (NSArray<SDLVoiceCommand *> *)allVoiceMenuItemsWithManager:(SDLManager *)manager {
    if (!manager.systemCapabilityManager.vrCapability) {
        SDLLogE(@"The head unit does not support voice recognition");
        return @[];
    }

    return @[[self.class sdlex_voiceCommandStartWithManager:manager], [self.class sdlex_voiceCommandStopWithManager:manager]];
}

#pragma mark - Menu Items

+ (SDLMenuCell *)sdlex_menuCellSpeakNameWithManager:(SDLManager *)manager {
    return [[SDLMenuCell alloc] initWithTitle:ACSpeakAppNameMenuName icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:SpeakBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[ACSpeakAppNameMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [manager sendRequest:[[SDLSpeak alloc] initWithTTS:ExampleAppNameTTS]];
    }];
}

+ (SDLMenuCell *)sdlex_menuCellGetVehicleSpeedWithManager:(SDLManager *)manager {
    return [[SDLMenuCell alloc] initWithTitle:ACGetVehicleDataMenuName icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:CarBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[ACGetVehicleDataMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [VehicleDataManager getVehicleSpeedWithManager:manager];
    }];
}

+ (SDLMenuCell *)sdlex_menuCellShowPerformInteractionWithManager:(SDLManager *)manager performManager:(PerformInteractionManager *)performManager {
    return [[SDLMenuCell alloc] initWithTitle:ACShowChoiceSetMenuName icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:MenuBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[ACShowChoiceSetMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [performManager showWithTriggerSource:triggerSource];
    }];
}

+ (SDLMenuCell *)sdlex_menuCellRecordInCarMicrophoneAudioWithManager:(SDLManager *)manager {
    AudioManager *audioManager = [[AudioManager alloc] initWithManager:manager];
    return [[SDLMenuCell alloc] initWithTitle:ACRecordInCarMicrophoneAudioMenuName icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:MicrophoneBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[ACRecordInCarMicrophoneAudioMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [audioManager startRecording];
    }];
}

+ (SDLMenuCell *)sdlex_menuCellDialNumberWithManager:(SDLManager *)manager {
    return [[SDLMenuCell alloc] initWithTitle:ACDialPhoneNumberMenuName icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:PhoneBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:@[ACDialPhoneNumberMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        if (![RPCPermissionsManager isDialNumberRPCAllowedWithManager:manager]) {
            [manager sendRequest:[AlertManager alertWithMessageAndCloseButton:@"This app does not have the required permissions to dial a number" textField2:nil]];
            return;
        }

        [VehicleDataManager checkPhoneCallCapabilityWithManager:manager phoneNumber:@"555-555-5555"];
    }];
}

+ (SDLMenuCell *)sdlex_menuCellWithSubmenuWithManager:(SDLManager *)manager {
    NSMutableArray *submenuItems = [NSMutableArray array];
    for (int i = 0; i < 75; i++) {
        SDLMenuCell *cell = [[SDLMenuCell alloc] initWithTitle:[NSString stringWithFormat:@"%@ %i", ACSubmenuItemMenuName, i] icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:MenuBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
            [manager sendRequest:[AlertManager alertWithMessageAndCloseButton:[NSString stringWithFormat:@"You selected %@ %i", ACSubmenuItemMenuName, i] textField2:nil]];
        }];
        [submenuItems addObject:cell];
    }

    return [[SDLMenuCell alloc] initWithTitle:ACSubmenuMenuName subCells:[submenuItems copy]];
}

#pragma mark - Voice Commands

+ (SDLVoiceCommand *)sdlex_voiceCommandStartWithManager:(SDLManager *)manager {
    return [[SDLVoiceCommand alloc] initWithVoiceCommands:@[VCStop] handler:^{
        [manager sendRequest:[AlertManager alertWithMessageAndCloseButton:[NSString stringWithFormat:@"%@ voice command selected!", VCStop] textField2:nil]];
    }];
}

+ (SDLVoiceCommand *)sdlex_voiceCommandStopWithManager:(SDLManager *)manager {
    return [[SDLVoiceCommand alloc] initWithVoiceCommands:@[VCStart] handler:^{
        [manager sendRequest:[AlertManager alertWithMessageAndCloseButton:[NSString stringWithFormat:@"%@ voice command selected!", VCStart] textField2:nil]];
    }];
}

@end

NS_ASSUME_NONNULL_END
