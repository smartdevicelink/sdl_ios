//
//  SDLSecurityQueryPayload.h
//  SmartDeviceLink
//
//  Created by Frank Elias on 7/28/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLRPCMessageType.h"

typedef NS_ENUM(Byte, SDLSecurityQueryType) {
    /// A request that will require a response
    SDLSecurityQueryTypeRequest = 0x00,

    /// A response to a request
    SDLSecurityQueryTypeResponse = 0x10,

    /// A message that does not have a response
    SDLSecurityQueryTypeNotification = 0x20
};

typedef NS_ENUM(UInt32, SDLSecurityQueryId) {
    /// Send handshake data
    SDLSecurityQueryIdSendHandshake = 0x000001,

    /// Send internal error
    SDLSecurityQueryIdSendInternalError = 0x000002,
};

NS_ASSUME_NONNULL_BEGIN

@interface SDLSecurityQueryPayload : NSObject

@property (assign, nonatomic) SDLSecurityQueryType queryType;
@property (assign, nonatomic) UInt32 queryID;
@property (assign, nonatomic) UInt32 sequenceNumber;
@property (nullable, strong, nonatomic) NSData *jsonData;
@property (nullable, strong, nonatomic) NSData *binaryData;

- (NSData *)data;
+ (nullable id)securityPayloadWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
