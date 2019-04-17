//  SDLLocationDetails.m
//

#import "SDLLocationDetails.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLLocationCoordinate.h"
#import "SDLRPCParameterNames.h"
#import "SDLOasisAddress.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLocationDetails

- (instancetype)initWithCoordinate:(SDLLocationCoordinate *)coordinate {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.coordinate = coordinate;

    return self;
}

- (instancetype)initWithCoordinate:(SDLLocationCoordinate *)coordinate locationName:(nullable NSString *)locationName addressLines:(nullable NSArray<NSString *> *)addressLines locationDescription:(nullable NSString *)locationDescription phoneNumber:(nullable NSString*)phoneNumber locationImage:(nullable SDLImage *)locationImage searchAddress:(nullable SDLOasisAddress *)searchAddress {
    self = [self initWithCoordinate:coordinate];
    if (!self) {
        return nil;
    }

    self.locationName = locationName;
    self.addressLines = addressLines;
    self.locationDescription = locationDescription;
    self.phoneNumber = phoneNumber;
    self.locationImage = locationImage;
    self.searchAddress = searchAddress;

    return self;
}

- (void)setCoordinate:(nullable SDLLocationCoordinate *)coordinate {
    [store sdl_setObject:coordinate forName:SDLRPCParameterNameLocationCoordinate];
}

- (nullable SDLLocationCoordinate *)coordinate {
    return [store sdl_objectForName:SDLRPCParameterNameLocationCoordinate ofClass:SDLLocationCoordinate.class error:nil];
}

- (void)setLocationName:(nullable NSString *)locationName {
    [store sdl_setObject:locationName forName:SDLRPCParameterNameLocationName];
}

- (nullable NSString *)locationName {
    return [store sdl_objectForName:SDLRPCParameterNameLocationName ofClass:NSString.class error:nil];
}

- (void)setAddressLines:(nullable NSArray<NSString *> *)addressLines {
    [store sdl_setObject:addressLines forName:SDLRPCParameterNameAddressLines];
}

- (nullable NSArray<NSString *> *)addressLines {
    return [store sdl_objectsForName:SDLRPCParameterNameAddressLines ofClass:NSString.class error:nil];
}

- (void)setLocationDescription:(nullable NSString *)locationDescription {
    [store sdl_setObject:locationDescription forName:SDLRPCParameterNameLocationDescription];
}

- (nullable NSString *)locationDescription {
    return [store sdl_objectForName:SDLRPCParameterNameLocationDescription ofClass:NSString.class error:nil];
}

- (void)setPhoneNumber:(nullable NSString *)phoneNumber {
    [store sdl_setObject:phoneNumber forName:SDLRPCParameterNamePhoneNumber];
}

- (nullable NSString *)phoneNumber {
    return [store sdl_objectForName:SDLRPCParameterNamePhoneNumber ofClass:NSString.class error:nil];
}

- (void)setLocationImage:(nullable SDLImage *)locationImage {
    [store sdl_setObject:locationImage forName:SDLRPCParameterNameLocationImage];
}

- (nullable SDLImage *)locationImage {
    return [store sdl_objectForName:SDLRPCParameterNameLocationImage ofClass:SDLImage.class error:nil];
}

- (void)setSearchAddress:(nullable SDLOasisAddress *)searchAddress {
    [store sdl_setObject:searchAddress forName:SDLRPCParameterNameSearchAddress];
}

- (nullable SDLOasisAddress *)searchAddress {
    return [store sdl_objectForName:SDLRPCParameterNameSearchAddress ofClass:SDLOasisAddress.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
