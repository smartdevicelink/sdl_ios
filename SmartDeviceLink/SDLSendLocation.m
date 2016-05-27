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

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    return self;
}

- (void)setLongitudeDegrees:(NSNumber *)longitudeDegrees {
    if (longitudeDegrees != nil) {
        parameters[NAMES_longitudeDegrees] = longitudeDegrees;
    } else {
        [parameters removeObjectForKey:NAMES_longitudeDegrees];
    }
}

- (NSNumber *)longitudeDegrees {
    return parameters[NAMES_longitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        parameters[NAMES_latitudeDegrees] = latitudeDegrees;
    } else {
        [parameters removeObjectForKey:NAMES_latitudeDegrees];
    }
}

- (NSNumber *)latitudeDegrees {
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

@end
