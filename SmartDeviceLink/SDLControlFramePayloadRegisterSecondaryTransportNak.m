//
//  SDLControlFramePayloadRegisterSecondaryTransportNak.m
//  SmartDeviceLink
//
//  Created by Sho Amano on 2018/03/16.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import "SDLControlFramePayloadRegisterSecondaryTransportNak.h"

#import "bson_object.h"
#import "SDLControlFramePayloadConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadRegisterSecondaryTransportNak ()

@property (copy, nonatomic, readwrite, nullable) NSString *reason;

@end

@implementation SDLControlFramePayloadRegisterSecondaryTransportNak

- (instancetype)initWithReason:(nullable NSString *)reason {
    self = [super init];
    if (!self) {
        return nil;
    }

    _reason = reason;

    return self;
}

- (instancetype)initWithData:(nullable NSData *)data {
    self = [super init];
    if (!self) {
        return nil;
    }

    if (data.length > 0) {
        [self sdl_parse:data];
    }

    return self;
}

- (nullable NSData *)data {
    if (self.reason == nil) {
        return nil;
    }

    BsonObject payloadObject;
    bson_object_initialize_default(&payloadObject);
    bson_object_put_string(&payloadObject, SDLControlFrameReasonKey, (char *)self.reason.UTF8String);

    BytePtr bsonData = bson_object_to_bytes(&payloadObject);
    NSUInteger length = bson_object_size(&payloadObject);

    bson_object_deinitialize(&payloadObject);

    return [[NSData alloc] initWithBytes:bsonData length:length];
}

- (void)sdl_parse:(NSData *)data {
    BsonObject payloadObject = bson_object_from_bytes((BytePtr)data.bytes);

    char *reasonString = bson_object_get_string(&payloadObject, SDLControlFrameReasonKey);
    if (reasonString != NULL) {
        self.reason = [NSString stringWithUTF8String:reasonString];
    }

    bson_object_deinitialize(&payloadObject);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@>: reason: %@", NSStringFromClass(self.class), self.reason];
}

@end

NS_ASSUME_NONNULL_END
