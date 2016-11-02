//  SDLLocationDetails.m
//

#import "SDLLocationDetails.h"

#import "SDLLocationCoordinate.h"
#import "SDLImage.h"
#import "SDLNames.h"
//#import "SDLOasisAddress.h"

@implementation SDLLocationDetails

- (void)setCoordinate:(SDLLocationCoordinate *)coordinate {
    if (coordinate != nil) {
        store[NAMES_locationCoordinate] = coordinate;
    } else {
        [store removeObjectForKey:NAMES_locationCoordinate];
    }
}

- (SDLLocationCoordinate *)coordinate {
    return store[NAMES_locationCoordinate];
}

- (void)setLocationName:(NSString *)locationName {
    if (locationName != nil) {
        store[NAMES_locationName] = locationName;
    } else {
        [store removeObjectForKey:NAMES_locationName];
    }
}

- (NSString *)locationName {
    return store[NAMES_locationName];
}

- (void)setAddressLines:(NSArray<NSString *> *)addressLines {
    if (addressLines != nil) {
        store[NAMES_addressLines] = addressLines;
    } else {
        [store removeObjectForKey:NAMES_addressLines];
    }
}

- (NSArray<NSString *> *)addressLines {
    return store[NAMES_addressLines];
}

- (void)setLocationDescription:(NSString *)locationDescription {
    if (locationDescription != nil) {
        store[NAMES_locationDescription] = locationDescription;
    } else {
        [store removeObjectForKey:NAMES_locationDescription];
    }
}

- (NSString *)locationDescription {
    return store[NAMES_locationDescription];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber != nil) {
        store[NAMES_phoneNumber] = phoneNumber;
    } else {
        [store removeObjectForKey:NAMES_phoneNumber];
    }
}

- (NSString *)phoneNumber {
    return store[NAMES_phoneNumber];
}

- (void)setLocationImage:(SDLImage *)locationImage {
    if (locationImage != nil) {
        store[NAMES_locationImage] = locationImage;
    } else {
        [store removeObjectForKey:NAMES_locationImage];
    }
}

- (SDLImage *)locationImage {
    return store[NAMES_locationImage];
}

//- (void)setSearchAddress:(SDLOasisAddress *)searchAddress {
//    if (searchAddress != nil) {
//        store[NAMES_address] = searchAddress;
//    } else {
//        [store removeObjectForKey:NAMES_address];
//    }
//}
//
//- (SDLOasisAddress *)searchAddress {
//    return store[NAMES_address];
//}

@end
