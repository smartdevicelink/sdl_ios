//
//  SDLSendLocation.m
//  SmartDeviceLink

#import "SDLSendLocation.h"

#import "SDLNames.h"


@implementation SDLSendLocation

- (instancetype)init {
    self = [super initWithName:SDLNameSendLocation];
    if (!self) {
        return nil;
    }

    return self;
}

- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(NSString *)locationName locationDescription:(NSString *)locationDescription address:(NSArray<NSString *> *)address phoneNumber:(NSString *)phoneNumber image:(SDLImage *)image {
    return [self initWithLongitude:longitude latitude:latitude locationName:locationName locationDescription:locationDescription displayAddressLines:address phoneNumber:phoneNumber image:image deliveryMode:nil timeStamp:nil address:nil];
}

- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(NSString *)locationName locationDescription:(NSString *)locationDescription displayAddressLines:(NSArray<NSString *> *)displayAddressLines phoneNumber:(NSString *)phoneNumber image:(SDLImage *)image deliveryMode:(SDLDeliveryMode)deliveryMode timeStamp:(SDLDateTime *)timeStamp address:(SDLOasisAddress *)address {
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
        parameters[SDLNameLongitudeDegrees] = longitudeDegrees;
    } else {
        [parameters removeObjectForKey:SDLNameLongitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return parameters[SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        parameters[SDLNameLatitudeDegrees] = latitudeDegrees;
    } else {
        [parameters removeObjectForKey:SDLNameLatitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return parameters[SDLNameLatitudeDegrees];
}

- (void)setLocationName:(NSString *)locationName {
    if (locationName != nil) {
        parameters[SDLNameLocationName] = locationName;
    } else {
        [parameters removeObjectForKey:SDLNameLocationName];
    }
}

- (NSString *)locationName {
    return parameters[SDLNameLocationName];
}

- (void)setAddressLines:(NSArray<NSString *> *)addressLines {
    if (addressLines != nil) {
        parameters[SDLNameAddressLines] = addressLines;
    } else {
        [parameters removeObjectForKey:SDLNameAddressLines];
    }
}

- (NSString *)locationDescription {
    return parameters[SDLNameLocationDescription];
}

- (void)setLocationDescription:(NSString *)locationDescription {
    if (locationDescription != nil) {
        parameters[SDLNameLocationDescription] = locationDescription;
    } else {
        [parameters removeObjectForKey:SDLNameLocationDescription];
    }
}

- (NSArray<NSString *> *)addressLines {
    return parameters[SDLNameAddressLines];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber != nil) {
        parameters[SDLNamePhoneNumber] = phoneNumber;
    } else {
        [parameters removeObjectForKey:SDLNamePhoneNumber];
    }
}

- (NSString *)phoneNumber {
    return parameters[SDLNamePhoneNumber];
}

- (void)setLocationImage:(SDLImage *)locationImage {
    if (locationImage != nil) {
        parameters[SDLNameLocationImage] = locationImage;
    } else {
        [parameters removeObjectForKey:SDLNameLocationImage];
    }
}

- (SDLImage *)locationImage {
    id obj = parameters[SDLNameLocationImage];
    if (obj == nil || [obj isKindOfClass:[SDLImage class]]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:obj];
    }
}

- (void)setDeliveryMode:(SDLDeliveryMode)deliveryMode {
    if (deliveryMode != nil) {
        parameters[SDLNameDeliveryMode] = deliveryMode;
    } else {
        [parameters removeObjectForKey:SDLNameDeliveryMode];
    }
}

- (SDLDeliveryMode)deliveryMode {
    return parameters[SDLNameDeliveryMode];
}

- (void)setTimeStamp:(SDLDateTime *)timeStamp {
    if (timeStamp != nil) {
        parameters[SDLNameLocationTimeStamp] = timeStamp;
    } else {
        [parameters removeObjectForKey:SDLNameLocationTimeStamp];
    }
}

- (SDLDateTime *)timeStamp {
    id obj = parameters[SDLNameLocationTimeStamp];
    if (obj == nil || [obj isKindOfClass:[SDLDateTime class]]) {
        return (SDLDateTime *)obj;
    } else {
        return [[SDLDateTime alloc] initWithDictionary:obj];
    }
}

- (void)setAddress:(SDLOasisAddress *)address {
    if (address != nil) {
        parameters[SDLNameAddress] = address;
    } else {
        [parameters removeObjectForKey:SDLNameAddress];
    }
}

- (SDLOasisAddress *)address {
    id obj = parameters[SDLNameAddress];
    if (obj == nil || [obj isKindOfClass:[SDLOasisAddress class]]) {
        return (SDLOasisAddress *)obj;
    } else {
        return [[SDLOasisAddress alloc] initWithDictionary:obj];
    }
}

@end
