//  SDLOasisAddress.m
//

#import "SDLOasisAddress.h"
#import "SDLNames.h"

@implementation SDLOasisAddress

- (instancetype)initWithSubThoroughfare:(NSString *)subThoroughfare thoroughfare:(NSString *)thoroughfare locality:(NSString *)locality administrativeArea:(NSString *)administrativeArea postalCode:(NSString *)postalCode countryCode:(NSString *)countryCode {
    return [self initWithSubThoroughfare:subThoroughfare thoroughfare:thoroughfare locality:locality administrativeArea:administrativeArea postalCode:postalCode countryCode:countryCode countryName:nil subAdministrativeArea:nil subLocality:nil];
}

- (instancetype)initWithSubThoroughfare:(NSString *)subThoroughfare thoroughfare:(NSString *)thoroughfare locality:(NSString *)locality administrativeArea:(NSString *)administrativeArea postalCode:(NSString *)postalCode countryCode:(NSString *)countryCode countryName:(NSString *)countryName subAdministrativeArea:(NSString *)subAdministrativeArea subLocality:(NSString *)subLocality {
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


- (void)setCountryName:(NSString *)countryName {
    if (countryName != nil) {
        store[NAMES_countryName] = countryName;
    } else {
        [store removeObjectForKey:NAMES_countryName];
    }
}

- (NSString *)countryName {
    return store[NAMES_countryName];
}

- (void)setCountryCode:(NSString *)countryCode {
    if (countryCode != nil) {
        store[NAMES_countryCode] = countryCode;
    } else {
        [store removeObjectForKey:NAMES_countryCode];
    }
}

- (NSString *)countryCode {
    return store[NAMES_countryCode];
}

- (void)setPostalCode:(NSString *)postalCode {
    if (postalCode != nil) {
        store[NAMES_postalCode] = postalCode;
    } else {
        [store removeObjectForKey:NAMES_postalCode];
    }
}

- (NSString *)postalCode {
    return store[NAMES_postalCode];
}

- (void)setAdministrativeArea:(NSString *)administrativeArea {
    if (administrativeArea != nil) {
        store[NAMES_administrativeArea] = administrativeArea;
    } else {
        [store removeObjectForKey:NAMES_administrativeArea];
    }
}

- (NSString *)administrativeArea {
    return store[NAMES_administrativeArea];
}

- (void)setSubAdministrativeArea:(NSString *)subAdministrativeArea {
    if (subAdministrativeArea != nil) {
        store[NAMES_subAdministrativeArea] = subAdministrativeArea;
    } else {
        [store removeObjectForKey:NAMES_subAdministrativeArea];
    }
}

- (NSString *)subAdministrativeArea {
    return store[NAMES_subAdministrativeArea];
}

- (void)setLocality:(NSString *)locality {
    if (locality != nil) {
        store[NAMES_locality] = locality;
    } else {
        [store removeObjectForKey:NAMES_locality];
    }
}

- (NSString *)locality {
    return store[NAMES_locality];
}

- (void)setSubLocality:(NSString *)subLocality {
    if (subLocality != nil) {
        store[NAMES_subLocality] = subLocality;
    } else {
        [store removeObjectForKey:NAMES_subLocality];
    }
}

- (NSString *)subLocality {
    return store[NAMES_subLocality];
}

- (void)setThoroughfare:(NSString *)thoroughfare {
    if (thoroughfare != nil) {
        store[NAMES_thoroughfare] = thoroughfare;
    } else {
        [store removeObjectForKey:NAMES_thoroughfare];
    }
}

- (NSString *)thoroughfare {
    return store[NAMES_thoroughfare];
}

- (void)setSubThoroughfare:(NSString *)subThoroughfare {
    if (subThoroughfare != nil) {
        store[NAMES_subThoroughfare] = subThoroughfare;
    } else {
        [store removeObjectForKey:NAMES_subThoroughfare];
    }
}

- (NSString *)subThoroughfare {
    return store[NAMES_subThoroughfare];
}

@end
