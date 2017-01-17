//  SDLLocationDetails.m
//

#import "SDLLocationDetails.h"

#import "SDLImage.h"
#import "SDLLocationCoordinate.h"
#import "SDLNames.h"
#import "SDLOasisAddress.h"

@implementation SDLLocationDetails

- (void)setCoordinate:(SDLLocationCoordinate *)coordinate {
    [store sdl_setObject:coordinate forName:SDLNameLocationCoordinate];
}

- (SDLLocationCoordinate *)coordinate {
    return [store sdl_objectForName:SDLNameLocationCoordinate ofClass:SDLLocationCoordinate.class];
}

- (void)setLocationName:(NSString *)locationName {
    [store sdl_setObject:locationName forName:SDLNameLocationName];
}

- (NSString *)locationName {
    return [store sdl_objectForName:SDLNameLocationName];
}

- (void)setAddressLines:(NSArray<NSString *> *)addressLines {
    [store sdl_setObject:addressLines forName:SDLNameAddressLines];
}

- (NSArray<NSString *> *)addressLines {
    return [store sdl_objectForName:SDLNameAddressLines];
}

- (void)setLocationDescription:(NSString *)locationDescription {
    [store sdl_setObject:locationDescription forName:SDLNameLocationDescription];
}

- (NSString *)locationDescription {
    return [store sdl_objectForName:SDLNameLocationDescription];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    [store sdl_setObject:phoneNumber forName:SDLNamePhoneNumber];
}

- (NSString *)phoneNumber {
    return [store sdl_objectForName:SDLNamePhoneNumber];
}

- (void)setLocationImage:(SDLImage *)locationImage {
    [store sdl_setObject:locationImage forName:SDLNameLocationImage];
}

- (SDLImage *)locationImage {
    return [store sdl_objectForName:SDLNameLocationImage ofClass:SDLImage.class];
}

- (void)setSearchAddress:(SDLOasisAddress *)searchAddress {
    [store sdl_setObject:searchAddress forName:SDLNameAddress];
}

- (SDLOasisAddress *)searchAddress {
    return [store sdl_objectForName:SDLNameAddress ofClass:SDLOasisAddress.class];
}

@end
