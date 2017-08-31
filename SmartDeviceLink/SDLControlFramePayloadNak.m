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

@end

@implementation SDLControlFramePayloadNak

- (instancetype)initWithRejectedParams:(nullable NSArray<NSString *> *)rejectedParams {
    self = [super init];
    if (!self) return nil;

    _rejectedParams = rejectedParams;

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
    if (self.rejectedParams == nil) {
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

    BytePtr bsonData = bson_object_to_bytes(&payloadObject);
    NSUInteger length = bson_object_size(&payloadObject);

    bson_object_deinitialize(&payloadObject);

    return [[NSData alloc] initWithBytes:bsonData length:length];
}

- (void)sdl_parse:(NSData *)data {
    BsonObject payloadObject = bson_object_from_bytes((BytePtr)data.bytes);
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
    return [NSString stringWithFormat:@"<%@>: Rejected params: %@", NSStringFromClass(self.class), self.rejectedParams];
}

@end

NS_ASSUME_NONNULL_END
