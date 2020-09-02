//
//  SDLGetFile.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"
#import "SDLFileType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  This request is sent to the module to retrieve a file.
 */
@interface SDLGetFile : SDLRPCRequest

/**
 *  Convenience init for required parameters.
 *
 *  @param fileName     File name that should be retrieved.
 *  @return             A SDLGetFile object
 */
- (instancetype)initWithFileName:(NSString *)fileName;

/**
 *  Convenience init for sending a small file.
 *
 *  @param fileName     File name that should be retrieved.
 *  @param appServiceId ID of the service that should have uploaded the requested file
 *  @param fileType     Selected file type
 *  @return             A SDLGetFile object
 */
- (instancetype)initWithFileName:(NSString *)fileName appServiceId:(nullable NSString *)appServiceId fileType:(nullable SDLFileType)fileType;

/**
 *  Convenience init for sending a large file in multiple data chunks.
 *
 *  @param fileName     File name that should be retrieved.
 *  @param appServiceId ID of the service that should have uploaded the requested file
 *  @param fileType     Selected file type
 *  @param offset       Offset in bytes for resuming partial data chunks
 *  @param length       Length in bytes for resuming partial data chunks
 *  @return             A SDLGetFile object
 */
- (instancetype)initWithFileName:(NSString *)fileName appServiceId:(nullable NSString *)appServiceId fileType:(nullable SDLFileType)fileType offset:(UInt32)offset length:(UInt32)length;

/**
 *  File name that should be retrieved.
 *
 *  String, Required, Max string length 255 chars
 */
@property (strong, nonatomic) NSString *fileName;

/**
 *  ID of the service that should have uploaded the requested file.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *appServiceId;

/**
 *  Selected file type.
 *
 *  SDLFileType, Optional
 */
@property (nullable, strong, nonatomic) SDLFileType fileType;

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

@end

NS_ASSUME_NONNULL_END
