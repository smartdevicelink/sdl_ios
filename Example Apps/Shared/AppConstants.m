//
//  AppConstants.m
//  SmartDeviceLink
//
//  Created by Nicole on 4/10/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "AppConstants.h"

#pragma mark - SDL Configuration
NSString * const ExampleAppName = @"SDL Example App";
NSString * const ExampleAppNameShort = @"SDL";
NSString * const ExampleAppNameTTS = @"S D L Example App";
NSString * const ExampleFullAppId = @"123e4567-e89b-12d3-a456-426655440000"; // Dummy App Id

#pragma mark - SDL Textfields
NSString * const SmartDeviceLinkText = @"SmartDeviceLink (SDL)";
NSString * const ExampleAppText = @"Example App";

#pragma mark - SDL Soft Buttons
NSString * const SubtleAlertSoftButton = @"SubtleAlertSoftButton";
NSString * const SubtleAlertSoftButtonImageAndTextState = @"SubtleAlertSoftButtonImageAndTextState";
NSString * const SubtleAlertSoftButtonTextState = @"SubtleAlertSoftButtonTextState";
NSString * const SubtleAlertSoftButtonText = @"Check Battery";

NSString * const AlertSoftButton = @"AlertSoftButton";
NSString * const AlertSoftButtonImageAndTextState = @"AlertSoftButtonImageAndTextState";
NSString * const AlertSoftButtonTextState = @"AlertSoftButtonTextState";
NSString * const AlertSoftButtonText = @"Show Alert";

NSString * const TextVisibleSoftButton = @"TextVisibleSoftButton";
NSString * const TextVisibleSoftButtonTextOnState = @"TextVisibleSoftButtonTextOnState";
NSString * const TextVisibleSoftButtonTextOffState = @"TextVisibleSoftButtonTextOffState";
NSString * const TextVisibleSoftButtonTextOnText = @"➖Text";
NSString * const TextVisibleSoftButtonTextOffText = @"➕Text";

NSString * const ImagesVisibleSoftButton = @"ImagesVisibleSoftButton";
NSString * const ImagesVisibleSoftButtonImageOnState = @"ImagesVisibleSoftButtonImageOnState";
NSString * const ImagesVisibleSoftButtonImageOffState = @"ImagesVisibleSoftButtonImageOffState";
NSString * const ImagesVisibleSoftButtonImageOnText = @"➖Icons";
NSString * const ImagesVisibleSoftButtonImageOffText = @"➕Icons";

#pragma mark - Alert
NSString * const AlertMessageText = @"You pressed the button!";
NSString * const AlertOKButtonText = @"OK";
NSString * const SubtleAlertHeaderText = @"Battery Level";
NSString * const SubtleAlertSubheaderText = @"Almost empty";
NSString * const AlertDialNumberPermissionsWarningText = @"This app does not have the required permissions to dial a number";
NSString * const AlertDialNumberUnavailableWarningText = @"The dial number feature is unavailable for this head unit";
NSString * const AlertSliderTimedOutWarningText = @"Slider timed out";
NSString * const AlertSliderCancelledWarningText = @"Slider cancelled";
NSString * const AlertSliderGeneralWarningText = @"Slider could not be displayed";
NSString * const AlertScrollableMessageTimedOutWarningText = @"Scrollable Message timed out";
NSString * const AlertScrollableMessageCancelledWarningText = @"Scrollable Message cancelled";
NSString * const AlertScrollableMessageGeneralWarningText = @"Scrollable Message could not be displayed";
NSString * const AlertVehicleDataPermissionsWarningText = @"This app does not have the required permissions to access vehicle data";
NSString * const AlertVehicleDataGeneralWarningText = @"Something went wrong while getting vehicle data";
NSString * const AlertSpeechPermissionsWarningText = @"You must give this app permission to access Speech Recognition";

#pragma mark - SDL Text-To-Speech
NSString * const TTSGoodJob = @"Good Job";
NSString * const TTSYouMissed = @"You Missed";

#pragma mark - SDL Voice Commands
NSString * const VCStart = @"Start";
NSString * const VCStop = @"Stop";

#pragma mark - SDL Perform Interaction Choice Set Menu
NSString * const PICSInitialText = @"Perform Interaction Choice Set Menu Example";
NSString * const PICSInitialPrompt = @"Select an item from the menu";
NSString * const PICSHelpPrompt = @"Select a menu row using your voice or by tapping on the screen";
NSString * const PICSTimeoutPrompt = @"Closing the menu";
NSString * const PICSFirstChoice = @"First Choice";
NSString * const PICSSecondChoice = @"Second Choice";
NSString * const PICSThirdChoice = @"Third Choice";

