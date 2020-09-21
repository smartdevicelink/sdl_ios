//  SDLSoftButtonType.h
//


#import "SDLEnum.h"

/**
 SoftButtonType (TEXT / IMAGE / BOTH). Used by SoftButton.
 */
typedef SDLEnum SDLSoftButtonType NS_TYPED_ENUM;

/**
 Text kind Softbutton
 */
extern SDLSoftButtonType const SDLSoftButtonTypeText;

/**
 Image kind Softbutton
 */
extern SDLSoftButtonType const SDLSoftButtonTypeImage;

/**
 Both (Text & Image) kind Softbutton
 */
extern SDLSoftButtonType const SDLSoftButtonTypeBoth;
