//
//  AppConstants.h
//  SmartDeviceLink
//
//  Created by Nicole on 4/10/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - SDL Setup
extern NSString * const ExampleAppName;
extern NSString * const ExampleAppNameShort;
extern NSString * const ExampleAppNameTTS;
extern NSString * const ExampleAppId;

#pragma mark - Text
extern NSString * const SmartDeviceLinkText;
extern NSString * const ExampleAppText;

#pragma mark - SDL Soft Buttons
extern NSString * const HexagonSoftButton;
extern NSString * const HexagonSoftButtonImageOnState;
extern NSString * const HexagonSoftButtonImageOffState;
extern NSString * const HexagonSoftButtonTextOnState;
extern NSString * const HexagonSoftButtonTextOffState;
extern NSString * const HexagonSoftButtonTextTextOnText;
extern NSString * const HexagonSoftButtonTextTextOffText;

extern NSString * const StarSoftButton;
extern NSString * const StarSoftButtonImageState;
extern NSString * const StarSoftButtonTextState;
extern NSString * const StarSoftButtonText;

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

#pragma mart - SDL Text-To-Speech
extern NSString * const TTSGoodJob;
extern NSString * const TTSYouMissed;

#pragma mark - SDL Perform Interaction Choice Set Menu
extern NSString * const PICSInitialText;
extern NSString * const PICSInitialPrompt;
extern NSString * const PICSHelpPrompt;
extern NSString * const PICSTimeoutPrompt;
extern NSString * const PICSFirstChoice;
extern NSString * const PICSSecondChoice;
extern NSString * const PICSThirdChoice;

#pragma mark - SDL Add Command Menu
extern NSString * const ACSpeakAppNameMenuName;
extern NSString * const ACShowChoiceSetMenuName;
extern NSString * const ACGetVehicleDataMenuName;

#pragma mark - SDL Image Names
extern NSString * const ExampleAppLogoName;
extern NSString * const StarImageName;
extern NSString * const HexagonOffImageName;
extern NSString * const HexagonOnImageName;

@interface AppConstants : NSObject

@end

NS_ASSUME_NONNULL_END
