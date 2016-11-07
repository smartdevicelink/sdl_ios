//  SDLLocationDetails.m
//

#import "SDLLocationDetails.h"

#import "SDLImage.h"
#import "SDLLocationCoordinate.h"
#import "SDLNames.h"
#import "SDLOasisAddress.h"

@implementation SDLLocationDetails

- (void)setCoordinate:(SDLLocationCoordinate *)coordinate {
    [self setObject:coordinate forName:SDLNameLocationCoordinate];
}

- (SDLLocationCoordinate *)coordinate {
    return [self objectForName:SDLNameLocationCoordinate];
}

- (void)setLocationName:(NSString *)locationName {
    [self setObject:locationName forName:SDLNameLocationName];
}

- (NSString *)locationName {
    return [self objectForName:SDLNameLocationName];
}

- (void)setAddressLines:(NSArray<NSString *> *)addressLines {
    [self setObject:addressLines forName:SDLNameAddressLines];
}

- (NSArray<NSString *> *)addressLines {
    return [self objectForName:SDLNameAddressLines];
}

- (void)setLocationDescription:(NSString *)locationDescription {
    [self setObject:locationDescription forName:SDLNameLocationDescription];
}

- (NSString *)locationDescription {
    return [self objectForName:SDLNameLocationDescription];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    [self setObject:phoneNumber forName:SDLNamePhoneNumber];
}

- (NSString *)phoneNumber {
    return [self objectForName:SDLNamePhoneNumber];
}

- (void)setLocationImage:(SDLImage *)locationImage {
    [self setObject:locationImage forName:SDLNameLocationImage];
}

- (SDLImage *)locationImage {
    return [self objectForName:SDLNameLocationImage];
}

- (void)setSearchAddress:(SDLOasisAddress *)searchAddress {
    [self setObject:searchAddress forName:SDLNameAddress];
}

- (SDLOasisAddress *)searchAddress {
    return [self objectForName:SDLNameAddress];
}

@end
