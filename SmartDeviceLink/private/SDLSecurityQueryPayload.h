//
//  SDLSecurityQueryPayload.h
//  SmartDeviceLink
//
//  Created by Frank Elias on 7/28/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLRPCMessageType.h"

/// Enum for different SDL security query types
typedef NS_ENUM(Byte, SDLSecurityQueryType) {
    /// A request that will require a response
    SDLSecurityQueryTypeRequest = 0x00,

    /// A response to a request
    SDLSecurityQueryTypeResponse = 0x10,

    /// A message that does not have a response
    SDLSecurityQueryTypeNotification = 0x20,

    /// An invalid query Type
    SDLSecurityQueryTypeInvalid = 0xFF
};

/// Enum for each type of SDL security query IDs
typedef NS_ENUM(UInt32, SDLSecurityQueryId) {
    /// Send handshake data
    SDLSecurityQueryIdSendHandshake = 0x000001,

    /// Send internal error
    SDLSecurityQueryIdSendInternalError = 0x000002,

    /// Invalid query id
    SDLSecurityQueryIdInvalid = 0xFFFFFF
};

NS_ASSUME_NONNULL_BEGIN

@interface SDLSecurityQueryPayload : NSObject

/// The security query's type, could be of type request, response, or notification
@property (assign, nonatomic) SDLSecurityQueryType queryType;

/// The security query's ID.
@property (assign, nonatomic) SDLSecurityQueryId queryID;

/// The message ID is set by the Mobile libraries to track security messages.
@property (assign, nonatomic) UInt32 sequenceNumber;

/// The JSON data following the binary query header.
@property (nullable, strong, nonatomic) NSData *jsonData;

/// The binary data that is after the header (96 bits) and the JSON data.
@property (nullable, strong, nonatomic) NSData *binaryData;

/// Create a security query object from raw data
/// @param data The data to convert into an SDLSecurityQueryPayload object
/// @return The SDLSecurityQueryPayload object, or nil if the data is malformed
- (nullable instancetype)initWithData:(NSData *)data;

/// Create a security query object from security query properties
/// @param queryType The security query type to be sent
/// @param queryID The security query ID
/// @param sequenceNumber The security query sequence number
/// @param jsonData The JSON data to be set in the security query
/// @param binaryData The binary data that's after the header and the JSON data
/// @return The SDLSecurityQueryPayload non-nullable object
- (instancetype)initWithQueryType:(SDLSecurityQueryType)queryType queryID:(SDLSecurityQueryId)queryID sequenceNumber:(UInt32)sequenceNumber jsonData:(nullable NSData *)jsonData binaryData:(nullable NSData *)binaryData;

/// Create a security query object from raw data
/// @param data The data to convert into an SDLSecurityQueryPayload object
/// @return The SDLSecurityQueryPayload object, or nil if the data is malformed
+ (nullable id)securityPayloadWithData:(NSData *)data;

/// Convert the object into raw NSData
/// @return The raw NSData of the object
- (NSData *)convertToData;

@end

NS_ASSUME_NONNULL_END
