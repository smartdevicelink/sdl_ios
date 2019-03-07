//  SDLOasisAddress.m
//

#import "SDLOasisAddress.h"

#import "NSMutableDictionary+Store.h"
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
    [store sdl_setObject:countryName forName:SDLNameCountryName];
}

- (nullable NSString *)countryName {
    return [store sdl_objectForName:SDLNameCountryName ofClass:NSString.class];
}

- (void)setCountryCode:(nullable NSString *)countryCode {
    [store sdl_setObject:countryCode forName:SDLNameCountryCode];
}

- (nullable NSString *)countryCode {
    return [store sdl_objectForName:SDLNameCountryCode ofClass:NSString.class];
}

- (void)setPostalCode:(nullable NSString *)postalCode {
    [store sdl_setObject:postalCode forName:SDLNamePostalCode];
}

- (nullable NSString *)postalCode {
    return [store sdl_objectForName:SDLNamePostalCode ofClass:NSString.class];
}

- (void)setAdministrativeArea:(nullable NSString *)administrativeArea {
    [store sdl_setObject:administrativeArea forName:SDLNameAdministrativeArea];
}

- (nullable NSString *)administrativeArea {
    return [store sdl_objectForName:SDLNameAdministrativeArea ofClass:NSString.class];
}

- (void)setSubAdministrativeArea:(nullable NSString *)subAdministrativeArea {
    [store sdl_setObject:subAdministrativeArea forName:SDLNameSubAdministrativeArea];
}

- (nullable NSString *)subAdministrativeArea {
    return [store sdl_objectForName:SDLNameSubAdministrativeArea ofClass:NSString.class];
}

- (void)setLocality:(nullable NSString *)locality {
    [store sdl_setObject:locality forName:SDLNameLocality];
}

- (nullable NSString *)locality {
    return [store sdl_objectForName:SDLNameLocality ofClass:NSString.class];
}

- (void)setSubLocality:(nullable NSString *)subLocality {
    [store sdl_setObject:subLocality forName:SDLNameSubLocality];
}

- (nullable NSString *)subLocality {
    return [store sdl_objectForName:SDLNameSubLocality ofClass:NSString.class];
}

- (void)setThoroughfare:(nullable NSString *)thoroughfare {
    [store sdl_setObject:thoroughfare forName:SDLNameThoroughfare];
}

- (nullable NSString *)thoroughfare {
    return [store sdl_objectForName:SDLNameThoroughfare ofClass:NSString.class];
}

- (void)setSubThoroughfare:(nullable NSString *)subThoroughfare {
    [store sdl_setObject:subThoroughfare forName:SDLNameSubThoroughfare];
}

- (nullable NSString *)subThoroughfare {
    return [store sdl_objectForName:SDLNameSubThoroughfare ofClass:NSString.class];
}

@end

NS_ASSUME_NONNULL_END
