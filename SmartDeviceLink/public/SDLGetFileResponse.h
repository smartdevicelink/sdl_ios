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

#import "SDLRPCResponse.h"

#import "SDLFileType.h"

NS_ASSUME_NONNULL_BEGIN

/// Response to GetFiles
///
/// @since RPC 5.1
@interface SDLGetFileResponse : SDLRPCResponse

/**
 * @param offset - offset
 * @param length - length
 * @param fileType - fileType
 * @param crc - crc
 * @return A SDLGetFileResponse object
 */
- (instancetype)initWithOffsetParam:(nullable NSNumber<SDLUInt> *)offset length:(nullable NSNumber<SDLUInt> *)length fileType:(nullable SDLFileType)fileType crc:(nullable NSNumber<SDLUInt> *)crc __deprecated_msg("This will eventually be replaced with a non-param version");

/**
 *  Convenience init for all parameters.
 *
 *  @param offset      Optional offset in bytes for resuming partial data chunks
 *  @param length      Optional length in bytes for resuming partial data chunks. If offset is set to 0, then length is the total length of the file to be downloaded
 *  @param fileType    File type that is being sent in response
 *  @param crc         Additional CRC32 checksum to protect data integrity up to 512 Mbits
 *  @return            A SDLGetFileResponse object
 */
- (instancetype)initWithOffset:(UInt32)offset length:(UInt32)length fileType:(nullable SDLFileType)fileType crc:(UInt32)crc __deprecated_msg("This will eventually be replaced with a similar initializer with different parameter types");

/**
 *  Optional offset in bytes for resuming partial data chunks.
 *
 *  Integer, Optional, minvalue="0" maxvalue="2000000000"
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *offset;

/**
 *  Optional length in bytes for resuming partial data chunks. If offset is set to 0, then length is the total length of the file to be downloaded.
 *
 *  Integer, Optional, minvalue="0" maxvalue="2000000000"
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *length;

/**
 *  File type that is being sent in response.
 *
 *  SDLFileType, Optional
 */
@property (nullable, strong, nonatomic) SDLFileType fileType;

/**
 *  Additional CRC32 checksum to protect data integrity up to 512 Mbits.
 *
 *  Integer, Optional, minvalue="0" maxvalue="4294967295"
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *crc;

@end

NS_ASSUME_NONNULL_END