#pragma mark - SDL Perform Interaction Choice Set Menu VR Commands
NSString * const VCPICSFirstChoice = @"First";
NSString * const VCPICSecondChoice = @"Second";
NSString * const VCPICSThirdChoice = @"Third";

#pragma mark - SDL Add Command Menu
NSString * const ACSpeakAppNameMenuName = @"Speak App Name";
NSString * const ACShowChoiceSetMenuName = @"Show Perform Interaction Choice Set";
NSString * const ACGetVehicleDataMenuName = @"Get Vehicle Speed";
NSString * const ACGetAllVehicleDataMenuName = @"Get All Vehicle Data";
NSString * const ACRecordInCarMicrophoneAudioMenuName = @"Record In-Car Microphone Audio";
NSString * const ACDialPhoneNumberMenuName = @"Dial Phone Number";
NSString * const ACSubmenuMenuName = @"Submenu";
NSString * const ACSubmenuItemMenuName = @"Item";
NSString * const ACSubmenuTemplateMenuName = @"Change Template";
NSString * const ACSliderMenuName = @"Show Slider";
NSString * const ACScrollableMessageMenuName = @"Show Scrollable Message";

NSString * const ACAccelerationPedalPositionMenuName = @"Acceleration Pedal Position";
NSString * const ACAirbagStatusMenuName = @"Airbag Status";
NSString * const ACBeltStatusMenuName = @"Belt Status";
NSString * const ACBodyInformationMenuName = @"Body Information";
NSString * const ACClusterModeStatusMenuName = @"Cluster Mode Status";
NSString * const ACDeviceStatusMenuName = @"Device Status";
NSString * const ACDriverBrakingMenuName = @"Driver Braking";
NSString * const ACECallInfoMenuName = @"eCall Info";
NSString * const ACElectronicParkBrakeStatus = @"Electronic Parking Brake Status";
NSString * const ACEmergencyEventMenuName = @"Emergency Event";
NSString * const ACEngineOilLifeMenuName = @"Engine Oil Life";
NSString * const ACEngineTorqueMenuName = @"Engine Torque";
NSString * const ACExternalTemperatureMenuName = @"External Temperature";
NSString * const ACFuelLevelMenuName = @"Fuel Level";
NSString * const ACFuelLevelStateMenuName = @"Fuel Level State";
NSString * const ACFuelRangeMenuName = @"Fuel Range";
NSString * const ACGearStatusMenuName = @"Gear Status";
NSString * const ACGPSMenuName = @"GPS";
NSString * const ACHeadLampStatusMenuName = @"Head Lamp Status";
NSString * const ACInstantFuelConsumptionMenuName = @"Instant Fuel Consumption";
NSString * const ACMyKeyMenuName = @"MyKey";
NSString * const ACOdometerMenuName = @"Odometer";
NSString * const ACPRNDLMenuName = @"PRNDL";
NSString * const ACRPMMenuName = @"RPM";
NSString * const ACSpeedMenuName = @"Speed";
NSString * const ACSteeringWheelAngleMenuName = @"Steering Wheel Angle";
NSString * const ACTirePressureMenuName = @"Tire Pressure";
NSString * const ACTurnSignalMenuName = @"Turn Signal";
NSString * const ACVINMenuName = @"VIN";
NSString * const ACWiperStatusMenuName = @"Wiper Status";

#pragma mark - SDL Image Names
NSString * const AlertBWIconName = @"alert";
NSString * const CarBWIconImageName = @"car";
NSString * const ExampleAppLogoName = @"sdl_logo_green";
NSString * const MenuBWIconImageName = @"choice_set";
NSString * const MicrophoneBWIconImageName = @"microphone";
NSString * const PhoneBWIconImageName = @"phone";
NSString * const SpeakBWIconImageName = @"speak";
NSString * const BatteryEmptyBWIconName = @"toggle_off";
NSString * const BatteryFullBWIconName = @"toggle_on";

#pragma mark - SDL App Name in Different Languages
NSString * const ExampleAppNameSpanish = @"SDL Aplicación de ejemplo";
NSString * const ExampleAppNameFrench = @"SDL Exemple App";

#pragma mark - SDL Vehicle Data
NSString * const VehicleDataOdometerName = @"Odometer";
NSString * const VehicleDataSpeedName = @"Speed";

@implementation AppConstants

@end
