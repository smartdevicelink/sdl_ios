//  SDLSoftButtonType.h
//


#import "SDLEnum.h"

/**
 SoftButtonType (TEXT / IMAGE / BOTH)
 */
typedef SDLEnum SDLSoftButtonType NS_STRING_ENUM;

/**
 @abstract Text kind Softbutton
 */
extern SDLSoftButtonType const SDLSoftButtonTypeText;

/**
 @abstract Image kind Softbutton
 */
extern SDLSoftButtonType const SDLSoftButtonTypeImage;

/**
 @abstract Both (Text & Image) kind Softbutton
 */
extern SDLSoftButtonType const SDLSoftButtonTypeBoth;
