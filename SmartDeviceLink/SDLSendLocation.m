//
//  SDLSendLocation.m
//  SmartDeviceLink

#import "SDLSendLocation.h"

#import "SDLNames.h"


@implementation SDLSendLocation

- (instancetype)init {
    self = [super initWithName:NAMES_SendLocation];
    if (!self) {
        return nil;
    }

    return self;
}

- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(NSString *)locationName locationDescription:(NSString *)locationDescription address:(NSArray<NSString *> *)address phoneNumber:(NSString *)phoneNumber image:(SDLImage *)image {
    return [self initWithLongitude:longitude latitude:latitude locationName:locationName locationDescription:locationDescription displayAddressLines:address phoneNumber:phoneNumber image:image deliveryMode:nil timeStamp:nil address:nil];
}

- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(NSString *)locationName locationDescription:(NSString *)locationDescription displayAddressLines:(NSArray<NSString *> *)displayAddressLines phoneNumber:(NSString *)phoneNumber image:(SDLImage *)image deliveryMode:(SDLDeliveryMode *)deliveryMode timeStamp:(SDLDateTime *)timeStamp address:(SDLOasisAddress *)address {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.longitudeDegrees = @(longitude);
    self.latitudeDegrees = @(latitude);
    self.locationName = locationName;
    self.locationDescription = locationDescription;
    self.addressLines = displayAddressLines;
    self.phoneNumber = phoneNumber;
    self.locationImage = image;
    self.deliveryMode = deliveryMode;
    self.timeStamp = timeStamp;
    self.address = address;

    return self;
}

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    if (longitudeDegrees != nil) {
        parameters[NAMES_longitudeDegrees] = longitudeDegrees;
    } else {
        [parameters removeObjectForKey:NAMES_longitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return parameters[NAMES_longitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        parameters[NAMES_latitudeDegrees] = latitudeDegrees;
    } else {
        [parameters removeObjectForKey:NAMES_latitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return parameters[NAMES_latitudeDegrees];
}

- (void)setLocationName:(NSString *)locationName {
    if (locationName != nil) {
        parameters[NAMES_locationName] = locationName;
    } else {
        [parameters removeObjectForKey:NAMES_locationName];
    }
}

- (NSString *)locationName {
    return parameters[NAMES_locationName];
}

- (void)setAddressLines:(NSArray *)addressLines {
    if (addressLines != nil) {
        parameters[NAMES_addressLines] = addressLines;
    } else {
        [parameters removeObjectForKey:NAMES_addressLines];
    }
}

- (NSString *)locationDescription {
    return parameters[NAMES_locationDescription];
}

- (void)setLocationDescription:(NSString *)locationDescription {
    if (locationDescription != nil) {
        parameters[NAMES_locationDescription] = locationDescription;
    } else {
        [parameters removeObjectForKey:NAMES_locationDescription];
    }
}

- (NSArray *)addressLines {
    return parameters[NAMES_addressLines];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber != nil) {
        parameters[NAMES_phoneNumber] = phoneNumber;
    } else {
        [parameters removeObjectForKey:NAMES_phoneNumber];
    }
}

- (NSString *)phoneNumber {
    return parameters[NAMES_phoneNumber];
}

- (void)setLocationImage:(SDLImage *)locationImage {
    if (locationImage != nil) {
        parameters[NAMES_locationImage] = locationImage;
    } else {
        [parameters removeObjectForKey:NAMES_locationImage];
    }
}

- (SDLImage *)locationImage {
    id obj = parameters[NAMES_locationImage];
    if (obj == nil || [obj isKindOfClass:[SDLImage class]]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:obj];
    }
}

- (void)setDeliveryMode:(SDLDeliveryMode *)deliveryMode {
    if (deliveryMode != nil) {
        parameters[NAMES_deliveryMode] = deliveryMode;
    } else {
        [parameters removeObjectForKey:NAMES_deliveryMode];
    }
}

- (SDLDeliveryMode *)deliveryMode {
    NSObject *obj = [parameters objectForKey:NAMES_deliveryMode];
    if (obj == nil || [obj isKindOfClass:SDLDeliveryMode.class]) {
        return (SDLDeliveryMode *)obj;
    } else {
        return [SDLDeliveryMode valueOf:(NSString *)obj];
    }
}

- (void)setTimeStamp:(SDLDateTime *)timeStamp {
    if (timeStamp != nil) {
        parameters[NAMES_timeStamp] = timeStamp;
    } else {
        [parameters removeObjectForKey:NAMES_timeStamp];
    }
}

- (SDLDateTime *)timeStamp {
    id obj = parameters[NAMES_timeStamp];
    if (obj == nil || [obj isKindOfClass:[SDLDateTime class]]) {
        return (SDLDateTime *)obj;
    } else {
        return [[SDLDateTime alloc] initWithDictionary:obj];
    }
}

- (void)setAddress:(SDLOasisAddress *)address {
    if (address != nil) {
        parameters[NAMES_address] = address;
    } else {
        [parameters removeObjectForKey:NAMES_address];
    }
}

- (SDLOasisAddress *)address {
    id obj = [parameters objectForKey:NAMES_address];
    if (obj == nil || [obj isKindOfClass:[SDLOasisAddress class]]) {
        return (SDLOasisAddress *)obj;
    } else {
        return [[SDLOasisAddress alloc] initWithDictionary:obj];
    }
}

@end
