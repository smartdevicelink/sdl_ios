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
#import "RemoteControlManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MenuManager

+ (NSArray<SDLMenuCell *> *)allMenuItemsWithManager:(SDLManager *)manager performManager:(PerformInteractionManager *)performManager {
    return @[[self sdlex_menuCellSpeakNameWithManager:manager],
             [self sdlex_menuCellGetAllVehicleDataWithManager:manager],
             [self sdlex_menuCellShowPerformInteractionWithManager:manager performManager:performManager],
             [self sdlex_sliderMenuCellWithManager:manager],
             [self sdlex_scrollableMessageMenuCellWithManager:manager],
             [self sdlex_menuCellRecordInCarMicrophoneAudioWithManager:manager],
             [self sdlex_menuCellDialNumberWithManager:manager],
             [self sdlex_menuCellChangeTemplateWithManager:manager],
             [self sdlex_menuCellWithSubmenuWithManager:manager],
             [self sdlex_menuCellRemote:manager]];
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
    return [[SDLMenuCell alloc] initWithTitle:ACSpeakAppNameMenuName secondaryText:nil tertiaryText:nil icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:SpeakBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] secondaryArtwork:nil voiceCommands:@[ACSpeakAppNameMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [manager sendRequest:[[SDLSpeak alloc] initWithTTS:ExampleAppNameTTS]];
    }];
}

+ (SDLMenuCell *)sdlex_menuCellGetAllVehicleDataWithManager:(SDLManager *)manager {
    NSMutableArray *submenuItems = [[NSMutableArray alloc] init];
    NSArray<NSString *> *allVehicleDataTypes = [self sdlex_allVehicleDataTypes];
    for (NSString *vehicleDataType in allVehicleDataTypes) {
        SDLMenuCell *cell = [[SDLMenuCell alloc] initWithTitle:vehicleDataType secondaryText:nil tertiaryText:nil icon:[SDLArtwork artworkWithStaticIcon:SDLStaticIconNameSettings] secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
            [VehicleDataManager getAllVehicleDataWithManager:manager triggerSource:triggerSource vehicleDataType:vehicleDataType];
        }];
        [submenuItems addObject:cell];
    }

    return [[SDLMenuCell alloc] initWithTitle:ACGetAllVehicleDataMenuName secondaryText:nil tertiaryText:nil icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:CarBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] secondaryArtwork:nil submenuLayout:SDLMenuLayoutTiles subCells:submenuItems];
}

+ (NSArray<NSString *> *)sdlex_allVehicleDataTypes {
    return @[ACAccelerationPedalPositionMenuName, ACAirbagStatusMenuName, ACBeltStatusMenuName, ACBodyInformationMenuName, ACClusterModeStatusMenuName, ACDeviceStatusMenuName, ACDriverBrakingMenuName, ACECallInfoMenuName, ACElectronicParkBrakeStatus, ACEmergencyEventMenuName, ACEngineOilLifeMenuName, ACEngineTorqueMenuName, ACFuelLevelMenuName, ACFuelLevelStateMenuName, ACFuelRangeMenuName, ACGearStatusMenuName, ACGPSMenuName, ACHeadLampStatusMenuName, ACInstantFuelConsumptionMenuName, ACMyKeyMenuName, ACOdometerMenuName, ACPRNDLMenuName, ACRPMMenuName, ACSpeedMenuName, ACSteeringWheelAngleMenuName, ACTirePressureMenuName, ACTurnSignalMenuName, ACVINMenuName, ACWiperStatusMenuName];
}

+ (SDLMenuCell *)sdlex_menuCellShowPerformInteractionWithManager:(SDLManager *)manager performManager:(PerformInteractionManager *)performManager {
    return [[SDLMenuCell alloc] initWithTitle:ACShowChoiceSetMenuName secondaryText:nil tertiaryText:nil icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:MenuBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] secondaryArtwork:nil voiceCommands:@[ACShowChoiceSetMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [performManager showWithTriggerSource:triggerSource];
    }];
}

+ (SDLMenuCell *)sdlex_menuCellRecordInCarMicrophoneAudioWithManager:(SDLManager *)manager {
    AudioManager *audioManager = [[AudioManager alloc] initWithManager:manager];
    return [[SDLMenuCell alloc] initWithTitle:ACRecordInCarMicrophoneAudioMenuName secondaryText:nil tertiaryText:nil icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:MicrophoneBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] secondaryArtwork:nil voiceCommands:@[ACRecordInCarMicrophoneAudioMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [audioManager startRecording];
    }];
}

