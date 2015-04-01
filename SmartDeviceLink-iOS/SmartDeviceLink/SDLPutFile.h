//  SDLPutFile.h
//

#import "SDLRPCRequest.h"

@class SDLFileType;


/**
 * @abstract Used to push a binary data onto the SDL module from a mobile device, such as
 * icons and album art
 * <p>
 *
 * Since SmartDeviceLink 2.0<br/>
 * See DeleteFile ListFiles
 */
@interface SDLPutFile : SDLRPCRequest {}
/**
 * @abstract Constructs a new SDLPutFile object
 */
-(instancetype) init;
/**
 * @abstract Constructs a new SDLPutFile object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;
/**
 * @abstract A file reference name
 *            <br/><b>Notes: </b>Maxlength=500
 */
@property(strong) NSString* syncFileName;
/**
 * @abstract A FileType value representing a selected file type
 */
@property(strong) SDLFileType* fileType;
/**
 * @abstract A value to indicates if the file is meant to persist between
 * sessions / ignition cycles. If set to TRUE, then the system will aim to
 * persist this file through session / cycles. While files with this
 * designation will have priority over others, they are subject to deletion
 * by the system at any time. In the event of automatic deletion by the
 * system, the app will receive a rejection and have to resend the file. If
 * omitted, the value will be set to false
 */
@property(strong) NSNumber* persistentFile;
/**
 * @abstract Indicates if the file is meant to be passed thru core to elsewhere on the system.
 If set to TRUE, then the system will instead pass the data thru as it arrives to a predetermined area outside of core.
 If omitted, the value will be set to false.
 */
@property(strong) NSNumber* systemFile;
/**
 * @abstract Optional offset in bytes for resuming partial data chunks.
 */
@property(strong) NSNumber* offset;
/**
 * @abstract Optional length in bytes for resuming partial data chunks
 */
@property(strong) NSNumber* length;
@end
