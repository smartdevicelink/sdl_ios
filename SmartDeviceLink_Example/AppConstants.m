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
NSString * const ExampleAppId = @"9c21";
BOOL const ExampleAppShouldRestartSDLManagerOnDisconnect = NO;

#pragma mark - SDL Textfields
NSString * const SmartDeviceLinkText = @"SmartDeviceLink (SDL)";
NSString * const ExampleAppText = @"Example App";

#pragma mark - SDL Soft Buttons
NSString * const ToggleSoftButton = @"ToggleSoftButton";
NSString * const ToggleSoftButtonImageOnState = @"ToggleSoftButtonImageOnState";
NSString * const ToggleSoftButtonImageOffState = @"ToggleSoftButtonImageOffState";
NSString * const ToggleSoftButtonTextOnState = @"ToggleSoftButtonTextOnState";
NSString * const ToggleSoftButtonTextOffState = @"ToggleSoftButtonTextOffState";
NSString * const ToggleSoftButtonTextTextOnText = @"➖";
NSString * const ToggleSoftButtonTextTextOffText = @"➕";

NSString * const AlertSoftButton = @"AlertSoftButton";
NSString * const AlertSoftButtonImageState = @"AlertSoftButtonImageState";
NSString * const AlertSoftButtonTextState = @"AlertSoftButtonTextState";
NSString * const AlertSoftButtonText = @"Tap Me";

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

#pragma mart - SDL Text-To-Speech
NSString * const TTSGoodJob = @"Good Job";
NSString * const TTSYouMissed = @"You Missed";

#pragma martk - SDL Voice Commands
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

#pragma mark - SDL Add Command Menu
NSString * const ACSpeakAppNameMenuName = @"Speak App Name";
NSString * const ACShowChoiceSetMenuName = @"Show Perform Interaction Choice Set";
NSString * const ACGetVehicleDataMenuName = @"Get Vehicle Speed";
NSString * const ACRecordInCarMicrophoneAudioMenuName = @"Record In-Car Microphone Audio";
NSString * const ACDialPhoneNumberMenuName = @"Dial Phone Number";
NSString * const ACSubmenuMenuName = @"Submenu";
NSString * const ACSubmenuItemMenuName = @"Item";

#pragma mark - SDL Image Names
NSString * const ExampleAppLogoName = @"sdl_logo_green";
NSString * const CarIconImageName = @"car_icon";
NSString * const LaptopIconImageName = @"laptop_icon";
NSString * const WheelIconImageName = @"wheel_icon";
NSString * const SpeakBWIconImageName = @"speak";
NSString * const CarBWIconImageName = @"car";
NSString * const MenuBWIconImageName = @"choice_set";
NSString * const PhoneBWIconImageName = @"phone";
NSString * const MicrophoneBWIconImageName = @"microphone";

#pragma mark - SDL App Name in Different Languages
NSString * const ExampleAppNameSpanish = @"SDL Aplicación de ejemplo";
NSString * const ExampleAppNameFrench = @"SDL Exemple App";

#pragma mark - SDL Vehicle Data
NSString * const VehicleDataOdometerName = @"Odometer";
NSString * const VehicleDataSpeedName = @"Speed";

@implementation AppConstants

@end
