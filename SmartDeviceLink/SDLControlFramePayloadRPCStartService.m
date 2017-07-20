//
//  SDLControlFrameStartService.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/18/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLControlFramePayloadRPCStartService.h"

#import "bson_object.h"
#import "SDLControlFramePayloadConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadRPCStartService ()

@property (copy, nonatomic, readwrite) NSString *protocolVersion;

@end


@implementation SDLControlFramePayloadRPCStartService

- (instancetype)initWithMajorVersion:(NSUInteger)majorVersion minorVersion:(NSUInteger)minorVersion patchVersion:(NSUInteger)patchVersion {
    self = [super init];
    if (!self) return nil;

    _protocolVersion = [NSString stringWithFormat:@"%lu.%lu.%lu", majorVersion, minorVersion, patchVersion];

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

    bson_object_put_string(&payloadObject, protocolVersionKey, (char *)self.protocolVersion.UTF8String);

    BytePtr bsonData = bson_object_to_bytes(&payloadObject);
    NSUInteger length = bson_object_size(&payloadObject);

    bson_object_deinitialize(&payloadObject);

    return [[NSData alloc] initWithBytes:bsonData length:length];
}

- (void)sdl_parse:(NSData *)data {
    BsonObject payloadObject = bson_object_from_bytes((BytePtr)data.bytes);

    self.protocolVersion = [NSString stringWithUTF8String:bson_object_get_string(&payloadObject, protocolVersionKey)];

    bson_object_deinitialize(&payloadObject);
}

@end

NS_ASSUME_NONNULL_END
