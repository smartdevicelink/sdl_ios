//  SDLFileType.h
//


#import "SDLEnum.h"

/**
 * Enumeration listing possible file types. Used in SDLFile, PutFile, ImageField, OnSystemRequest
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLFileType NS_TYPED_ENUM;

/**
 * file type: Bitmap (BMP)
 */
extern SDLFileType const SDLFileTypeBMP;

/**
 * file type: JPEG
 */
extern SDLFileType const SDLFileTypeJPEG;

/**
 * file type: PNG
 */
extern SDLFileType const SDLFileTypePNG;

/**
 * file type: WAVE (WAV)
 */
extern SDLFileType const SDLFileTypeWAV;

/**
 * file type: MP3
 */
extern SDLFileType const SDLFileTypeMP3;

/**
 * file type: AAC
 */
extern SDLFileType const SDLFileTypeAAC;

/**
 * file type: BINARY
 */
extern SDLFileType const SDLFileTypeBinary;

/**
 * file type: JSON
 */
extern SDLFileType const SDLFileTypeJSON;
