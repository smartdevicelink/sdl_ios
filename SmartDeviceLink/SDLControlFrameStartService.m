//
//  SDLControlFrameStartService.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/18/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLControlFrameStartService.h"

#import "bson_object.h"

char *const versionKey = "protocolVersion";

@interface SDLControlFrameStartService ()

@property (copy, nonatomic, readwrite) NSString *versionNumber;

@end


@implementation SDLControlFrameStartService

- (instancetype)initWithMajorVersion:(int32_t)majorVersion minorVersion:(int32_t)minorVersion patchVersion:(int32_t)patchVersion {
    self = [super init];
    if (!self) return nil;

    _versionNumber = [NSString stringWithFormat:@"%d.%d.%d", majorVersion, minorVersion, patchVersion];

    return self;
}

- (NSData *)payload {
    BsonObject payloadObject;
    bson_object_initialize_default(&payloadObject);

    bson_object_put_string(&payloadObject, versionKey, (char *)self.versionNumber.UTF8String);

    BytePtr bsonData = bson_object_to_bytes(&payloadObject);
    NSUInteger length = bson_object_size(&payloadObject);

    bson_object_deinitialize(&payloadObject);

    return [[NSData alloc] initWithBytes:bsonData length:length];
}

- (void)setPayload:(NSData *)payload {
    BsonObject payloadObject = bson_object_from_bytes((BytePtr)payload.bytes);

    self.versionNumber = [NSString stringWithUTF8String:bson_object_get_string(&payloadObject, versionKey)];
}

@end
