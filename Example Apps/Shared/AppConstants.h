//
//  AppConstants.h
//  SmartDeviceLink
//
//  Created by Nicole on 4/10/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - SDL Configuration
extern NSString * const ExampleAppName;
extern NSString * const ExampleAppNameShort;
extern NSString * const ExampleAppNameTTS;
extern NSString * const ExampleFullAppId;
extern BOOL const ExampleAppShouldRestartSDLManagerOnDisconnect;

#pragma mark - SDL Textfields
extern NSString * const SmartDeviceLinkText;
extern NSString * const ExampleAppText;

#pragma mark - SDL Soft Buttons
extern NSString * const SubtleAlertSoftButton;

extern NSString * const AlertSoftButton;
extern NSString * const AlertSoftButtonImageState;
extern NSString * const AlertSoftButtonTextState;
extern NSString * const AlertSoftButtonText;

extern NSString * const TextVisibleSoftButton;
extern NSString * const TextVisibleSoftButtonTextOnState;
extern NSString * const TextVisibleSoftButtonTextOffState;
extern NSString * const TextVisibleSoftButtonTextOnText;
extern NSString * const TextVisibleSoftButtonTextOffText;

extern NSString * const ImagesVisibleSoftButton;
extern NSString * const ImagesVisibleSoftButtonImageOnState;
extern NSString * const ImagesVisibleSoftButtonImageOffState;
extern NSString * const ImagesVisibleSoftButtonImageOnText;
extern NSString * const ImagesVisibleSoftButtonImageOffText;

#pragma mark - Alert
extern NSString * const AlertMessageText;
extern NSString * const AlertOKButtonText;
extern NSString * const SubtleAlertHeaderText;
extern NSString * const SubtleAlertSubheaderText;
extern NSString * const SubtleAlertNotSupportedText;

#pragma mark - SDL Text-To-Speech
extern NSString * const TTSGoodJob;
extern NSString * const TTSYouMissed;

#pragma mark - SDL Voice Commands
extern NSString * const VCStart;
extern NSString * const VCStop;

#pragma mark - SDL Perform Interaction Choice Set Menu
extern NSString * const PICSInitialText;
extern NSString * const PICSInitialPrompt;
extern NSString * const PICSHelpPrompt;
extern NSString * const PICSTimeoutPrompt;
extern NSString * const PICSFirstChoice;
extern NSString * const PICSSecondChoice;
extern NSString * const PICSThirdChoice;

#pragma mark - SDL Perform Interaction Choice Set Menu VR Commands
extern NSString  * const VCPICSFirstChoice;
extern NSString  * const VCPICSecondChoice;
extern NSString  * const VCPICSThirdChoice;

#pragma mark - SDL Add Command Menu
extern NSString * const ACSpeakAppNameMenuName;
extern NSString * const ACShowChoiceSetMenuName;
extern NSString * const ACGetVehicleDataMenuName;
extern NSString * const ACGetAllVehicleDataMenuName;
extern NSString * const ACRecordInCarMicrophoneAudioMenuName;
extern NSString * const ACDialPhoneNumberMenuName;
extern NSString * const ACSubmenuMenuName;
extern NSString * const ACSubmenuItemMenuName;
extern NSString * const ACSubmenuTemplateMenuName;
extern NSString * const ACSliderMenuName;
extern NSString * const ACScrollableMessageMenuName;

extern NSString * const ACAccelerationPedalPositionMenuName;
extern NSString * const ACAirbagStatusMenuName;
extern NSString * const ACBeltStatusMenuName;
extern NSString * const ACBodyInformationMenuName;
extern NSString * const ACClusterModeStatusMenuName;
extern NSString * const ACDeviceStatusMenuName;
extern NSString * const ACDriverBrakingMenuName;
extern NSString * const ACECallInfoMenuName;
extern NSString * const ACElectronicParkBrakeStatus;
extern NSString * const ACEmergencyEventMenuName;
extern NSString * const ACEngineOilLifeMenuName;
extern NSString * const ACEngineTorqueMenuName;
extern NSString * const ACExternalTemperatureMenuName;
extern NSString * const ACFuelLevelMenuName;
extern NSString * const ACFuelLevelStateMenuName;
extern NSString * const ACFuelRangeMenuName;
extern NSString * const ACGPSMenuName;
extern NSString * const ACHeadLampStatusMenuName;
extern NSString * const ACInstantFuelConsumptionMenuName;
extern NSString * const ACMyKeyMenuName;
extern NSString * const ACOdometerMenuName;
extern NSString * const ACPRNDLMenuName;
extern NSString * const ACRPMMenuName;
extern NSString * const ACSpeedMenuName;
extern NSString * const ACSteeringWheelAngleMenuName;
extern NSString * const ACTirePressureMenuName;
extern NSString * const ACTurnSignalMenuName;
extern NSString * const ACVINMenuName;
extern NSString * const ACWiperStatusMenuName;

#pragma mark - SDL Image Names
extern NSString * const AlertBWIconName;
extern NSString * const CarBWIconImageName;
extern NSString * const ExampleAppLogoName;
extern NSString * const MenuBWIconImageName;
extern NSString * const MicrophoneBWIconImageName;
extern NSString * const PhoneBWIconImageName;
extern NSString * const SpeakBWIconImageName;
extern NSString * const BatteryEmptyBWIconName;
extern NSString * const BatteryFullBWIconName;

#pragma mark - SDL App Name in Different Languages
extern NSString * const ExampleAppNameSpanish;
extern NSString * const ExampleAppNameFrench;

#pragma mark - SDL Vehicle Data
extern NSString * const VehicleDataOdometerName;
extern NSString * const VehicleDataSpeedName;

@interface AppConstants : NSObject

@end

NS_ASSUME_NONNULL_END
