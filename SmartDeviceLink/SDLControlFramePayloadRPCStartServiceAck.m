//
//  SDLControlFramePayloadStartServiceAck.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/20/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLControlFramePayloadRPCStartServiceAck.h"

#import "bson_object.h"
#import "SDLControlFramePayloadConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadRPCStartServiceAck ()

@property (assign, nonatomic, readwrite) int32_t hashId;
@property (assign, nonatomic, readwrite) int64_t mtu;
@property (copy, nonatomic, readwrite, nullable) NSString *protocolVersion;

@end


@implementation SDLControlFramePayloadRPCStartServiceAck

- (instancetype)initWithHashId:(int32_t)hashId mtu:(int64_t)mtu protocolVersion:(nullable NSString *)protocolVersion {
    self = [super init];
    if (!self) return nil;

    _hashId = hashId;
    _mtu = mtu;
    _protocolVersion = protocolVersion;

    return self;
}

- (instancetype)initWithData:(nullable NSData *)data {
    self = [super init];
    if (!self) return nil;

    _hashId = SDLControlFrameInt32NotFound;
    _mtu = SDLControlFrameInt64NotFound;

    if (data.length > 0) {
        [self sdl_parse:data];
    }

    return self;
}

- (nullable NSData *)data {
    if (self.hashId == SDLControlFrameInt32NotFound
        && self.mtu == SDLControlFrameInt64NotFound
        && self.protocolVersion == nil) {
        return nil;
    }

    BsonObject payloadObject;
    bson_object_initialize_default(&payloadObject);

    if (self.hashId != SDLControlFrameInt32NotFound) {
        bson_object_put_int32(&payloadObject, SDLControlFrameHashIdKey, self.hashId);
    }

    if (self.mtu != SDLControlFrameInt64NotFound) {
        bson_object_put_int64(&payloadObject, SDLControlFrameMTUKey, self.mtu);
    }

    if (self.protocolVersion != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameProtocolVersionKey, (char *)self.protocolVersion.UTF8String);
    }

    BytePtr bsonData = bson_object_to_bytes(&payloadObject);
    NSUInteger length = bson_object_size(&payloadObject);

    bson_object_deinitialize(&payloadObject);

    return [[NSData alloc] initWithBytes:bsonData length:length];
}

- (void)sdl_parse:(NSData *)data {
    BsonObject payloadObject = bson_object_from_bytes((BytePtr)data.bytes);

    self.hashId = bson_object_get_int32(&payloadObject, SDLControlFrameHashIdKey);
    self.mtu = bson_object_get_int64(&payloadObject, SDLControlFrameMTUKey);

    char *utf8String = bson_object_get_string(&payloadObject, SDLControlFrameProtocolVersionKey);
    if (utf8String != NULL) {
        self.protocolVersion = [NSString stringWithUTF8String:utf8String];
    }

    bson_object_deinitialize(&payloadObject);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@>: Protocol Version: %@, hash id: %d, MTU: %lld", NSStringFromClass(self.class), self.protocolVersion, self.hashId, self.mtu];
}

@end

NS_ASSUME_NONNULL_END
