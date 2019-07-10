//
//  SDLControlFramePayloadAudioStartServiceAck.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLControlFramePayloadAudioStartServiceAck.h"

#import "bson_object.h"
#import "SDLControlFramePayloadConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadAudioStartServiceAck ()

@property (assign, nonatomic, readwrite) int64_t mtu;

@end

@implementation SDLControlFramePayloadAudioStartServiceAck

- (instancetype)initWithMTU:(int64_t)mtu {
    self = [super init];
    if (!self) return nil;

    _mtu = mtu;

    return self;
}

- (instancetype)initWithData:(nullable NSData *)data {
    self = [super init];
    if (!self) return nil;

    _mtu = SDLControlFrameInt64NotFound;

    if (data.length > 0) {
        [self sdl_parse:data];
    }

    return self;
}

- (nullable NSData *)data {
    if (self.mtu == SDLControlFrameInt64NotFound) {
        return nil;
    }

    BsonObject payloadObject;
    bson_object_initialize_default(&payloadObject);

    if (self.mtu != SDLControlFrameInt64NotFound) {
        bson_object_put_int64(&payloadObject, SDLControlFrameMTUKey, self.mtu);
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

    bson_object_deinitialize(&payloadObject);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@>: MTU: %lld", NSStringFromClass(self.class), self.mtu];
}

@end

NS_ASSUME_NONNULL_END
