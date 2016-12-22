//  SDLLocationDetails.m
//

#import "SDLLocationDetails.h"

#import "SDLImage.h"
#import "SDLLocationCoordinate.h"
#import "SDLNames.h"
#import "SDLOasisAddress.h"

@implementation SDLLocationDetails

- (void)setCoordinate:(nullable SDLLocationCoordinate *)coordinate {
    if (coordinate != nil) {
        store[SDLNameLocationCoordinate] = coordinate;
    } else {
        [store removeObjectForKey:SDLNameLocationCoordinate];
    }
}

- (nullable SDLLocationCoordinate *)coordinate {
    return store[SDLNameLocationCoordinate];
}

- (void)setLocationName:(nullable NSString *)locationName {
    if (locationName != nil) {
        store[SDLNameLocationName] = locationName;
    } else {
        [store removeObjectForKey:SDLNameLocationName];
    }
}

- (nullable NSString *)locationName {
    return store[SDLNameLocationName];
}

- (void)setAddressLines:(nullable NSArray<NSString *> *)addressLines {
    if (addressLines != nil) {
        store[SDLNameAddressLines] = addressLines;
    } else {
        [store removeObjectForKey:SDLNameAddressLines];
    }
}

- (nullable NSArray<NSString *> *)addressLines {
    return store[SDLNameAddressLines];
}

- (void)setLocationDescription:(nullable NSString *)locationDescription {
    if (locationDescription != nil) {
        store[SDLNameLocationDescription] = locationDescription;
    } else {
        [store removeObjectForKey:SDLNameLocationDescription];
    }
}

- (nullable NSString *)locationDescription {
    return store[SDLNameLocationDescription];
}

- (void)setPhoneNumber:(nullable NSString *)phoneNumber {
    if (phoneNumber != nil) {
        store[SDLNamePhoneNumber] = phoneNumber;
    } else {
        [store removeObjectForKey:SDLNamePhoneNumber];
    }
}

- (nullable NSString *)phoneNumber {
    return store[SDLNamePhoneNumber];
}

- (void)setLocationImage:(nullable SDLImage *)locationImage {
    if (locationImage != nil) {
        store[SDLNameLocationImage] = locationImage;
    } else {
        [store removeObjectForKey:SDLNameLocationImage];
    }
}

- (nullable SDLImage *)locationImage {
    return store[SDLNameLocationImage];
}

- (void)setSearchAddress:(nullable SDLOasisAddress *)searchAddress {
    if (searchAddress != nil) {
        store[SDLNameAddress] = searchAddress;
    } else {
        [store removeObjectForKey:SDLNameAddress];
    }
}

- (nullable SDLOasisAddress *)searchAddress {
    return store[SDLNameAddress];
}

@end