+ (SDLMenuCell *)sdlex_menuCellDialNumberWithManager:(SDLManager *)manager {
    return [[SDLMenuCell alloc] initWithTitle:ACDialPhoneNumberMenuName secondaryText:nil tertiaryText:nil icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:PhoneBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] secondaryArtwork:nil voiceCommands:@[ACDialPhoneNumberMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        if (![RPCPermissionsManager isDialNumberRPCAllowedWithManager:manager]) {
            [AlertManager sendAlertWithManager:manager image:nil textField1:AlertDialNumberPermissionsWarningText textField2:nil];
            return;
        }

        [VehicleDataManager checkPhoneCallCapabilityWithManager:manager phoneNumber:@"555-555-5555"];
    }];
}

+ (SDLMenuCell *)sdlex_menuCellChangeTemplateWithManager:(SDLManager *)manager {
    
    /// Lets give an example of 2 templates
    NSMutableArray *submenuItems = [NSMutableArray array];
    NSString *errorMessage = @"Changing the template failed";
    
    // Non - Media
    SDLMenuCell *cell = [[SDLMenuCell alloc] initWithTitle:@"Non - Media (Default)" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [manager.screenManager changeLayout:[[SDLTemplateConfiguration alloc] initWithPredefinedLayout:SDLPredefinedLayoutNonMedia] withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                [AlertManager sendAlertWithManager:manager image:nil textField1:errorMessage textField2:nil];
            }
        }];
    }];
    [submenuItems addObject:cell];
    
    // Graphic With Text
    SDLMenuCell *cell2 = [[SDLMenuCell alloc] initWithTitle:@"Graphic With Text" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [manager.screenManager changeLayout:[[SDLTemplateConfiguration alloc] initWithPredefinedLayout:SDLPredefinedLayoutGraphicWithText] withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                [AlertManager sendAlertWithManager:manager image:nil textField1:errorMessage textField2:nil];
            }
        }];
    }];
    [submenuItems addObject:cell2];
    
    return [[SDLMenuCell alloc] initWithTitle:ACSubmenuTemplateMenuName secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil submenuLayout:SDLMenuLayoutList subCells:[submenuItems copy]];
}

+ (SDLMenuCell *)sdlex_menuCellWithSubmenuWithManager:(SDLManager *)manager {
    NSMutableArray *submenuItems = [NSMutableArray array];
    for (int i = 0; i < 75; i++) {
        SDLMenuCell *cell = [[SDLMenuCell alloc] initWithTitle:[NSString stringWithFormat:@"%@ %i", ACSubmenuItemMenuName, i] secondaryText:nil tertiaryText:nil icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:MenuBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
            [AlertManager sendAlertWithManager:manager image:nil textField1:[NSString stringWithFormat:@"You selected %@ %i", ACSubmenuItemMenuName, i] textField2:nil];
        }];
        [submenuItems addObject:cell];
    }

    return [[SDLMenuCell alloc] initWithTitle:ACSubmenuMenuName secondaryText:nil tertiaryText:nil icon:[SDLArtwork artworkWithImage:[[UIImage imageNamed:MenuBWIconImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] asImageFormat:SDLArtworkImageFormatPNG] secondaryArtwork:nil submenuLayout:SDLMenuLayoutList subCells:[submenuItems copy]];
}

+ (SDLMenuCell *)sdlex_sliderMenuCellWithManager:(SDLManager *)manager {
    return [[SDLMenuCell alloc] initWithTitle:ACSliderMenuName secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:@[ACSliderMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        SDLSlider *sliderRPC = [[SDLSlider alloc] initWithNumTicks:3 position:1 sliderHeader:@"Select a letter" sliderFooters:@[@"A", @"B", @"C"] timeout:10000];
        [manager sendRequest:sliderRPC withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if(![response.resultCode isEqualToEnum:SDLResultSuccess]) {
                if ([response.resultCode isEqualToEnum:SDLResultTimedOut]) {
                    [AlertManager sendAlertWithManager:manager image:nil textField1:AlertSliderTimedOutWarningText textField2:nil];
                } else if ([response.resultCode isEqualToEnum:SDLResultAborted]) {
                    [AlertManager sendAlertWithManager:manager image:nil textField1:AlertSliderCancelledWarningText textField2:nil];
                } else {
                    [AlertManager sendAlertWithManager:manager image:nil textField1:AlertSliderGeneralWarningText textField2:nil];
                }
            }
        }];
    }];
}

