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
@property (copy, nonatomic, readwrite, nullable) NSString *authToken;
@property (copy, nonatomic, readwrite, nullable) NSString *protocolVersion;
@property (copy, nonatomic, readwrite, nullable) NSArray<NSString *> *secondaryTransports;
@property (copy, nonatomic, readwrite, nullable) NSArray<NSNumber *> *audioServiceTransports;
@property (copy, nonatomic, readwrite, nullable) NSArray<NSNumber *> *videoServiceTransports;
@property (copy, nonatomic, readwrite, nullable) NSString *make;
@property (copy, nonatomic, readwrite, nullable) NSString *model;
@property (copy, nonatomic, readwrite, nullable) NSString *trim;
@property (copy, nonatomic, readwrite, nullable) NSString *modelYear;
@property (copy, nonatomic, readwrite, nullable) NSString *systemSoftwareVersion;
@property (copy, nonatomic, readwrite, nullable) NSString *systemHardwareVersion;

@end


@implementation SDLControlFramePayloadRPCStartServiceAck

- (instancetype)initWithHashId:(int32_t)hashId mtu:(int64_t)mtu authToken:(nullable NSString *)authToken protocolVersion:(nullable NSString *)protocolVersion secondaryTransports:(nullable NSArray<NSString *> *)secondaryTransports audioServiceTransports:(nullable NSArray<NSNumber *> *)audioServiceTransports videoServiceTransports:(nullable NSArray<NSNumber *> *)videoServiceTransports make:(nullable NSString *)make model:(nullable NSString *)model trim:(nullable NSString *)trim modelYear:(nullable NSString *)modelYear systemSoftwareVersion:(nullable NSString *)systemSoftwareVersion systemHardwareVersion:(nullable NSString *)systemHardwareVersion {
    self = [super init];
    if (!self) return nil;

    _hashId = hashId;
    _mtu = mtu;
    _authToken = authToken;
    _protocolVersion = protocolVersion;
    _secondaryTransports = secondaryTransports;
    _audioServiceTransports = audioServiceTransports;
    _videoServiceTransports = videoServiceTransports;
    _make = make;
    _model = model;
    _trim = trim;
    _modelYear = modelYear;
    _systemSoftwareVersion = systemSoftwareVersion;
    _systemHardwareVersion = systemHardwareVersion;

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

    if (self.authToken != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameAuthTokenKey, (char *)self.authToken.UTF8String);
    }

    if (self.protocolVersion != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameProtocolVersionKey, (char *)self.protocolVersion.UTF8String);
    }

    if (self.secondaryTransports != nil) {
        BsonArray arrayObject;
        // Currently there are 8 transport types defined. So initial value of 8 should be sufficient.
        bson_array_initialize(&arrayObject, 8);

        for (NSString *transport in self.secondaryTransports) {
            bson_array_add_string(&arrayObject, (char *)transport.UTF8String);
        }

        bson_object_put_array(&payloadObject, SDLControlFrameSecondaryTransportsKey, &arrayObject);
    }

    [self sdl_addServiceTransports:&payloadObject fromArray:self.audioServiceTransports forKey:SDLControlFrameAudioServiceTransportsKey];
    [self sdl_addServiceTransports:&payloadObject fromArray:self.videoServiceTransports forKey:SDLControlFrameVideoServiceTransportsKey];

    if (self.make != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameVehicleMakeKey, (char *)self.make.UTF8String);
    }

    if (self.model != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameVehicleModelKey, (char *)self.model.UTF8String);
    }

    if (self.trim != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameVehicleTrimKey, (char *)self.trim.UTF8String);
    }

    if (self.modelYear != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameVehicleModelYearKey, (char *)self.modelYear.UTF8String);
    }

    if (self.systemSoftwareVersion != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameVehicleSoftwareVersionKey, (char *)self.systemSoftwareVersion.UTF8String);
    }

    if (self.systemHardwareVersion != nil) {
        bson_object_put_string(&payloadObject, SDLControlFrameVehicleHardwareVersionKey, (char *)self.systemHardwareVersion.UTF8String);
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

    self.hashId = bson_object_get_int32(&payloadObject, SDLControlFrameHashIdKey);
    self.mtu = bson_object_get_int64(&payloadObject, SDLControlFrameMTUKey);

    char *protocolVersionUTF8String = bson_object_get_string(&payloadObject, SDLControlFrameProtocolVersionKey);
    if (protocolVersionUTF8String != NULL) {
        self.protocolVersion = [NSString stringWithUTF8String:protocolVersionUTF8String];
    }

    char *authTokenUTF8String = bson_object_get_string(&payloadObject, SDLControlFrameAuthTokenKey);
    if (authTokenUTF8String != NULL) {
        self.authToken = [NSString stringWithUTF8String:authTokenUTF8String];
    }

    BsonArray *arrayObject = bson_object_get_array(&payloadObject, SDLControlFrameSecondaryTransportsKey);
    if (arrayObject != NULL) {
        NSMutableArray<NSString *> *secondaryTransports = [NSMutableArray array];
        size_t index = 0;

        while ((protocolVersionUTF8String = bson_array_get_string(arrayObject, index)) != NULL) {
            [secondaryTransports addObject:[NSString stringWithUTF8String:protocolVersionUTF8String]];
            index++;
        }
        self.secondaryTransports = [secondaryTransports copy];
    }

    self.audioServiceTransports = [self sdl_getServiceTransports:&payloadObject forKey:SDLControlFrameAudioServiceTransportsKey];
    self.videoServiceTransports = [self sdl_getServiceTransports:&payloadObject forKey:SDLControlFrameVideoServiceTransportsKey];

    char *makeString = bson_object_get_string(&payloadObject, SDLControlFrameVehicleMakeKey);
    if (makeString != NULL) {
        self.make = [NSString stringWithUTF8String:makeString];
    }

    char *modelString = bson_object_get_string(&payloadObject, SDLControlFrameVehicleModelKey);
    if (modelString != NULL) {
        self.model = [NSString stringWithUTF8String:modelString];
    }

    char *trimString = bson_object_get_string(&payloadObject, SDLControlFrameVehicleTrimKey);
    if (trimString != NULL) {
        self.trim = [NSString stringWithUTF8String:trimString];
    }

    char *modelYearString = bson_object_get_string(&payloadObject, SDLControlFrameVehicleModelYearKey);
    if (modelYearString != NULL) {
        self.modelYear = [NSString stringWithUTF8String:modelYearString];
    }

    char *softwareVersionString = bson_object_get_string(&payloadObject, SDLControlFrameVehicleSoftwareVersionKey);
    if (softwareVersionString != NULL) {
        self.systemSoftwareVersion = [NSString stringWithUTF8String:softwareVersionString];
    }

    char *hardwareVersionString = bson_object_get_string(&payloadObject, SDLControlFrameVehicleHardwareVersionKey);
    if (hardwareVersionString != NULL) {
        self.systemHardwareVersion = [NSString stringWithUTF8String:hardwareVersionString];
    }

    bson_object_deinitialize(&payloadObject);
}

