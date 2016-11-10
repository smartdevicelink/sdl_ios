//  SDLVehicleType.m
//


#import "SDLVehicleType.h"

#import "SDLNames.h"

@implementation SDLVehicleType

- (void)setMake:(NSString *)make {
    [store sdl_setObject:make forName:SDLNameMake];
}

- (NSString *)make {
    return [store sdl_objectForName:SDLNameMake];
}

- (void)setModel:(NSString *)model {
    [store sdl_setObject:model forName:SDLNameModel];
}

- (NSString *)model {
    return [store sdl_objectForName:SDLNameModel];
}

- (void)setModelYear:(NSString *)modelYear {
    [store sdl_setObject:modelYear forName:SDLNameModelYear];
}

- (NSString *)modelYear {
    return [store sdl_objectForName:SDLNameModelYear];
}

- (void)setTrim:(NSString *)trim {
    [store sdl_setObject:trim forName:SDLNameTrim];
}

- (NSString *)trim {
    return [store sdl_objectForName:SDLNameTrim];
}

@end
