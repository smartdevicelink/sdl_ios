//  SDLVehicleType.m
//


#import "SDLVehicleType.h"

#import "SDLNames.h"

@implementation SDLVehicleType

- (void)setMake:(NSString *)make {
    [self setObject:make forName:SDLNameMake];
}

- (NSString *)make {
    return [self objectForName:SDLNameMake];
}

- (void)setModel:(NSString *)model {
    [self setObject:model forName:SDLNameModel];
}

- (NSString *)model {
    return [self objectForName:SDLNameModel];
}

- (void)setModelYear:(NSString *)modelYear {
    [self setObject:modelYear forName:SDLNameModelYear];
}

- (NSString *)modelYear {
    return [self objectForName:SDLNameModelYear];
}

- (void)setTrim:(NSString *)trim {
    [self setObject:trim forName:SDLNameTrim];
}

- (NSString *)trim {
    return [self objectForName:SDLNameTrim];
}

@end
