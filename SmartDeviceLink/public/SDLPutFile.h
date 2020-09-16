//  SDLPutFile.h
//

#import "SDLRPCRequest.h"

#import "SDLFileType.h"

/**
 *  Used to push a binary data onto the SDL module from a mobile device, such as icons and album art.
 *
 *  Since SmartDeviceLink 2.0
 *  @see SDLDeleteFile, SDLListFiles
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLPutFile : SDLRPCRequest

/**
 *  Init
 *
 *  @return A SDLPutFile object
 */
- (instancetype)init;

/**
 *  Convenience init for creating a putfile with a name and file format.
 *
 *  @param fileName    The file's name
 *  @param fileType    The file's format
 *  @return            A SDLPutFile object
 */
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType;

/**
 *  Convenience init for creating a putfile with a name, file format, and persistance.
 *
 *  @param fileName         The file's name
 *  @param fileType         The file's format
 *  @param persistentFile   Whether or not the image should persist between ignition cycles
 *  @return                 A SDLPutFile object
 */
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile;

/**
 *  Convenience init for creating a putfile that is part of a multiple frame payload.
 *
 *  @param fileName         The file's name
 *  @param fileType         The file's format
 *  @param persistentFile   Whether or not the image should persist between ignition cycles
 *  @param systemFile       Whether or not the file is meant to be passed through Core to elsewhere on the system
 *  @param offset           Offset in bytes for resuming partial data chunks
 *  @param length           Length in bytes for resuming partial data chunks
 *  @return                 A SDLPutFile object
 */
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length __deprecated_msg("Use initWithFileName:fileType:persistentFile:systemFile:offset:length:crc: instead");

/**
 *  Convenience init for creating a putfile that is part of a multiple frame payload.
 *
 *  @param fileName         The file's name
 *  @param fileType         The file's format
 *  @param persistentFile   Whether or not the image should persist between ignition cycles
 *  @param systemFile       Whether or not the file is meant to be passed through Core to elsewhere on the system
 *  @param offset           Offset in bytes for resuming partial data chunks
 *  @param length           Length in bytes for resuming partial data chunks
 *  @param crc              Checksum of the bulk data. Used by Core to check data integrity
 *  @return                 A SDLPutFile object
 */
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length crc:(UInt64)crc;

/**
 *  Convenience init for creating a putfile that is part of a multiple frame payload. A CRC checksum is calculated for the bulk data.
 *
 *  @param fileName         The file's name
 *  @param fileType         The file's format
 *  @param persistentFile   Whether or not the image should persist between ignition cycles
 *  @param systemFile       Whether or not the file is meant to be passed through Core to elsewhere on the system
 *  @param offset           Offset in bytes for resuming partial data chunks
 *  @param length           Length in bytes for resuming partial data chunks
 *  @param bulkData         Data being sent in the putfile
 *  @return                 A SDLPutFile object
 */
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length bulkData:(NSData *)bulkData;

/**
 *  File reference name
 *
 *  Required, max length 255 characters
 */
@property (strong, nonatomic) NSString *syncFileName __deprecated_msg("use sdlFileName instead");

/**
*  File reference name
*
*  Required, max length 255 characters
*/
@property (strong, nonatomic) NSString *sdlFileName;

/**
 *  A FileType value representing a selected file type
 *
 *  Required
 */
@property (strong, nonatomic) SDLFileType fileType;

/**
 *  A value to indicates if the file is meant to persist between sessions / ignition cycles. If set to TRUE, then the system will aim to persist this file through session / cycles. While files with this designation will have priority over others, they are subject to deletion by the system at any time. In the event of automatic deletion by the system, the app will receive a rejection and have to resend the file. If omitted, the value will be set to false.
 *
 *  Boolean, Optional, default = NO
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *persistentFile;

/**
 *  Indicates if the file is meant to be passed through core to elsewhere on the system. If set to TRUE, then the system will instead pass the data thru as it arrives to a predetermined area outside of core.
 *
 *  Boolean, Optional, default = NO
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *systemFile;

/**
 *  Offset in bytes for resuming partial data chunks.
 *
 *  Integer, Optional, 0 - 100,000,000,000
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *offset;

/**
 *  Length in bytes for resuming partial data chunks. If offset is set to 0, then length is the total length of the file to be downloaded
 *
 *  Integer, Optional, 0 - 100,000,000,000
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *length;

/**
 *  Additional CRC32 checksum to protect data integrity up to 512 Mbits.
 *
 *  Integer, Optional, 0 - 4,294,967,295
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *crc;

@end

NS_ASSUME_NONNULL_END