- (nullable NSArray<NSNumber *> *)sdl_getServiceTransports:(BsonObject *)payloadObject forKey:(const char * const)key {
    if (payloadObject == NULL || key == NULL) {
        return nil;
    }

    BsonArray *arrayObject = bson_object_get_array(payloadObject, key);
    if (arrayObject == NULL) {
        return nil;
    }

    NSMutableArray<NSNumber *> *transports = [NSMutableArray array];
    int32_t num;
    size_t index = 0;

    while ((num = bson_array_get_int32(arrayObject, index)) != -1) {
        [transports addObject:@(num)];
        index++;
    }

    return [transports copy];
}

- (void)sdl_addServiceTransports:(BsonObject *)payloadObject fromArray:(NSArray<NSNumber *> *)array forKey:(const char * const)key {
    if (payloadObject == NULL || array == nil || key == NULL) {
        return;
    }

    BsonArray arrayObject;
    // currently there are 2 transports defined (primary and secondary)
    bson_array_initialize(&arrayObject, 2);

    for (NSNumber *num in array) {
        int32_t transport = [num intValue];
        if (transport != -1) {
            bson_array_add_int32(&arrayObject, transport);
        }
    }

    bson_object_put_array(payloadObject, key, &arrayObject);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@>: Protocol Version: %@, hash id: %d, MTU: %lld, auth token: %@, secondary transports: %@, transports for audio service: %@, transports for video service: %@", NSStringFromClass(self.class), self.protocolVersion, self.hashId, self.mtu, self.authToken, self.secondaryTransports, self.audioServiceTransports, self.videoServiceTransports];
}

@end

NS_ASSUME_NONNULL_END
