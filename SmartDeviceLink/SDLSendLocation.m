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
    [self setObject:longitudeDegrees forName:SDLNameLongitudeDegrees];
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return [self objectForName:SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [self setObject:latitudeDegrees forName:SDLNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return [self objectForName:SDLNameLatitudeDegrees];
}

- (void)setLocationName:(NSString *)locationName {
    [self setObject:locationName forName:SDLNameLocationName];
}

- (NSString *)locationName {
    return [self objectForName:SDLNameLocationName];
}

- (void)setAddressLines:(NSArray<NSString *> *)addressLines {
    [self setObject:addressLines forName:SDLNameAddressLines];
}

- (NSString *)locationDescription {
    return [self objectForName:SDLNameLocationDescription];
}

- (void)setLocationDescription:(NSString *)locationDescription {
    [self setObject:locationDescription forName:SDLNameLocationDescription];
}

- (NSArray<NSString *> *)addressLines {
    return [self objectForName:SDLNameAddressLines];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    [self setObject:phoneNumber forName:SDLNamePhoneNumber];
}

- (NSString *)phoneNumber {
    return [self objectForName:SDLNamePhoneNumber];
}

- (void)setLocationImage:(SDLImage *)locationImage {
    [self setObject:locationImage forName:SDLNameLocationImage];
}

- (SDLImage *)locationImage {
    return [self objectForName:SDLNameLocationImage ofClass:SDLImage.class];
}

- (void)setDeliveryMode:(SDLDeliveryMode)deliveryMode {
    [self setObject:deliveryMode forName:SDLNameDeliveryMode];
}

- (SDLDeliveryMode)deliveryMode {
    return [self objectForName:SDLNameDeliveryMode];
}

- (void)setTimeStamp:(SDLDateTime *)timeStamp {
    [self setObject:timeStamp forName:SDLNameLocationTimeStamp];
}

- (SDLDateTime *)timeStamp {
    return [self objectForName:SDLNameLocationTimeStamp ofClass:SDLDateTime.class];
}

- (void)setAddress:(SDLOasisAddress *)address {
    [self setObject:address forName:SDLNameAddress];
}

- (SDLOasisAddress *)address {
    return [self objectForName:SDLNameAddress ofClass:SDLOasisAddress.class];
}

@end
