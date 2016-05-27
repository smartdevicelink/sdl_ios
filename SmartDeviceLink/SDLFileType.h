//  SDLFileType.h
//


#import "SDLEnum.h"

/**
 * Enumeration listing possible file types.
 *
 * @since SDL 2.0
 */
@interface SDLFileType : SDLEnum {
}

/**
 * @abstract Convert String to SDLFileType
 *
 * @param value String value to retrieve the object for
 *
 * @return SDLFileType
 */
+ (SDLFileType *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLFileType
 *
 * @return an array that store all possible SDLFileType
 */
+ (NSArray *)values;

/**
 * @abstract file type: Bitmap (BMP)
 *
 * @return SDLFileType with value of *GRAPHIC_BMP*
 */
+ (SDLFileType *)GRAPHIC_BMP;

/**
 * @abstract file type: JPEG
 *
 * @return SDLFileType with value of *GRAPHIC_JPEG*
 */
+ (SDLFileType *)GRAPHIC_JPEG;

/**
 * @abstract file type: PNG
 *
 * @return SDLFileType with value of *GRAPHIC_PNG*
 */
+ (SDLFileType *)GRAPHIC_PNG;

/**
 * @abstract file type: WAVE (WAV)
 *
 * @return SDLFileType with value of *AUDIO_WAVE*
 */
+ (SDLFileType *)AUDIO_WAVE;

/**
 * @abstract file type: MP3
 *
 * @return SDLFileType with value of *AUDIO_MP3*
 */
+ (SDLFileType *)AUDIO_MP3;

/**
 * @abstract file type: AAC
 *
 * @return SDLFileType with value of *AUDIO_AAC*
 */
+ (SDLFileType *)AUDIO_AAC;

/**
 * @abstract file type: BINARY
 *
 * @return SDLFileType with value of *BINARY*
 */
+ (SDLFileType *)BINARY;

/**
 * @abstract file type: JSON
 *
 * @return SDLFileType with value of *JSON*
 */
+ (SDLFileType *)JSON;

@end
