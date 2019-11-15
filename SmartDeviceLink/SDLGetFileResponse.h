//
//  SDLGetFileResponse.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"

#import "SDLFileType.h"

NS_ASSUME_NONNULL_BEGIN

/// Response to GetFiles
///
/// @since RPC 5.1
@interface SDLGetFileResponse : SDLRPCResponse

/**
 *  Convenience init for all parameters.
 *
 *  @param offset      Optional offset in bytes for resuming partial data chunks
 *  @param length      Optional length in bytes for resuming partial data chunks. If offset is set to 0, then length is the total length of the file to be downloaded
 *  @param fileType    File type that is being sent in response
 *  @param crc         Additional CRC32 checksum to protect data integrity up to 512 Mbits
 *  @return            A SDLGetFileResponse object
 */
- (instancetype)initWithOffset:(UInt32)offset length:(UInt32)length fileType:(nullable SDLFileType)fileType crc:(UInt32)crc;

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
