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
    [store sdl_setObject:countryName forName:SDLNameCountryName];
}

- (NSString *)countryName {
    return [store sdl_objectForName:SDLNameCountryName];
}

- (void)setCountryCode:(NSString *)countryCode {
    [store sdl_setObject:countryCode forName:SDLNameCountryCode];
}

- (NSString *)countryCode {
    return [store sdl_objectForName:SDLNameCountryCode];
}

- (void)setPostalCode:(NSString *)postalCode {
    [store sdl_setObject:postalCode forName:SDLNamePostalCode];
}

- (NSString *)postalCode {
    return [store sdl_objectForName:SDLNamePostalCode];
}

- (void)setAdministrativeArea:(NSString *)administrativeArea {
    [store sdl_setObject:administrativeArea forName:SDLNameAdministrativeArea];
}

- (NSString *)administrativeArea {
    return [store sdl_objectForName:SDLNameAdministrativeArea];
}

- (void)setSubAdministrativeArea:(NSString *)subAdministrativeArea {
    [store sdl_setObject:subAdministrativeArea forName:SDLNameSubAdministrativeArea];
}

- (NSString *)subAdministrativeArea {
    return [store sdl_objectForName:SDLNameSubAdministrativeArea];
}

- (void)setLocality:(NSString *)locality {
    [store sdl_setObject:locality forName:SDLNameLocality];
}

- (NSString *)locality {
    return [store sdl_objectForName:SDLNameLocality];
}

- (void)setSubLocality:(NSString *)subLocality {
    [store sdl_setObject:subLocality forName:SDLNameSubLocality];
}

- (NSString *)subLocality {
    return [store sdl_objectForName:SDLNameSubLocality];
}

- (void)setThoroughfare:(NSString *)thoroughfare {
    [store sdl_setObject:thoroughfare forName:SDLNameThoroughfare];
}

- (NSString *)thoroughfare {
    return [store sdl_objectForName:SDLNameThoroughfare];
}

- (void)setSubThoroughfare:(NSString *)subThoroughfare {
    [store sdl_setObject:subThoroughfare forName:SDLNameSubThoroughfare];
}

- (NSString *)subThoroughfare {
    return [store sdl_objectForName:SDLNameSubThoroughfare];
}

@end
