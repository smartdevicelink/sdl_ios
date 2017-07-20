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
@property (copy, nonatomic, readwrite) NSString *protocolVersion;

@end


@implementation SDLControlFramePayloadRPCStartServiceAck

- (instancetype)initWithHashId:(int32_t)hashId mtu:(int64_t)mtu majorVersion:(NSUInteger)major minorVersion:(NSUInteger)minor patchVersion:(NSUInteger)patch {
    self = [super init];
    if (!self) return nil;

    _hashId = hashId;
    _mtu = mtu;
    _protocolVersion = [NSString stringWithFormat:@"%lu.%lu.%lu", major, minor, patch];

    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (!self) return nil;

    [self sdl_parse:data];

    return self;
}

- (NSData *)data {
    BsonObject payloadObject;
    bson_object_initialize_default(&payloadObject);

    bson_object_put_int32(&payloadObject, hashIdKey, self.hashId);
    bson_object_put_int64(&payloadObject, mtuKey, self.mtu);
    bson_object_put_string(&payloadObject, protocolVersionKey, (char *)self.protocolVersion.UTF8String);

    BytePtr bsonData = bson_object_to_bytes(&payloadObject);
    NSUInteger length = bson_object_size(&payloadObject);

    bson_object_deinitialize(&payloadObject);

    return [[NSData alloc] initWithBytes:bsonData length:length];
}

- (void)sdl_parse:(NSData *)data {
    BsonObject payloadObject = bson_object_from_bytes((BytePtr)data.bytes);

    self.hashId = bson_object_get_int32(&payloadObject, hashIdKey);
    self.mtu = bson_object_get_int64(&payloadObject, mtuKey);
    self.protocolVersion = [NSString stringWithUTF8String:bson_object_get_string(&payloadObject, protocolVersionKey)];

    bson_object_deinitialize(&payloadObject);
}

@end

NS_ASSUME_NONNULL_END
