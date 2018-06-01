//  SDLImageFieldName.h
//


#import "SDLEnum.h"

/**
 The name that identifies the filed. Used in DisplayCapabilities.

 @since SmartDeviceLink 3.0
 */
typedef SDLEnum SDLImageFieldName SDL_SWIFT_ENUM;

/**
 The image field for SoftButton
 */
extern SDLImageFieldName const SDLImageFieldNameSoftButtonImage;

/**
 The first image field for Choice.
 */
extern SDLImageFieldName const SDLImageFieldNameChoiceImage;

/**
 The scondary image field for Choice.
 */
extern SDLImageFieldName const SDLImageFieldNameChoiceSecondaryImage;

/**
 The image field for vrHelpItem.
 */
extern SDLImageFieldName const SDLImageFieldNameVoiceRecognitionHelpItem;

/**
 The image field for Turn.
 */
extern SDLImageFieldName const SDLImageFieldNameTurnIcon;

/**
 The image field for the menu icon in SetGlobalProperties.
 */
extern SDLImageFieldName const SDLImageFieldNameMenuIcon;

/**
 The image filed for AddCommand.
 */
extern SDLImageFieldName const SDLImageFieldNameCommandIcon;

/**
 The image field for the app icon (set by setAppIcon).
 */
extern SDLImageFieldName const SDLImageFieldNameAppIcon;

/**
 The image filed for Show.
 */
extern SDLImageFieldName const SDLImageFieldNameGraphic;

/**
 The primary image field for ShowConstant TBT.
 */
extern SDLImageFieldName const SDLImageFieldNameShowConstantTBTIcon;

/**
 The secondary image field for ShowConstant TBT.
 */
extern SDLImageFieldName const SDLImageFieldNameShowConstantTBTNextTurnIcon;

/**
 The optional image of a destination / location

 @since SDL 4.0
 */
extern SDLImageFieldName const SDLImageFieldNameLocationImage;
