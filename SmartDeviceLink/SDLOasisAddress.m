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
        store[SDLNameCountryName] = countryName;
    } else {
        [store removeObjectForKey:SDLNameCountryName];
    }
}

- (NSString *)countryName {
    return store[SDLNameCountryName];
}

- (void)setCountryCode:(NSString *)countryCode {
    if (countryCode != nil) {
        store[SDLNameCountryCode] = countryCode;
    } else {
        [store removeObjectForKey:SDLNameCountryCode];
    }
}

- (NSString *)countryCode {
    return store[SDLNameCountryCode];
}

- (void)setPostalCode:(NSString *)postalCode {
    if (postalCode != nil) {
        store[SDLNamePostalCode] = postalCode;
    } else {
        [store removeObjectForKey:SDLNamePostalCode];
    }
}

- (NSString *)postalCode {
    return store[SDLNamePostalCode];
}

- (void)setAdministrativeArea:(NSString *)administrativeArea {
    if (administrativeArea != nil) {
        store[SDLNameAdministrativeArea] = administrativeArea;
    } else {
        [store removeObjectForKey:SDLNameAdministrativeArea];
    }
}

- (NSString *)administrativeArea {
    return store[SDLNameAdministrativeArea];
}

- (void)setSubAdministrativeArea:(NSString *)subAdministrativeArea {
    if (subAdministrativeArea != nil) {
        store[SDLNameSubAdministrativeArea] = subAdministrativeArea;
    } else {
        [store removeObjectForKey:SDLNameSubAdministrativeArea];
    }
}

- (NSString *)subAdministrativeArea {
    return store[SDLNameSubAdministrativeArea];
}

- (void)setLocality:(NSString *)locality {
    if (locality != nil) {
        store[SDLNameLocality] = locality;
    } else {
        [store removeObjectForKey:SDLNameLocality];
    }
}

- (NSString *)locality {
    return store[SDLNameLocality];
}

- (void)setSubLocality:(NSString *)subLocality {
    if (subLocality != nil) {
        store[SDLNameSubLocality] = subLocality;
    } else {
        [store removeObjectForKey:SDLNameSubLocality];
    }
}

- (NSString *)subLocality {
    return store[SDLNameSubLocality];
}

- (void)setThoroughfare:(NSString *)thoroughfare {
    if (thoroughfare != nil) {
        store[SDLNameThoroughfare] = thoroughfare;
    } else {
        [store removeObjectForKey:SDLNameThoroughfare];
    }
}

- (NSString *)thoroughfare {
    return store[SDLNameThoroughfare];
}

- (void)setSubThoroughfare:(NSString *)subThoroughfare {
    if (subThoroughfare != nil) {
        store[SDLNameSubThoroughfare] = subThoroughfare;
    } else {
        [store removeObjectForKey:SDLNameSubThoroughfare];
    }
}

- (NSString *)subThoroughfare {
    return store[SDLNameSubThoroughfare];
}

@end
