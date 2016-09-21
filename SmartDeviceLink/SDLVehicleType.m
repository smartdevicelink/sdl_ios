//  SDLVehicleType.m
//


#import "SDLVehicleType.h"



@implementation SDLVehicleType

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setMake:(NSString *)make {
    if (make != nil) {
        [store setObject:make forKey:SDLNameMake];
    } else {
        [store removeObjectForKey:SDLNameMake];
    }
}

- (NSString *)make {
    return [store objectForKey:SDLNameMake];
}

- (void)setModel:(NSString *)model {
    if (model != nil) {
        [store setObject:model forKey:SDLNameModel];
    } else {
        [store removeObjectForKey:SDLNameModel];
    }
}

- (NSString *)model {
    return [store objectForKey:SDLNameModel];
}

- (void)setModelYear:(NSString *)modelYear {
    if (modelYear != nil) {
        [store setObject:modelYear forKey:SDLNameModelYear];
    } else {
        [store removeObjectForKey:SDLNameModelYear];
    }
}

- (NSString *)modelYear {
    return [store objectForKey:SDLNameModelYear];
}

- (void)setTrim:(NSString *)trim {
    if (trim != nil) {
        [store setObject:trim forKey:SDLNameTrim];
    } else {
        [store removeObjectForKey:SDLNameTrim];
    }
}

- (NSString *)trim {
    return [store objectForKey:SDLNameTrim];
}

@end
