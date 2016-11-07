//  SDLLocationDetails.m
//

#import "SDLLocationDetails.h"

#import "SDLImage.h"
#import "SDLLocationCoordinate.h"
#import "SDLNames.h"
#import "SDLOasisAddress.h"

@implementation SDLLocationDetails

- (void)setCoordinate:(SDLLocationCoordinate *)coordinate {
    if (coordinate != nil) {
        store[SDLNameLocationCoordinate] = coordinate;
    } else {
        [store removeObjectForKey:SDLNameLocationCoordinate];
    }
}

- (SDLLocationCoordinate *)coordinate {
    return [self objectForName:SDLNameLocationCoordinate];
}

- (void)setLocationName:(NSString *)locationName {
    if (locationName != nil) {
        store[SDLNameLocationName] = locationName;
    } else {
        [store removeObjectForKey:SDLNameLocationName];
    }
}

- (NSString *)locationName {
    return [self objectForName:SDLNameLocationName];
}

- (void)setAddressLines:(NSArray<NSString *> *)addressLines {
    if (addressLines != nil) {
        store[SDLNameAddressLines] = addressLines;
    } else {
        [store removeObjectForKey:SDLNameAddressLines];
    }
}

- (NSArray<NSString *> *)addressLines {
    return [self objectForName:SDLNameAddressLines];
}

- (void)setLocationDescription:(NSString *)locationDescription {
    if (locationDescription != nil) {
        store[SDLNameLocationDescription] = locationDescription;
    } else {
        [store removeObjectForKey:SDLNameLocationDescription];
    }
}

- (NSString *)locationDescription {
    return [self objectForName:SDLNameLocationDescription];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber != nil) {
        store[SDLNamePhoneNumber] = phoneNumber;
    } else {
        [store removeObjectForKey:SDLNamePhoneNumber];
    }
}

- (NSString *)phoneNumber {
    return [self objectForName:SDLNamePhoneNumber];
}

- (void)setLocationImage:(SDLImage *)locationImage {
    if (locationImage != nil) {
        store[SDLNameLocationImage] = locationImage;
    } else {
        [store removeObjectForKey:SDLNameLocationImage];
    }
}

- (SDLImage *)locationImage {
    return [self objectForName:SDLNameLocationImage];
}

- (void)setSearchAddress:(SDLOasisAddress *)searchAddress {
    if (searchAddress != nil) {
        store[SDLNameAddress] = searchAddress;
    } else {
        [store removeObjectForKey:SDLNameAddress];
    }
}

- (SDLOasisAddress *)searchAddress {
    return [self objectForName:SDLNameAddress];
}

@end
