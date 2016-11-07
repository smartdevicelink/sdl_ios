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
    [self setObject:countryName forName:SDLNameCountryName];
}

- (NSString *)countryName {
    return [self objectForName:SDLNameCountryName];
}

- (void)setCountryCode:(NSString *)countryCode {
    [self setObject:countryCode forName:SDLNameCountryCode];
}

- (NSString *)countryCode {
    return [self objectForName:SDLNameCountryCode];
}

- (void)setPostalCode:(NSString *)postalCode {
    [self setObject:postalCode forName:SDLNamePostalCode];
}

- (NSString *)postalCode {
    return [self objectForName:SDLNamePostalCode];
}

- (void)setAdministrativeArea:(NSString *)administrativeArea {
    [self setObject:administrativeArea forName:SDLNameAdministrativeArea];
}

- (NSString *)administrativeArea {
    return [self objectForName:SDLNameAdministrativeArea];
}

- (void)setSubAdministrativeArea:(NSString *)subAdministrativeArea {
    [self setObject:subAdministrativeArea forName:SDLNameSubAdministrativeArea];
}

- (NSString *)subAdministrativeArea {
    return [self objectForName:SDLNameSubAdministrativeArea];
}

- (void)setLocality:(NSString *)locality {
    [self setObject:locality forName:SDLNameLocality];
}

- (NSString *)locality {
    return [self objectForName:SDLNameLocality];
}

- (void)setSubLocality:(NSString *)subLocality {
    [self setObject:subLocality forName:SDLNameSubLocality];
}

- (NSString *)subLocality {
    return [self objectForName:SDLNameSubLocality];
}

- (void)setThoroughfare:(NSString *)thoroughfare {
    [self setObject:thoroughfare forName:SDLNameThoroughfare];
}

- (NSString *)thoroughfare {
    return [self objectForName:SDLNameThoroughfare];
}

- (void)setSubThoroughfare:(NSString *)subThoroughfare {
    [self setObject:subThoroughfare forName:SDLNameSubThoroughfare];
}

- (NSString *)subThoroughfare {
    return [self objectForName:SDLNameSubThoroughfare];
}

@end
