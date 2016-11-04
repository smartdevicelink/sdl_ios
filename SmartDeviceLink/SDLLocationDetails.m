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
    return store[SDLNameLocationCoordinate];
}

- (void)setLocationName:(NSString *)locationName {
    if (locationName != nil) {
        store[SDLNameLocationName] = locationName;
    } else {
        [store removeObjectForKey:SDLNameLocationName];
    }
}

- (NSString *)locationName {
    return store[SDLNameLocationName];
}

- (void)setAddressLines:(NSArray<NSString *> *)addressLines {
    if (addressLines != nil) {
        store[SDLNameAddressLines] = addressLines;
    } else {
        [store removeObjectForKey:SDLNameAddressLines];
    }
}

- (NSArray<NSString *> *)addressLines {
    return store[SDLNameAddressLines];
}

- (void)setLocationDescription:(NSString *)locationDescription {
    if (locationDescription != nil) {
        store[SDLNameLocationDescription] = locationDescription;
    } else {
        [store removeObjectForKey:SDLNameLocationDescription];
    }
}

- (NSString *)locationDescription {
    return store[SDLNameLocationDescription];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber != nil) {
        store[SDLNamePhoneNumber] = phoneNumber;
    } else {
        [store removeObjectForKey:SDLNamePhoneNumber];
    }
}

- (NSString *)phoneNumber {
    return store[SDLNamePhoneNumber];
}

- (void)setLocationImage:(SDLImage *)locationImage {
    if (locationImage != nil) {
        store[SDLNameLocationImage] = locationImage;
    } else {
        [store removeObjectForKey:SDLNameLocationImage];
    }
}

- (SDLImage *)locationImage {
    return store[SDLNameLocationImage];
}

- (void)setSearchAddress:(SDLOasisAddress *)searchAddress {
    if (searchAddress != nil) {
        store[SDLNameAddress] = searchAddress;
    } else {
        [store removeObjectForKey:SDLNameAddress];
    }
}

- (SDLOasisAddress *)searchAddress {
    return store[SDLNameAddress];
}

@end
