//
//  SDLSendLocation.m
//  SmartDeviceLink

#import "SDLSendLocation.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSendLocation

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    self = [super initWithName:SDLRPCFunctionNameSendLocation];
    if (!self) {
        return nil;
    }

    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithAddress:(SDLOasisAddress *)address addressLines:(nullable NSArray<NSString *> *)addressLines locationName:(nullable NSString *)locationName locationDescription:(nullable NSString *)locationDescription phoneNumber:(nullable NSString *)phoneNumber image:(nullable SDLImage *)image deliveryMode:(nullable SDLDeliveryMode)deliveryMode timeStamp:(nullable SDLDateTime *)timeStamp {
    self = [self init];
    if (!self) { return nil; }

    self.address = address;
    self.addressLines = addressLines;
    self.locationName = locationName;
    self.locationDescription = locationDescription;
    self.phoneNumber = phoneNumber;
    self.locationImage = image;
    self.deliveryMode = deliveryMode;
    self.timeStamp = timeStamp;

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
    [self.parameters sdl_setObject:longitudeDegrees forName:SDLRPCParameterNameLongitudeDegrees];
}

- (nullable NSNumber<SDLFloat> *)longitudeDegrees {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameLongitudeDegrees ofClass:NSNumber.class error:nil];
}

- (void)setLatitudeDegrees:(nullable NSNumber<SDLFloat> *)latitudeDegrees {
    [self.parameters sdl_setObject:latitudeDegrees forName:SDLRPCParameterNameLatitudeDegrees];
}

- (nullable NSNumber<SDLFloat> *)latitudeDegrees {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameLatitudeDegrees ofClass:NSNumber.class error:nil];
}

- (void)setLocationName:(nullable NSString *)locationName {
    [self.parameters sdl_setObject:locationName forName:SDLRPCParameterNameLocationName];
}

- (nullable NSString *)locationName {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameLocationName ofClass:NSString.class error:nil];
}

- (void)setAddressLines:(nullable NSArray<NSString *> *)addressLines {
    [self.parameters sdl_setObject:addressLines forName:SDLRPCParameterNameAddressLines];
}

- (nullable NSString *)locationDescription {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameLocationDescription ofClass:NSString.class error:nil];
}

- (void)setLocationDescription:(nullable NSString *)locationDescription {
    [self.parameters sdl_setObject:locationDescription forName:SDLRPCParameterNameLocationDescription];
}

- (nullable NSArray<NSString *> *)addressLines {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameAddressLines ofClass:NSString.class error:nil];
}

- (void)setPhoneNumber:(nullable NSString *)phoneNumber {
    [self.parameters sdl_setObject:phoneNumber forName:SDLRPCParameterNamePhoneNumber];
}

- (nullable NSString *)phoneNumber {
    return [self.parameters sdl_objectForName:SDLRPCParameterNamePhoneNumber ofClass:NSString.class error:nil];
}

- (void)setLocationImage:(nullable SDLImage *)locationImage {
    [self.parameters sdl_setObject:locationImage forName:SDLRPCParameterNameLocationImage];
}

- (nullable SDLImage *)locationImage {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameLocationImage ofClass:SDLImage.class error:nil];
}

- (void)setDeliveryMode:(nullable SDLDeliveryMode)deliveryMode {
    [self.parameters sdl_setObject:deliveryMode forName:SDLRPCParameterNameDeliveryMode];
}

- (nullable SDLDeliveryMode)deliveryMode {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameDeliveryMode error:nil];
}

- (void)setTimeStamp:(nullable SDLDateTime *)timeStamp {
    [self.parameters sdl_setObject:timeStamp forName:SDLRPCParameterNameTimeStamp];
}

- (nullable SDLDateTime *)timeStamp {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTimeStamp ofClass:SDLDateTime.class error:nil];
}

- (void)setAddress:(nullable SDLOasisAddress *)address {
    [self.parameters sdl_setObject:address forName:SDLRPCParameterNameAddress];
}

- (nullable SDLOasisAddress *)address {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameAddress ofClass:SDLOasisAddress.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
