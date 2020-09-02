//  SDLVehicleType.m
//


#import "SDLVehicleType.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVehicleType

- (void)setMake:(nullable NSString *)make {
    [self.store sdl_setObject:make forName:SDLRPCParameterNameMake];
}

- (nullable NSString *)make {
    return [self.store sdl_objectForName:SDLRPCParameterNameMake ofClass:NSString.class error:nil];
}

- (void)setModel:(nullable NSString *)model {
    [self.store sdl_setObject:model forName:SDLRPCParameterNameModel];
}

- (nullable NSString *)model {
    return [self.store sdl_objectForName:SDLRPCParameterNameModel ofClass:NSString.class error:nil];
}

- (void)setModelYear:(nullable NSString *)modelYear {
    [self.store sdl_setObject:modelYear forName:SDLRPCParameterNameModelYear];
}

- (nullable NSString *)modelYear {
    return [self.store sdl_objectForName:SDLRPCParameterNameModelYear ofClass:NSString.class error:nil];
}

- (void)setTrim:(nullable NSString *)trim {
    [self.store sdl_setObject:trim forName:SDLRPCParameterNameTrim];
}

- (nullable NSString *)trim {
    return [self.store sdl_objectForName:SDLRPCParameterNameTrim ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
