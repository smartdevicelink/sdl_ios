//  SDLVehicleType.m
//


#import "SDLVehicleType.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLVehicleType

- (void)setMake:(nullable NSString *)make {
    if (make != nil) {
        [store setObject:make forKey:SDLNameMake];
    } else {
        [store removeObjectForKey:SDLNameMake];
    }
}

- (nullable NSString *)make {
    return [store objectForKey:SDLNameMake];
}

- (void)setModel:(nullable NSString *)model {
    if (model != nil) {
        [store setObject:model forKey:SDLNameModel];
    } else {
        [store removeObjectForKey:SDLNameModel];
    }
}

- (nullable NSString *)model {
    return [store objectForKey:SDLNameModel];
}

- (void)setModelYear:(nullable NSString *)modelYear {
    if (modelYear != nil) {
        [store setObject:modelYear forKey:SDLNameModelYear];
    } else {
        [store removeObjectForKey:SDLNameModelYear];
    }
}

- (nullable NSString *)modelYear {
    return [store objectForKey:SDLNameModelYear];
}

- (void)setTrim:(nullable NSString *)trim {
    if (trim != nil) {
        [store setObject:trim forKey:SDLNameTrim];
    } else {
        [store removeObjectForKey:SDLNameTrim];
    }
}

- (nullable NSString *)trim {
    return [store objectForKey:SDLNameTrim];
}

@end

NS_ASSUME_NONNULL_END
