//
//  SDLSendLocation.m
//  SmartDeviceLink

#import "SDLSendLocation.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSendLocation

- (instancetype)init {
    self = [super initWithName:SDLNameSendLocation];
    if (!self) {
        return nil;
    }

    return self;
}

- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(nullable NSString *)locationName locationDescription:(nullable NSString *)locationDescription address:(nullable NSArray<NSString *> *)address phoneNumber:(nullable NSString *)phoneNumber image:(nullable SDLImage *)image {
    return [self initWithLongitude:longitude latitude:latitude locationName:locationName locationDescription:locationDescription displayAddressLines:address phoneNumber:phoneNumber image:image deliveryMode:nil timeStamp:nil address:nil];
}

- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude locationName:(nullable NSString *)locationName locationDescription:(nullable NSString *)locationDescription displayAddressLines:(nullable NSArray<NSString *> *)displayAddressLines phoneNumber:(nullable NSString *)phoneNumber image:(nullable SDLImage *)image deliveryMode:(nullable SDLDeliveryMode)deliveryMode timeStamp:(nullable SDLDateTime *)timeStamp address:(nullable SDLOasisAddress *)address {
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

- (void)setLongitudeDegrees:(nullable NSNumber<SDLFloat> *)longitudeDegrees {
    if (longitudeDegrees != nil) {
        parameters[SDLNameLongitudeDegrees] = longitudeDegrees;
    } else {
        [parameters removeObjectForKey:SDLNameLongitudeDegrees];
    }
}

- (nullable NSNumber<SDLFloat> *)longitudeDegrees {
    return parameters[SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(nullable NSNumber<SDLFloat> *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        parameters[SDLNameLatitudeDegrees] = latitudeDegrees;
    } else {
        [parameters removeObjectForKey:SDLNameLatitudeDegrees];
    }
}

- (nullable NSNumber<SDLFloat> *)latitudeDegrees {
    return parameters[SDLNameLatitudeDegrees];
}

- (void)setLocationName:(nullable NSString *)locationName {
    if (locationName != nil) {
        parameters[SDLNameLocationName] = locationName;
    } else {
        [parameters removeObjectForKey:SDLNameLocationName];
    }
}

- (nullable NSString *)locationName {
    return parameters[SDLNameLocationName];
}

- (void)setAddressLines:(nullable NSArray<NSString *> *)addressLines {
    if (addressLines != nil) {
        parameters[SDLNameAddressLines] = addressLines;
    } else {
        [parameters removeObjectForKey:SDLNameAddressLines];
    }
}

- (nullable NSString *)locationDescription {
    return parameters[SDLNameLocationDescription];
}

- (void)setLocationDescription:(nullable NSString *)locationDescription {
    if (locationDescription != nil) {
        parameters[SDLNameLocationDescription] = locationDescription;
    } else {
        [parameters removeObjectForKey:SDLNameLocationDescription];
    }
}

- (nullable NSArray<NSString *> *)addressLines {
    return parameters[SDLNameAddressLines];
}

- (void)setPhoneNumber:(nullable NSString *)phoneNumber {
    if (phoneNumber != nil) {
        parameters[SDLNamePhoneNumber] = phoneNumber;
    } else {
        [parameters removeObjectForKey:SDLNamePhoneNumber];
    }
}

- (nullable NSString *)phoneNumber {
    return parameters[SDLNamePhoneNumber];
}

- (void)setLocationImage:(nullable SDLImage *)locationImage {
    if (locationImage != nil) {
        parameters[SDLNameLocationImage] = locationImage;
    } else {
        [parameters removeObjectForKey:SDLNameLocationImage];
    }
}

- (nullable SDLImage *)locationImage {
    id obj = parameters[SDLNameLocationImage];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLImage*)obj;
}

- (void)setDeliveryMode:(nullable SDLDeliveryMode)deliveryMode {
    if (deliveryMode != nil) {
        parameters[SDLNameDeliveryMode] = deliveryMode;
    } else {
        [parameters removeObjectForKey:SDLNameDeliveryMode];
    }
}

- (nullable SDLDeliveryMode)deliveryMode {
    return parameters[SDLNameDeliveryMode];
}

- (void)setTimeStamp:(nullable SDLDateTime *)timeStamp {
    if (timeStamp != nil) {
        parameters[SDLNameLocationTimeStamp] = timeStamp;
    } else {
        [parameters removeObjectForKey:SDLNameLocationTimeStamp];
    }
}

- (nullable SDLDateTime *)timeStamp {
    id obj = parameters[SDLNameLocationTimeStamp];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLDateTime alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLDateTime*)obj;
}

- (void)setAddress:(nullable SDLOasisAddress *)address {
    if (address != nil) {
        parameters[SDLNameAddress] = address;
    } else {
        [parameters removeObjectForKey:SDLNameAddress];
    }
}

- (nullable SDLOasisAddress *)address {
    id obj = parameters[SDLNameAddress];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLOasisAddress alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLOasisAddress*)obj;
}

@end

NS_ASSUME_NONNULL_END
