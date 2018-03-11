//
//  SDLControlFramePayloadTransportEventUpdate.m
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 2018/03/05.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import "SDLControlFramePayloadTransportEventUpdate.h"

#import "bson_object.h"
#import "SDLControlFramePayloadConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadTransportEventUpdate ()

/// A string representing IP address of Core's TCP transport. It can be either IPv4 or IPv6 address.
@property (copy, nonatomic, readwrite, nullable) NSString *tcpIpAddress;
/// TCP port number that Core is listening on
@property (assign, nonatomic, readwrite) int32_t tcpPort;

@end

@implementation SDLControlFramePayloadTransportEventUpdate

- (instancetype)initWithTcpIpAddress:(nullable NSString *)tcpIpAddress tcpPort:(int32_t)tcpPort {
    self = [super init];
    if (!self) {
        return nil;
    }

    _tcpIpAddress = tcpIpAddress;
    if (tcpPort >= 0 && tcpPort <= 65535) {
        _tcpPort = tcpPort;
    } else {
        _tcpPort = SDLControlFrameInt32NotFound;
    }

    return self;
}

- (instancetype)initWithData:(nullable NSData *)data {
    self = [super init];
    if (!self) {
        return nil;
    }

    _tcpPort = SDLControlFrameInt32NotFound;

    if (data.length > 0) {
        [self sdl_parse:data];
    }

    return self;
}

- (nullable NSData *)data {
    if (self.tcpIpAddress == nil && self.tcpPort == SDLControlFrameInt32NotFound) {
        return nil;
    }

    BsonObject payloadObject;
    bson_object_initialize_default(&payloadObject);

    if (self.tcpIpAddress != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameTCPIPAddressKey, (char *)self.tcpIpAddress.UTF8String);
    }
    if (self.tcpPort != SDLControlFrameInt32NotFound) {
        bson_object_put_int32(&payloadObject, SDLControlFrameTCPPortKey, self.tcpPort);
    }

    BytePtr bsonData = bson_object_to_bytes(&payloadObject);
    NSUInteger length = bson_object_size(&payloadObject);

    bson_object_deinitialize(&payloadObject);

    return [[NSData alloc] initWithBytes:bsonData length:length];
}

- (void)sdl_parse:(NSData *)data {
    BsonObject payloadObject = bson_object_from_bytes((BytePtr)data.bytes);

    char *utf8String = bson_object_get_string(&payloadObject, SDLControlFrameTCPIPAddressKey);
    if (utf8String != NULL) {
        self.tcpIpAddress = [NSString stringWithUTF8String:utf8String];
    }
    self.tcpPort = bson_object_get_int32(&payloadObject, SDLControlFrameTCPPortKey);

    bson_object_deinitialize(&payloadObject);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@>: TCP IP address: %@, TCP port: %d", NSStringFromClass(self.class), self.tcpIpAddress, self.tcpPort];
}

@end

NS_ASSUME_NONNULL_END
