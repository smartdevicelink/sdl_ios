//  SDLPutFile.h
//

#import "SDLRPCRequest.h"

@class SDLFileType;


/**
 * Used to push a binary data onto the SDL module from a mobile device, such as
 * icons and album art
 *
 * Since SmartDeviceLink 2.0
 * @see SDLDeleteFile
 * @see SDLListFiles
 */
@interface SDLPutFile : SDLRPCRequest {
}

/**
 * Constructs a new SDLPutFile object
 */
- (instancetype)init;

/**
 * Constructs a new SDLPutFile object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType *)fileType;

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType *)fileType persistentFile:(BOOL)persistentFile;

- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType *)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt64)offset length:(UInt64)length;

/**
 * A file reference name
 *
 * Required, maxlength 255 characters
 */
@property (strong) NSString *syncFileName;

/**
 * A FileType value representing a selected file type
 *
 * Required
 */
@property (strong) SDLFileType *fileType;

/**
 * A value to indicates if the file is meant to persist between
 * sessions / ignition cycles. If set to TRUE, then the system will aim to
 * persist this file through session / cycles. While files with this
 * designation will have priority over others, they are subject to deletion
 * by the system at any time. In the event of automatic deletion by the
 * system, the app will receive a rejection and have to resend the file. If
 * omitted, the value will be set to false
 *
 * Boolean, Optional, default = NO
 */
@property (strong) NSNumber *persistentFile;

/**
 * Indicates if the file is meant to be passed through core to elsewhere on the system. If set to TRUE, then the system will instead pass the data thru as it arrives to a predetermined area outside of core.
 *
 * Boolean, Optional, default = NO
 */
@property (strong) NSNumber *systemFile;

/**
 * Offset in bytes for resuming partial data chunks.
 *
 * Integer, Optional, 0 - 100,000,000,000
 */
@property (strong) NSNumber *offset;

/**
 * Length in bytes for resuming partial data chunks. If offset is set to 0, then length is the total length of the file to be downloaded
 *
 * Integer, Optional, 0 - 100,000,000,000
 */
@property (strong) NSNumber *length;

@end
