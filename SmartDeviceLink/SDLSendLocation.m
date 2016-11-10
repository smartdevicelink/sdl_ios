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
    [parameters sdl_setObject:longitudeDegrees forName:SDLNameLongitudeDegrees];
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return [parameters sdl_objectForName:SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [parameters sdl_setObject:latitudeDegrees forName:SDLNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return [parameters sdl_objectForName:SDLNameLatitudeDegrees];
}

- (void)setLocationName:(NSString *)locationName {
    [parameters sdl_setObject:locationName forName:SDLNameLocationName];
}

- (NSString *)locationName {
    return [parameters sdl_objectForName:SDLNameLocationName];
}

- (void)setAddressLines:(NSArray<NSString *> *)addressLines {
    [parameters sdl_setObject:addressLines forName:SDLNameAddressLines];
}

- (NSString *)locationDescription {
    return [parameters sdl_objectForName:SDLNameLocationDescription];
}

- (void)setLocationDescription:(NSString *)locationDescription {
    [parameters sdl_setObject:locationDescription forName:SDLNameLocationDescription];
}

- (NSArray<NSString *> *)addressLines {
    return [parameters sdl_objectForName:SDLNameAddressLines];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    [parameters sdl_setObject:phoneNumber forName:SDLNamePhoneNumber];
}

- (NSString *)phoneNumber {
    return [parameters sdl_objectForName:SDLNamePhoneNumber];
}

- (void)setLocationImage:(SDLImage *)locationImage {
    [parameters sdl_setObject:locationImage forName:SDLNameLocationImage];
}

- (SDLImage *)locationImage {
    return [parameters sdl_objectForName:SDLNameLocationImage ofClass:SDLImage.class];
}

- (void)setDeliveryMode:(SDLDeliveryMode)deliveryMode {
    [parameters sdl_setObject:deliveryMode forName:SDLNameDeliveryMode];
}

- (SDLDeliveryMode)deliveryMode {
    return [parameters sdl_objectForName:SDLNameDeliveryMode];
}

- (void)setTimeStamp:(SDLDateTime *)timeStamp {
    [parameters sdl_setObject:timeStamp forName:SDLNameLocationTimeStamp];
}

- (SDLDateTime *)timeStamp {
    return [parameters sdl_objectForName:SDLNameLocationTimeStamp ofClass:SDLDateTime.class];
}

- (void)setAddress:(SDLOasisAddress *)address {
    [parameters sdl_setObject:address forName:SDLNameAddress];
}

- (SDLOasisAddress *)address {
    return [parameters sdl_objectForName:SDLNameAddress ofClass:SDLOasisAddress.class];
}

@end
