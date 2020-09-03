//
//  SDLControlFramePayloadNak.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/20/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLControlFramePayloadNak.h"

#import "bson_object.h"
#import "SDLControlFramePayloadConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadNak ()

@property (copy, nonatomic, readwrite, nullable) NSArray<NSString *> *rejectedParams;
@property (copy, nonatomic, readwrite, nullable) NSString *reason;

@end

@implementation SDLControlFramePayloadNak

- (instancetype)initWithRejectedParams:(nullable NSArray<NSString *> *)rejectedParams reason:(nullable NSString *)reason {
    self = [super init];
    if (!self) return nil;

    _rejectedParams = rejectedParams;
    _reason = reason;

    return self;
}

- (instancetype)initWithData:(nullable NSData *)data {
    self = [super init];
    if (!self) return nil;

    if (data.length > 0) {
        [self sdl_parse:data];
    }

    return self;
}

- (nullable NSData *)data {
    if (self.rejectedParams == nil && self.reason == nil) {
        return nil;
    }

    BsonObject payloadObject;
    bson_object_initialize_default(&payloadObject);

    if (self.rejectedParams != nil) {
        BsonArray arrayObject;
        bson_array_initialize(&arrayObject, 512);

        for (NSString *param in self.rejectedParams) {
            bson_array_add_string(&arrayObject, (char *)param.UTF8String);
        }

        bson_object_put_array(&payloadObject, SDLControlFrameRejectedParams, &arrayObject);
    }

    if (self.reason != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameReasonKey, (char *)self.reason.UTF8String);
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

    // Pull out the reason
    char *reasonChars = bson_object_get_string(&payloadObject, SDLControlFrameReasonKey);
    if (reasonChars != NULL) {
        self.reason = [NSString stringWithUTF8String:reasonChars];
    }

    // Pull out the rejected params
    BsonArray *arrayObject = bson_object_get_array(&payloadObject, SDLControlFrameRejectedParams);
    if (arrayObject == NULL) {
        return;
    }

    NSMutableArray<NSString *> *rejectedParams = [NSMutableArray array];
    char *paramString;
    size_t index = 0;

    paramString = bson_array_get_string(arrayObject, index);
    while (paramString != NULL) {
        [rejectedParams addObject:[NSString stringWithUTF8String:paramString]];
        index++;
        paramString = bson_array_get_string(arrayObject, index);
    }

    self.rejectedParams = [rejectedParams copy];
    bson_object_deinitialize(&payloadObject);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@>: Rejected params: %@, reason: %@", NSStringFromClass(self.class), self.rejectedParams, self.reason];
}

@end

NS_ASSUME_NONNULL_END
