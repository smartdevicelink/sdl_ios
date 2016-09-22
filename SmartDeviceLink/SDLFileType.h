//  SDLFileType.h
//


#import "SDLEnum.h"

/**
 * Enumeration listing possible file types.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLFileType NS_STRING_ENUM;

/**
 * @abstract file type: Bitmap (BMP)
 */
extern SDLFileType const SDLFileTypeGraphicBMP;

/**
 * @abstract file type: JPEG
 */
extern SDLFileType const SDLFileTypeGraphicJPEG;

/**
 * @abstract file type: PNG
 */
extern SDLFileType const SDLFileTypeGraphicPNG;

/**
 * @abstract file type: WAVE (WAV)
 */
extern SDLFileType const SDLFileTypeAudioWAV;

/**
 * @abstract file type: MP3
 */
extern SDLFileType const SDLFileTypeAudioMP3;

/**
 * @abstract file type: AAC
 */
extern SDLFileType const SDLFileTypeAudioAAC;

/**
 * @abstract file type: BINARY
 */
extern SDLFileType const SDLFileTypeBinary;

/**
 * @abstract file type: JSON
 */
extern SDLFileType const SDLFileTypeJSON;
