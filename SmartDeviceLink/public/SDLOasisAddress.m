//  SDLOasisAddress.m
//

#import "SDLOasisAddress.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

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
    [self.store sdl_setObject:countryName forName:SDLRPCParameterNameCountryName];
}

- (nullable NSString *)countryName {
    return [self.store sdl_objectForName:SDLRPCParameterNameCountryName ofClass:NSString.class error:nil];
}

- (void)setCountryCode:(nullable NSString *)countryCode {
    [self.store sdl_setObject:countryCode forName:SDLRPCParameterNameCountryCode];
}

- (nullable NSString *)countryCode {
    return [self.store sdl_objectForName:SDLRPCParameterNameCountryCode ofClass:NSString.class error:nil];
}

- (void)setPostalCode:(nullable NSString *)postalCode {
    [self.store sdl_setObject:postalCode forName:SDLRPCParameterNamePostalCode];
}

- (nullable NSString *)postalCode {
    return [self.store sdl_objectForName:SDLRPCParameterNamePostalCode ofClass:NSString.class error:nil];
}

- (void)setAdministrativeArea:(nullable NSString *)administrativeArea {
    [self.store sdl_setObject:administrativeArea forName:SDLRPCParameterNameAdministrativeArea];
}

- (nullable NSString *)administrativeArea {
    return [self.store sdl_objectForName:SDLRPCParameterNameAdministrativeArea ofClass:NSString.class error:nil];
}

- (void)setSubAdministrativeArea:(nullable NSString *)subAdministrativeArea {
    [self.store sdl_setObject:subAdministrativeArea forName:SDLRPCParameterNameSubAdministrativeArea];
}

- (nullable NSString *)subAdministrativeArea {
    return [self.store sdl_objectForName:SDLRPCParameterNameSubAdministrativeArea ofClass:NSString.class error:nil];
}

- (void)setLocality:(nullable NSString *)locality {
    [self.store sdl_setObject:locality forName:SDLRPCParameterNameLocality];
}

- (nullable NSString *)locality {
    return [self.store sdl_objectForName:SDLRPCParameterNameLocality ofClass:NSString.class error:nil];
}

- (void)setSubLocality:(nullable NSString *)subLocality {
    [self.store sdl_setObject:subLocality forName:SDLRPCParameterNameSubLocality];
}

- (nullable NSString *)subLocality {
    return [self.store sdl_objectForName:SDLRPCParameterNameSubLocality ofClass:NSString.class error:nil];
}

- (void)setThoroughfare:(nullable NSString *)thoroughfare {
    [self.store sdl_setObject:thoroughfare forName:SDLRPCParameterNameThoroughfare];
}

- (nullable NSString *)thoroughfare {
    return [self.store sdl_objectForName:SDLRPCParameterNameThoroughfare ofClass:NSString.class error:nil];
}

- (void)setSubThoroughfare:(nullable NSString *)subThoroughfare {
    [self.store sdl_setObject:subThoroughfare forName:SDLRPCParameterNameSubThoroughfare];
}

- (nullable NSString *)subThoroughfare {
    return [self.store sdl_objectForName:SDLRPCParameterNameSubThoroughfare ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
