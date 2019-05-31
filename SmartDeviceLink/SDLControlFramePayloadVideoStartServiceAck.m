//
//  SDLControlFramePayloadVideoStartServiceAck.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/26/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLControlFramePayloadVideoStartServiceAck.h"

#import "bson_object.h"
#import "SDLControlFramePayloadConstants.h"


@interface SDLControlFramePayloadVideoStartServiceAck ()

@property (assign, nonatomic, readwrite) int64_t mtu;
@property (assign, nonatomic, readwrite) int32_t height;
@property (assign, nonatomic, readwrite) int32_t width;
@property (copy, nonatomic, readwrite) SDLVideoStreamingProtocol videoProtocol;
@property (copy, nonatomic, readwrite) SDLVideoStreamingCodec videoCodec;

@end

@implementation SDLControlFramePayloadVideoStartServiceAck

- (instancetype)initWithMTU:(int64_t)mtu height:(int32_t)height width:(int32_t)width protocol:(nullable SDLVideoStreamingProtocol)protocol codec:(nullable SDLVideoStreamingCodec)codec {
    self = [super init];
    if (!self) return nil;

    _mtu = mtu;
    _height = height;
    _width = width;
    _videoProtocol = protocol;
    _videoCodec = codec;

    return self;
}

- (instancetype)initWithData:(nullable NSData *)data {
    self = [super init];
    if (!self) return nil;

    _mtu = SDLControlFrameInt64NotFound;
    _height = SDLControlFrameInt32NotFound;
    _width = SDLControlFrameInt32NotFound;

    if (data.length > 0) {
        [self sdl_parse:data];
    }

    return self;
}

- (nullable NSData *)data {
    if (self.mtu == SDLControlFrameInt64NotFound
        && self.height == SDLControlFrameInt32NotFound
        && self.width == SDLControlFrameInt32NotFound
        && self.videoProtocol == nil
        && self.videoCodec == nil) {
        return nil;
    }

    BsonObject payloadObject;
    bson_object_initialize_default(&payloadObject);

    if (self.mtu != SDLControlFrameInt64NotFound) {
        bson_object_put_int64(&payloadObject, SDLControlFrameMTUKey, self.mtu);
    }

    if (self.height != SDLControlFrameInt32NotFound) {
        bson_object_put_int32(&payloadObject, SDLControlFrameHeightKey, self.height);
    }

    if (self.width != SDLControlFrameInt32NotFound) {
        bson_object_put_int32(&payloadObject, SDLControlFrameWidthKey, self.width);
    }

    if (self.videoProtocol != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameVideoProtocolKey, (char *)self.videoProtocol.UTF8String);
    }

    if (self.videoCodec != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameVideoCodecKey, (char *)self.videoCodec.UTF8String);
    }

    BytePtr bsonData = bson_object_to_bytes(&payloadObject);
    NSUInteger length = bson_object_size(&payloadObject);

    bson_object_deinitialize(&payloadObject);

    return [[NSData alloc] initWithBytes:bsonData length:length];
}

- (void)sdl_parse:(NSData *)data {
    BsonObject payloadObject;
    size_t retval = bson_object_from_bytes_len(&payloadObject, (BytePtr)data.bytes, data.length);
    if (retval <= 0) {
        return;
    }

    self.mtu = bson_object_get_int64(&payloadObject, SDLControlFrameMTUKey);
    self.height = bson_object_get_int32(&payloadObject, SDLControlFrameHeightKey);
    self.width = bson_object_get_int32(&payloadObject, SDLControlFrameWidthKey);

    char *utf8String = bson_object_get_string(&payloadObject, SDLControlFrameVideoProtocolKey);
    if (utf8String != NULL) {
        self.videoProtocol = [NSString stringWithUTF8String:utf8String];
    }

    utf8String = bson_object_get_string(&payloadObject, SDLControlFrameVideoCodecKey);
    if (utf8String != NULL) {
        self.videoCodec = [NSString stringWithUTF8String:utf8String];
    }

    bson_object_deinitialize(&payloadObject);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@>: MTU: %lld, Width: %d, Height: %d, Protocol: %@, Codec: %@", NSStringFromClass(self.class), self.mtu, self.width, self.height, self.videoProtocol, self.videoCodec];
}

@end
