//
//  SDLSecurityQueryPayload.h
//  SmartDeviceLink
//
//  Created by Frank Elias on 7/28/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLRPCMessageType.h"

/**
 * Enum for different SDL security query types
 */
typedef NS_ENUM(Byte, SDLSecurityQueryType) {
    /// A request that will require a response
    SDLSecurityQueryTypeRequest = 0x00,

    /// A response to a request
    SDLSecurityQueryTypeResponse = 0x10,

    /// A message that does not have a response
    SDLSecurityQueryTypeNotification = 0x20
};

/**
 * Enum for each type of SDL security query IDs
 */
typedef NS_ENUM(NSUInteger, SDLSecurityQueryId) {
    /// Send handshake data
    SDLSecurityQueryIdSendHandshake = 0x000001,

    /// Send internal error
    SDLSecurityQueryIdSendInternalError = 0x000002,
};

NS_ASSUME_NONNULL_BEGIN

@interface SDLSecurityQueryPayload : NSObject

/**
 The security query's type, could be of type request - response or notification
 */
@property (assign, nonatomic) SDLSecurityQueryType queryType;

/**
 The security query's ID.
 */
@property (assign, nonatomic) UInt32 queryID;

/**
 The message ID is set by the Mobile libraries to track security messages.
 */
@property (assign, nonatomic) UInt32 sequenceNumber;

/**
 The JSON data following the binary query header.
 */
@property (nullable, strong, nonatomic) NSData *jsonData;

/**
 The binary data that is after the header (96 bits) and the JSON data.
 */
@property (nullable, strong, nonatomic) NSData *binaryData;

+ (nullable id)securityPayloadWithData:(NSData *)data;
- (nullable instancetype)initWithData:(NSData *)data;
- (NSData *)data;

@end

NS_ASSUME_NONNULL_END
