//  SDLVehicleType.m
//


#import "SDLVehicleType.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVehicleType

- (void)setMake:(nullable NSString *)make {
    [store sdl_setObject:make forName:SDLNameMake];
}

- (nullable NSString *)make {
    return [store sdl_objectForName:SDLNameMake ofClass:NSString.class];
}

- (void)setModel:(nullable NSString *)model {
    [store sdl_setObject:model forName:SDLNameModel];
}

- (nullable NSString *)model {
    return [store sdl_objectForName:SDLNameModel ofClass:NSString.class];
}

- (void)setModelYear:(nullable NSString *)modelYear {
    [store sdl_setObject:modelYear forName:SDLNameModelYear];
}

- (nullable NSString *)modelYear {
    return [store sdl_objectForName:SDLNameModelYear ofClass:NSString.class];
}

- (void)setTrim:(nullable NSString *)trim {
    [store sdl_setObject:trim forName:SDLNameTrim];
}

- (nullable NSString *)trim {
    return [store sdl_objectForName:SDLNameTrim ofClass:NSString.class];
}

@end

NS_ASSUME_NONNULL_END
