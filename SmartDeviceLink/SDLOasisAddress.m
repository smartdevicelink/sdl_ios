//  SDLOasisAddress.m
//

#import "SDLOasisAddress.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOasisAddress

- (instancetype)initWithSubThoroughfare:(nullable NSString *)subThoroughfare thoroughfare:(nullable NSString *)thoroughfare locality:(nullable NSString *)locality administrativeArea:(nullable NSString *)administrativeArea postalCode:(nullable NSString *)postalCode countryCode:(nullable NSString *)countryCode {
    return [self initWithSubThoroughfare:subThoroughfare thoroughfare:thoroughfare locality:locality administrativeArea:administrativeArea postalCode:postalCode countryCode:countryCode countryName:nil subAdministrativeArea:nil subLocality:nil];
}

- (instancetype)initWithSubThoroughfare:(nullable NSString *)subThoroughfare thoroughfare:(nullable NSString *)thoroughfare locality:(nullable NSString *)locality administrativeArea:(nullable NSString *)administrativeArea postalCode:(nullable NSString *)postalCode countryCode:(nullable NSString *)countryCode countryName:(nullable NSString *)countryName subAdministrativeArea:(nullable NSString *)subAdministrativeArea subLocality:(nullable NSString *)subLocality {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.subThoroughfare = subThoroughfare;
    self.thoroughfare = thoroughfare;
    self.locality = locality;
    self.administrativeArea = administrativeArea;
    self.postalCode = postalCode;
    self.countryCode = countryCode;
    self.countryName = countryName;
    self.subAdministrativeArea = subAdministrativeArea;
    self.subLocality = subLocality;

    return self;
}


- (void)setCountryName:(nullable NSString *)countryName {
    if (countryName != nil) {
        store[SDLNameCountryName] = countryName;
    } else {
        [store removeObjectForKey:SDLNameCountryName];
    }
}

- (nullable NSString *)countryName {
    return store[SDLNameCountryName];
}

- (void)setCountryCode:(nullable NSString *)countryCode {
    if (countryCode != nil) {
        store[SDLNameCountryCode] = countryCode;
    } else {
        [store removeObjectForKey:SDLNameCountryCode];
    }
}

- (nullable NSString *)countryCode {
    return store[SDLNameCountryCode];
}

- (void)setPostalCode:(nullable NSString *)postalCode {
    if (postalCode != nil) {
        store[SDLNamePostalCode] = postalCode;
    } else {
        [store removeObjectForKey:SDLNamePostalCode];
    }
}

- (nullable NSString *)postalCode {
    return store[SDLNamePostalCode];
}

- (void)setAdministrativeArea:(nullable NSString *)administrativeArea {
    if (administrativeArea != nil) {
        store[SDLNameAdministrativeArea] = administrativeArea;
    } else {
        [store removeObjectForKey:SDLNameAdministrativeArea];
    }
}

- (nullable NSString *)administrativeArea {
    return store[SDLNameAdministrativeArea];
}

- (void)setSubAdministrativeArea:(nullable NSString *)subAdministrativeArea {
    if (subAdministrativeArea != nil) {
        store[SDLNameSubAdministrativeArea] = subAdministrativeArea;
    } else {
        [store removeObjectForKey:SDLNameSubAdministrativeArea];
    }
}

- (nullable NSString *)subAdministrativeArea {
    return store[SDLNameSubAdministrativeArea];
}

- (void)setLocality:(nullable NSString *)locality {
    if (locality != nil) {
        store[SDLNameLocality] = locality;
    } else {
        [store removeObjectForKey:SDLNameLocality];
    }
}

- (nullable NSString *)locality {
    return store[SDLNameLocality];
}

- (void)setSubLocality:(nullable NSString *)subLocality {
    if (subLocality != nil) {
        store[SDLNameSubLocality] = subLocality;
    } else {
        [store removeObjectForKey:SDLNameSubLocality];
    }
}

- (nullable NSString *)subLocality {
    return store[SDLNameSubLocality];
}

- (void)setThoroughfare:(nullable NSString *)thoroughfare {
    if (thoroughfare != nil) {
        store[SDLNameThoroughfare] = thoroughfare;
    } else {
        [store removeObjectForKey:SDLNameThoroughfare];
    }
}

- (nullable NSString *)thoroughfare {
    return store[SDLNameThoroughfare];
}

- (void)setSubThoroughfare:(nullable NSString *)subThoroughfare {
    if (subThoroughfare != nil) {
        store[SDLNameSubThoroughfare] = subThoroughfare;
    } else {
        [store removeObjectForKey:SDLNameSubThoroughfare];
    }
}

- (nullable NSString *)subThoroughfare {
    return store[SDLNameSubThoroughfare];
}

@end

NS_ASSUME_NONNULL_END