+ (SDLMenuCell *)sdlex_scrollableMessageMenuCellWithManager:(SDLManager *)manager {
    return [[SDLMenuCell alloc] initWithTitle:ACScrollableMessageMenuName secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:@[ACScrollableMessageMenuName] handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        SDLScrollableMessage *messageRPC = [[SDLScrollableMessage alloc] initWithMessage:@"This is a scrollable message\nIt can contain many lines"];
        [manager sendRequest:messageRPC withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
           if(![response.resultCode isEqualToEnum:SDLResultSuccess]) {
                if ([response.resultCode isEqualToEnum:SDLResultTimedOut]) {
                    [AlertManager sendAlertWithManager:manager image:nil textField1:AlertScrollableMessageTimedOutWarningText textField2:nil];
                } else if ([response.resultCode isEqualToEnum:SDLResultAborted]) {
                    [AlertManager sendAlertWithManager:manager image:nil textField1:AlertScrollableMessageCancelledWarningText textField2:nil];
                } else {
                    [AlertManager sendAlertWithManager:manager image:nil textField1:AlertScrollableMessageGeneralWarningText textField2:nil];
                }
           }
        }];
    }];
}

+ (SDLMenuCell *)sdlex_menuCellRemote:(SDLManager *)manager {
    
    RemoteControlManager *remoteControlManager = [[RemoteControlManager alloc] initWithManager:manager];
    //[remoteControlManager setupRemoteData];
        
    /// Lets give an example of 2 templates
    NSMutableArray *submenuItems = [NSMutableArray array];
    NSString *errorMessage = @"Changing the template failed";
    
    // Climate Control
    NSString *titleControl = @"Climate Control";
    SDLMenuCell *cell = [[SDLMenuCell alloc] initWithTitle:titleControl secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        [manager.screenManager changeLayout:[[SDLTemplateConfiguration alloc] initWithPredefinedLayout:SDLPredefinedLayoutNonMedia] withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                [AlertManager sendAlertWithManager:manager image:nil textField1:errorMessage textField2:nil];
            }
            [remoteControlManager showClimateControl];
        }];
    }];
    [submenuItems addObject:cell];
    
    // View Climate
    NSString *titleView = @"View Climate";
    SDLMenuCell *cell2 = [[SDLMenuCell alloc] initWithTitle:titleView secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil voiceCommands:nil handler:^(SDLTriggerSource  _Nonnull triggerSource) {
        SDLScrollableMessage *messageRPC = [[SDLScrollableMessage alloc] initWithMessage:[remoteControlManager getClimateData]];
        [manager sendRequest:messageRPC withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
           if(![response.resultCode isEqualToEnum:SDLResultSuccess]) {
                if ([response.resultCode isEqualToEnum:SDLResultTimedOut]) {
                    [AlertManager sendAlertWithManager:manager image:nil textField1:AlertScrollableMessageTimedOutWarningText textField2:nil];
                } else if ([response.resultCode isEqualToEnum:SDLResultAborted]) {
                    [AlertManager sendAlertWithManager:manager image:nil textField1:AlertScrollableMessageCancelledWarningText textField2:nil];
                } else {
                    [AlertManager sendAlertWithManager:manager image:nil textField1:AlertScrollableMessageGeneralWarningText textField2:nil];
                }
           }
        }];
    }];
    [submenuItems addObject:cell2];
    
    return [[SDLMenuCell alloc] initWithTitle:@"Remote Control" secondaryText:nil tertiaryText:nil icon:nil secondaryArtwork:nil submenuLayout:SDLMenuLayoutList subCells:[submenuItems copy]];
}

#pragma mark - Voice Commands

+ (SDLVoiceCommand *)sdlex_voiceCommandStartWithManager:(SDLManager *)manager {
    return [[SDLVoiceCommand alloc] initWithVoiceCommands:@[VCStop] handler:^{
        [AlertManager sendAlertWithManager:manager image:nil textField1:[NSString stringWithFormat:@"%@ voice command selected!", VCStop] textField2:nil];
    }];
}

+ (SDLVoiceCommand *)sdlex_voiceCommandStopWithManager:(SDLManager *)manager {
    return [[SDLVoiceCommand alloc] initWithVoiceCommands:@[VCStart] handler:^{
        [AlertManager sendAlertWithManager:manager image:nil textField1:[NSString stringWithFormat:@"%@ voice command selected!", VCStart] textField2:nil];
    }];
}

@end

NS_ASSUME_NONNULL_END
