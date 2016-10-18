//  SDLImageType.h
//


#import "SDLEnum.h"

/**
* Contains information about the type of image.
*
* @since SDL 2.0
*/
SDLEnum(SDLImageType);

/**
 * @abstract Just the static hex icon value to be used
 */
extern SDLImageType const SDLImageTypeStatic;

/**
 * @abstract Binary image file to be used (identifier to be sent by SDLPutFile)
 *
 * @see SDLPutFile
 */
extern SDLImageType const SDLImageTypeDynamic;
