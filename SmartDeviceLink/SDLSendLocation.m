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

- (void)setLongitudeDegrees:(NSNumber *)longitudeDegrees {
    if (longitudeDegrees != nil) {
        parameters[SDLNameLongitudeDegrees] = longitudeDegrees;
    } else {
        [parameters removeObjectForKey:SDLNameLongitudeDegrees];
    }
}

- (NSNumber *)longitudeDegrees {
    return parameters[SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        parameters[SDLNameLatitudeDegrees] = latitudeDegrees;
    } else {
        [parameters removeObjectForKey:SDLNameLatitudeDegrees];
    }
}

- (NSNumber *)latitudeDegrees {
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

- (void)setAddressLines:(NSArray *)addressLines {
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

- (NSArray *)addressLines {
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

@end
