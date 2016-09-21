//  SDLFileType.h
//


#import "SDLEnum.h"

/**
 * Enumeration listing possible file types.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLFileType NS_EXTENSIBLE_STRING_ENUM;

/**
 * @abstract file type: Bitmap (BMP)
 */
extern SDLFileType const SDLFileTypeGraphicBmp;

/**
 * @abstract file type: JPEG
 */
extern SDLFileType const SDLFileTypeGraphicJpeg;

/**
 * @abstract file type: PNG
 */
extern SDLFileType const SDLFileTypeGraphicPng;

/**
 * @abstract file type: WAVE (WAV)
 */
extern SDLFileType const SDLFileTypeAudioWave;

/**
 * @abstract file type: MP3
 */
extern SDLFileType const SDLFileTypeAudioMp3;

/**
 * @abstract file type: AAC
 */
extern SDLFileType const SDLFileTypeAudioAac;

/**
 * @abstract file type: BINARY
 */
extern SDLFileType const SDLFileTypeBinary;

/**
 * @abstract file type: JSON
 */
extern SDLFileType const SDLFileTypeJson;
