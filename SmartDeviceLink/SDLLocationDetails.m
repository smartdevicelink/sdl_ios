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
        store[NAMES_locationCoordinate] = coordinate;
    } else {
        [store removeObjectForKey:NAMES_locationCoordinate];
    }
}

- (SDLLocationCoordinate *)coordinate {
    NSObject *obj = [store objectForKey:NAMES_locationCoordinate];
    if (obj == nil || [obj isKindOfClass:SDLLocationCoordinate.class]) {
        return (SDLLocationCoordinate *)obj;
    } else {
        return [[SDLLocationCoordinate alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
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
    NSObject *obj = [store objectForKey:NAMES_locationImage];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setSearchAddress:(SDLOasisAddress *)searchAddress {
    if (searchAddress != nil) {
        store[NAMES_searchAddress] = searchAddress;
    } else {
        [store removeObjectForKey:NAMES_searchAddress];
    }
}

- (SDLOasisAddress *)searchAddress {
    NSObject *obj = [store objectForKey:NAMES_searchAddress];
    if (obj == nil || [obj isKindOfClass:SDLOasisAddress.class]) {
        return (SDLOasisAddress *)obj;
    } else {
        return [[SDLOasisAddress alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
