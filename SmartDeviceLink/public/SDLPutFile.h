/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "SDLRPCRequest.h"

#import "SDLFileType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Used to push a binary data onto the SDL module from a mobile device, such as icons and album art.
 *
 *  Since SmartDeviceLink 2.0
 *  @see SDLDeleteFile, SDLListFiles
 */
@interface SDLPutFile : SDLRPCRequest

/**
 * @param sdlFileName - sdlFileName
 * @param fileType - fileType
 * @return A SDLPutFile object
 */
- (instancetype)initWithSdlFileName:(NSString *)sdlFileName fileType:(SDLFileType)fileType;

/**
 * @param sdlFileName - sdlFileName
 * @param fileType - fileType
 * @param persistentFile - persistentFile
 * @param systemFile - systemFile
 * @param offset - offset
 * @param length - length
 * @param crc - crc
 * @return A SDLPutFile object
 */
- (instancetype)initWithSdlFileName:(NSString *)sdlFileName fileType:(SDLFileType)fileType persistentFile:(nullable NSNumber<SDLBool> *)persistentFile systemFile:(nullable NSNumber<SDLBool> *)systemFile offset:(nullable NSNumber<SDLUInt> *)offset length:(nullable NSNumber<SDLUInt> *)length crc:(nullable NSNumber<SDLUInt> *)crc;

/**
 *  Convenience init for creating a putfile with a name and file format.
 *
 *  @param fileName    The file's name
 *  @param fileType    The file's format
 *  @return            A SDLPutFile object
 */
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType __deprecated_msg("Use initWithSdlFileName:fileType: instead");

/**
 *  Convenience init for creating a putfile with a name, file format, and persistance.
 *
 *  @param fileName         The file's name
 *  @param fileType         The file's format
 *  @param persistentFile   Whether or not the image should persist between ignition cycles
 *  @return                 A SDLPutFile object
 */
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile __deprecated_msg("Use initWithSdlFileName:fileType: instead");

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
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length crc:(UInt64)crc __deprecated_msg("Use initWithSdlFileName:fileType: instead");

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
- (instancetype)initWithFileName:(NSString *)fileName fileType:(SDLFileType)fileType persistentFile:(BOOL)persistentFile systemFile:(BOOL)systemFile offset:(UInt32)offset length:(UInt32)length bulkData:(NSData *)bulkData __deprecated_msg("Use initWithSdlFileName:fileType: instead");

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
