//  SDLImageType.h
//


#import "SDLEnum.h"

/**
 Contains information about the type of image. Used in Image.

 @since SDL 2.0
 */
typedef SDLEnum SDLImageType NS_TYPED_ENUM;

/**
 Activate an icon that shipped with the IVI system by passing a hex value.
 */
extern SDLImageType const SDLImageTypeStatic;

/**
 An icon referencing an image uploaded by the app (identifier to be sent by SDLPutFile)

 @see SDLPutFile
 */
extern SDLImageType const SDLImageTypeDynamic;
