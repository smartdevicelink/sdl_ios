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
    NSObject *obj = [store objectForKey: SDLNameLocationCoordinate];
    if (obj == nil || [obj isKindOfClass:SDLLocationCoordinate.class]) {
        return (SDLLocationCoordinate *)obj;
    } else {
        return [[SDLLocationCoordinate alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
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
    NSObject *obj = [store objectForKey: SDLNameLocationImage];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setSearchAddress:(SDLOasisAddress *)searchAddress {
    if (searchAddress != nil) {
        store[SDLNameSearchAddress] = searchAddress;
    } else {
        [store removeObjectForKey:SDLNameSearchAddress];
    }
}

- (SDLOasisAddress *)searchAddress {
    NSObject *obj = [store objectForKey:SDLNameSearchAddress];
    if (obj == nil || [obj isKindOfClass:SDLOasisAddress.class]) {
        return (SDLOasisAddress *)obj;
    } else {
        return [[SDLOasisAddress alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
